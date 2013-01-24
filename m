Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab3AXUOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:14:22 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54098
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755947Ab3AXUIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:51 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 64/74] perf tools: Fix usage of __ in event parsing struct names
Date: Thu, 24 Jan 2013 17:08:13 -0300
Message-Id: <1359058103-31645-65-git-send-email-acme@infradead.org>
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

Fix this usage by removing it from the struct names and fix also the
associated functions.

Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-kdcoh7uitivx68otqcz12aaz@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/parse-events.c | 24 ++++++++++++------------
 tools/perf/util/parse-events.c  |  4 ++--
 tools/perf/util/parse-events.h  |  4 ++--
 tools/perf/util/parse-events.y  | 26 +++++++++++++-------------
 4 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 9ac45c5..20acaff 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -840,13 +840,13 @@ static int test__all_tracepoints(struct perf_evlist *evlist)
 	return test__checkevent_tracepoint_multi(evlist);
 }
 
-struct test__event_st {
+struct evlist_test {
 	const char *name;
 	__u32 type;
 	int (*check)(struct perf_evlist *evlist);
 };
 
-static struct test__event_st test__events[] = {
+static struct evlist_test test__events[] = {
 	[0] = {
 		.name  = "syscalls:sys_enter_open",
 		.check = test__checkevent_tracepoint,
@@ -985,7 +985,7 @@ static struct test__event_st test__events[] = {
 	},
 };
 
-static struct test__event_st test__events_pmu[] = {
+static struct evlist_test test__events_pmu[] = {
 	[0] = {
 		.name  = "cpu/config=10,config1,config2=3,period=1000/u",
 		.check = test__checkevent_pmu,
@@ -996,20 +996,20 @@ static struct test__event_st test__events_pmu[] = {
 	},
 };
 
-struct test__term {
+struct terms_test {
 	const char *str;
 	__u32 type;
 	int (*check)(struct list_head *terms);
 };
 
-static struct test__term test__terms[] = {
+static struct terms_test test__terms[] = {
 	[0] = {
 		.str   = "config=10,config1,config2=3,umask=1",
 		.check = test__checkterms_simple,
 	},
 };
 
-static int test_event(struct test__event_st *e)
+static int test_event(struct evlist_test *e)
 {
 	struct perf_evlist *evlist;
 	int ret;
@@ -1031,13 +1031,13 @@ static int test_event(struct test__event_st *e)
 	return ret;
 }
 
-static int test_events(struct test__event_st *events, unsigned cnt)
+static int test_events(struct evlist_test *events, unsigned cnt)
 {
 	int ret1, ret2 = 0;
 	unsigned i;
 
 	for (i = 0; i < cnt; i++) {
-		struct test__event_st *e = &events[i];
+		struct evlist_test *e = &events[i];
 
 		pr_debug("running test %d '%s'\n", i, e->name);
 		ret1 = test_event(e);
@@ -1048,7 +1048,7 @@ static int test_events(struct test__event_st *events, unsigned cnt)
 	return ret2;
 }
 
-static int test_term(struct test__term *t)
+static int test_term(struct terms_test *t)
 {
 	struct list_head *terms;
 	int ret;
@@ -1072,13 +1072,13 @@ static int test_term(struct test__term *t)
 	return ret;
 }
 
-static int test_terms(struct test__term *terms, unsigned cnt)
+static int test_terms(struct terms_test *terms, unsigned cnt)
 {
 	int ret = 0;
 	unsigned i;
 
 	for (i = 0; i < cnt; i++) {
-		struct test__term *t = &terms[i];
+		struct terms_test *t = &terms[i];
 
 		pr_debug("running test %d '%s'\n", i, t->str);
 		ret = test_term(t);
@@ -1129,7 +1129,7 @@ static int test_pmu_events(void)
 
 	while (!ret && (ent = readdir(dir))) {
 #define MAX_NAME 100
-		struct test__event_st e;
+		struct evlist_test e;
 		char name[MAX_NAME];
 
 		if (!strcmp(ent->d_name, ".") ||
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index e5c0fcb..02f6421 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -856,7 +856,7 @@ static int parse_events__scanner(const char *str, void *data, int start_token)
  */
 int parse_events_terms(struct list_head *terms, const char *str)
 {
-	struct parse_events_data__terms data = {
+	struct parse_events_terms data = {
 		.terms = NULL,
 	};
 	int ret;
@@ -874,7 +874,7 @@ int parse_events_terms(struct list_head *terms, const char *str)
 
 int parse_events(struct perf_evlist *evlist, const char *str)
 {
-	struct parse_events_data__events data = {
+	struct parse_events_evlist data = {
 		.list = LIST_HEAD_INIT(data.list),
 		.idx  = evlist->nr_entries,
 	};
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index dd2978e7..2cd2c42 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -61,12 +61,12 @@ struct parse_events_term {
 	struct list_head list;
 };
 
-struct parse_events_data__events {
+struct parse_events_evlist {
 	struct list_head list;
 	int idx;
 };
 
-struct parse_events_data__terms {
+struct parse_events_terms {
 	struct list_head *terms;
 };
 
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 57ecf9d..9d43c86 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -79,7 +79,7 @@ PE_START_TERMS  start_terms
 
 start_events: groups
 {
-	struct parse_events_data__events *data = _data;
+	struct parse_events_evlist *data = _data;
 
 	parse_events_update_lists($1, &data->list);
 }
@@ -186,7 +186,7 @@ event_def: event_pmu |
 event_pmu:
 PE_NAME '/' event_config '/'
 {
-	struct parse_events_data__events *data = _data;
+	struct parse_events_evlist *data = _data;
 	struct list_head *list = NULL;
 
 	ABORT_ON(parse_events_add_pmu(&list, &data->idx, $1, $3));
@@ -202,7 +202,7 @@ PE_VALUE_SYM_SW
 event_legacy_symbol:
 value_sym '/' event_config '/'
 {
-	struct parse_events_data__events *data = _data;
+	struct parse_events_evlist *data = _data;
 	struct list_head *list = NULL;
 	int type = $1 >> 16;
 	int config = $1 & 255;
@@ -215,7 +215,7 @@ value_sym '/' event_config '/'
 |
 value_sym sep_slash_dc
 {
-	struct parse_events_data__events *data = _data;
+	struct parse_events_evlist *data = _data;
 	struct list_head *list = NULL;
 	int type = $1 >> 16;
 	int config = $1 & 255;
@@ -228,7 +228,7 @@ value_sym sep_slash_dc
 event_legacy_cache:
 PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT '-' PE_NAME_CACHE_OP_RESULT
 {
-	struct parse_events_data__events *data = _data;
+	struct parse_events_evlist *data = _data;
 	struct list_head *list = NULL;
 
 	ABORT_ON(parse_events_add_cache(&list, &data->idx, $1, $3, $5));
@@ -237,7 +237,7 @@ PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT '-' PE_NAME_CACHE_OP_RESULT
 |
 PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT
 {
-	struct parse_events_data__events *data = _data;
+	struct parse_events_evlist *data = _data;
 	struct list_head *list = NULL;
 
 	ABORT_ON(parse_events_add_cache(&list, &data->idx, $1, $3, NULL));
@@ -246,7 +246,7 @@ PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT
 |
 PE_NAME_CACHE_TYPE
 {
-	struct parse_events_data__events *data = _data;
+	struct parse_events_evlist *data = _data;
 	struct list_head *list = NULL;
 
 	ABORT_ON(parse_events_add_cache(&list, &data->idx, $1, NULL, NULL));
@@ -256,7 +256,7 @@ PE_NAME_CACHE_TYPE
 event_legacy_mem:
 PE_PREFIX_MEM PE_VALUE ':' PE_MODIFIER_BP sep_dc
 {
-	struct parse_events_data__events *data = _data;
+	struct parse_events_evlist *data = _data;
 	struct list_head *list = NULL;
 
 	ABORT_ON(parse_events_add_breakpoint(&list, &data->idx,
@@ -266,7 +266,7 @@ PE_PREFIX_MEM PE_VALUE ':' PE_MODIFIER_BP sep_dc
 |
 PE_PREFIX_MEM PE_VALUE sep_dc
 {
-	struct parse_events_data__events *data = _data;
+	struct parse_events_evlist *data = _data;
 	struct list_head *list = NULL;
 
 	ABORT_ON(parse_events_add_breakpoint(&list, &data->idx,
@@ -277,7 +277,7 @@ PE_PREFIX_MEM PE_VALUE sep_dc
 event_legacy_tracepoint:
 PE_NAME ':' PE_NAME
 {
-	struct parse_events_data__events *data = _data;
+	struct parse_events_evlist *data = _data;
 	struct list_head *list = NULL;
 
 	ABORT_ON(parse_events_add_tracepoint(&list, &data->idx, $1, $3));
@@ -287,7 +287,7 @@ PE_NAME ':' PE_NAME
 event_legacy_numeric:
 PE_VALUE ':' PE_VALUE
 {
-	struct parse_events_data__events *data = _data;
+	struct parse_events_evlist *data = _data;
 	struct list_head *list = NULL;
 
 	ABORT_ON(parse_events_add_numeric(&list, &data->idx, (u32)$1, $3, NULL));
@@ -297,7 +297,7 @@ PE_VALUE ':' PE_VALUE
 event_legacy_raw:
 PE_RAW
 {
-	struct parse_events_data__events *data = _data;
+	struct parse_events_evlist *data = _data;
 	struct list_head *list = NULL;
 
 	ABORT_ON(parse_events_add_numeric(&list, &data->idx,
@@ -307,7 +307,7 @@ PE_RAW
 
 start_terms: event_config
 {
-	struct parse_events_data__terms *data = _data;
+	struct parse_events_terms *data = _data;
 	data->terms = $1;
 }
 
-- 
1.8.1.1.361.gec3ae6e

