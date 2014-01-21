Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092AbaAUNvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 08:51:18 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:52970 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568AbaAUNuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 08:50:11 -0500
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>
Subject: [PATCH 1/3] scripts/dtc: Update shipped files to build with bison 2.7.12
Date: Tue, 21 Jan 2014 13:49:59 +0000
Message-Id: <1390312201-22754-2-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1390312201-22754-1-git-send-email-grant.likely@linaro.org>
References: <1390312201-22754-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparation patch before updating to upstream dtc version 1.4.0. This
change only contains the changes caused by a new version of bison
on the shipped files. There are no functional changes.

The shipped files were build on an Ubuntu 13.10 system

Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 scripts/dtc/dtc-parser.tab.c_shipped | 469 +++++++++++++++--------------------
 scripts/dtc/dtc-parser.tab.h_shipped |  36 ++-
 2 files changed, 222 insertions(+), 283 deletions(-)

diff --git a/scripts/dtc/dtc-parser.tab.c_shipped b/scripts/dtc/dtc-parser.tab.c_shipped
index ee1d8c3042fb..c8769d550cfb 100644
--- a/scripts/dtc/dtc-parser.tab.c_shipped
+++ b/scripts/dtc/dtc-parser.tab.c_shipped
@@ -1,8 +1,8 @@
-/* A Bison parser, made by GNU Bison 2.5.  */
+/* A Bison parser, made by GNU Bison 2.7.12-4996.  */
 
 /* Bison implementation for Yacc-like parsers in C
    
-      Copyright (C) 1984, 1989-1990, 2000-2011 Free Software Foundation, Inc.
+      Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
@@ -44,7 +44,7 @@
 #define YYBISON 1
 
 /* Bison version.  */
-#define YYBISON_VERSION "2.5"
+#define YYBISON_VERSION "2.7.12-4996"
 
 /* Skeleton name.  */
 #define YYSKELETON_NAME "yacc.c"
@@ -58,14 +58,11 @@
 /* Pull parsers.  */
 #define YYPULL 1
 
-/* Using locations.  */
-#define YYLSP_NEEDED 0
 
 
 
 /* Copy the first part of user declarations.  */
-
-/* Line 268 of yacc.c  */
+/* Line 371 of yacc.c  */
 #line 21 "dtc-parser.y"
 
 #include <stdio.h>
@@ -85,14 +82,16 @@ extern int treesource_error;
 static unsigned long long eval_literal(const char *s, int base, int bits);
 static unsigned char eval_char_literal(const char *s);
 
+/* Line 371 of yacc.c  */
+#line 87 "dtc-parser.tab.c"
 
-/* Line 268 of yacc.c  */
-#line 91 "dtc-parser.tab.c"
-
-/* Enabling traces.  */
-#ifndef YYDEBUG
-# define YYDEBUG 0
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
@@ -102,11 +101,17 @@ static unsigned char eval_char_literal(const char *s);
 # define YYERROR_VERBOSE 0
 #endif
 
-/* Enabling the token table.  */
-#ifndef YYTOKEN_TABLE
-# define YYTOKEN_TABLE 0
+/* In a future release of Bison, this section will be replaced
+   by #include "dtc-parser.tab.h".  */
+#ifndef YY_YY_DTC_PARSER_TAB_H_INCLUDED
+# define YY_YY_DTC_PARSER_TAB_H_INCLUDED
+/* Enabling traces.  */
+#ifndef YYDEBUG
+# define YYDEBUG 0
+#endif
+#if YYDEBUG
+extern int yydebug;
 #endif
-
 
 /* Tokens.  */
 #ifndef YYTOKENTYPE
@@ -140,12 +145,10 @@ static unsigned char eval_char_literal(const char *s);
 #endif
 
 
-
 #if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
 typedef union YYSTYPE
 {
-
-/* Line 293 of yacc.c  */
+/* Line 387 of yacc.c  */
 #line 40 "dtc-parser.y"
 
 	char *propnodename;
@@ -168,21 +171,36 @@ typedef union YYSTYPE
 	uint64_t integer;
 
 
-
-/* Line 293 of yacc.c  */
-#line 174 "dtc-parser.tab.c"
+/* Line 387 of yacc.c  */
+#line 176 "dtc-parser.tab.c"
 } YYSTYPE;
 # define YYSTYPE_IS_TRIVIAL 1
 # define yystype YYSTYPE /* obsolescent; will be withdrawn */
 # define YYSTYPE_IS_DECLARED 1
 #endif
 
+extern YYSTYPE yylval;
 
-/* Copy the second part of user declarations.  */
+#ifdef YYPARSE_PARAM
+#if defined __STDC__ || defined __cplusplus
+int yyparse (void *YYPARSE_PARAM);
+#else
+int yyparse ();
+#endif
+#else /* ! YYPARSE_PARAM */
+#if defined __STDC__ || defined __cplusplus
+int yyparse (void);
+#else
+int yyparse ();
+#endif
+#endif /* ! YYPARSE_PARAM */
 
+#endif /* !YY_YY_DTC_PARSER_TAB_H_INCLUDED  */
 
-/* Line 343 of yacc.c  */
-#line 186 "dtc-parser.tab.c"
+/* Copy the second part of user declarations.  */
+
+/* Line 390 of yacc.c  */
+#line 204 "dtc-parser.tab.c"
 
 #ifdef short
 # undef short
@@ -235,24 +253,33 @@ typedef short int yytype_int16;
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
+# endif
+#endif
+
+#ifndef __attribute__
+/* This feature is available in gcc versions 2.5 and later.  */
+# if (! defined __GNUC__ || __GNUC__ < 2 \
+      || (__GNUC__ == 2 && __GNUC_MINOR__ < 5))
+#  define __attribute__(Spec) /* empty */
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
 
+
 /* Identity function, used to suppress warnings about constant conditions.  */
 #ifndef lint
-# define YYID(n) (n)
+# define YYID(N) (N)
 #else
 #if (defined __STDC__ || defined __C99__FUNC__ \
      || defined __cplusplus || defined _MSC_VER)
@@ -288,6 +315,7 @@ YYID (yyi)
 #    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
      || defined __cplusplus || defined _MSC_VER)
 #     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
+      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
 #     ifndef EXIT_SUCCESS
 #      define EXIT_SUCCESS 0
 #     endif
@@ -379,20 +407,20 @@ union yyalloc
 #endif
 
 #if defined YYCOPY_NEEDED && YYCOPY_NEEDED
-/* Copy COUNT objects from FROM to TO.  The source and destination do
+/* Copy COUNT objects from SRC to DST.  The source and destination do
    not overlap.  */
 # ifndef YYCOPY
 #  if defined __GNUC__ && 1 < __GNUC__
-#   define YYCOPY(To, From, Count) \
-      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
+#   define YYCOPY(Dst, Src, Count) \
+      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
 #  else
-#   define YYCOPY(To, From, Count)		\
-      do					\
-	{					\
-	  YYSIZE_T yyi;				\
-	  for (yyi = 0; yyi < (Count); yyi++)	\
-	    (To)[yyi] = (From)[yyi];		\
-	}					\
+#   define YYCOPY(Dst, Src, Count)              \
+      do                                        \
+        {                                       \
+          YYSIZE_T yyi;                         \
+          for (yyi = 0; yyi < (Count); yyi++)   \
+            (Dst)[yyi] = (Src)[yyi];            \
+        }                                       \
       while (YYID (0))
 #  endif
 # endif
@@ -513,7 +541,7 @@ static const yytype_uint16 yyrline[] =
 };
 #endif
 
-#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
+#if YYDEBUG || YYERROR_VERBOSE || 0
 /* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
    First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
 static const char *const yytname[] =
@@ -530,7 +558,7 @@ static const char *const yytname[] =
   "integer_expr", "integer_trinary", "integer_or", "integer_and",
   "integer_bitor", "integer_bitxor", "integer_bitand", "integer_eq",
   "integer_rela", "integer_shift", "integer_add", "integer_mul",
-  "integer_unary", "bytestring", "subnodes", "subnode", 0
+  "integer_unary", "bytestring", "subnodes", "subnode", YY_NULL
 };
 #endif
 
@@ -655,10 +683,10 @@ static const yytype_uint8 yytable[] =
      137,     0,    73,   139
 };
 
-#define yypact_value_is_default(yystate) \
-  ((yystate) == (-78))
+#define yypact_value_is_default(Yystate) \
+  (!!((Yystate) == (-78)))
 
-#define yytable_value_is_error(yytable_value) \
+#define yytable_value_is_error(Yytable_value) \
   YYID (0)
 
 static const yytype_int16 yycheck[] =
@@ -727,62 +755,35 @@ static const yytype_uint8 yystos[] =
 
 #define YYRECOVERING()  (!!yyerrstatus)
 
-#define YYBACKUP(Token, Value)					\
-do								\
-  if (yychar == YYEMPTY && yylen == 1)				\
-    {								\
-      yychar = (Token);						\
-      yylval = (Value);						\
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
 /* This macro is provided for backward compatibility. */
-
 #ifndef YY_LOCATION_PRINT
 # define YY_LOCATION_PRINT(File, Loc) ((void) 0)
 #endif
 
 
 /* YYLEX -- calling `yylex' with the right arguments.  */
-
 #ifdef YYLEX_PARAM
 # define YYLEX yylex (YYLEX_PARAM)
 #else
@@ -832,6 +833,8 @@ yy_symbol_value_print (yyoutput, yytype, yyvaluep)
     YYSTYPE const * const yyvaluep;
 #endif
 {
+  FILE *yyo = yyoutput;
+  YYUSE (yyo);
   if (!yyvaluep)
     return;
 # ifdef YYPRINT
@@ -840,11 +843,7 @@ yy_symbol_value_print (yyoutput, yytype, yyvaluep)
 # else
   YYUSE (yyoutput);
 # endif
-  switch (yytype)
-    {
-      default:
-	break;
-    }
+  YYUSE (yytype);
 }
 
 
@@ -1083,12 +1082,11 @@ static int
 yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                 yytype_int16 *yyssp, int yytoken)
 {
-  YYSIZE_T yysize0 = yytnamerr (0, yytname[yytoken]);
+  YYSIZE_T yysize0 = yytnamerr (YY_NULL, yytname[yytoken]);
   YYSIZE_T yysize = yysize0;
-  YYSIZE_T yysize1;
   enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
   /* Internationalized format string. */
-  const char *yyformat = 0;
+  const char *yyformat = YY_NULL;
   /* Arguments of yyformat. */
   char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
   /* Number of reported tokens (one for the "unexpected", one per
@@ -1148,11 +1146,13 @@ yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                     break;
                   }
                 yyarg[yycount++] = yytname[yyx];
-                yysize1 = yysize + yytnamerr (0, yytname[yyx]);
-                if (! (yysize <= yysize1
-                       && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
-                  return 2;
-                yysize = yysize1;
+                {
+                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULL, yytname[yyx]);
+                  if (! (yysize <= yysize1
+                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
+                    return 2;
+                  yysize = yysize1;
+                }
               }
         }
     }
@@ -1172,10 +1172,12 @@ yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
 # undef YYCASE_
     }
 
-  yysize1 = yysize + yystrlen (yyformat);
-  if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
-    return 2;
-  yysize = yysize1;
+  {
+    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
+    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
+      return 2;
+    yysize = yysize1;
+  }
 
   if (*yymsg_alloc < yysize)
     {
@@ -1231,36 +1233,26 @@ yydestruct (yymsg, yytype, yyvaluep)
     yymsg = "Deleting";
   YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);
 
-  switch (yytype)
-    {
-
-      default:
-	break;
-    }
+  YYUSE (yytype);
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
@@ -1300,7 +1292,7 @@ yyparse ()
        `yyss': related to states.
        `yyvs': related to semantic values.
 
-       Refer to the stacks thru separate pointers, to allow yyoverflow
+       Refer to the stacks through separate pointers, to allow yyoverflow
        to reallocate them elsewhere.  */
 
     /* The state stack.  */
@@ -1318,7 +1310,7 @@ yyparse ()
   int yyn;
   int yyresult;
   /* Lookahead token as an internal (translated) token number.  */
-  int yytoken;
+  int yytoken = 0;
   /* The variables used to return semantic value and location from the
      action routines.  */
   YYSTYPE yyval;
@@ -1336,9 +1328,8 @@ yyparse ()
      Keep to zero when no symbol should be popped.  */
   int yylen = 0;
 
-  yytoken = 0;
-  yyss = yyssa;
-  yyvs = yyvsa;
+  yyssp = yyss = yyssa;
+  yyvsp = yyvs = yyvsa;
   yystacksize = YYINITDEPTH;
 
   YYDPRINTF ((stderr, "Starting parse\n"));
@@ -1347,14 +1338,6 @@ yyparse ()
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
@@ -1495,7 +1478,9 @@ yybackup:
   yychar = YYEMPTY;
 
   yystate = yyn;
+  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
   *++yyvsp = yylval;
+  YY_IGNORE_MAYBE_UNINITIALIZED_END
 
   goto yynewstate;
 
@@ -1532,8 +1517,7 @@ yyreduce:
   switch (yyn)
     {
         case 2:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 110 "dtc-parser.y"
     {
 			the_boot_info = build_boot_info((yyvsp[(3) - (4)].re), (yyvsp[(4) - (4)].node),
@@ -1542,8 +1526,7 @@ yyreduce:
     break;
 
   case 3:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 118 "dtc-parser.y"
     {
 			(yyval.re) = NULL;
@@ -1551,8 +1534,7 @@ yyreduce:
     break;
 
   case 4:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 122 "dtc-parser.y"
     {
 			(yyval.re) = chain_reserve_entry((yyvsp[(1) - (2)].re), (yyvsp[(2) - (2)].re));
@@ -1560,8 +1542,7 @@ yyreduce:
     break;
 
   case 5:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 129 "dtc-parser.y"
     {
 			(yyval.re) = build_reserve_entry((yyvsp[(2) - (4)].integer), (yyvsp[(3) - (4)].integer));
@@ -1569,8 +1550,7 @@ yyreduce:
     break;
 
   case 6:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 133 "dtc-parser.y"
     {
 			add_label(&(yyvsp[(2) - (2)].re)->labels, (yyvsp[(1) - (2)].labelref));
@@ -1579,8 +1559,7 @@ yyreduce:
     break;
 
   case 7:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 141 "dtc-parser.y"
     {
 			(yyval.node) = name_node((yyvsp[(2) - (2)].node), "");
@@ -1588,8 +1567,7 @@ yyreduce:
     break;
 
   case 8:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 145 "dtc-parser.y"
     {
 			(yyval.node) = merge_nodes((yyvsp[(1) - (3)].node), (yyvsp[(3) - (3)].node));
@@ -1597,8 +1575,7 @@ yyreduce:
     break;
 
   case 9:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 149 "dtc-parser.y"
     {
 			struct node *target = get_node_by_ref((yyvsp[(1) - (3)].node), (yyvsp[(2) - (3)].labelref));
@@ -1612,8 +1589,7 @@ yyreduce:
     break;
 
   case 10:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 159 "dtc-parser.y"
     {
 			struct node *target = get_node_by_ref((yyvsp[(1) - (4)].node), (yyvsp[(3) - (4)].labelref));
@@ -1628,8 +1604,7 @@ yyreduce:
     break;
 
   case 11:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 173 "dtc-parser.y"
     {
 			(yyval.node) = build_node((yyvsp[(2) - (5)].proplist), (yyvsp[(3) - (5)].nodelist));
@@ -1637,8 +1612,7 @@ yyreduce:
     break;
 
   case 12:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 180 "dtc-parser.y"
     {
 			(yyval.proplist) = NULL;
@@ -1646,8 +1620,7 @@ yyreduce:
     break;
 
   case 13:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 184 "dtc-parser.y"
     {
 			(yyval.proplist) = chain_property((yyvsp[(2) - (2)].prop), (yyvsp[(1) - (2)].proplist));
@@ -1655,8 +1628,7 @@ yyreduce:
     break;
 
   case 14:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 191 "dtc-parser.y"
     {
 			(yyval.prop) = build_property((yyvsp[(1) - (4)].propnodename), (yyvsp[(3) - (4)].data));
@@ -1664,8 +1636,7 @@ yyreduce:
     break;
 
   case 15:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 195 "dtc-parser.y"
     {
 			(yyval.prop) = build_property((yyvsp[(1) - (2)].propnodename), empty_data);
@@ -1673,8 +1644,7 @@ yyreduce:
     break;
 
   case 16:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 199 "dtc-parser.y"
     {
 			(yyval.prop) = build_property_delete((yyvsp[(2) - (3)].propnodename));
@@ -1682,8 +1652,7 @@ yyreduce:
     break;
 
   case 17:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 203 "dtc-parser.y"
     {
 			add_label(&(yyvsp[(2) - (2)].prop)->labels, (yyvsp[(1) - (2)].labelref));
@@ -1692,8 +1661,7 @@ yyreduce:
     break;
 
   case 18:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 211 "dtc-parser.y"
     {
 			(yyval.data) = data_merge((yyvsp[(1) - (2)].data), (yyvsp[(2) - (2)].data));
@@ -1701,8 +1669,7 @@ yyreduce:
     break;
 
   case 19:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 215 "dtc-parser.y"
     {
 			(yyval.data) = data_merge((yyvsp[(1) - (3)].data), (yyvsp[(2) - (3)].array).data);
@@ -1710,8 +1677,7 @@ yyreduce:
     break;
 
   case 20:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 219 "dtc-parser.y"
     {
 			(yyval.data) = data_merge((yyvsp[(1) - (4)].data), (yyvsp[(3) - (4)].data));
@@ -1719,8 +1685,7 @@ yyreduce:
     break;
 
   case 21:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 223 "dtc-parser.y"
     {
 			(yyval.data) = data_add_marker((yyvsp[(1) - (2)].data), REF_PATH, (yyvsp[(2) - (2)].labelref));
@@ -1728,8 +1693,7 @@ yyreduce:
     break;
 
   case 22:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 227 "dtc-parser.y"
     {
 			FILE *f = srcfile_relative_open((yyvsp[(4) - (9)].data).val, NULL);
@@ -1750,8 +1714,7 @@ yyreduce:
     break;
 
   case 23:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 244 "dtc-parser.y"
     {
 			FILE *f = srcfile_relative_open((yyvsp[(4) - (5)].data).val, NULL);
@@ -1765,8 +1728,7 @@ yyreduce:
     break;
 
   case 24:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 254 "dtc-parser.y"
     {
 			(yyval.data) = data_add_marker((yyvsp[(1) - (2)].data), LABEL, (yyvsp[(2) - (2)].labelref));
@@ -1774,8 +1736,7 @@ yyreduce:
     break;
 
   case 25:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 261 "dtc-parser.y"
     {
 			(yyval.data) = empty_data;
@@ -1783,8 +1744,7 @@ yyreduce:
     break;
 
   case 26:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 265 "dtc-parser.y"
     {
 			(yyval.data) = (yyvsp[(1) - (2)].data);
@@ -1792,8 +1752,7 @@ yyreduce:
     break;
 
   case 27:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 269 "dtc-parser.y"
     {
 			(yyval.data) = data_add_marker((yyvsp[(1) - (2)].data), LABEL, (yyvsp[(2) - (2)].labelref));
@@ -1801,8 +1760,7 @@ yyreduce:
     break;
 
   case 28:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 276 "dtc-parser.y"
     {
 			(yyval.array).data = empty_data;
@@ -1821,8 +1779,7 @@ yyreduce:
     break;
 
   case 29:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 291 "dtc-parser.y"
     {
 			(yyval.array).data = empty_data;
@@ -1831,8 +1788,7 @@ yyreduce:
     break;
 
   case 30:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 296 "dtc-parser.y"
     {
 			if ((yyvsp[(1) - (2)].array).bits < 64) {
@@ -1856,8 +1812,7 @@ yyreduce:
     break;
 
   case 31:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 316 "dtc-parser.y"
     {
 			uint64_t val = ~0ULL >> (64 - (yyvsp[(1) - (2)].array).bits);
@@ -1875,8 +1830,7 @@ yyreduce:
     break;
 
   case 32:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 330 "dtc-parser.y"
     {
 			(yyval.array).data = data_add_marker((yyvsp[(1) - (2)].array).data, LABEL, (yyvsp[(2) - (2)].labelref));
@@ -1884,8 +1838,7 @@ yyreduce:
     break;
 
   case 33:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 337 "dtc-parser.y"
     {
 			(yyval.integer) = eval_literal((yyvsp[(1) - (1)].literal), 0, 64);
@@ -1893,8 +1846,7 @@ yyreduce:
     break;
 
   case 34:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 341 "dtc-parser.y"
     {
 			(yyval.integer) = eval_char_literal((yyvsp[(1) - (1)].literal));
@@ -1902,8 +1854,7 @@ yyreduce:
     break;
 
   case 35:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 345 "dtc-parser.y"
     {
 			(yyval.integer) = (yyvsp[(2) - (3)].integer);
@@ -1911,162 +1862,139 @@ yyreduce:
     break;
 
   case 38:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 356 "dtc-parser.y"
     { (yyval.integer) = (yyvsp[(1) - (5)].integer) ? (yyvsp[(3) - (5)].integer) : (yyvsp[(5) - (5)].integer); }
     break;
 
   case 40:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 361 "dtc-parser.y"
     { (yyval.integer) = (yyvsp[(1) - (3)].integer) || (yyvsp[(3) - (3)].integer); }
     break;
 
   case 42:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 366 "dtc-parser.y"
     { (yyval.integer) = (yyvsp[(1) - (3)].integer) && (yyvsp[(3) - (3)].integer); }
     break;
 
   case 44:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 371 "dtc-parser.y"
     { (yyval.integer) = (yyvsp[(1) - (3)].integer) | (yyvsp[(3) - (3)].integer); }
     break;
 
   case 46:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 376 "dtc-parser.y"
     { (yyval.integer) = (yyvsp[(1) - (3)].integer) ^ (yyvsp[(3) - (3)].integer); }
     break;
 
   case 48:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 381 "dtc-parser.y"
     { (yyval.integer) = (yyvsp[(1) - (3)].integer) & (yyvsp[(3) - (3)].integer); }
     break;
 
   case 50:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 386 "dtc-parser.y"
     { (yyval.integer) = (yyvsp[(1) - (3)].integer) == (yyvsp[(3) - (3)].integer); }
     break;
 
   case 51:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 387 "dtc-parser.y"
     { (yyval.integer) = (yyvsp[(1) - (3)].integer) != (yyvsp[(3) - (3)].integer); }
     break;
 
   case 53:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 392 "dtc-parser.y"
     { (yyval.integer) = (yyvsp[(1) - (3)].integer) < (yyvsp[(3) - (3)].integer); }
     break;
 
   case 54:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 393 "dtc-parser.y"
     { (yyval.integer) = (yyvsp[(1) - (3)].integer) > (yyvsp[(3) - (3)].integer); }
     break;
 
   case 55:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 394 "dtc-parser.y"
     { (yyval.integer) = (yyvsp[(1) - (3)].integer) <= (yyvsp[(3) - (3)].integer); }
     break;
 
   case 56:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 395 "dtc-parser.y"
     { (yyval.integer) = (yyvsp[(1) - (3)].integer) >= (yyvsp[(3) - (3)].integer); }
     break;
 
   case 57:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 399 "dtc-parser.y"
     { (yyval.integer) = (yyvsp[(1) - (3)].integer) << (yyvsp[(3) - (3)].integer); }
     break;
 
   case 58:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 400 "dtc-parser.y"
     { (yyval.integer) = (yyvsp[(1) - (3)].integer) >> (yyvsp[(3) - (3)].integer); }
     break;
 
   case 60:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 405 "dtc-parser.y"
     { (yyval.integer) = (yyvsp[(1) - (3)].integer) + (yyvsp[(3) - (3)].integer); }
     break;
 
   case 61:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 406 "dtc-parser.y"
     { (yyval.integer) = (yyvsp[(1) - (3)].integer) - (yyvsp[(3) - (3)].integer); }
     break;
 
   case 63:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 411 "dtc-parser.y"
     { (yyval.integer) = (yyvsp[(1) - (3)].integer) * (yyvsp[(3) - (3)].integer); }
     break;
 
   case 64:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 412 "dtc-parser.y"
     { (yyval.integer) = (yyvsp[(1) - (3)].integer) / (yyvsp[(3) - (3)].integer); }
     break;
 
   case 65:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 413 "dtc-parser.y"
     { (yyval.integer) = (yyvsp[(1) - (3)].integer) % (yyvsp[(3) - (3)].integer); }
     break;
 
   case 68:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 419 "dtc-parser.y"
     { (yyval.integer) = -(yyvsp[(2) - (2)].integer); }
     break;
 
   case 69:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 420 "dtc-parser.y"
     { (yyval.integer) = ~(yyvsp[(2) - (2)].integer); }
     break;
 
   case 70:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 421 "dtc-parser.y"
     { (yyval.integer) = !(yyvsp[(2) - (2)].integer); }
     break;
 
   case 71:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 426 "dtc-parser.y"
     {
 			(yyval.data) = empty_data;
@@ -2074,8 +2002,7 @@ yyreduce:
     break;
 
   case 72:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 430 "dtc-parser.y"
     {
 			(yyval.data) = data_append_byte((yyvsp[(1) - (2)].data), (yyvsp[(2) - (2)].byte));
@@ -2083,8 +2010,7 @@ yyreduce:
     break;
 
   case 73:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 434 "dtc-parser.y"
     {
 			(yyval.data) = data_add_marker((yyvsp[(1) - (2)].data), LABEL, (yyvsp[(2) - (2)].labelref));
@@ -2092,8 +2018,7 @@ yyreduce:
     break;
 
   case 74:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 441 "dtc-parser.y"
     {
 			(yyval.nodelist) = NULL;
@@ -2101,8 +2026,7 @@ yyreduce:
     break;
 
   case 75:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 445 "dtc-parser.y"
     {
 			(yyval.nodelist) = chain_node((yyvsp[(1) - (2)].node), (yyvsp[(2) - (2)].nodelist));
@@ -2110,8 +2034,7 @@ yyreduce:
     break;
 
   case 76:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 449 "dtc-parser.y"
     {
 			print_error("syntax error: properties must precede subnodes");
@@ -2120,8 +2043,7 @@ yyreduce:
     break;
 
   case 77:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 457 "dtc-parser.y"
     {
 			(yyval.node) = name_node((yyvsp[(2) - (2)].node), (yyvsp[(1) - (2)].propnodename));
@@ -2129,8 +2051,7 @@ yyreduce:
     break;
 
   case 78:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 461 "dtc-parser.y"
     {
 			(yyval.node) = name_node(build_node_delete(), (yyvsp[(2) - (3)].propnodename));
@@ -2138,8 +2059,7 @@ yyreduce:
     break;
 
   case 79:
-
-/* Line 1806 of yacc.c  */
+/* Line 1787 of yacc.c  */
 #line 465 "dtc-parser.y"
     {
 			add_label(&(yyvsp[(2) - (2)].node)->labels, (yyvsp[(1) - (2)].labelref));
@@ -2148,9 +2068,8 @@ yyreduce:
     break;
 
 
-
-/* Line 1806 of yacc.c  */
-#line 2154 "dtc-parser.tab.c"
+/* Line 1787 of yacc.c  */
+#line 2073 "dtc-parser.tab.c"
       default: break;
     }
   /* User semantic actions sometimes alter yychar, and that requires
@@ -2313,7 +2232,9 @@ yyerrlab1:
       YY_STACK_PRINT (yyss, yyssp);
     }
 
+  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
   *++yyvsp = yylval;
+  YY_IGNORE_MAYBE_UNINITIALIZED_END
 
 
   /* Shift the error token.  */
@@ -2337,7 +2258,7 @@ yyabortlab:
   yyresult = 1;
   goto yyreturn;
 
-#if !defined(yyoverflow) || YYERROR_VERBOSE
+#if !defined yyoverflow || YYERROR_VERBOSE
 /*-------------------------------------------------.
 | yyexhaustedlab -- memory exhaustion comes here.  |
 `-------------------------------------------------*/
@@ -2379,8 +2300,7 @@ yyreturn:
 }
 
 
-
-/* Line 2067 of yacc.c  */
+/* Line 2050 of yacc.c  */
 #line 471 "dtc-parser.y"
 
 
@@ -2444,4 +2364,3 @@ static unsigned char eval_char_literal(const char *s)
 
 	return c;
 }
-
diff --git a/scripts/dtc/dtc-parser.tab.h_shipped b/scripts/dtc/dtc-parser.tab.h_shipped
index 25d3b88c6132..b2e7a86cd85e 100644
--- a/scripts/dtc/dtc-parser.tab.h_shipped
+++ b/scripts/dtc/dtc-parser.tab.h_shipped
@@ -1,8 +1,8 @@
-/* A Bison parser, made by GNU Bison 2.5.  */
+/* A Bison parser, made by GNU Bison 2.7.12-4996.  */
 
 /* Bison interface for Yacc-like parsers in C
    
-      Copyright (C) 1984, 1989-1990, 2000-2011 Free Software Foundation, Inc.
+      Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.
    
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
@@ -30,6 +30,15 @@
    This special exception was added by the Free Software Foundation in
    version 2.2 of Bison.  */
 
+#ifndef YY_YY_DTC_PARSER_TAB_H_INCLUDED
+# define YY_YY_DTC_PARSER_TAB_H_INCLUDED
+/* Enabling traces.  */
+#ifndef YYDEBUG
+# define YYDEBUG 0
+#endif
+#if YYDEBUG
+extern int yydebug;
+#endif
 
 /* Tokens.  */
 #ifndef YYTOKENTYPE
@@ -63,12 +72,10 @@
 #endif
 
 
-
 #if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
 typedef union YYSTYPE
 {
-
-/* Line 2068 of yacc.c  */
+/* Line 2053 of yacc.c  */
 #line 40 "dtc-parser.y"
 
 	char *propnodename;
@@ -91,9 +98,8 @@ typedef union YYSTYPE
 	uint64_t integer;
 
 
-
-/* Line 2068 of yacc.c  */
-#line 97 "dtc-parser.tab.h"
+/* Line 2053 of yacc.c  */
+#line 103 "dtc-parser.tab.h"
 } YYSTYPE;
 # define YYSTYPE_IS_TRIVIAL 1
 # define yystype YYSTYPE /* obsolescent; will be withdrawn */
@@ -102,4 +108,18 @@ typedef union YYSTYPE
 
 extern YYSTYPE yylval;
 
+#ifdef YYPARSE_PARAM
+#if defined __STDC__ || defined __cplusplus
+int yyparse (void *YYPARSE_PARAM);
+#else
+int yyparse ();
+#endif
+#else /* ! YYPARSE_PARAM */
+#if defined __STDC__ || defined __cplusplus
+int yyparse (void);
+#else
+int yyparse ();
+#endif
+#endif /* ! YYPARSE_PARAM */
 
+#endif /* !YY_YY_DTC_PARSER_TAB_H_INCLUDED  */
-- 
1.8.3.2

