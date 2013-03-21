Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab3CUIXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 04:23:18 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:43402 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab3CUIXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 04:23:08 -0400
Subject: [PATCH RFC 2/5] kconfig: regen parser
To: Michal Marek <mmarek@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Richard Cochran <richardcochran@gmail.com>
Date: Thu, 21 Mar 2013 12:23:01 +0400
Message-ID: <20130321082301.21557.32518.stgit@zurg>
In-Reply-To: <20130321082256.21557.68351.stgit@zurg>
References: <20130321082256.21557.68351.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 scripts/kconfig/zconf.hash.c_shipped |   28 -
 scripts/kconfig/zconf.tab.c_shipped  | 1320 ++++++++++++++++++----------------
 2 files changed, 700 insertions(+), 648 deletions(-)

diff --git a/scripts/kconfig/zconf.hash.c_shipped b/scripts/kconfig/zconf.hash.c_shipped
index 40df000..7f85c6c 100644
--- a/scripts/kconfig/zconf.hash.c_shipped
+++ b/scripts/kconfig/zconf.hash.c_shipped
@@ -55,10 +55,10 @@ kconf_id_hash (register const char *str, register unsigned int len)
       73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
       73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
       73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
-      73, 73, 73, 73, 73, 73, 73, 73, 25, 25,
+      73, 73, 73, 73, 73, 73, 73,  0, 25, 25,
        0,  0,  0,  5,  0,  0, 73, 73,  5,  0,
       10,  5, 45, 73, 20, 20,  0, 15, 15, 73,
-      20, 73, 73, 73, 73, 73, 73, 73, 73, 73,
+      20,  0, 73, 73, 73, 73, 73, 73, 73, 73,
       73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
       73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
       73, 73, 73, 73, 73, 73, 73, 73, 73, 73,
@@ -118,6 +118,7 @@ struct kconf_id_strings_t
     char kconf_id_strings_str43[sizeof("hex")];
     char kconf_id_strings_str46[sizeof("config")];
     char kconf_id_strings_str47[sizeof("boolean")];
+    char kconf_id_strings_str50[sizeof("apply")];
     char kconf_id_strings_str51[sizeof("string")];
     char kconf_id_strings_str54[sizeof("help")];
     char kconf_id_strings_str56[sizeof("prompt")];
@@ -153,6 +154,7 @@ static const struct kconf_id_strings_t kconf_id_strings_contents =
     "hex",
     "config",
     "boolean",
+    "apply",
     "string",
     "help",
     "prompt",
@@ -170,7 +172,7 @@ kconf_id_lookup (register const char *str, register unsigned int len)
 {
   enum
     {
-      TOTAL_KEYWORDS = 32,
+      TOTAL_KEYWORDS = 33,
       MIN_WORD_LENGTH = 2,
       MAX_WORD_LENGTH = 14,
       MIN_HASH_VALUE = 2,
@@ -199,15 +201,15 @@ kconf_id_lookup (register const char *str, register unsigned int len)
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str12,	T_DEFAULT,	TF_COMMAND, S_TRISTATE},
 #line 35 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str13,	T_DEFAULT,	TF_COMMAND, S_BOOLEAN},
-#line 45 "scripts/kconfig/zconf.gperf"
+#line 46 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str14,	T_OPT_DEFCONFIG_LIST,TF_OPTION},
       {-1}, {-1},
-#line 43 "scripts/kconfig/zconf.gperf"
+#line 44 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str17,		T_ON,		TF_PARAM},
 #line 28 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str18,	T_OPTIONAL,	TF_COMMAND},
       {-1}, {-1},
-#line 42 "scripts/kconfig/zconf.gperf"
+#line 43 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str21,		T_OPTION,	TF_COMMAND},
 #line 17 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str22,	T_ENDMENU,	TF_COMMAND},
@@ -217,7 +219,7 @@ kconf_id_lookup (register const char *str, register unsigned int len)
 #line 23 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str25,	T_MENUCONFIG,	TF_COMMAND},
       {-1},
-#line 44 "scripts/kconfig/zconf.gperf"
+#line 45 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str27,	T_OPT_MODULES,	TF_OPTION},
       {-1},
 #line 16 "scripts/kconfig/zconf.gperf"
@@ -227,10 +229,10 @@ kconf_id_lookup (register const char *str, register unsigned int len)
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str31,		T_SELECT,	TF_COMMAND},
 #line 21 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str32,	T_COMMENT,	TF_COMMAND},
-#line 46 "scripts/kconfig/zconf.gperf"
+#line 47 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str33,		T_OPT_ENV,	TF_OPTION},
       {-1},
-#line 40 "scripts/kconfig/zconf.gperf"
+#line 41 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str35,		T_RANGE,	TF_COMMAND},
 #line 19 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str36,		T_CHOICE,	TF_COMMAND},
@@ -240,7 +242,7 @@ kconf_id_lookup (register const char *str, register unsigned int len)
       {-1},
 #line 18 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str41,		T_SOURCE,	TF_COMMAND},
-#line 41 "scripts/kconfig/zconf.gperf"
+#line 42 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str42,	T_VISIBLE,	TF_COMMAND},
 #line 37 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str43,		T_TYPE,		TF_COMMAND, S_HEX},
@@ -249,7 +251,9 @@ kconf_id_lookup (register const char *str, register unsigned int len)
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str46,		T_CONFIG,	TF_COMMAND},
 #line 34 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str47,	T_TYPE,		TF_COMMAND, S_BOOLEAN},
-      {-1}, {-1}, {-1},
+      {-1}, {-1},
+#line 40 "scripts/kconfig/zconf.gperf"
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str50,		T_APPLY,	TF_COMMAND},
 #line 38 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str51,		T_TYPE,		TF_COMMAND, S_STRING},
       {-1}, {-1},
@@ -282,5 +286,5 @@ kconf_id_lookup (register const char *str, register unsigned int len)
     }
   return 0;
 }
-#line 47 "scripts/kconfig/zconf.gperf"
+#line 48 "scripts/kconfig/zconf.gperf"
 
diff --git a/scripts/kconfig/zconf.tab.c_shipped b/scripts/kconfig/zconf.tab.c_shipped
index f636141..82bb7c7 100644
--- a/scripts/kconfig/zconf.tab.c_shipped
+++ b/scripts/kconfig/zconf.tab.c_shipped
@@ -1,9 +1,8 @@
-/* A Bison parser, made by GNU Bison 2.4.3.  */
+/* A Bison parser, made by GNU Bison 2.7.  */
 
-/* Skeleton implementation for Bison's Yacc-like parsers in C
+/* Bison implementation for Yacc-like parsers in C
    
-      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006,
-   2009, 2010 Free Software Foundation, Inc.
+      Copyright (C) 1984, 1989-1990, 2000-2012 Free Software Foundation, Inc.
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
@@ -45,7 +44,7 @@
 #define YYBISON 1
 
 /* Bison version.  */
-#define YYBISON_VERSION "2.4.3"
+#define YYBISON_VERSION "2.7"
 
 /* Skeleton name.  */
 #define YYSKELETON_NAME "yacc.c"
@@ -59,8 +58,6 @@
 /* Pull parsers.  */
 #define YYPULL 1
 
-/* Using locations.  */
-#define YYLSP_NEEDED 0
 
 /* Substitute the variable and function names.  */
 #define yyparse         zconfparse
@@ -71,7 +68,6 @@
 #define yydebug         zconfdebug
 #define yynerrs         zconfnerrs
 
-
 /* Copy the first part of user declarations.  */
 
 
@@ -109,10 +105,13 @@ static struct menu *current_menu, *current_entry;
 
 
 
-/* Enabling traces.  */
-#ifndef YYDEBUG
-# define YYDEBUG 1
-#endif
+# ifndef YY_NULL
+#  if defined __cplusplus && 201103L <= __cplusplus
+#   define YY_NULL nullptr
+#  else
+#   define YY_NULL 0
+#  endif
+# endif
 
 /* Enabling verbose error messages.  */
 #ifdef YYERROR_VERBOSE
@@ -122,11 +121,14 @@ static struct menu *current_menu, *current_entry;
 # define YYERROR_VERBOSE 0
 #endif
 
-/* Enabling the token table.  */
-#ifndef YYTOKEN_TABLE
-# define YYTOKEN_TABLE 0
-#endif
 
+/* Enabling traces.  */
+#ifndef YYDEBUG
+# define YYDEBUG 1
+#endif
+#if YYDEBUG
+extern int zconfdebug;
+#endif
 
 /* Tokens.  */
 #ifndef YYTOKENTYPE
@@ -153,25 +155,25 @@ static struct menu *current_menu, *current_entry;
      T_TYPE = 274,
      T_DEFAULT = 275,
      T_SELECT = 276,
-     T_RANGE = 277,
-     T_VISIBLE = 278,
-     T_OPTION = 279,
-     T_ON = 280,
-     T_WORD = 281,
-     T_WORD_QUOTE = 282,
-     T_UNEQUAL = 283,
-     T_CLOSE_PAREN = 284,
-     T_OPEN_PAREN = 285,
-     T_EOL = 286,
-     T_OR = 287,
-     T_AND = 288,
-     T_EQUAL = 289,
-     T_NOT = 290
+     T_APPLY = 277,
+     T_RANGE = 278,
+     T_VISIBLE = 279,
+     T_OPTION = 280,
+     T_ON = 281,
+     T_WORD = 282,
+     T_WORD_QUOTE = 283,
+     T_UNEQUAL = 284,
+     T_CLOSE_PAREN = 285,
+     T_OPEN_PAREN = 286,
+     T_EOL = 287,
+     T_OR = 288,
+     T_AND = 289,
+     T_EQUAL = 290,
+     T_NOT = 291
    };
 #endif
 
 
-
 #if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
 typedef union YYSTYPE
 {
@@ -192,6 +194,23 @@ typedef union YYSTYPE
 # define YYSTYPE_IS_DECLARED 1
 #endif
 
+extern YYSTYPE zconflval;
+
+#ifdef YYPARSE_PARAM
+#if defined __STDC__ || defined __cplusplus
+int zconfparse (void *YYPARSE_PARAM);
+#else
+int zconfparse ();
+#endif
+#else /* ! YYPARSE_PARAM */
+#if defined __STDC__ || defined __cplusplus
+int zconfparse (void);
+#else
+int zconfparse ();
+#endif
+#endif /* ! YYPARSE_PARAM */
+
+
 
 /* Copy the second part of user declarations.  */
 
@@ -252,24 +271,24 @@ typedef short int yytype_int16;
 # if defined YYENABLE_NLS && YYENABLE_NLS
 #  if ENABLE_NLS
 #   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
-#   define YY_(msgid) dgettext ("bison-runtime", msgid)
+#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
 #  endif
 # endif
 # ifndef YY_
-#  define YY_(msgid) msgid
+#  define YY_(Msgid) Msgid
 # endif
 #endif
 
 /* Suppress unused-variable warnings by "using" E.  */
 #if ! defined lint || defined __GNUC__
-# define YYUSE(e) ((void) (e))
+# define YYUSE(E) ((void) (E))
 #else
-# define YYUSE(e) /* empty */
+# define YYUSE(E) /* empty */
 #endif
 
 /* Identity function, used to suppress warnings about constant conditions.  */
 #ifndef lint
-# define YYID(n) (n)
+# define YYID(N) (N)
 #else
 #if (defined __STDC__ || defined __C99__FUNC__ \
      || defined __cplusplus || defined _MSC_VER)
@@ -302,11 +321,12 @@ YYID (yyi)
 #    define alloca _alloca
 #   else
 #    define YYSTACK_ALLOC alloca
-#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
+#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
      || defined __cplusplus || defined _MSC_VER)
 #     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
-#     ifndef _STDLIB_H
-#      define _STDLIB_H 1
+      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
+#     ifndef EXIT_SUCCESS
+#      define EXIT_SUCCESS 0
 #     endif
 #    endif
 #   endif
@@ -329,24 +349,24 @@ YYID (yyi)
 #  ifndef YYSTACK_ALLOC_MAXIMUM
 #   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
 #  endif
-#  if (defined __cplusplus && ! defined _STDLIB_H \
+#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
        && ! ((defined YYMALLOC || defined malloc) \
 	     && (defined YYFREE || defined free)))
 #   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
-#   ifndef _STDLIB_H
-#    define _STDLIB_H 1
+#   ifndef EXIT_SUCCESS
+#    define EXIT_SUCCESS 0
 #   endif
 #  endif
 #  ifndef YYMALLOC
 #   define YYMALLOC malloc
-#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
+#   if ! defined malloc && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
      || defined __cplusplus || defined _MSC_VER)
 void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
 #   endif
 #  endif
 #  ifndef YYFREE
 #   define YYFREE free
-#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
+#   if ! defined free && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
      || defined __cplusplus || defined _MSC_VER)
 void free (void *); /* INFRINGES ON USER NAME SPACE */
 #   endif
@@ -375,23 +395,7 @@ union yyalloc
      ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
       + YYSTACK_GAP_MAXIMUM)
 
-/* Copy COUNT objects from FROM to TO.  The source and destination do
-   not overlap.  */
-# ifndef YYCOPY
-#  if defined __GNUC__ && 1 < __GNUC__
-#   define YYCOPY(To, From, Count) \
-      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
-#  else
-#   define YYCOPY(To, From, Count)		\
-      do					\
-	{					\
-	  YYSIZE_T yyi;				\
-	  for (yyi = 0; yyi < (Count); yyi++)	\
-	    (To)[yyi] = (From)[yyi];		\
-	}					\
-      while (YYID (0))
-#  endif
-# endif
+# define YYCOPY_NEEDED 1
 
 /* Relocate STACK from its old location to the new one.  The
    local variables YYSIZE and YYSTACKSIZE give the old and new number of
@@ -411,23 +415,43 @@ union yyalloc
 
 #endif
 
+#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
+/* Copy COUNT objects from SRC to DST.  The source and destination do
+   not overlap.  */
+# ifndef YYCOPY
+#  if defined __GNUC__ && 1 < __GNUC__
+#   define YYCOPY(Dst, Src, Count) \
+      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
+#  else
+#   define YYCOPY(Dst, Src, Count)              \
+      do                                        \
+        {                                       \
+          YYSIZE_T yyi;                         \
+          for (yyi = 0; yyi < (Count); yyi++)   \
+            (Dst)[yyi] = (Src)[yyi];            \
+        }                                       \
+      while (YYID (0))
+#  endif
+# endif
+#endif /* !YYCOPY_NEEDED */
+
 /* YYFINAL -- State number of the termination state.  */
 #define YYFINAL  11
 /* YYLAST -- Last index in YYTABLE.  */
-#define YYLAST   290
+#define YYLAST   298
 
 /* YYNTOKENS -- Number of terminals.  */
-#define YYNTOKENS  36
+#define YYNTOKENS  37
 /* YYNNTS -- Number of nonterminals.  */
 #define YYNNTS  50
 /* YYNRULES -- Number of rules.  */
-#define YYNRULES  118
+#define YYNRULES  120
 /* YYNRULES -- Number of states.  */
-#define YYNSTATES  191
+#define YYNSTATES  196
 
 /* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
 #define YYUNDEFTOK  2
-#define YYMAXUTOK   290
+#define YYMAXUTOK   291
 
 #define YYTRANSLATE(YYX)						\
   ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)
@@ -464,7 +488,7 @@ static const yytype_uint8 yytranslate[] =
        5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
       15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
       25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
-      35
+      35,    36
 };
 
 #if YYDEBUG
@@ -474,56 +498,58 @@ static const yytype_uint16 yyprhs[] =
 {
        0,     0,     3,     6,     8,    11,    13,    14,    17,    20,
       23,    26,    31,    36,    40,    42,    44,    46,    48,    50,
-      52,    54,    56,    58,    60,    62,    64,    66,    68,    72,
-      75,    79,    82,    86,    89,    90,    93,    96,    99,   102,
-     105,   108,   112,   117,   122,   127,   133,   137,   138,   142,
-     143,   146,   150,   153,   155,   159,   160,   163,   166,   169,
-     172,   175,   180,   184,   187,   192,   193,   196,   200,   202,
-     206,   207,   210,   213,   216,   220,   224,   228,   230,   234,
-     235,   238,   241,   244,   248,   252,   255,   258,   261,   262,
-     265,   268,   271,   276,   277,   280,   283,   286,   287,   290,
-     292,   294,   297,   300,   303,   305,   308,   309,   312,   314,
-     318,   322,   326,   329,   333,   337,   339,   341,   342
+      52,    54,    56,    58,    60,    62,    64,    66,    68,    70,
+      74,    77,    81,    84,    88,    91,    92,    95,    98,   101,
+     104,   107,   110,   114,   119,   124,   129,   134,   140,   144,
+     145,   149,   150,   153,   157,   160,   162,   166,   167,   170,
+     173,   176,   179,   182,   187,   191,   194,   199,   200,   203,
+     207,   209,   213,   214,   217,   220,   223,   227,   231,   235,
+     237,   241,   242,   245,   248,   251,   255,   259,   262,   265,
+     268,   269,   272,   275,   278,   283,   284,   287,   290,   293,
+     294,   297,   299,   301,   304,   307,   310,   312,   315,   316,
+     319,   321,   325,   329,   333,   336,   340,   344,   346,   348,
+     349
 };
 
 /* YYRHS -- A `-1'-separated list of the rules' RHS.  */
 static const yytype_int8 yyrhs[] =
 {
-      37,     0,    -1,    81,    38,    -1,    38,    -1,    63,    39,
-      -1,    39,    -1,    -1,    39,    41,    -1,    39,    55,    -1,
-      39,    67,    -1,    39,    80,    -1,    39,    26,     1,    31,
-      -1,    39,    40,     1,    31,    -1,    39,     1,    31,    -1,
-      16,    -1,    18,    -1,    19,    -1,    21,    -1,    17,    -1,
-      22,    -1,    20,    -1,    23,    -1,    31,    -1,    61,    -1,
-      71,    -1,    44,    -1,    46,    -1,    69,    -1,    26,     1,
-      31,    -1,     1,    31,    -1,    10,    26,    31,    -1,    43,
-      47,    -1,    11,    26,    31,    -1,    45,    47,    -1,    -1,
-      47,    48,    -1,    47,    49,    -1,    47,    75,    -1,    47,
-      73,    -1,    47,    42,    -1,    47,    31,    -1,    19,    78,
-      31,    -1,    18,    79,    82,    31,    -1,    20,    83,    82,
-      31,    -1,    21,    26,    82,    31,    -1,    22,    84,    84,
-      82,    31,    -1,    24,    50,    31,    -1,    -1,    50,    26,
-      51,    -1,    -1,    34,    79,    -1,     7,    85,    31,    -1,
-      52,    56,    -1,    80,    -1,    53,    58,    54,    -1,    -1,
-      56,    57,    -1,    56,    75,    -1,    56,    73,    -1,    56,
-      31,    -1,    56,    42,    -1,    18,    79,    82,    31,    -1,
-      19,    78,    31,    -1,    17,    31,    -1,    20,    26,    82,
-      31,    -1,    -1,    58,    41,    -1,    14,    83,    81,    -1,
-      80,    -1,    59,    62,    60,    -1,    -1,    62,    41,    -1,
-      62,    67,    -1,    62,    55,    -1,     3,    79,    81,    -1,
-       4,    79,    31,    -1,    64,    76,    74,    -1,    80,    -1,
-      65,    68,    66,    -1,    -1,    68,    41,    -1,    68,    67,
-      -1,    68,    55,    -1,     6,    79,    31,    -1,     9,    79,
-      31,    -1,    70,    74,    -1,    12,    31,    -1,    72,    13,
-      -1,    -1,    74,    75,    -1,    74,    31,    -1,    74,    42,
-      -1,    16,    25,    83,    31,    -1,    -1,    76,    77,    -1,
-      76,    31,    -1,    23,    82,    -1,    -1,    79,    82,    -1,
-      26,    -1,    27,    -1,     5,    31,    -1,     8,    31,    -1,
-      15,    31,    -1,    31,    -1,    81,    31,    -1,    -1,    14,
-      83,    -1,    84,    -1,    84,    34,    84,    -1,    84,    28,
-      84,    -1,    30,    83,    29,    -1,    35,    83,    -1,    83,
-      32,    83,    -1,    83,    33,    83,    -1,    26,    -1,    27,
-      -1,    -1,    26,    -1
+      38,     0,    -1,    82,    39,    -1,    39,    -1,    64,    40,
+      -1,    40,    -1,    -1,    40,    42,    -1,    40,    56,    -1,
+      40,    68,    -1,    40,    81,    -1,    40,    27,     1,    32,
+      -1,    40,    41,     1,    32,    -1,    40,     1,    32,    -1,
+      16,    -1,    18,    -1,    19,    -1,    21,    -1,    22,    -1,
+      17,    -1,    23,    -1,    20,    -1,    24,    -1,    32,    -1,
+      62,    -1,    72,    -1,    45,    -1,    47,    -1,    70,    -1,
+      27,     1,    32,    -1,     1,    32,    -1,    10,    27,    32,
+      -1,    44,    48,    -1,    11,    27,    32,    -1,    46,    48,
+      -1,    -1,    48,    49,    -1,    48,    50,    -1,    48,    76,
+      -1,    48,    74,    -1,    48,    43,    -1,    48,    32,    -1,
+      19,    79,    32,    -1,    18,    80,    83,    32,    -1,    20,
+      84,    83,    32,    -1,    21,    27,    83,    32,    -1,    22,
+      27,    83,    32,    -1,    23,    85,    85,    83,    32,    -1,
+      25,    51,    32,    -1,    -1,    51,    27,    52,    -1,    -1,
+      35,    80,    -1,     7,    86,    32,    -1,    53,    57,    -1,
+      81,    -1,    54,    59,    55,    -1,    -1,    57,    58,    -1,
+      57,    76,    -1,    57,    74,    -1,    57,    32,    -1,    57,
+      43,    -1,    18,    80,    83,    32,    -1,    19,    79,    32,
+      -1,    17,    32,    -1,    20,    27,    83,    32,    -1,    -1,
+      59,    42,    -1,    14,    84,    82,    -1,    81,    -1,    60,
+      63,    61,    -1,    -1,    63,    42,    -1,    63,    68,    -1,
+      63,    56,    -1,     3,    80,    82,    -1,     4,    80,    32,
+      -1,    65,    77,    75,    -1,    81,    -1,    66,    69,    67,
+      -1,    -1,    69,    42,    -1,    69,    68,    -1,    69,    56,
+      -1,     6,    80,    32,    -1,     9,    80,    32,    -1,    71,
+      75,    -1,    12,    32,    -1,    73,    13,    -1,    -1,    75,
+      76,    -1,    75,    32,    -1,    75,    43,    -1,    16,    26,
+      84,    32,    -1,    -1,    77,    78,    -1,    77,    32,    -1,
+      24,    83,    -1,    -1,    80,    83,    -1,    27,    -1,    28,
+      -1,     5,    32,    -1,     8,    32,    -1,    15,    32,    -1,
+      32,    -1,    82,    32,    -1,    -1,    14,    84,    -1,    85,
+      -1,    85,    35,    85,    -1,    85,    29,    85,    -1,    31,
+      84,    30,    -1,    36,    84,    -1,    84,    33,    84,    -1,
+      84,    34,    84,    -1,    27,    -1,    28,    -1,    -1,    27,
+      -1
 };
 
 /* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
@@ -531,20 +557,21 @@ static const yytype_uint16 yyrline[] =
 {
        0,   104,   104,   104,   106,   106,   108,   110,   111,   112,
      113,   114,   115,   119,   123,   123,   123,   123,   123,   123,
-     123,   123,   127,   128,   129,   130,   131,   132,   136,   137,
-     143,   151,   157,   165,   175,   177,   178,   179,   180,   181,
-     182,   185,   193,   199,   209,   215,   221,   224,   226,   237,
-     238,   243,   252,   257,   265,   268,   270,   271,   272,   273,
-     274,   277,   283,   294,   300,   310,   312,   317,   325,   333,
-     336,   338,   339,   340,   345,   352,   359,   364,   372,   375,
-     377,   378,   379,   382,   390,   397,   404,   410,   417,   419,
-     420,   421,   424,   432,   434,   435,   438,   445,   447,   452,
-     453,   456,   457,   458,   462,   463,   466,   467,   470,   471,
-     472,   473,   474,   475,   476,   479,   480,   483,   484
+     123,   123,   123,   127,   128,   129,   130,   131,   132,   136,
+     137,   143,   151,   157,   165,   175,   177,   178,   179,   180,
+     181,   182,   185,   193,   199,   209,   215,   221,   227,   230,
+     232,   243,   244,   249,   258,   263,   271,   274,   276,   277,
+     278,   279,   280,   283,   289,   300,   306,   316,   318,   323,
+     331,   339,   342,   344,   345,   346,   351,   358,   365,   370,
+     378,   381,   383,   384,   385,   388,   396,   403,   410,   416,
+     423,   425,   426,   427,   430,   438,   440,   441,   444,   451,
+     453,   458,   459,   462,   463,   464,   468,   469,   472,   473,
+     476,   477,   478,   479,   480,   481,   482,   485,   486,   489,
+     490
 };
 #endif
 
-#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
+#if YYDEBUG || YYERROR_VERBOSE || 0
 /* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
    First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
 static const char *const yytname[] =
@@ -552,20 +579,21 @@ static const char *const yytname[] =
   "$end", "error", "$undefined", "T_MAINMENU", "T_MENU", "T_ENDMENU",
   "T_SOURCE", "T_CHOICE", "T_ENDCHOICE", "T_COMMENT", "T_CONFIG",
   "T_MENUCONFIG", "T_HELP", "T_HELPTEXT", "T_IF", "T_ENDIF", "T_DEPENDS",
-  "T_OPTIONAL", "T_PROMPT", "T_TYPE", "T_DEFAULT", "T_SELECT", "T_RANGE",
-  "T_VISIBLE", "T_OPTION", "T_ON", "T_WORD", "T_WORD_QUOTE", "T_UNEQUAL",
-  "T_CLOSE_PAREN", "T_OPEN_PAREN", "T_EOL", "T_OR", "T_AND", "T_EQUAL",
-  "T_NOT", "$accept", "input", "start", "stmt_list", "option_name",
-  "common_stmt", "option_error", "config_entry_start", "config_stmt",
-  "menuconfig_entry_start", "menuconfig_stmt", "config_option_list",
-  "config_option", "symbol_option", "symbol_option_list",
-  "symbol_option_arg", "choice", "choice_entry", "choice_end",
-  "choice_stmt", "choice_option_list", "choice_option", "choice_block",
-  "if_entry", "if_end", "if_stmt", "if_block", "mainmenu_stmt", "menu",
-  "menu_entry", "menu_end", "menu_stmt", "menu_block", "source_stmt",
-  "comment", "comment_stmt", "help_start", "help", "depends_list",
-  "depends", "visibility_list", "visible", "prompt_stmt_opt", "prompt",
-  "end", "nl", "if_expr", "expr", "symbol", "word_opt", 0
+  "T_OPTIONAL", "T_PROMPT", "T_TYPE", "T_DEFAULT", "T_SELECT", "T_APPLY",
+  "T_RANGE", "T_VISIBLE", "T_OPTION", "T_ON", "T_WORD", "T_WORD_QUOTE",
+  "T_UNEQUAL", "T_CLOSE_PAREN", "T_OPEN_PAREN", "T_EOL", "T_OR", "T_AND",
+  "T_EQUAL", "T_NOT", "$accept", "input", "start", "stmt_list",
+  "option_name", "common_stmt", "option_error", "config_entry_start",
+  "config_stmt", "menuconfig_entry_start", "menuconfig_stmt",
+  "config_option_list", "config_option", "symbol_option",
+  "symbol_option_list", "symbol_option_arg", "choice", "choice_entry",
+  "choice_end", "choice_stmt", "choice_option_list", "choice_option",
+  "choice_block", "if_entry", "if_end", "if_stmt", "if_block",
+  "mainmenu_stmt", "menu", "menu_entry", "menu_end", "menu_stmt",
+  "menu_block", "source_stmt", "comment", "comment_stmt", "help_start",
+  "help", "depends_list", "depends", "visibility_list", "visible",
+  "prompt_stmt_opt", "prompt", "end", "nl", "if_expr", "expr", "symbol",
+  "word_opt", YY_NULL
 };
 #endif
 
@@ -577,25 +605,26 @@ static const yytype_uint16 yytoknum[] =
        0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
      265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
      275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
-     285,   286,   287,   288,   289,   290
+     285,   286,   287,   288,   289,   290,   291
 };
 # endif
 
 /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
 static const yytype_uint8 yyr1[] =
 {
-       0,    36,    37,    37,    38,    38,    39,    39,    39,    39,
-      39,    39,    39,    39,    40,    40,    40,    40,    40,    40,
-      40,    40,    41,    41,    41,    41,    41,    41,    42,    42,
-      43,    44,    45,    46,    47,    47,    47,    47,    47,    47,
-      47,    48,    48,    48,    48,    48,    49,    50,    50,    51,
-      51,    52,    53,    54,    55,    56,    56,    56,    56,    56,
-      56,    57,    57,    57,    57,    58,    58,    59,    60,    61,
-      62,    62,    62,    62,    63,    64,    65,    66,    67,    68,
-      68,    68,    68,    69,    70,    71,    72,    73,    74,    74,
-      74,    74,    75,    76,    76,    76,    77,    78,    78,    79,
-      79,    80,    80,    80,    81,    81,    82,    82,    83,    83,
-      83,    83,    83,    83,    83,    84,    84,    85,    85
+       0,    37,    38,    38,    39,    39,    40,    40,    40,    40,
+      40,    40,    40,    40,    41,    41,    41,    41,    41,    41,
+      41,    41,    41,    42,    42,    42,    42,    42,    42,    43,
+      43,    44,    45,    46,    47,    48,    48,    48,    48,    48,
+      48,    48,    49,    49,    49,    49,    49,    49,    50,    51,
+      51,    52,    52,    53,    54,    55,    56,    57,    57,    57,
+      57,    57,    57,    58,    58,    58,    58,    59,    59,    60,
+      61,    62,    63,    63,    63,    63,    64,    65,    66,    67,
+      68,    69,    69,    69,    69,    70,    71,    72,    73,    74,
+      75,    75,    75,    75,    76,    77,    77,    77,    78,    79,
+      79,    80,    80,    81,    81,    81,    82,    82,    83,    83,
+      84,    84,    84,    84,    84,    84,    84,    85,    85,    86,
+      86
 };
 
 /* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
@@ -603,189 +632,195 @@ static const yytype_uint8 yyr2[] =
 {
        0,     2,     2,     1,     2,     1,     0,     2,     2,     2,
        2,     4,     4,     3,     1,     1,     1,     1,     1,     1,
-       1,     1,     1,     1,     1,     1,     1,     1,     3,     2,
-       3,     2,     3,     2,     0,     2,     2,     2,     2,     2,
-       2,     3,     4,     4,     4,     5,     3,     0,     3,     0,
-       2,     3,     2,     1,     3,     0,     2,     2,     2,     2,
-       2,     4,     3,     2,     4,     0,     2,     3,     1,     3,
-       0,     2,     2,     2,     3,     3,     3,     1,     3,     0,
-       2,     2,     2,     3,     3,     2,     2,     2,     0,     2,
-       2,     2,     4,     0,     2,     2,     2,     0,     2,     1,
-       1,     2,     2,     2,     1,     2,     0,     2,     1,     3,
-       3,     3,     2,     3,     3,     1,     1,     0,     1
+       1,     1,     1,     1,     1,     1,     1,     1,     1,     3,
+       2,     3,     2,     3,     2,     0,     2,     2,     2,     2,
+       2,     2,     3,     4,     4,     4,     4,     5,     3,     0,
+       3,     0,     2,     3,     2,     1,     3,     0,     2,     2,
+       2,     2,     2,     4,     3,     2,     4,     0,     2,     3,
+       1,     3,     0,     2,     2,     2,     3,     3,     3,     1,
+       3,     0,     2,     2,     2,     3,     3,     2,     2,     2,
+       0,     2,     2,     2,     4,     0,     2,     2,     2,     0,
+       2,     1,     1,     2,     2,     2,     1,     2,     0,     2,
+       1,     3,     3,     3,     2,     3,     3,     1,     1,     0,
+       1
 };
 
-/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
-   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
+/* YYDEFACT[STATE-NAME] -- Default reduction number in state STATE-NUM.
+   Performed when YYTABLE doesn't specify something else to do.  Zero
    means the default is an error.  */
 static const yytype_uint8 yydefact[] =
 {
-       6,     0,   104,     0,     3,     0,     6,     6,    99,   100,
-       0,     1,     0,     0,     0,     0,   117,     0,     0,     0,
-       0,     0,     0,    14,    18,    15,    16,    20,    17,    19,
-      21,     0,    22,     0,     7,    34,    25,    34,    26,    55,
-      65,     8,    70,    23,    93,    79,     9,    27,    88,    24,
-      10,     0,   105,     2,    74,    13,     0,   101,     0,   118,
-       0,   102,     0,     0,     0,   115,   116,     0,     0,     0,
-     108,   103,     0,     0,     0,     0,     0,     0,     0,    88,
-       0,     0,    75,    83,    51,    84,    30,    32,     0,   112,
-       0,     0,    67,     0,     0,    11,    12,     0,     0,     0,
-       0,    97,     0,     0,     0,    47,     0,    40,    39,    35,
-      36,     0,    38,    37,     0,     0,    97,     0,    59,    60,
-      56,    58,    57,    66,    54,    53,    71,    73,    69,    72,
-      68,   106,    95,     0,    94,    80,    82,    78,    81,    77,
-      90,    91,    89,   111,   113,   114,   110,   109,    29,    86,
-       0,   106,     0,   106,   106,   106,     0,     0,     0,    87,
-      63,   106,     0,   106,     0,    96,     0,     0,    41,    98,
-       0,     0,   106,    49,    46,    28,     0,    62,     0,   107,
-      92,    42,    43,    44,     0,     0,    48,    61,    64,    45,
-      50
+       6,     0,   106,     0,     3,     0,     6,     6,   101,   102,
+       0,     1,     0,     0,     0,     0,   119,     0,     0,     0,
+       0,     0,     0,    14,    19,    15,    16,    21,    17,    18,
+      20,    22,     0,    23,     0,     7,    35,    26,    35,    27,
+      57,    67,     8,    72,    24,    95,    81,     9,    28,    90,
+      25,    10,     0,   107,     2,    76,    13,     0,   103,     0,
+     120,     0,   104,     0,     0,     0,   117,   118,     0,     0,
+       0,   110,   105,     0,     0,     0,     0,     0,     0,     0,
+      90,     0,     0,    77,    85,    53,    86,    31,    33,     0,
+     114,     0,     0,    69,     0,     0,    11,    12,     0,     0,
+       0,     0,    99,     0,     0,     0,     0,    49,     0,    41,
+      40,    36,    37,     0,    39,    38,     0,     0,    99,     0,
+      61,    62,    58,    60,    59,    68,    56,    55,    73,    75,
+      71,    74,    70,   108,    97,     0,    96,    82,    84,    80,
+      83,    79,    92,    93,    91,   113,   115,   116,   112,   111,
+      30,    88,     0,   108,     0,   108,   108,   108,   108,     0,
+       0,     0,    89,    65,   108,     0,   108,     0,    98,     0,
+       0,    42,   100,     0,     0,     0,   108,    51,    48,    29,
+       0,    64,     0,   109,    94,    43,    44,    45,    46,     0,
+       0,    50,    63,    66,    47,    52
 };
 
 /* YYDEFGOTO[NTERM-NUM].  */
 static const yytype_int16 yydefgoto[] =
 {
-      -1,     3,     4,     5,    33,    34,   108,    35,    36,    37,
-      38,    74,   109,   110,   157,   186,    39,    40,   124,    41,
-      76,   120,    77,    42,   128,    43,    78,     6,    44,    45,
-     137,    46,    80,    47,    48,    49,   111,   112,    81,   113,
-      79,   134,   152,   153,    50,     7,   165,    69,    70,    60
+      -1,     3,     4,     5,    34,    35,   110,    36,    37,    38,
+      39,    75,   111,   112,   160,   191,    40,    41,   126,    42,
+      77,   122,    78,    43,   130,    44,    79,     6,    45,    46,
+     139,    47,    81,    48,    49,    50,   113,   114,    82,   115,
+      80,   136,   154,   155,    51,     7,   168,    70,    71,    61
 };
 
 /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
    STATE-NUM.  */
-#define YYPACT_NINF -90
+#define YYPACT_NINF -91
 static const yytype_int16 yypact[] =
 {
-       4,    42,   -90,    96,   -90,   111,   -90,    15,   -90,   -90,
-      75,   -90,    82,    42,   104,    42,   110,   107,    42,   115,
-     125,    -4,   121,   -90,   -90,   -90,   -90,   -90,   -90,   -90,
-     -90,   162,   -90,   163,   -90,   -90,   -90,   -90,   -90,   -90,
-     -90,   -90,   -90,   -90,   -90,   -90,   -90,   -90,   -90,   -90,
-     -90,   139,   -90,   -90,   138,   -90,   142,   -90,   143,   -90,
-     152,   -90,   164,   167,   168,   -90,   -90,    -4,    -4,    77,
-     -18,   -90,   177,   185,    33,    71,   195,   247,   236,    -2,
-     236,   171,   -90,   -90,   -90,   -90,   -90,   -90,    41,   -90,
-      -4,    -4,   138,    97,    97,   -90,   -90,   186,   187,   194,
-      42,    42,    -4,   196,    97,   -90,   219,   -90,   -90,   -90,
-     -90,   210,   -90,   -90,   204,    42,    42,   199,   -90,   -90,
-     -90,   -90,   -90,   -90,   -90,   -90,   -90,   -90,   -90,   -90,
-     -90,   222,   -90,   223,   -90,   -90,   -90,   -90,   -90,   -90,
-     -90,   -90,   -90,   -90,   215,   -90,   -90,   -90,   -90,   -90,
-      -4,   222,   228,   222,    -5,   222,    97,    35,   229,   -90,
-     -90,   222,   232,   222,    -4,   -90,   135,   233,   -90,   -90,
-     234,   235,   222,   240,   -90,   -90,   237,   -90,   239,   -13,
-     -90,   -90,   -90,   -90,   244,    42,   -90,   -90,   -90,   -90,
-     -90
+       6,    52,   -91,    70,   -91,   132,   -91,    16,   -91,   -91,
+      55,   -91,    59,    52,    66,    52,    75,   102,    52,   117,
+     118,    57,   125,   -91,   -91,   -91,   -91,   -91,   -91,   -91,
+     -91,   -91,   157,   -91,   159,   -91,   -91,   -91,   -91,   -91,
+     -91,   -91,   -91,   -91,   -91,   -91,   -91,   -91,   -91,   -91,
+     -91,   -91,   161,   -91,   -91,   131,   -91,   141,   -91,   142,
+     -91,   154,   -91,   155,   160,   170,   -91,   -91,    57,    57,
+      63,   -11,   -91,   171,   183,    35,   103,   215,   255,   244,
+     -17,   244,   190,   -91,   -91,   -91,   -91,   -91,   -91,    -2,
+     -91,    57,    57,   131,    78,    78,   -91,   -91,   186,   187,
+     202,    52,    52,    57,   212,   213,    78,   -91,   240,   -91,
+     -91,   -91,   -91,   230,   -91,   -91,   214,    52,    52,   217,
+     -91,   -91,   -91,   -91,   -91,   -91,   -91,   -91,   -91,   -91,
+     -91,   -91,   -91,   231,   -91,    67,   -91,   -91,   -91,   -91,
+     -91,   -91,   -91,   -91,   -91,   -91,   222,   -91,   -91,   -91,
+     -91,   -91,    57,   231,   225,   231,    -4,   231,   231,    78,
+      -5,   235,   -91,   -91,   231,   236,   231,    57,   -91,   204,
+     239,   -91,   -91,   241,   242,   249,   231,   227,   -91,   -91,
+     250,   -91,   251,     0,   -91,   -91,   -91,   -91,   -91,   252,
+      52,   -91,   -91,   -91,   -91,   -91
 };
 
 /* YYPGOTO[NTERM-NUM].  */
 static const yytype_int16 yypgoto[] =
 {
-     -90,   -90,   269,   271,   -90,    23,   -70,   -90,   -90,   -90,
-     -90,   243,   -90,   -90,   -90,   -90,   -90,   -90,   -90,   -48,
-     -90,   -90,   -90,   -90,   -90,   -90,   -90,   -90,   -90,   -90,
-     -90,   -20,   -90,   -90,   -90,   -90,   -90,   206,   205,   -68,
-     -90,   -90,   169,    -1,    27,    -7,   118,   -66,   -89,   -90
+     -91,   -91,   265,   279,   -91,   -58,   -71,   -91,   -91,   -91,
+     -91,   253,   -91,   -91,   -91,   -91,   -91,   -91,   -91,   -16,
+     -91,   -91,   -91,   -91,   -91,   -91,   -91,   -91,   -91,   -91,
+     -91,    50,   -91,   -91,   -91,   -91,   -91,   216,   209,   -69,
+     -91,   -91,   172,    -1,    11,    -9,   122,   -66,   -90,   -91
 };
 
 /* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
    positive, shift that token.  If negative, reduce the rule which
-   number is the opposite.  If zero, do what YYDEFACT says.
-   If YYTABLE_NINF, syntax error.  */
-#define YYTABLE_NINF -86
+   number is the opposite.  If YYTABLE_NINF, syntax error.  */
+#define YYTABLE_NINF -88
 static const yytype_int16 yytable[] =
 {
-      10,    88,    89,    54,   146,   147,   119,     1,   122,   164,
-      93,   141,    56,   142,    58,   156,    94,    62,     1,    90,
-      91,   131,    65,    66,   144,   145,    67,    90,    91,   132,
-     127,    68,   136,   -31,    97,     2,   154,   -31,   -31,   -31,
-     -31,   -31,   -31,   -31,   -31,    98,    52,   -31,   -31,    99,
-     -31,   100,   101,   102,   103,   104,   -31,   105,   129,   106,
-     138,   173,    92,   141,   107,   142,   174,   172,     8,     9,
-     143,   -33,    97,    90,    91,   -33,   -33,   -33,   -33,   -33,
-     -33,   -33,   -33,    98,   166,   -33,   -33,    99,   -33,   100,
-     101,   102,   103,   104,   -33,   105,    11,   106,   179,   151,
-     123,   126,   107,   135,   125,   130,     2,   139,     2,    90,
-      91,    -5,    12,    55,   161,    13,    14,    15,    16,    17,
-      18,    19,    20,    65,    66,    21,    22,    23,    24,    25,
-      26,    27,    28,    29,    30,    57,    59,    31,    61,    -4,
-      12,    63,    32,    13,    14,    15,    16,    17,    18,    19,
-      20,    64,    71,    21,    22,    23,    24,    25,    26,    27,
-      28,    29,    30,    72,    73,    31,   180,    90,    91,    52,
-      32,   -85,    97,    82,    83,   -85,   -85,   -85,   -85,   -85,
-     -85,   -85,   -85,    84,   190,   -85,   -85,    99,   -85,   -85,
-     -85,   -85,   -85,   -85,   -85,    85,    97,   106,    86,    87,
-     -52,   -52,   140,   -52,   -52,   -52,   -52,    98,    95,   -52,
-     -52,    99,   114,   115,   116,   117,    96,   148,   149,   150,
-     158,   106,   155,   159,    97,   163,   118,   -76,   -76,   -76,
-     -76,   -76,   -76,   -76,   -76,   160,   164,   -76,   -76,    99,
-      13,    14,    15,    16,    17,    18,    19,    20,    91,   106,
-      21,    22,    14,    15,   140,    17,    18,    19,    20,   168,
-     175,    21,    22,   177,   181,   182,   183,    32,   187,   167,
-     188,   169,   170,   171,   185,   189,    53,    51,    32,   176,
-      75,   178,   121,     0,   133,   162,     0,     0,     0,     0,
-     184
+      10,    55,    89,    90,   148,   149,   121,   133,   124,     1,
+     167,   143,    57,   144,    59,   134,   159,    63,    94,     1,
+     125,   128,   177,   137,    95,   146,   147,   178,   145,    91,
+      92,    91,    92,    91,    92,   -32,    98,   156,     2,   -32,
+     -32,   -32,   -32,   -32,   -32,   -32,   -32,    99,    53,   -32,
+     -32,   100,   -32,   101,   102,   103,   104,   105,   106,   -32,
+     107,    93,   108,   129,   143,   138,   144,   109,    98,   176,
+      11,   -78,   -78,   -78,   -78,   -78,   -78,   -78,   -78,     8,
+       9,   -78,   -78,   100,    66,    67,   169,     2,    68,   127,
+     132,    56,   141,    69,   108,     2,    91,    92,    58,   142,
+     153,   183,    60,   -34,    98,    66,    67,   -34,   -34,   -34,
+     -34,   -34,   -34,   -34,   -34,    99,   164,   -34,   -34,   100,
+     -34,   101,   102,   103,   104,   105,   106,   -34,   107,   131,
+     108,   140,    -5,    12,    62,   109,    13,    14,    15,    16,
+      17,    18,    19,    20,    64,    65,    21,    22,    23,    24,
+      25,    26,    27,    28,    29,    30,    31,    72,    73,    32,
+      74,    -4,    12,    53,    33,    13,    14,    15,    16,    17,
+      18,    19,    20,    83,    84,    21,    22,    23,    24,    25,
+      26,    27,    28,    29,    30,    31,    85,    86,    32,   195,
+     -87,    98,    87,    33,   -87,   -87,   -87,   -87,   -87,   -87,
+     -87,   -87,    88,    96,   -87,   -87,   100,   -87,   -87,   -87,
+     -87,   -87,   -87,   -87,   -87,    97,    98,   108,   150,   151,
+     -54,   -54,   142,   -54,   -54,   -54,   -54,    99,   152,   -54,
+     -54,   100,   116,   117,   118,   119,   184,    91,    92,   157,
+     158,   161,   108,   162,   166,   167,   163,   120,    13,    14,
+      15,    16,    17,    18,    19,    20,    92,   171,    21,    22,
+      14,    15,   190,    17,    18,    19,    20,   179,   181,    21,
+      22,   185,    54,   186,   187,   170,    33,   172,   173,   174,
+     175,   188,   192,   193,   194,    52,   180,    33,   182,   135,
+     165,    76,     0,   123,     0,     0,     0,     0,   189
 };
 
+#define yypact_value_is_default(Yystate) \
+  (!!((Yystate) == (-91)))
+
+#define yytable_value_is_error(Yytable_value) \
+  YYID (0)
+
 static const yytype_int16 yycheck[] =
 {
-       1,    67,    68,    10,    93,    94,    76,     3,    76,    14,
-      28,    81,    13,    81,    15,   104,    34,    18,     3,    32,
-      33,    23,    26,    27,    90,    91,    30,    32,    33,    31,
-      78,    35,    80,     0,     1,    31,   102,     4,     5,     6,
-       7,     8,     9,    10,    11,    12,    31,    14,    15,    16,
-      17,    18,    19,    20,    21,    22,    23,    24,    78,    26,
-      80,    26,    69,   133,    31,   133,    31,   156,    26,    27,
-      29,     0,     1,    32,    33,     4,     5,     6,     7,     8,
-       9,    10,    11,    12,   150,    14,    15,    16,    17,    18,
-      19,    20,    21,    22,    23,    24,     0,    26,   164,   100,
-      77,    78,    31,    80,    77,    78,    31,    80,    31,    32,
-      33,     0,     1,    31,   115,     4,     5,     6,     7,     8,
-       9,    10,    11,    26,    27,    14,    15,    16,    17,    18,
-      19,    20,    21,    22,    23,    31,    26,    26,    31,     0,
-       1,    26,    31,     4,     5,     6,     7,     8,     9,    10,
-      11,    26,    31,    14,    15,    16,    17,    18,    19,    20,
-      21,    22,    23,     1,     1,    26,    31,    32,    33,    31,
-      31,     0,     1,    31,    31,     4,     5,     6,     7,     8,
-       9,    10,    11,    31,   185,    14,    15,    16,    17,    18,
-      19,    20,    21,    22,    23,    31,     1,    26,    31,    31,
-       5,     6,    31,     8,     9,    10,    11,    12,    31,    14,
-      15,    16,    17,    18,    19,    20,    31,    31,    31,    25,
-       1,    26,    26,    13,     1,    26,    31,     4,     5,     6,
-       7,     8,     9,    10,    11,    31,    14,    14,    15,    16,
-       4,     5,     6,     7,     8,     9,    10,    11,    33,    26,
-      14,    15,     5,     6,    31,     8,     9,    10,    11,    31,
-      31,    14,    15,    31,    31,    31,    31,    31,    31,   151,
-      31,   153,   154,   155,    34,    31,     7,     6,    31,   161,
-      37,   163,    76,    -1,    79,   116,    -1,    -1,    -1,    -1,
-     172
+       1,    10,    68,    69,    94,    95,    77,    24,    77,     3,
+      14,    82,    13,    82,    15,    32,   106,    18,    29,     3,
+      78,    79,    27,    81,    35,    91,    92,    32,    30,    33,
+      34,    33,    34,    33,    34,     0,     1,   103,    32,     4,
+       5,     6,     7,     8,     9,    10,    11,    12,    32,    14,
+      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
+      25,    70,    27,    79,   135,    81,   135,    32,     1,   159,
+       0,     4,     5,     6,     7,     8,     9,    10,    11,    27,
+      28,    14,    15,    16,    27,    28,   152,    32,    31,    78,
+      79,    32,    81,    36,    27,    32,    33,    34,    32,    32,
+     101,   167,    27,     0,     1,    27,    28,     4,     5,     6,
+       7,     8,     9,    10,    11,    12,   117,    14,    15,    16,
+      17,    18,    19,    20,    21,    22,    23,    24,    25,    79,
+      27,    81,     0,     1,    32,    32,     4,     5,     6,     7,
+       8,     9,    10,    11,    27,    27,    14,    15,    16,    17,
+      18,    19,    20,    21,    22,    23,    24,    32,     1,    27,
+       1,     0,     1,    32,    32,     4,     5,     6,     7,     8,
+       9,    10,    11,    32,    32,    14,    15,    16,    17,    18,
+      19,    20,    21,    22,    23,    24,    32,    32,    27,   190,
+       0,     1,    32,    32,     4,     5,     6,     7,     8,     9,
+      10,    11,    32,    32,    14,    15,    16,    17,    18,    19,
+      20,    21,    22,    23,    24,    32,     1,    27,    32,    32,
+       5,     6,    32,     8,     9,    10,    11,    12,    26,    14,
+      15,    16,    17,    18,    19,    20,    32,    33,    34,    27,
+      27,     1,    27,    13,    27,    14,    32,    32,     4,     5,
+       6,     7,     8,     9,    10,    11,    34,    32,    14,    15,
+       5,     6,    35,     8,     9,    10,    11,    32,    32,    14,
+      15,    32,     7,    32,    32,   153,    32,   155,   156,   157,
+     158,    32,    32,    32,    32,     6,   164,    32,   166,    80,
+     118,    38,    -1,    77,    -1,    -1,    -1,    -1,   176
 };
 
 /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
    symbol of state STATE-NUM.  */
 static const yytype_uint8 yystos[] =
 {
-       0,     3,    31,    37,    38,    39,    63,    81,    26,    27,
-      79,     0,     1,     4,     5,     6,     7,     8,     9,    10,
+       0,     3,    32,    38,    39,    40,    64,    82,    27,    28,
+      80,     0,     1,     4,     5,     6,     7,     8,     9,    10,
       11,    14,    15,    16,    17,    18,    19,    20,    21,    22,
-      23,    26,    31,    40,    41,    43,    44,    45,    46,    52,
-      53,    55,    59,    61,    64,    65,    67,    69,    70,    71,
-      80,    39,    31,    38,    81,    31,    79,    31,    79,    26,
-      85,    31,    79,    26,    26,    26,    27,    30,    35,    83,
-      84,    31,     1,     1,    47,    47,    56,    58,    62,    76,
-      68,    74,    31,    31,    31,    31,    31,    31,    83,    83,
-      32,    33,    81,    28,    34,    31,    31,     1,    12,    16,
-      18,    19,    20,    21,    22,    24,    26,    31,    42,    48,
-      49,    72,    73,    75,    17,    18,    19,    20,    31,    42,
-      57,    73,    75,    41,    54,    80,    41,    55,    60,    67,
-      80,    23,    31,    74,    77,    41,    55,    66,    67,    80,
-      31,    42,    75,    29,    83,    83,    84,    84,    31,    31,
-      25,    79,    78,    79,    83,    26,    84,    50,     1,    13,
-      31,    79,    78,    26,    14,    82,    83,    82,    31,    82,
-      82,    82,    84,    26,    31,    31,    82,    31,    82,    83,
-      31,    31,    31,    31,    82,    34,    51,    31,    31,    31,
-      79
+      23,    24,    27,    32,    41,    42,    44,    45,    46,    47,
+      53,    54,    56,    60,    62,    65,    66,    68,    70,    71,
+      72,    81,    40,    32,    39,    82,    32,    80,    32,    80,
+      27,    86,    32,    80,    27,    27,    27,    28,    31,    36,
+      84,    85,    32,     1,     1,    48,    48,    57,    59,    63,
+      77,    69,    75,    32,    32,    32,    32,    32,    32,    84,
+      84,    33,    34,    82,    29,    35,    32,    32,     1,    12,
+      16,    18,    19,    20,    21,    22,    23,    25,    27,    32,
+      43,    49,    50,    73,    74,    76,    17,    18,    19,    20,
+      32,    43,    58,    74,    76,    42,    55,    81,    42,    56,
+      61,    68,    81,    24,    32,    75,    78,    42,    56,    67,
+      68,    81,    32,    43,    76,    30,    84,    84,    85,    85,
+      32,    32,    26,    80,    79,    80,    84,    27,    27,    85,
+      51,     1,    13,    32,    80,    79,    27,    14,    83,    84,
+      83,    32,    83,    83,    83,    83,    85,    27,    32,    32,
+      83,    32,    83,    84,    32,    32,    32,    32,    32,    83,
+      35,    52,    32,    32,    32,    80
 };
 
 #define yyerrok		(yyerrstatus = 0)
@@ -815,72 +850,35 @@ static const yytype_uint8 yystos[] =
 
 #define YYRECOVERING()  (!!yyerrstatus)
 
-#define YYBACKUP(Token, Value)					\
-do								\
-  if (yychar == YYEMPTY && yylen == 1)				\
-    {								\
-      yychar = (Token);						\
-      yylval = (Value);						\
-      yytoken = YYTRANSLATE (yychar);				\
-      YYPOPSTACK (1);						\
-      goto yybackup;						\
-    }								\
-  else								\
-    {								\
+#define YYBACKUP(Token, Value)                                  \
+do                                                              \
+  if (yychar == YYEMPTY)                                        \
+    {                                                           \
+      yychar = (Token);                                         \
+      yylval = (Value);                                         \
+      YYPOPSTACK (yylen);                                       \
+      yystate = *yyssp;                                         \
+      goto yybackup;                                            \
+    }                                                           \
+  else                                                          \
+    {                                                           \
       yyerror (YY_("syntax error: cannot back up")); \
       YYERROR;							\
     }								\
 while (YYID (0))
 
-
+/* Error token number */
 #define YYTERROR	1
 #define YYERRCODE	256
 
 
-/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
-   If N is 0, then set CURRENT to the empty location which ends
-   the previous symbol: RHS[0] (always defined).  */
-
-#define YYRHSLOC(Rhs, K) ((Rhs)[K])
-#ifndef YYLLOC_DEFAULT
-# define YYLLOC_DEFAULT(Current, Rhs, N)				\
-    do									\
-      if (YYID (N))                                                    \
-	{								\
-	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
-	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
-	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
-	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
-	}								\
-      else								\
-	{								\
-	  (Current).first_line   = (Current).last_line   =		\
-	    YYRHSLOC (Rhs, 0).last_line;				\
-	  (Current).first_column = (Current).last_column =		\
-	    YYRHSLOC (Rhs, 0).last_column;				\
-	}								\
-    while (YYID (0))
-#endif
-
-
-/* YY_LOCATION_PRINT -- Print the location on the stream.
-   This macro was not mandated originally: define only if we know
-   we won't break user code: when these are the locations we know.  */
-
+/* This macro is provided for backward compatibility. */
 #ifndef YY_LOCATION_PRINT
-# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL
-#  define YY_LOCATION_PRINT(File, Loc)			\
-     fprintf (File, "%d.%d-%d.%d",			\
-	      (Loc).first_line, (Loc).first_column,	\
-	      (Loc).last_line,  (Loc).last_column)
-# else
-#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
-# endif
+# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
 #endif
 
 
 /* YYLEX -- calling `yylex' with the right arguments.  */
-
 #ifdef YYLEX_PARAM
 # define YYLEX yylex (YYLEX_PARAM)
 #else
@@ -930,6 +928,8 @@ yy_symbol_value_print (yyoutput, yytype, yyvaluep)
     YYSTYPE const * const yyvaluep;
 #endif
 {
+  FILE *yyo = yyoutput;
+  YYUSE (yyo);
   if (!yyvaluep)
     return;
 # ifdef YYPRINT
@@ -941,7 +941,7 @@ yy_symbol_value_print (yyoutput, yytype, yyvaluep)
   switch (yytype)
     {
       default:
-	break;
+        break;
     }
 }
 
@@ -1067,7 +1067,6 @@ int yydebug;
 # define YYMAXDEPTH 10000
 #endif
 
-
 
 #if YYERROR_VERBOSE
 
@@ -1170,115 +1169,145 @@ yytnamerr (char *yyres, const char *yystr)
 }
 # endif
 
-/* Copy into YYRESULT an error message about the unexpected token
-   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
-   including the terminating null byte.  If YYRESULT is null, do not
-   copy anything; just return the number of bytes that would be
-   copied.  As a special case, return 0 if an ordinary "syntax error"
-   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
-   size calculation.  */
-static YYSIZE_T
-yysyntax_error (char *yyresult, int yystate, int yychar)
-{
-  int yyn = yypact[yystate];
+/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
+   about the unexpected token YYTOKEN for the state stack whose top is
+   YYSSP.
 
-  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
-    return 0;
-  else
+   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
+   not large enough to hold the message.  In that case, also set
+   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
+   required number of bytes is too large to store.  */
+static int
+yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
+                yytype_int16 *yyssp, int yytoken)
+{
+  YYSIZE_T yysize0 = yytnamerr (YY_NULL, yytname[yytoken]);
+  YYSIZE_T yysize = yysize0;
+  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
+  /* Internationalized format string. */
+  const char *yyformat = YY_NULL;
+  /* Arguments of yyformat. */
+  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
+  /* Number of reported tokens (one for the "unexpected", one per
+     "expected"). */
+  int yycount = 0;
+
+  /* There are many possibilities here to consider:
+     - Assume YYFAIL is not used.  It's too flawed to consider.  See
+       <http://lists.gnu.org/archive/html/bison-patches/2009-12/msg00024.html>
+       for details.  YYERROR is fine as it does not invoke this
+       function.
+     - If this state is a consistent state with a default action, then
+       the only way this function was invoked is if the default action
+       is an error action.  In that case, don't check for expected
+       tokens because there are none.
+     - The only way there can be no lookahead present (in yychar) is if
+       this state is a consistent state with a default action.  Thus,
+       detecting the absence of a lookahead is sufficient to determine
+       that there is no unexpected or expected token to report.  In that
+       case, just report a simple "syntax error".
+     - Don't assume there isn't a lookahead just because this state is a
+       consistent state with a default action.  There might have been a
+       previous inconsistent state, consistent state with a non-default
+       action, or user semantic action that manipulated yychar.
+     - Of course, the expected token list depends on states to have
+       correct lookahead information, and it depends on the parser not
+       to perform extra reductions after fetching a lookahead from the
+       scanner and before detecting a syntax error.  Thus, state merging
+       (from LALR or IELR) and default reductions corrupt the expected
+       token list.  However, the list is correct for canonical LR with
+       one exception: it will still contain any token that will not be
+       accepted due to an error action in a later state.
+  */
+  if (yytoken != YYEMPTY)
     {
-      int yytype = YYTRANSLATE (yychar);
-      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
-      YYSIZE_T yysize = yysize0;
-      YYSIZE_T yysize1;
-      int yysize_overflow = 0;
-      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
-      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
-      int yyx;
-
-# if 0
-      /* This is so xgettext sees the translatable formats that are
-	 constructed on the fly.  */
-      YY_("syntax error, unexpected %s");
-      YY_("syntax error, unexpected %s, expecting %s");
-      YY_("syntax error, unexpected %s, expecting %s or %s");
-      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
-      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
-# endif
-      char *yyfmt;
-      char const *yyf;
-      static char const yyunexpected[] = "syntax error, unexpected %s";
-      static char const yyexpecting[] = ", expecting %s";
-      static char const yyor[] = " or %s";
-      char yyformat[sizeof yyunexpected
-		    + sizeof yyexpecting - 1
-		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
-		       * (sizeof yyor - 1))];
-      char const *yyprefix = yyexpecting;
-
-      /* Start YYX at -YYN if negative to avoid negative indexes in
-	 YYCHECK.  */
-      int yyxbegin = yyn < 0 ? -yyn : 0;
-
-      /* Stay within bounds of both yycheck and yytname.  */
-      int yychecklim = YYLAST - yyn + 1;
-      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
-      int yycount = 1;
-
-      yyarg[0] = yytname[yytype];
-      yyfmt = yystpcpy (yyformat, yyunexpected);
-
-      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
-	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
-	  {
-	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
-	      {
-		yycount = 1;
-		yysize = yysize0;
-		yyformat[sizeof yyunexpected - 1] = '\0';
-		break;
-	      }
-	    yyarg[yycount++] = yytname[yyx];
-	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
-	    yysize_overflow |= (yysize1 < yysize);
-	    yysize = yysize1;
-	    yyfmt = yystpcpy (yyfmt, yyprefix);
-	    yyprefix = yyor;
-	  }
+      int yyn = yypact[*yyssp];
+      yyarg[yycount++] = yytname[yytoken];
+      if (!yypact_value_is_default (yyn))
+        {
+          /* Start YYX at -YYN if negative to avoid negative indexes in
+             YYCHECK.  In other words, skip the first -YYN actions for
+             this state because they are default actions.  */
+          int yyxbegin = yyn < 0 ? -yyn : 0;
+          /* Stay within bounds of both yycheck and yytname.  */
+          int yychecklim = YYLAST - yyn + 1;
+          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
+          int yyx;
+
+          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
+            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
+                && !yytable_value_is_error (yytable[yyx + yyn]))
+              {
+                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
+                  {
+                    yycount = 1;
+                    yysize = yysize0;
+                    break;
+                  }
+                yyarg[yycount++] = yytname[yyx];
+                {
+                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULL, yytname[yyx]);
+                  if (! (yysize <= yysize1
+                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
+                    return 2;
+                  yysize = yysize1;
+                }
+              }
+        }
+    }
 
-      yyf = YY_(yyformat);
-      yysize1 = yysize + yystrlen (yyf);
-      yysize_overflow |= (yysize1 < yysize);
-      yysize = yysize1;
+  switch (yycount)
+    {
+# define YYCASE_(N, S)                      \
+      case N:                               \
+        yyformat = S;                       \
+      break
+      YYCASE_(0, YY_("syntax error"));
+      YYCASE_(1, YY_("syntax error, unexpected %s"));
+      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
+      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
+      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
+      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
+# undef YYCASE_
+    }
 
-      if (yysize_overflow)
-	return YYSIZE_MAXIMUM;
+  {
+    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
+    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
+      return 2;
+    yysize = yysize1;
+  }
 
-      if (yyresult)
-	{
-	  /* Avoid sprintf, as that infringes on the user's name space.
-	     Don't have undefined behavior even if the translation
-	     produced a string with the wrong number of "%s"s.  */
-	  char *yyp = yyresult;
-	  int yyi = 0;
-	  while ((*yyp = *yyf) != '\0')
-	    {
-	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
-		{
-		  yyp += yytnamerr (yyp, yyarg[yyi++]);
-		  yyf += 2;
-		}
-	      else
-		{
-		  yyp++;
-		  yyf++;
-		}
-	    }
-	}
-      return yysize;
+  if (*yymsg_alloc < yysize)
+    {
+      *yymsg_alloc = 2 * yysize;
+      if (! (yysize <= *yymsg_alloc
+             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
+        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
+      return 1;
     }
+
+  /* Avoid sprintf, as that infringes on the user's name space.
+     Don't have undefined behavior even if the translation
+     produced a string with the wrong number of "%s"s.  */
+  {
+    char *yyp = *yymsg;
+    int yyi = 0;
+    while ((*yyp = *yyformat) != '\0')
+      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
+        {
+          yyp += yytnamerr (yyp, yyarg[yyi++]);
+          yyformat += 2;
+        }
+      else
+        {
+          yyp++;
+          yyformat++;
+        }
+  }
+  return 0;
 }
 #endif /* YYERROR_VERBOSE */
-
 
 /*-----------------------------------------------.
 | Release the memory associated to this symbol.  |
@@ -1305,72 +1334,67 @@ yydestruct (yymsg, yytype, yyvaluep)
 
   switch (yytype)
     {
-      case 53: /* "choice_entry" */
+      case 54: /* choice_entry */
 
-	{
+        {
 	fprintf(stderr, "%s:%d: missing end statement for this entry\n",
-		(yyvaluep->menu)->file->name, (yyvaluep->menu)->lineno);
-	if (current_menu == (yyvaluep->menu))
+		((*yyvaluep).menu)->file->name, ((*yyvaluep).menu)->lineno);
+	if (current_menu == ((*yyvaluep).menu))
 		menu_end_menu();
 };
 
-	break;
-      case 59: /* "if_entry" */
+        break;
+      case 60: /* if_entry */
 
-	{
+        {
 	fprintf(stderr, "%s:%d: missing end statement for this entry\n",
-		(yyvaluep->menu)->file->name, (yyvaluep->menu)->lineno);
-	if (current_menu == (yyvaluep->menu))
+		((*yyvaluep).menu)->file->name, ((*yyvaluep).menu)->lineno);
+	if (current_menu == ((*yyvaluep).menu))
 		menu_end_menu();
 };
 
-	break;
-      case 65: /* "menu_entry" */
+        break;
+      case 66: /* menu_entry */
 
-	{
+        {
 	fprintf(stderr, "%s:%d: missing end statement for this entry\n",
-		(yyvaluep->menu)->file->name, (yyvaluep->menu)->lineno);
-	if (current_menu == (yyvaluep->menu))
+		((*yyvaluep).menu)->file->name, ((*yyvaluep).menu)->lineno);
+	if (current_menu == ((*yyvaluep).menu))
 		menu_end_menu();
 };
 
-	break;
+        break;
 
       default:
-	break;
+        break;
     }
 }
 
-/* Prevent warnings from -Wmissing-prototypes.  */
-#ifdef YYPARSE_PARAM
-#if defined __STDC__ || defined __cplusplus
-int yyparse (void *YYPARSE_PARAM);
-#else
-int yyparse ();
-#endif
-#else /* ! YYPARSE_PARAM */
-#if defined __STDC__ || defined __cplusplus
-int yyparse (void);
-#else
-int yyparse ();
-#endif
-#endif /* ! YYPARSE_PARAM */
+
 
 
 /* The lookahead symbol.  */
 int yychar;
 
+
+#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
+# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
+# define YY_IGNORE_MAYBE_UNINITIALIZED_END
+#endif
+#ifndef YY_INITIAL_VALUE
+# define YY_INITIAL_VALUE(Value) /* Nothing. */
+#endif
+
 /* The semantic value of the lookahead symbol.  */
-YYSTYPE yylval;
+YYSTYPE yylval YY_INITIAL_VALUE(yyval_default);
 
 /* Number of syntax errors so far.  */
 int yynerrs;
 
 
-
-/*-------------------------.
-| yyparse or yypush_parse.  |
-`-------------------------*/
+/*----------.
+| yyparse.  |
+`----------*/
 
 #ifdef YYPARSE_PARAM
 #if (defined __STDC__ || defined __C99__FUNC__ \
@@ -1394,8 +1418,6 @@ yyparse ()
 #endif
 #endif
 {
-
-
     int yystate;
     /* Number of tokens to shift before error messages enabled.  */
     int yyerrstatus;
@@ -1404,7 +1426,7 @@ yyparse ()
        `yyss': related to states.
        `yyvs': related to semantic values.
 
-       Refer to the stacks thru separate pointers, to allow yyoverflow
+       Refer to the stacks through separate pointers, to allow yyoverflow
        to reallocate them elsewhere.  */
 
     /* The state stack.  */
@@ -1422,7 +1444,7 @@ yyparse ()
   int yyn;
   int yyresult;
   /* Lookahead token as an internal (translated) token number.  */
-  int yytoken;
+  int yytoken = 0;
   /* The variables used to return semantic value and location from the
      action routines.  */
   YYSTYPE yyval;
@@ -1440,9 +1462,8 @@ yyparse ()
      Keep to zero when no symbol should be popped.  */
   int yylen = 0;
 
-  yytoken = 0;
-  yyss = yyssa;
-  yyvs = yyvsa;
+  yyssp = yyss = yyssa;
+  yyvsp = yyvs = yyvsa;
   yystacksize = YYINITDEPTH;
 
   YYDPRINTF ((stderr, "Starting parse\n"));
@@ -1451,14 +1472,6 @@ yyparse ()
   yyerrstatus = 0;
   yynerrs = 0;
   yychar = YYEMPTY; /* Cause a token to be read.  */
-
-  /* Initialize stack pointers.
-     Waste one element of value and location stack
-     so that they stay on the same level as the state stack.
-     The wasted elements are never initialized.  */
-  yyssp = yyss;
-  yyvsp = yyvs;
-
   goto yysetstate;
 
 /*------------------------------------------------------------.
@@ -1550,7 +1563,7 @@ yybackup:
 
   /* First try to decide what to do without reference to lookahead token.  */
   yyn = yypact[yystate];
-  if (yyn == YYPACT_NINF)
+  if (yypact_value_is_default (yyn))
     goto yydefault;
 
   /* Not known => get a lookahead token if don't already have one.  */
@@ -1581,8 +1594,8 @@ yybackup:
   yyn = yytable[yyn];
   if (yyn <= 0)
     {
-      if (yyn == 0 || yyn == YYTABLE_NINF)
-	goto yyerrlab;
+      if (yytable_value_is_error (yyn))
+        goto yyerrlab;
       yyn = -yyn;
       goto yyreduce;
     }
@@ -1599,7 +1612,9 @@ yybackup:
   yychar = YYEMPTY;
 
   yystate = yyn;
+  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
   *++yyvsp = yylval;
+  YY_IGNORE_MAYBE_UNINITIALIZED_END
 
   goto yynewstate;
 
@@ -1637,65 +1652,65 @@ yyreduce:
     {
         case 10:
 
-    { zconf_error("unexpected end statement"); ;}
+    { zconf_error("unexpected end statement"); }
     break;
 
   case 11:
 
-    { zconf_error("unknown statement \"%s\"", (yyvsp[(2) - (4)].string)); ;}
+    { zconf_error("unknown statement \"%s\"", (yyvsp[(2) - (4)].string)); }
     break;
 
   case 12:
 
     {
 	zconf_error("unexpected option \"%s\"", kconf_id_strings + (yyvsp[(2) - (4)].id)->name);
-;}
+}
     break;
 
   case 13:
 
-    { zconf_error("invalid statement"); ;}
+    { zconf_error("invalid statement"); }
     break;
 
-  case 28:
+  case 29:
 
-    { zconf_error("unknown option \"%s\"", (yyvsp[(1) - (3)].string)); ;}
+    { zconf_error("unknown option \"%s\"", (yyvsp[(1) - (3)].string)); }
     break;
 
-  case 29:
+  case 30:
 
-    { zconf_error("invalid option"); ;}
+    { zconf_error("invalid option"); }
     break;
 
-  case 30:
+  case 31:
 
     {
 	struct symbol *sym = sym_lookup((yyvsp[(2) - (3)].string), 0);
 	sym->flags |= SYMBOL_OPTIONAL;
 	menu_add_entry(sym);
 	printd(DEBUG_PARSE, "%s:%d:config %s\n", zconf_curname(), zconf_lineno(), (yyvsp[(2) - (3)].string));
-;}
+}
     break;
 
-  case 31:
+  case 32:
 
     {
 	menu_end_entry();
 	printd(DEBUG_PARSE, "%s:%d:endconfig\n", zconf_curname(), zconf_lineno());
-;}
+}
     break;
 
-  case 32:
+  case 33:
 
     {
 	struct symbol *sym = sym_lookup((yyvsp[(2) - (3)].string), 0);
 	sym->flags |= SYMBOL_OPTIONAL;
 	menu_add_entry(sym);
 	printd(DEBUG_PARSE, "%s:%d:menuconfig %s\n", zconf_curname(), zconf_lineno(), (yyvsp[(2) - (3)].string));
-;}
+}
     break;
 
-  case 33:
+  case 34:
 
     {
 	if (current_entry->prompt)
@@ -1704,28 +1719,28 @@ yyreduce:
 		zconfprint("warning: menuconfig statement without prompt");
 	menu_end_entry();
 	printd(DEBUG_PARSE, "%s:%d:endconfig\n", zconf_curname(), zconf_lineno());
-;}
+}
     break;
 
-  case 41:
+  case 42:
 
     {
 	menu_set_type((yyvsp[(1) - (3)].id)->stype);
 	printd(DEBUG_PARSE, "%s:%d:type(%u)\n",
 		zconf_curname(), zconf_lineno(),
 		(yyvsp[(1) - (3)].id)->stype);
-;}
+}
     break;
 
-  case 42:
+  case 43:
 
     {
 	menu_add_prompt(P_PROMPT, (yyvsp[(2) - (4)].string), (yyvsp[(3) - (4)].expr));
 	printd(DEBUG_PARSE, "%s:%d:prompt\n", zconf_curname(), zconf_lineno());
-;}
+}
     break;
 
-  case 43:
+  case 44:
 
     {
 	menu_add_expr(P_DEFAULT, (yyvsp[(2) - (4)].expr), (yyvsp[(3) - (4)].expr));
@@ -1734,26 +1749,34 @@ yyreduce:
 	printd(DEBUG_PARSE, "%s:%d:default(%u)\n",
 		zconf_curname(), zconf_lineno(),
 		(yyvsp[(1) - (4)].id)->stype);
-;}
+}
     break;
 
-  case 44:
+  case 45:
 
     {
 	menu_add_symbol(P_SELECT, sym_lookup((yyvsp[(2) - (4)].string), 0), (yyvsp[(3) - (4)].expr));
 	printd(DEBUG_PARSE, "%s:%d:select\n", zconf_curname(), zconf_lineno());
-;}
+}
     break;
 
-  case 45:
+  case 46:
+
+    {
+	menu_add_symbol(P_APPLY, sym_lookup((yyvsp[(2) - (4)].string), 0), (yyvsp[(3) - (4)].expr));
+	printd(DEBUG_PARSE, "%s:%d:utilize\n", zconf_curname(), zconf_lineno());
+}
+    break;
+
+  case 47:
 
     {
 	menu_add_expr(P_RANGE, expr_alloc_comp(E_RANGE,(yyvsp[(2) - (5)].symbol), (yyvsp[(3) - (5)].symbol)), (yyvsp[(4) - (5)].expr));
 	printd(DEBUG_PARSE, "%s:%d:range\n", zconf_curname(), zconf_lineno());
-;}
+}
     break;
 
-  case 48:
+  case 50:
 
     {
 	const struct kconf_id *id = kconf_id_lookup((yyvsp[(2) - (3)].string), strlen((yyvsp[(2) - (3)].string)));
@@ -1762,20 +1785,20 @@ yyreduce:
 	else
 		zconfprint("warning: ignoring unknown option %s", (yyvsp[(2) - (3)].string));
 	free((yyvsp[(2) - (3)].string));
-;}
+}
     break;
 
-  case 49:
+  case 51:
 
-    { (yyval.string) = NULL; ;}
+    { (yyval.string) = NULL; }
     break;
 
-  case 50:
+  case 52:
 
-    { (yyval.string) = (yyvsp[(2) - (2)].string); ;}
+    { (yyval.string) = (yyvsp[(2) - (2)].string); }
     break;
 
-  case 51:
+  case 53:
 
     {
 	struct symbol *sym = sym_lookup((yyvsp[(2) - (3)].string), SYMBOL_CHOICE);
@@ -1783,35 +1806,35 @@ yyreduce:
 	menu_add_entry(sym);
 	menu_add_expr(P_CHOICE, NULL, NULL);
 	printd(DEBUG_PARSE, "%s:%d:choice\n", zconf_curname(), zconf_lineno());
-;}
+}
     break;
 
-  case 52:
+  case 54:
 
     {
 	(yyval.menu) = menu_add_menu();
-;}
+}
     break;
 
-  case 53:
+  case 55:
 
     {
 	if (zconf_endtoken((yyvsp[(1) - (1)].id), T_CHOICE, T_ENDCHOICE)) {
 		menu_end_menu();
 		printd(DEBUG_PARSE, "%s:%d:endchoice\n", zconf_curname(), zconf_lineno());
 	}
-;}
+}
     break;
 
-  case 61:
+  case 63:
 
     {
 	menu_add_prompt(P_PROMPT, (yyvsp[(2) - (4)].string), (yyvsp[(3) - (4)].expr));
 	printd(DEBUG_PARSE, "%s:%d:prompt\n", zconf_curname(), zconf_lineno());
-;}
+}
     break;
 
-  case 62:
+  case 64:
 
     {
 	if ((yyvsp[(1) - (3)].id)->stype == S_BOOLEAN || (yyvsp[(1) - (3)].id)->stype == S_TRISTATE) {
@@ -1821,18 +1844,18 @@ yyreduce:
 			(yyvsp[(1) - (3)].id)->stype);
 	} else
 		YYERROR;
-;}
+}
     break;
 
-  case 63:
+  case 65:
 
     {
 	current_entry->sym->flags |= SYMBOL_OPTIONAL;
 	printd(DEBUG_PARSE, "%s:%d:optional\n", zconf_curname(), zconf_lineno());
-;}
+}
     break;
 
-  case 64:
+  case 66:
 
     {
 	if ((yyvsp[(1) - (4)].id)->stype == S_UNKNOWN) {
@@ -1841,202 +1864,213 @@ yyreduce:
 			zconf_curname(), zconf_lineno());
 	} else
 		YYERROR;
-;}
+}
     break;
 
-  case 67:
+  case 69:
 
     {
 	printd(DEBUG_PARSE, "%s:%d:if\n", zconf_curname(), zconf_lineno());
 	menu_add_entry(NULL);
 	menu_add_dep((yyvsp[(2) - (3)].expr));
 	(yyval.menu) = menu_add_menu();
-;}
+}
     break;
 
-  case 68:
+  case 70:
 
     {
 	if (zconf_endtoken((yyvsp[(1) - (1)].id), T_IF, T_ENDIF)) {
 		menu_end_menu();
 		printd(DEBUG_PARSE, "%s:%d:endif\n", zconf_curname(), zconf_lineno());
 	}
-;}
+}
     break;
 
-  case 74:
+  case 76:
 
     {
 	menu_add_prompt(P_MENU, (yyvsp[(2) - (3)].string), NULL);
-;}
+}
     break;
 
-  case 75:
+  case 77:
 
     {
 	menu_add_entry(NULL);
 	menu_add_prompt(P_MENU, (yyvsp[(2) - (3)].string), NULL);
 	printd(DEBUG_PARSE, "%s:%d:menu\n", zconf_curname(), zconf_lineno());
-;}
+}
     break;
 
-  case 76:
+  case 78:
 
     {
 	(yyval.menu) = menu_add_menu();
-;}
+}
     break;
 
-  case 77:
+  case 79:
 
     {
 	if (zconf_endtoken((yyvsp[(1) - (1)].id), T_MENU, T_ENDMENU)) {
 		menu_end_menu();
 		printd(DEBUG_PARSE, "%s:%d:endmenu\n", zconf_curname(), zconf_lineno());
 	}
-;}
+}
     break;
 
-  case 83:
+  case 85:
 
     {
 	printd(DEBUG_PARSE, "%s:%d:source %s\n", zconf_curname(), zconf_lineno(), (yyvsp[(2) - (3)].string));
 	zconf_nextfile((yyvsp[(2) - (3)].string));
-;}
+}
     break;
 
-  case 84:
+  case 86:
 
     {
 	menu_add_entry(NULL);
 	menu_add_prompt(P_COMMENT, (yyvsp[(2) - (3)].string), NULL);
 	printd(DEBUG_PARSE, "%s:%d:comment\n", zconf_curname(), zconf_lineno());
-;}
+}
     break;
 
-  case 85:
+  case 87:
 
     {
 	menu_end_entry();
-;}
+}
     break;
 
-  case 86:
+  case 88:
 
     {
 	printd(DEBUG_PARSE, "%s:%d:help\n", zconf_curname(), zconf_lineno());
 	zconf_starthelp();
-;}
+}
     break;
 
-  case 87:
+  case 89:
 
     {
 	current_entry->help = (yyvsp[(2) - (2)].string);
-;}
+}
     break;
 
-  case 92:
+  case 94:
 
     {
 	menu_add_dep((yyvsp[(3) - (4)].expr));
 	printd(DEBUG_PARSE, "%s:%d:depends on\n", zconf_curname(), zconf_lineno());
-;}
+}
     break;
 
-  case 96:
+  case 98:
 
     {
 	menu_add_visibility((yyvsp[(2) - (2)].expr));
-;}
+}
     break;
 
-  case 98:
+  case 100:
 
     {
 	menu_add_prompt(P_PROMPT, (yyvsp[(1) - (2)].string), (yyvsp[(2) - (2)].expr));
-;}
-    break;
-
-  case 101:
-
-    { (yyval.id) = (yyvsp[(1) - (2)].id); ;}
-    break;
-
-  case 102:
-
-    { (yyval.id) = (yyvsp[(1) - (2)].id); ;}
+}
     break;
 
   case 103:
 
-    { (yyval.id) = (yyvsp[(1) - (2)].id); ;}
+    { (yyval.id) = (yyvsp[(1) - (2)].id); }
     break;
 
-  case 106:
+  case 104:
 
-    { (yyval.expr) = NULL; ;}
+    { (yyval.id) = (yyvsp[(1) - (2)].id); }
     break;
 
-  case 107:
+  case 105:
 
-    { (yyval.expr) = (yyvsp[(2) - (2)].expr); ;}
+    { (yyval.id) = (yyvsp[(1) - (2)].id); }
     break;
 
   case 108:
 
-    { (yyval.expr) = expr_alloc_symbol((yyvsp[(1) - (1)].symbol)); ;}
+    { (yyval.expr) = NULL; }
     break;
 
   case 109:
 
-    { (yyval.expr) = expr_alloc_comp(E_EQUAL, (yyvsp[(1) - (3)].symbol), (yyvsp[(3) - (3)].symbol)); ;}
+    { (yyval.expr) = (yyvsp[(2) - (2)].expr); }
     break;
 
   case 110:
 
-    { (yyval.expr) = expr_alloc_comp(E_UNEQUAL, (yyvsp[(1) - (3)].symbol), (yyvsp[(3) - (3)].symbol)); ;}
+    { (yyval.expr) = expr_alloc_symbol((yyvsp[(1) - (1)].symbol)); }
     break;
 
   case 111:
 
-    { (yyval.expr) = (yyvsp[(2) - (3)].expr); ;}
+    { (yyval.expr) = expr_alloc_comp(E_EQUAL, (yyvsp[(1) - (3)].symbol), (yyvsp[(3) - (3)].symbol)); }
     break;
 
   case 112:
 
-    { (yyval.expr) = expr_alloc_one(E_NOT, (yyvsp[(2) - (2)].expr)); ;}
+    { (yyval.expr) = expr_alloc_comp(E_UNEQUAL, (yyvsp[(1) - (3)].symbol), (yyvsp[(3) - (3)].symbol)); }
     break;
 
   case 113:
 
-    { (yyval.expr) = expr_alloc_two(E_OR, (yyvsp[(1) - (3)].expr), (yyvsp[(3) - (3)].expr)); ;}
+    { (yyval.expr) = (yyvsp[(2) - (3)].expr); }
     break;
 
   case 114:
 
-    { (yyval.expr) = expr_alloc_two(E_AND, (yyvsp[(1) - (3)].expr), (yyvsp[(3) - (3)].expr)); ;}
+    { (yyval.expr) = expr_alloc_one(E_NOT, (yyvsp[(2) - (2)].expr)); }
     break;
 
   case 115:
 
-    { (yyval.symbol) = sym_lookup((yyvsp[(1) - (1)].string), 0); free((yyvsp[(1) - (1)].string)); ;}
+    { (yyval.expr) = expr_alloc_two(E_OR, (yyvsp[(1) - (3)].expr), (yyvsp[(3) - (3)].expr)); }
     break;
 
   case 116:
 
-    { (yyval.symbol) = sym_lookup((yyvsp[(1) - (1)].string), SYMBOL_CONST); free((yyvsp[(1) - (1)].string)); ;}
+    { (yyval.expr) = expr_alloc_two(E_AND, (yyvsp[(1) - (3)].expr), (yyvsp[(3) - (3)].expr)); }
     break;
 
   case 117:
 
-    { (yyval.string) = NULL; ;}
+    { (yyval.symbol) = sym_lookup((yyvsp[(1) - (1)].string), 0); free((yyvsp[(1) - (1)].string)); }
+    break;
+
+  case 118:
+
+    { (yyval.symbol) = sym_lookup((yyvsp[(1) - (1)].string), SYMBOL_CONST); free((yyvsp[(1) - (1)].string)); }
+    break;
+
+  case 119:
+
+    { (yyval.string) = NULL; }
     break;
 
 
 
       default: break;
     }
+  /* User semantic actions sometimes alter yychar, and that requires
+     that yytoken be updated with the new translation.  We take the
+     approach of translating immediately before every use of yytoken.
+     One alternative is translating here after every semantic action,
+     but that translation would be missed if the semantic action invokes
+     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
+     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
+     incorrect destructor might then be invoked immediately.  In the
+     case of YYERROR or YYBACKUP, subsequent parser actions might lead
+     to an incorrect destructor call or verbose syntax error message
+     before the lookahead is translated.  */
   YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);
 
   YYPOPSTACK (yylen);
@@ -2064,6 +2098,10 @@ yyreduce:
 | yyerrlab -- here on detecting error |
 `------------------------------------*/
 yyerrlab:
+  /* Make sure we have latest lookahead translation.  See comments at
+     user semantic actions for why this is necessary.  */
+  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);
+
   /* If not already recovering from an error, report this error.  */
   if (!yyerrstatus)
     {
@@ -2071,37 +2109,36 @@ yyerrlab:
 #if ! YYERROR_VERBOSE
       yyerror (YY_("syntax error"));
 #else
+# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
+                                        yyssp, yytoken)
       {
-	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
-	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
-	  {
-	    YYSIZE_T yyalloc = 2 * yysize;
-	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
-	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
-	    if (yymsg != yymsgbuf)
-	      YYSTACK_FREE (yymsg);
-	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
-	    if (yymsg)
-	      yymsg_alloc = yyalloc;
-	    else
-	      {
-		yymsg = yymsgbuf;
-		yymsg_alloc = sizeof yymsgbuf;
-	      }
-	  }
-
-	if (0 < yysize && yysize <= yymsg_alloc)
-	  {
-	    (void) yysyntax_error (yymsg, yystate, yychar);
-	    yyerror (yymsg);
-	  }
-	else
-	  {
-	    yyerror (YY_("syntax error"));
-	    if (yysize != 0)
-	      goto yyexhaustedlab;
-	  }
+        char const *yymsgp = YY_("syntax error");
+        int yysyntax_error_status;
+        yysyntax_error_status = YYSYNTAX_ERROR;
+        if (yysyntax_error_status == 0)
+          yymsgp = yymsg;
+        else if (yysyntax_error_status == 1)
+          {
+            if (yymsg != yymsgbuf)
+              YYSTACK_FREE (yymsg);
+            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
+            if (!yymsg)
+              {
+                yymsg = yymsgbuf;
+                yymsg_alloc = sizeof yymsgbuf;
+                yysyntax_error_status = 2;
+              }
+            else
+              {
+                yysyntax_error_status = YYSYNTAX_ERROR;
+                yymsgp = yymsg;
+              }
+          }
+        yyerror (yymsgp);
+        if (yysyntax_error_status == 2)
+          goto yyexhaustedlab;
       }
+# undef YYSYNTAX_ERROR
 #endif
     }
 
@@ -2160,7 +2197,7 @@ yyerrlab1:
   for (;;)
     {
       yyn = yypact[yystate];
-      if (yyn != YYPACT_NINF)
+      if (!yypact_value_is_default (yyn))
 	{
 	  yyn += YYTERROR;
 	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
@@ -2183,7 +2220,9 @@ yyerrlab1:
       YY_STACK_PRINT (yyss, yyssp);
     }
 
+  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
   *++yyvsp = yylval;
+  YY_IGNORE_MAYBE_UNINITIALIZED_END
 
 
   /* Shift the error token.  */
@@ -2207,7 +2246,7 @@ yyabortlab:
   yyresult = 1;
   goto yyreturn;
 
-#if !defined(yyoverflow) || YYERROR_VERBOSE
+#if !defined yyoverflow || YYERROR_VERBOSE
 /*-------------------------------------------------.
 | yyexhaustedlab -- memory exhaustion comes here.  |
 `-------------------------------------------------*/
@@ -2219,8 +2258,13 @@ yyexhaustedlab:
 
 yyreturn:
   if (yychar != YYEMPTY)
-     yydestruct ("Cleanup: discarding lookahead",
-		 yytoken, &yylval);
+    {
+      /* Make sure we have latest lookahead translation.  See comments at
+         user semantic actions for why this is necessary.  */
+      yytoken = YYTRANSLATE (yychar);
+      yydestruct ("Cleanup: discarding lookahead",
+                  yytoken, &yylval);
+    }
   /* Do not reclaim the symbols of the rule which action triggered
      this YYABORT or YYACCEPT.  */
   YYPOPSTACK (yylen);
@@ -2425,6 +2469,11 @@ static void print_symbol(FILE *out, struct menu *menu)
 			expr_fprint(prop->expr, out);
 			fputc('\n', out);
 			break;
+		case P_APPLY:
+			fputs( "  apply ", out);
+			expr_fprint(prop->expr, out);
+			fputc('\n', out);
+			break;
 		case P_RANGE:
 			fputs( "  range ", out);
 			expr_fprint(prop->expr, out);
@@ -2501,4 +2550,3 @@ void zconfdump(FILE *out)
 #include "expr.c"
 #include "symbol.c"
 #include "menu.c"
-

