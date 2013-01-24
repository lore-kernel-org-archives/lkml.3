Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160995Ab3AXUOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:14:47 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54097
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755945Ab3AXUIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:50 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 61/74] perf tools: Fix usage of __ in parse_events_term struct
Date: Thu, 24 Jan 2013 17:08:10 -0300
Message-Id: <1359058103-31645-62-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

In tools/perf we use a convention where __ separates the struct name
from the function name for functions that operate on a struct instance.

Fix this usage by removing it from the struct parse_events_term and fix
also its associated functions.

Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-h6vkql4jr7dv0096f1s6hldm@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/parse-events.c | 10 +++++-----
 tools/perf/tests/pmu.c          |  4 ++--
 tools/perf/util/parse-events.c  | 26 +++++++++++++-------------
 tools/perf/util/parse-events.h  | 14 +++++++-------
 tools/perf/util/parse-events.y  | 38 +++++++++++++++++++-------------------
 tools/perf/util/pmu.c           | 12 ++++++------
 6 files changed, 52 insertions(+), 52 deletions(-)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 337424d..9ac45c5 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -464,10 +464,10 @@ static int test__checkevent_pmu_events(struct perf_evlist *evlist)
 
 static int test__checkterms_simple(struct list_head *terms)
 {
-	struct parse_events__term *term;
+	struct parse_events_term *term;
 
 	/* config=10 */
-	term = list_entry(terms->next, struct parse_events__term, list);
+	term = list_entry(terms->next, struct parse_events_term, list);
 	TEST_ASSERT_VAL("wrong type term",
 			term->type_term == PARSE_EVENTS__TERM_TYPE_CONFIG);
 	TEST_ASSERT_VAL("wrong type val",
@@ -476,7 +476,7 @@ static int test__checkterms_simple(struct list_head *terms)
 	TEST_ASSERT_VAL("wrong config", !term->config);
 
 	/* config1 */
-	term = list_entry(term->list.next, struct parse_events__term, list);
+	term = list_entry(term->list.next, struct parse_events_term, list);
 	TEST_ASSERT_VAL("wrong type term",
 			term->type_term == PARSE_EVENTS__TERM_TYPE_CONFIG1);
 	TEST_ASSERT_VAL("wrong type val",
@@ -485,7 +485,7 @@ static int test__checkterms_simple(struct list_head *terms)
 	TEST_ASSERT_VAL("wrong config", !term->config);
 
 	/* config2=3 */
-	term = list_entry(term->list.next, struct parse_events__term, list);
+	term = list_entry(term->list.next, struct parse_events_term, list);
 	TEST_ASSERT_VAL("wrong type term",
 			term->type_term == PARSE_EVENTS__TERM_TYPE_CONFIG2);
 	TEST_ASSERT_VAL("wrong type val",
@@ -494,7 +494,7 @@ static int test__checkterms_simple(struct list_head *terms)
 	TEST_ASSERT_VAL("wrong config", !term->config);
 
 	/* umask=1*/
-	term = list_entry(term->list.next, struct parse_events__term, list);
+	term = list_entry(term->list.next, struct parse_events_term, list);
 	TEST_ASSERT_VAL("wrong type term",
 			term->type_term == PARSE_EVENTS__TERM_TYPE_USER);
 	TEST_ASSERT_VAL("wrong type val",
diff --git a/tools/perf/tests/pmu.c b/tools/perf/tests/pmu.c
index a5f3798..6803ed1 100644
--- a/tools/perf/tests/pmu.c
+++ b/tools/perf/tests/pmu.c
@@ -22,7 +22,7 @@ static struct test_format {
 #define TEST_FORMATS_CNT (sizeof(test_formats) / sizeof(struct test_format))
 
 /* Simulated users input. */
-static struct parse_events__term test_terms[] = {
+static struct parse_events_term test_terms[] = {
 	{
 		.config    = (char *) "krava01",
 		.val.num   = 15,
@@ -78,7 +78,7 @@ static struct parse_events__term test_terms[] = {
 		.type_term = PARSE_EVENTS__TERM_TYPE_USER,
 	},
 };
-#define TERMS_CNT (sizeof(test_terms) / sizeof(struct parse_events__term))
+#define TERMS_CNT (sizeof(test_terms) / sizeof(struct parse_events_term))
 
 /*
  * Prepare format directory data, exported by kernel
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index d3bf570..e5c0fcb 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -534,7 +534,7 @@ int parse_events_add_breakpoint(struct list_head **list, int *idx,
 }
 
 static int config_term(struct perf_event_attr *attr,
-		       struct parse_events__term *term)
+		       struct parse_events_term *term)
 {
 #define CHECK_TYPE_VAL(type)					\
 do {								\
@@ -579,7 +579,7 @@ do {								\
 static int config_attr(struct perf_event_attr *attr,
 		       struct list_head *head, int fail)
 {
-	struct parse_events__term *term;
+	struct parse_events_term *term;
 
 	list_for_each_entry(term, head, list)
 		if (config_term(attr, term) && fail)
@@ -605,14 +605,14 @@ int parse_events_add_numeric(struct list_head **list, int *idx,
 	return add_event(list, idx, &attr, NULL);
 }
 
-static int parse_events__is_name_term(struct parse_events__term *term)
+static int parse_events__is_name_term(struct parse_events_term *term)
 {
 	return term->type_term == PARSE_EVENTS__TERM_TYPE_NAME;
 }
 
 static char *pmu_event_name(struct list_head *head_terms)
 {
-	struct parse_events__term *term;
+	struct parse_events_term *term;
 
 	list_for_each_entry(term, head_terms, list)
 		if (parse_events__is_name_term(term))
@@ -1162,16 +1162,16 @@ void print_events(const char *event_glob, bool name_only)
 	print_tracepoint_events(NULL, NULL, name_only);
 }
 
-int parse_events__is_hardcoded_term(struct parse_events__term *term)
+int parse_events__is_hardcoded_term(struct parse_events_term *term)
 {
 	return term->type_term != PARSE_EVENTS__TERM_TYPE_USER;
 }
 
-static int new_term(struct parse_events__term **_term, int type_val,
+static int new_term(struct parse_events_term **_term, int type_val,
 		    int type_term, char *config,
 		    char *str, u64 num)
 {
-	struct parse_events__term *term;
+	struct parse_events_term *term;
 
 	term = zalloc(sizeof(*term));
 	if (!term)
@@ -1197,21 +1197,21 @@ static int new_term(struct parse_events__term **_term, int type_val,
 	return 0;
 }
 
-int parse_events__term_num(struct parse_events__term **term,
+int parse_events_term__num(struct parse_events_term **term,
 			   int type_term, char *config, u64 num)
 {
 	return new_term(term, PARSE_EVENTS__TERM_TYPE_NUM, type_term,
 			config, NULL, num);
 }
 
-int parse_events__term_str(struct parse_events__term **term,
+int parse_events_term__str(struct parse_events_term **term,
 			   int type_term, char *config, char *str)
 {
 	return new_term(term, PARSE_EVENTS__TERM_TYPE_STR, type_term,
 			config, str, 0);
 }
 
-int parse_events__term_sym_hw(struct parse_events__term **term,
+int parse_events_term__sym_hw(struct parse_events_term **term,
 			      char *config, unsigned idx)
 {
 	struct event_symbol *sym;
@@ -1229,8 +1229,8 @@ int parse_events__term_sym_hw(struct parse_events__term **term,
 				(char *) "event", (char *) sym->symbol, 0);
 }
 
-int parse_events__term_clone(struct parse_events__term **new,
-			     struct parse_events__term *term)
+int parse_events_term__clone(struct parse_events_term **new,
+			     struct parse_events_term *term)
 {
 	return new_term(new, term->type_val, term->type_term, term->config,
 			term->val.str, term->val.num);
@@ -1238,7 +1238,7 @@ int parse_events__term_clone(struct parse_events__term **new,
 
 void parse_events__free_terms(struct list_head *terms)
 {
-	struct parse_events__term *term, *h;
+	struct parse_events_term *term, *h;
 
 	list_for_each_entry_safe(term, h, terms, list)
 		free(term);
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 7c5244f..dd2978e7 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -50,7 +50,7 @@ enum {
 	PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE,
 };
 
-struct parse_events__term {
+struct parse_events_term {
 	char *config;
 	union {
 		char *str;
@@ -70,15 +70,15 @@ struct parse_events_data__terms {
 	struct list_head *terms;
 };
 
-int parse_events__is_hardcoded_term(struct parse_events__term *term);
-int parse_events__term_num(struct parse_events__term **_term,
+int parse_events__is_hardcoded_term(struct parse_events_term *term);
+int parse_events_term__num(struct parse_events_term **_term,
 			   int type_term, char *config, u64 num);
-int parse_events__term_str(struct parse_events__term **_term,
+int parse_events_term__str(struct parse_events_term **_term,
 			   int type_term, char *config, char *str);
-int parse_events__term_sym_hw(struct parse_events__term **term,
+int parse_events_term__sym_hw(struct parse_events_term **term,
 			      char *config, unsigned idx);
-int parse_events__term_clone(struct parse_events__term **new,
-			     struct parse_events__term *term);
+int parse_events_term__clone(struct parse_events_term **new,
+			     struct parse_events_term *term);
 void parse_events__free_terms(struct list_head *terms);
 int parse_events__modifier_event(struct list_head *list, char *str, bool add);
 int parse_events__modifier_group(struct list_head *list, char *event_mod);
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 0f9914a..57ecf9d 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -68,7 +68,7 @@ do { \
 	char *str;
 	u64 num;
 	struct list_head *head;
-	struct parse_events__term *term;
+	struct parse_events_term *term;
 }
 %%
 
@@ -315,7 +315,7 @@ event_config:
 event_config ',' event_term
 {
 	struct list_head *head = $1;
-	struct parse_events__term *term = $3;
+	struct parse_events_term *term = $3;
 
 	ABORT_ON(!head);
 	list_add_tail(&term->list, head);
@@ -325,7 +325,7 @@ event_config ',' event_term
 event_term
 {
 	struct list_head *head = malloc(sizeof(*head));
-	struct parse_events__term *term = $1;
+	struct parse_events_term *term = $1;
 
 	ABORT_ON(!head);
 	INIT_LIST_HEAD(head);
@@ -336,70 +336,70 @@ event_term
 event_term:
 PE_NAME '=' PE_NAME
 {
-	struct parse_events__term *term;
+	struct parse_events_term *term;
 
-	ABORT_ON(parse_events__term_str(&term, PARSE_EVENTS__TERM_TYPE_USER,
+	ABORT_ON(parse_events_term__str(&term, PARSE_EVENTS__TERM_TYPE_USER,
 					$1, $3));
 	$$ = term;
 }
 |
 PE_NAME '=' PE_VALUE
 {
-	struct parse_events__term *term;
+	struct parse_events_term *term;
 
-	ABORT_ON(parse_events__term_num(&term, PARSE_EVENTS__TERM_TYPE_USER,
+	ABORT_ON(parse_events_term__num(&term, PARSE_EVENTS__TERM_TYPE_USER,
 					$1, $3));
 	$$ = term;
 }
 |
 PE_NAME '=' PE_VALUE_SYM_HW
 {
-	struct parse_events__term *term;
+	struct parse_events_term *term;
 	int config = $3 & 255;
 
-	ABORT_ON(parse_events__term_sym_hw(&term, $1, config));
+	ABORT_ON(parse_events_term__sym_hw(&term, $1, config));
 	$$ = term;
 }
 |
 PE_NAME
 {
-	struct parse_events__term *term;
+	struct parse_events_term *term;
 
-	ABORT_ON(parse_events__term_num(&term, PARSE_EVENTS__TERM_TYPE_USER,
+	ABORT_ON(parse_events_term__num(&term, PARSE_EVENTS__TERM_TYPE_USER,
 					$1, 1));
 	$$ = term;
 }
 |
 PE_VALUE_SYM_HW
 {
-	struct parse_events__term *term;
+	struct parse_events_term *term;
 	int config = $1 & 255;
 
-	ABORT_ON(parse_events__term_sym_hw(&term, NULL, config));
+	ABORT_ON(parse_events_term__sym_hw(&term, NULL, config));
 	$$ = term;
 }
 |
 PE_TERM '=' PE_NAME
 {
-	struct parse_events__term *term;
+	struct parse_events_term *term;
 
-	ABORT_ON(parse_events__term_str(&term, (int)$1, NULL, $3));
+	ABORT_ON(parse_events_term__str(&term, (int)$1, NULL, $3));
 	$$ = term;
 }
 |
 PE_TERM '=' PE_VALUE
 {
-	struct parse_events__term *term;
+	struct parse_events_term *term;
 
-	ABORT_ON(parse_events__term_num(&term, (int)$1, NULL, $3));
+	ABORT_ON(parse_events_term__num(&term, (int)$1, NULL, $3));
 	$$ = term;
 }
 |
 PE_TERM
 {
-	struct parse_events__term *term;
+	struct parse_events_term *term;
 
-	ABORT_ON(parse_events__term_num(&term, (int)$1, NULL, 1));
+	ABORT_ON(parse_events_term__num(&term, (int)$1, NULL, 1));
 	$$ = term;
 }
 
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index b93ff14..c107e24b 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -175,12 +175,12 @@ static int pmu_aliases(char *name, struct list_head *head)
 static int pmu_alias_terms(struct perf_pmu__alias *alias,
 			   struct list_head *terms)
 {
-	struct parse_events__term *term, *clone;
+	struct parse_events_term *term, *clone;
 	LIST_HEAD(list);
 	int ret;
 
 	list_for_each_entry(term, &alias->terms, list) {
-		ret = parse_events__term_clone(&clone, term);
+		ret = parse_events_term__clone(&clone, term);
 		if (ret) {
 			parse_events__free_terms(&list);
 			return ret;
@@ -403,7 +403,7 @@ static __u64 pmu_format_value(unsigned long *format, __u64 value)
  */
 static int pmu_config_term(struct list_head *formats,
 			   struct perf_event_attr *attr,
-			   struct parse_events__term *term)
+			   struct parse_events_term *term)
 {
 	struct perf_pmu__format *format;
 	__u64 *vp;
@@ -450,7 +450,7 @@ int perf_pmu__config_terms(struct list_head *formats,
 			   struct perf_event_attr *attr,
 			   struct list_head *head_terms)
 {
-	struct parse_events__term *term;
+	struct parse_events_term *term;
 
 	list_for_each_entry(term, head_terms, list)
 		if (pmu_config_term(formats, attr, term))
@@ -472,7 +472,7 @@ int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
 }
 
 static struct perf_pmu__alias *pmu_find_alias(struct perf_pmu *pmu,
-					      struct parse_events__term *term)
+					      struct parse_events_term *term)
 {
 	struct perf_pmu__alias *alias;
 	char *name;
@@ -507,7 +507,7 @@ static struct perf_pmu__alias *pmu_find_alias(struct perf_pmu *pmu,
  */
 int perf_pmu__check_alias(struct perf_pmu *pmu, struct list_head *head_terms)
 {
-	struct parse_events__term *term, *h;
+	struct parse_events_term *term, *h;
 	struct perf_pmu__alias *alias;
 	int ret;
 
-- 
1.8.1.1.361.gec3ae6e

