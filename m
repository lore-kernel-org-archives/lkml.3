Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161008Ab3AXUOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:14:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50183 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943Ab3AXUIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:50 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ulrich Drepper <drepper@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 55/74] perf tools: Remove unused 'unset' parameter from parse_events
Date: Thu, 24 Jan 2013 17:08:04 -0300
Message-Id: <1359058103-31645-56-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

The 'unset' parameter is option callback leftover with no use, removing.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ulrich Drepper <drepper@gmail.com>
Link: http://lkml.kernel.org/r/1358257194-8204-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/evsel-roundtrip-name.c | 4 ++--
 tools/perf/tests/hists_link.c           | 4 ++--
 tools/perf/tests/parse-events.c         | 2 +-
 tools/perf/util/parse-events.c          | 5 ++---
 tools/perf/util/parse-events.h          | 3 +--
 5 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/tools/perf/tests/evsel-roundtrip-name.c b/tools/perf/tests/evsel-roundtrip-name.c
index e61fc82..0fd99a9 100644
--- a/tools/perf/tests/evsel-roundtrip-name.c
+++ b/tools/perf/tests/evsel-roundtrip-name.c
@@ -22,7 +22,7 @@ static int perf_evsel__roundtrip_cache_name_test(void)
 			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
 				__perf_evsel__hw_cache_type_op_res_name(type, op, i,
 									name, sizeof(name));
-				err = parse_events(evlist, name, 0);
+				err = parse_events(evlist, name);
 				if (err)
 					ret = err;
 			}
@@ -70,7 +70,7 @@ static int __perf_evsel__name_array_test(const char *names[], int nr_names)
                 return -ENOMEM;
 
 	for (i = 0; i < nr_names; ++i) {
-		err = parse_events(evlist, names[i], 0);
+		err = parse_events(evlist, names[i]);
 		if (err) {
 			pr_debug("failed to parse event '%s', err %d\n",
 				 names[i], err);
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 27860a0..0afd922 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -441,10 +441,10 @@ int test__hists_link(void)
 	if (evlist == NULL)
                 return -ENOMEM;
 
-	err = parse_events(evlist, "cpu-clock", 0);
+	err = parse_events(evlist, "cpu-clock");
 	if (err)
 		goto out;
-	err = parse_events(evlist, "task-clock", 0);
+	err = parse_events(evlist, "task-clock");
 	if (err)
 		goto out;
 
diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index e7eb708..337424d 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -1018,7 +1018,7 @@ static int test_event(struct test__event_st *e)
 	if (evlist == NULL)
 		return -ENOMEM;
 
-	ret = parse_events(evlist, e->name, 0);
+	ret = parse_events(evlist, e->name);
 	if (ret) {
 		pr_debug("failed to parse event '%s', err %d\n",
 			 e->name, ret);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 626c120..d3bf570 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -872,8 +872,7 @@ int parse_events_terms(struct list_head *terms, const char *str)
 	return ret;
 }
 
-int parse_events(struct perf_evlist *evlist, const char *str,
-		 int unset __maybe_unused)
+int parse_events(struct perf_evlist *evlist, const char *str)
 {
 	struct parse_events_data__events data = {
 		.list = LIST_HEAD_INIT(data.list),
@@ -900,7 +899,7 @@ int parse_events_option(const struct option *opt, const char *str,
 			int unset __maybe_unused)
 {
 	struct perf_evlist *evlist = *(struct perf_evlist **)opt->value;
-	int ret = parse_events(evlist, str, unset);
+	int ret = parse_events(evlist, str);
 
 	if (ret) {
 		fprintf(stderr, "invalid or unsupported event: '%s'\n", str);
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index b7af80b..7c5244f 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -29,8 +29,7 @@ const char *event_type(int type);
 
 extern int parse_events_option(const struct option *opt, const char *str,
 			       int unset);
-extern int parse_events(struct perf_evlist *evlist, const char *str,
-			int unset);
+extern int parse_events(struct perf_evlist *evlist, const char *str);
 extern int parse_events_terms(struct list_head *terms, const char *str);
 extern int parse_filter(const struct option *opt, const char *str, int unset);
 
-- 
1.8.1.1.361.gec3ae6e

