\NeedsTeXFormat{LaTeX2e}
\RequirePackage{expl3}
\ProvidesExplClass{WHU-Recommendation-Letter}
  {2022-05-03}{v0.1a}
  {Recommendation letter template for Wuhan University}

\RequirePackage{xparse}

% 检查 LaTeX2e kernel 版本
\msg_new:nnn { whu-recommendation-letter } { latex-too-old }
  { TeX~ Live~ 2020~ or~ later~ version~ is~ required~ to~ compile~ this~ document. }
\@ifl@t@r \fmtversion { 2020/02/02 }
  { }
  { \msg_fatal:nn { whu-recommendation-letter } { latex-too-old } }

% 检查编译引擎，要求使用 XeLaTeX。
\msg_new:nnn { whu-recommendation-letter } { incompatible-engine }
  { XeLaTeX~ is~ required~ to~ compile~ this~ document. }

\sys_if_engine_xetex:F
  { \msg_fatal:nn { whu-recommendation-letter } { incompatible-engine } }


% 使用 l3keys 定义 \examsetup 配置命令
\NewDocumentCommand \whurecommendationlettersetup { m }
  { \keys_set:nn { whu-recommendation-letter } {#1} }




% 加载文档类和宏包

% 处理文档类选项
\PassOptionsToClass 
  { UTF8 , a4paper , scheme = chinese , zihao = -4 } { ctexart }
\DeclareOption* { \PassOptionsToClass { \CurrentOption } { ctexart } }
\ProcessOptions*

\RequirePackage { filehook }
\AtEndOfPackageFile* { fontspec }
  { \msg_redirect_name:nnn { fontspec } { no-script } { none } }
\AtEndOfPackageFile* { xeCJK }
  {
    \msg_redirect_name:nnn { xeCJK } { CJKfamily-redef } { none }
    \defaultCJKfontfeatures
      {
        Script  = CJK,
        Mapping = fullwidth-stop ,
      }
  }

% 载入 \cls{ctexart} 文档类。
\LoadClass { ctexart }

% 要求 ctex v2.4.9 2017-04-01 或更高的版本。
\msg_new:nnn { whu-recommendation-letter } { require-package-version }
  { The~ package~ "#1"~ is~ required. }

\@ifclasslater { ctexart } { 2017/04/01 }
  { }
  {
    \msg_fatal:nnn { whu-recommendation-letter } { require-package-version }
      { ctex~ v2.4.9~ 2017-04-01 }
  }

% 建议在模板开始处载入全部宏包，不要轻易改变加载顺序。
\RequirePackage { etoolbox }
\RequirePackage { geometry }
\RequirePackage { fontspec }
\RequirePackage { xeCJK }
\RequirePackage { xeCJKfntef }
\RequirePackage { fancyhdr }
\RequirePackage { graphicx }
\RequirePackage { lastpage }
\RequirePackage { afterpage }
\RequirePackage { hyperref }


% 页面设置
\geometry
  {
    a4paper,
    top        = 3cm,
    left       = 2.5cm,
    right      = 2.5cm,
    bottom     = 2cm,
    headheight = 3cm
  }

\AtBeginDocument
  {
    \newgeometry
      {
        top        = 5cm,
        left       = 2.5cm,
        right      = 2.5cm,
        bottom     = 2cm,
        headheight = 3cm
      }
    \afterpage{\aftergroup\restoregeometry}
  }


% 页眉页脚设置

% 第二页后的样式设置
\fancypagestyle{whu-second}
  {
    \fancyfoot[C]{\thepage}
    \renewcommand{\headrulewidth}{0pt}
  }
\pagestyle{whu-second}


% 第一页的样式设置
\fancypagestyle{whu-first}
  {
    \fancyhead [L]
      {
        \includegraphics[width = 6cm]{./logo/whu-logo.png}
      }
    \fancyhead [R]
      {
        \begin{tabular}{l}
          \bfseries
          { \zihao{-2} 数学与统计学院 } \\[1em]
          { \zihao{5} SCHOOL~OF~MATHEMATICS~AND~STATISTICS }
        \end{tabular}
        \smallskip
      }
    \fancyfoot[C]{\thepage}
    \renewcommand{\headrulewidth}{2pt}
  }
\thispagestyle{whu-first}


% 首段不缩进
\ctexset
  {
    section/afterindent = false
  }



% 自定义命令环境


%% 导师信息

% 邮箱
\NewDocumentCommand { \email } { m }
  { \href{ mailto:#1 }{ \texttt{#1} } }

% 导师个人信息
\NewDocumentEnvironment { info } { +b }
  {
    \begin{flushleft}
      #1
    \end{flushleft}
  }
  {}


%% 标题
\NewDocumentCommand { \lettertitle } { m }
  {
    \section*{#1}
  }


%% 落款
\keys_define:nn { whu-recommendation-letter / signature }
  {
    direction .choice:,
    direction / left .code:n =
      {
        \cs_set:Nn \__whu_recommendation_letter_signature_begin:
          { \begin{flushleft} }
        \cs_set:Nn \__whu_recommendation_letter_signature_end:
          { \end{flushleft} }
      },
    direction / right .code:n =
      {
        \cs_set:Nn \__whu_recommendation_letter_signature_begin:
          { \begin{flushright} }
        \cs_set:Nn \__whu_recommendation_letter_signature_end:
          { \end{flushright} }
      },
    direction .initial:n = left
  }

\NewDocumentEnvironment { signature } { O{} +b }
  {
    \int_set:Nn \clubpenalty { 300 }
    \int_set:Nn \widowpenalty { 300 }
    \keys_set:nn { whu-recommendation-letter / signature } {#1}
    % \medskip
    \vfil
    \__whu_recommendation_letter_signature_begin:
      #2
    \__whu_recommendation_letter_signature_end:
    \vfil
  }
  {}