Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbaLHB4y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 20:56:54 -0500
Received: from smtprelay01.ispgateway.de ([80.67.18.43]:46089 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbaLHB4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 20:56:52 -0500
From: Christoph Jaeger <cj@linux.com>
To: yann.morin.1998@free.fr
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        dborkman@redhat.com, Christoph Jaeger <cj@linux.com>
Subject: [PATCH 3/3] kconfig: rename S_BOOLEAN to S_BOOL for consistency
Date: Sun,  7 Dec 2014 20:49:20 -0500
Message-Id: <7fa2d6b65dfd4d5549baf8cbc53b6940b00fe52d.1418003065.git.cj@linux.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1418003065.git.cj@linux.com>
References: <cover.1418003065.git.cj@linux.com>
In-Reply-To: <cover.1418003065.git.cj@linux.com>
References: <cover.1418003065.git.cj@linux.com>
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename S_BOOLEAN to S_BOOL so that it reflects the actual string as
S_TRISTATE, S_INT, etc., do. No functional changes.

Signed-off-by: Christoph Jaeger <cj@linux.com>
---
 scripts/kconfig/confdata.c           | 20 ++++++++++----------
 scripts/kconfig/expr.c               | 10 +++++-----
 scripts/kconfig/expr.h               |  2 +-
 scripts/kconfig/gconf.c              |  4 ++--
 scripts/kconfig/mconf.c              |  4 ++--
 scripts/kconfig/menu.c               |  4 ++--
 scripts/kconfig/nconf.c              |  4 ++--
 scripts/kconfig/qconf.cc             | 10 +++++-----
 scripts/kconfig/symbol.c             | 32 ++++++++++++++++----------------
 scripts/kconfig/zconf.gperf          |  4 ++--
 scripts/kconfig/zconf.hash.c_shipped |  4 ++--
 scripts/kconfig/zconf.tab.c_shipped  |  4 ++--
 scripts/kconfig/zconf.y              |  4 ++--
 13 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 412e66c..6fbcf07 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -129,7 +129,7 @@ static int conf_set_sym_val(struct symbol *sym, int def, int def_flags, char *p)
 			break;
 		}
 		/* fall through */
-	case S_BOOLEAN:
+	case S_BOOL:
 		if (p[0] == 'y') {
 			sym->def[def].tri = yes;
 			sym->flags |= def_flags;
@@ -329,13 +329,13 @@ load:
 			} else {
 				sym = sym_lookup(line + 2 + strlen(CONFIG_), 0);
 				if (sym->type == S_UNKNOWN)
-					sym->type = S_BOOLEAN;
+					sym->type = S_BOOL;
 			}
 			if (sym->flags & def_flags) {
 				conf_warning("override: reassigning to symbol %s", sym->name);
 			}
 			switch (sym->type) {
-			case S_BOOLEAN:
+			case S_BOOL:
 			case S_TRISTATE:
 				sym->def[def].tri = no;
 				sym->flags |= def_flags;
@@ -421,7 +421,7 @@ int conf_read(const char *name)
 		if (sym_has_value(sym) && (sym->flags & SYMBOL_WRITE)) {
 			/* check that calculated value agrees with saved value */
 			switch (sym->type) {
-			case S_BOOLEAN:
+			case S_BOOL:
 			case S_TRISTATE:
 				if (sym->def[S_DEF_USER].tri != sym_get_tristate_value(sym))
 					break;
@@ -483,7 +483,7 @@ kconfig_print_symbol(FILE *fp, struct symbol *sym, const char *value, void *arg)
 {
 
 	switch (sym->type) {
-	case S_BOOLEAN:
+	case S_BOOL:
 	case S_TRISTATE:
 		if (*value == 'n') {
 			bool skip_unset = (arg != NULL);
@@ -537,7 +537,7 @@ header_print_symbol(FILE *fp, struct symbol *sym, const char *value, void *arg)
 {
 
 	switch (sym->type) {
-	case S_BOOLEAN:
+	case S_BOOL:
 	case S_TRISTATE: {
 		const char *suffix = "";
 
@@ -706,7 +706,7 @@ int conf_write_defconfig(const char *filename)
 				cs = prop_get_symbol(sym_get_choice_prop(sym));
 				ds = sym_choice_default(cs);
 				if (!sym_is_optional(cs) && sym == ds) {
-					if ((sym->type == S_BOOLEAN) &&
+					if ((sym->type == S_BOOL) &&
 					    sym_get_tristate_value(sym) == yes)
 						goto next_menu;
 				}
@@ -859,7 +859,7 @@ static int conf_split_config(void)
 				 * so compare them...
 				 */
 				switch (sym->type) {
-				case S_BOOLEAN:
+				case S_BOOL:
 				case S_TRISTATE:
 					if (sym_get_tristate_value(sym) ==
 					    sym->def[S_DEF_AUTO].tri)
@@ -881,7 +881,7 @@ static int conf_split_config(void)
 				 * is allowed as new value.
 				 */
 				switch (sym->type) {
-				case S_BOOLEAN:
+				case S_BOOL:
 				case S_TRISTATE:
 					if (sym_get_tristate_value(sym) == no)
 						continue;
@@ -1167,7 +1167,7 @@ bool conf_set_all_new_symbols(enum conf_def_mode mode)
 		if (sym_has_value(sym) || (sym->flags & SYMBOL_VALID))
 			continue;
 		switch (sym_get_type(sym)) {
-		case S_BOOLEAN:
+		case S_BOOL:
 		case S_TRISTATE:
 			has_changed = true;
 			switch (mode) {
diff --git a/scripts/kconfig/expr.c b/scripts/kconfig/expr.c
index d662652..62b1790 100644
--- a/scripts/kconfig/expr.c
+++ b/scripts/kconfig/expr.c
@@ -369,7 +369,7 @@ static struct expr *expr_join_or(struct expr *e1, struct expr *e2)
 		sym2 = e2->left.sym;
 	if (sym1 != sym2)
 		return NULL;
-	if (sym1->type != S_BOOLEAN && sym1->type != S_TRISTATE)
+	if (sym1->type != S_BOOL && sym1->type != S_TRISTATE)
 		return NULL;
 	if (sym1->type == S_TRISTATE) {
 		if (e1->type == E_EQUAL && e2->type == E_EQUAL &&
@@ -391,7 +391,7 @@ static struct expr *expr_join_or(struct expr *e1, struct expr *e2)
 			return expr_alloc_comp(E_UNEQUAL, sym1, &symbol_yes);
 		}
 	}
-	if (sym1->type == S_BOOLEAN && sym1 == sym2) {
+	if (sym1->type == S_BOOL && sym1 == sym2) {
 		if ((e1->type == E_NOT && e1->left.expr->type == E_SYMBOL && e2->type == E_SYMBOL) ||
 		    (e2->type == E_NOT && e2->left.expr->type == E_SYMBOL && e1->type == E_SYMBOL))
 			return expr_alloc_symbol(&symbol_yes);
@@ -433,7 +433,7 @@ static struct expr *expr_join_and(struct expr *e1, struct expr *e2)
 		sym2 = e2->left.sym;
 	if (sym1 != sym2)
 		return NULL;
-	if (sym1->type != S_BOOLEAN && sym1->type != S_TRISTATE)
+	if (sym1->type != S_BOOL && sym1->type != S_TRISTATE)
 		return NULL;
 
 	if ((e1->type == E_SYMBOL && e2->type == E_EQUAL && e2->right.sym == &symbol_yes) ||
@@ -652,7 +652,7 @@ struct expr *expr_transform(struct expr *e)
 
 	switch (e->type) {
 	case E_EQUAL:
-		if (e->left.sym->type != S_BOOLEAN)
+		if (e->left.sym->type != S_BOOL)
 			break;
 		if (e->right.sym == &symbol_no) {
 			e->type = E_NOT;
@@ -674,7 +674,7 @@ struct expr *expr_transform(struct expr *e)
 		}
 		break;
 	case E_UNEQUAL:
-		if (e->left.sym->type != S_BOOLEAN)
+		if (e->left.sym->type != S_BOOL)
 			break;
 		if (e->right.sym == &symbol_no) {
 			e->type = E_SYMBOL;
diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index 412ea8a..8ce0d00 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -60,7 +60,7 @@ struct symbol_value {
 };
 
 enum symbol_type {
-	S_UNKNOWN, S_BOOLEAN, S_TRISTATE, S_INT, S_HEX, S_STRING, S_OTHER
+	S_UNKNOWN, S_BOOL, S_TRISTATE, S_INT, S_HEX, S_STRING, S_OTHER
 };
 
 /* enum values are used as index to symbol.def[] */
diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
index d0a35b2..b431beb 100644
--- a/scripts/kconfig/gconf.c
+++ b/scripts/kconfig/gconf.c
@@ -845,7 +845,7 @@ static void change_sym_value(struct menu *menu, gint col)
 		return;
 
 	switch (sym_get_type(sym)) {
-	case S_BOOLEAN:
+	case S_BOOL:
 	case S_TRISTATE:
 		if (!sym_tristate_within_range(sym, newval))
 			newval = yes;
@@ -1133,7 +1133,7 @@ static gchar **fill_row(struct menu *menu)
 
 	stype = sym_get_type(sym);
 	switch (stype) {
-	case S_BOOLEAN:
+	case S_BOOL:
 		if (GPOINTER_TO_INT(row[COL_PIXVIS]) == FALSE)
 			row[COL_BTNVIS] = GINT_TO_POINTER(TRUE);
 		if (sym_is_choice(sym))
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 03fddd5..e792ddb 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -539,7 +539,7 @@ static void build_conf(struct menu *menu)
 		val = sym_get_tristate_value(sym);
 		if (sym_is_changable(sym)) {
 			switch (type) {
-			case S_BOOLEAN:
+			case S_BOOL:
 				item_make("[%c]", val == no ? ' ' : '*');
 				break;
 			case S_TRISTATE:
@@ -587,7 +587,7 @@ static void build_conf(struct menu *menu)
 			item_set_data(menu);
 		} else {
 			switch (type) {
-			case S_BOOLEAN:
+			case S_BOOL:
 				if (sym_is_changable(sym))
 					item_make("[%c]", val == no ? ' ' : '*');
 				else
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index f3594fa..69c48b4 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -253,12 +253,12 @@ static void sym_check_prop(struct symbol *sym)
 			break;
 		case P_SELECT:
 			sym2 = prop_get_symbol(prop);
-			if (sym->type != S_BOOLEAN && sym->type != S_TRISTATE)
+			if (sym->type != S_BOOL && sym->type != S_TRISTATE)
 				prop_warn(prop,
 				    "config symbol '%s' uses select, but is "
 				    "neither bool nor tristate", sym->name);
 			else if (sym2->type != S_UNKNOWN &&
-				 sym2->type != S_BOOLEAN &&
+				 sym2->type != S_BOOL &&
 				 sym2->type != S_TRISTATE)
 				prop_warn(prop,
 				    "'%s' has wrong type. 'select' only "
diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index 984489e..4e28cbe 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -803,7 +803,7 @@ static void build_conf(struct menu *menu)
 		val = sym_get_tristate_value(sym);
 		if (sym_is_changable(sym)) {
 			switch (type) {
-			case S_BOOLEAN:
+			case S_BOOL:
 				item_make(menu, 't', "[%c]",
 						val == no ? ' ' : '*');
 				break;
@@ -854,7 +854,7 @@ static void build_conf(struct menu *menu)
 			item_make(menu, ':', "   ");
 		} else {
 			switch (type) {
-			case S_BOOLEAN:
+			case S_BOOL:
 				if (sym_is_changable(sym))
 					item_make(menu, 't', "[%c]",
 						val == no ? ' ' : '*');
diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index 9d3b04b..cd205ff 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -165,7 +165,7 @@ void ConfigItem::updateMenu(void)
 
 	type = sym_get_type(sym);
 	switch (type) {
-	case S_BOOLEAN:
+	case S_BOOL:
 	case S_TRISTATE:
 		char ch;
 
@@ -179,7 +179,7 @@ void ConfigItem::updateMenu(void)
 		expr = sym_get_tristate_value(sym);
 		switch (expr) {
 		case yes:
-			if (sym_is_choice_value(sym) && type == S_BOOLEAN)
+			if (sym_is_choice_value(sym) && type == S_BOOL)
 				setPixmap(promptColIdx, list->choiceYesPix);
 			else
 				setPixmap(promptColIdx, list->symbolYesPix);
@@ -192,7 +192,7 @@ void ConfigItem::updateMenu(void)
 			ch = 'M';
 			break;
 		default:
-			if (sym_is_choice_value(sym) && type == S_BOOLEAN)
+			if (sym_is_choice_value(sym) && type == S_BOOL)
 				setPixmap(promptColIdx, list->choiceNoPix);
 			else
 				setPixmap(promptColIdx, list->symbolNoPix);
@@ -499,7 +499,7 @@ void ConfigList::setValue(ConfigItem* item, tristate val)
 
 	type = sym_get_type(sym);
 	switch (type) {
-	case S_BOOLEAN:
+	case S_BOOL:
 	case S_TRISTATE:
 		oldval = sym_get_tristate_value(sym);
 
@@ -530,7 +530,7 @@ void ConfigList::changeValue(ConfigItem* item)
 
 	type = sym_get_type(sym);
 	switch (type) {
-	case S_BOOLEAN:
+	case S_BOOL:
 	case S_TRISTATE:
 		oldexpr = sym_get_tristate_value(sym);
 		newexpr = sym_toggle_tristate_value(sym);
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index d855325..bdcfc61 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -66,9 +66,9 @@ enum symbol_type sym_get_type(struct symbol *sym)
 
 	if (type == S_TRISTATE) {
 		if (sym_is_choice_value(sym) && sym->visible == yes)
-			type = S_BOOLEAN;
+			type = S_BOOL;
 		else if (modules_val == no)
-			type = S_BOOLEAN;
+			type = S_BOOL;
 	}
 	return type;
 }
@@ -76,7 +76,7 @@ enum symbol_type sym_get_type(struct symbol *sym)
 const char *sym_type_name(enum symbol_type type)
 {
 	switch (type) {
-	case S_BOOLEAN:
+	case S_BOOL:
 		return "bool";
 	case S_TRISTATE:
 		return "tristate";
@@ -218,7 +218,7 @@ static void sym_calc_visibility(struct symbol *sym)
 	tri = no;
 	if (sym->rev_dep.expr)
 		tri = expr_calc_value(sym->rev_dep.expr);
-	if (tri == mod && sym_get_type(sym) == S_BOOLEAN)
+	if (tri == mod && sym_get_type(sym) == S_BOOL)
 		tri = yes;
 	if (sym->rev_dep.tri != tri) {
 		sym->rev_dep.tri = tri;
@@ -319,7 +319,7 @@ void sym_calc_value(struct symbol *sym)
 	case S_STRING:
 		newval = symbol_empty.curr;
 		break;
-	case S_BOOLEAN:
+	case S_BOOL:
 	case S_TRISTATE:
 		newval = symbol_no.curr;
 		break;
@@ -337,7 +337,7 @@ void sym_calc_value(struct symbol *sym)
 	sym->curr = newval;
 
 	switch (sym_get_type(sym)) {
-	case S_BOOLEAN:
+	case S_BOOL:
 	case S_TRISTATE:
 		if (sym_is_choice_value(sym) && sym->visible == yes) {
 			prop = sym_get_choice_prop(sym);
@@ -379,7 +379,7 @@ void sym_calc_value(struct symbol *sym)
 			}
 			newval.tri = EXPR_OR(newval.tri, sym->rev_dep.tri);
 		}
-		if (newval.tri == mod && sym_get_type(sym) == S_BOOLEAN)
+		if (newval.tri == mod && sym_get_type(sym) == S_BOOL)
 			newval.tri = yes;
 		break;
 	case S_STRING:
@@ -478,10 +478,10 @@ bool sym_tristate_within_range(struct symbol *sym, tristate val)
 	if (sym->visible == no)
 		return false;
 
-	if (type != S_BOOLEAN && type != S_TRISTATE)
+	if (type != S_BOOL && type != S_TRISTATE)
 		return false;
 
-	if (type == S_BOOLEAN && val == mod)
+	if (type == S_BOOL && val == mod)
 		return false;
 	if (sym->visible <= sym->rev_dep.tri)
 		return false;
@@ -578,7 +578,7 @@ bool sym_string_valid(struct symbol *sym, const char *str)
 				return false;
 		} while ((ch = *str++));
 		return true;
-	case S_BOOLEAN:
+	case S_BOOL:
 	case S_TRISTATE:
 		switch (str[0]) {
 		case 'y': case 'Y':
@@ -618,7 +618,7 @@ bool sym_string_within_range(struct symbol *sym, const char *str)
 		val = strtoll(str, NULL, 16);
 		return val >= sym_get_range_val(prop->expr->left.sym, 16) &&
 		       val <= sym_get_range_val(prop->expr->right.sym, 16);
-	case S_BOOLEAN:
+	case S_BOOL:
 	case S_TRISTATE:
 		switch (str[0]) {
 		case 'y': case 'Y':
@@ -641,7 +641,7 @@ bool sym_set_string_value(struct symbol *sym, const char *newval)
 	int size;
 
 	switch (sym->type) {
-	case S_BOOLEAN:
+	case S_BOOL:
 	case S_TRISTATE:
 		switch (newval[0]) {
 		case 'y': case 'Y':
@@ -706,7 +706,7 @@ const char *sym_get_string_default(struct symbol *sym)
 	prop = sym_get_default_prop(sym);
 	if (prop != NULL) {
 		switch (sym->type) {
-		case S_BOOLEAN:
+		case S_BOOL:
 		case S_TRISTATE:
 			/* The visibility may limit the value from yes => mod */
 			val = EXPR_AND(expr_calc_value(prop->expr), prop->visible.tri);
@@ -734,11 +734,11 @@ const char *sym_get_string_default(struct symbol *sym)
 			val = yes;
 
 	/* transpose mod to yes if type is bool */
-	if (sym->type == S_BOOLEAN && val == mod)
+	if (sym->type == S_BOOL && val == mod)
 		val = yes;
 
 	switch (sym->type) {
-	case S_BOOLEAN:
+	case S_BOOL:
 	case S_TRISTATE:
 		switch (val) {
 		case no: return "n";
@@ -762,7 +762,7 @@ const char *sym_get_string_value(struct symbol *sym)
 	tristate val;
 
 	switch (sym->type) {
-	case S_BOOLEAN:
+	case S_BOOL:
 	case S_TRISTATE:
 		val = sym_get_tristate_value(sym);
 		switch (val) {
diff --git a/scripts/kconfig/zconf.gperf b/scripts/kconfig/zconf.gperf
index d8fcf97..990c929 100644
--- a/scripts/kconfig/zconf.gperf
+++ b/scripts/kconfig/zconf.gperf
@@ -30,8 +30,8 @@ default,	T_DEFAULT,	TF_COMMAND, S_UNKNOWN
 prompt,		T_PROMPT,	TF_COMMAND
 tristate,	T_TYPE,		TF_COMMAND, S_TRISTATE
 def_tristate,	T_DEFAULT,	TF_COMMAND, S_TRISTATE
-bool,		T_TYPE,		TF_COMMAND, S_BOOLEAN
-def_bool,	T_DEFAULT,	TF_COMMAND, S_BOOLEAN
+bool,		T_TYPE,		TF_COMMAND, S_BOOL
+def_bool,	T_DEFAULT,	TF_COMMAND, S_BOOL
 int,		T_TYPE,		TF_COMMAND, S_INT
 hex,		T_TYPE,		TF_COMMAND, S_HEX
 string,		T_TYPE,		TF_COMMAND, S_STRING
diff --git a/scripts/kconfig/zconf.hash.c_shipped b/scripts/kconfig/zconf.hash.c_shipped
index c29b2a3..e627643 100644
--- a/scripts/kconfig/zconf.hash.c_shipped
+++ b/scripts/kconfig/zconf.hash.c_shipped
@@ -198,7 +198,7 @@ kconf_id_lookup (register const char *str, register unsigned int len)
 #line 32 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str12,	T_DEFAULT,	TF_COMMAND, S_TRISTATE},
 #line 34 "scripts/kconfig/zconf.gperf"
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str13,	T_DEFAULT,	TF_COMMAND, S_BOOLEAN},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str13,	T_DEFAULT,	TF_COMMAND, S_BOOL},
 #line 44 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str14,	T_OPT_DEFCONFIG_LIST,TF_OPTION},
       {-1}, {-1},
@@ -207,7 +207,7 @@ kconf_id_lookup (register const char *str, register unsigned int len)
 #line 28 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str18,	T_OPTIONAL,	TF_COMMAND},
 #line 33 "scripts/kconfig/zconf.gperf"
-      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str19,		T_TYPE,		TF_COMMAND, S_BOOLEAN},
+      {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str19,		T_TYPE,		TF_COMMAND, S_BOOL},
       {-1},
 #line 41 "scripts/kconfig/zconf.gperf"
       {(int)(long)&((struct kconf_id_strings_t *)0)->kconf_id_strings_str21,		T_OPTION,	TF_COMMAND},
diff --git a/scripts/kconfig/zconf.tab.c_shipped b/scripts/kconfig/zconf.tab.c_shipped
index acdf6e3..a44c458 100644
--- a/scripts/kconfig/zconf.tab.c_shipped
+++ b/scripts/kconfig/zconf.tab.c_shipped
@@ -1684,7 +1684,7 @@ yyreduce:
   case 62:
 
     {
-	if ((yyvsp[-2].id)->stype == S_BOOLEAN || (yyvsp[-2].id)->stype == S_TRISTATE) {
+	if ((yyvsp[-2].id)->stype == S_BOOL || (yyvsp[-2].id)->stype == S_TRISTATE) {
 		menu_set_type((yyvsp[-2].id)->stype);
 		printd(DEBUG_PARSE, "%s:%d:type(%u)\n",
 			zconf_curname(), zconf_lineno(),
@@ -2289,7 +2289,7 @@ static void print_symbol(FILE *out, struct menu *menu)
 	else
 		fprintf(out, "\nconfig %s\n", sym->name);
 	switch (sym->type) {
-	case S_BOOLEAN:
+	case S_BOOL:
 		fputs("  bool\n", out);
 		break;
 	case S_TRISTATE:
diff --git a/scripts/kconfig/zconf.y b/scripts/kconfig/zconf.y
index adb8828..f50b4db 100644
--- a/scripts/kconfig/zconf.y
+++ b/scripts/kconfig/zconf.y
@@ -281,7 +281,7 @@ choice_option: T_PROMPT prompt if_expr T_EOL
 
 choice_option: T_TYPE prompt_stmt_opt T_EOL
 {
-	if ($1->stype == S_BOOLEAN || $1->stype == S_TRISTATE) {
+	if ($1->stype == S_BOOL || $1->stype == S_TRISTATE) {
 		menu_set_type($1->stype);
 		printd(DEBUG_PARSE, "%s:%d:type(%u)\n",
 			zconf_curname(), zconf_lineno(),
@@ -606,7 +606,7 @@ static void print_symbol(FILE *out, struct menu *menu)
 	else
 		fprintf(out, "\nconfig %s\n", sym->name);
 	switch (sym->type) {
-	case S_BOOLEAN:
+	case S_BOOL:
 		fputs("  bool\n", out);
 		break;
 	case S_TRISTATE:
-- 
2.1.0

