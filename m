Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210Ab3AYLxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:53:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42074 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126Ab3AYLxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:53:30 -0500
Date: Fri, 25 Jan 2013 03:52:56 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-d8f7bbc947afb59c68a8574d1fe99b20cff2b1be@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        drepper@gmail.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, drepper@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1358257194-8204-2-git-send-email-jolsa@redhat.com>
References: <1358257194-8204-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Remove unused 'unset'
  parameter from parse_events
Git-Commit-ID: d8f7bbc947afb59c68a8574d1fe99b20cff2b1be
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:53:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8f7bbc947afb59c68a8574d1fe99b20cff2b1be
Gitweb:     http://git.kernel.org/tip/d8f7bbc947afb59c68a8574d1fe99b20cff2b1be
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 15 Jan 2013 14:39:51 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:40 -0300

perf tools: Remove unused 'unset' parameter from parse_events

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
 
