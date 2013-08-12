Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab3HLKSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:18:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47750 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290Ab3HLKS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:18:29 -0400
Date: Mon, 12 Aug 2013 03:18:06 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-tmcy0ir7i8id2t54qg5ifbio@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests:
  Add parse events tests for leader sampling
Git-Commit-ID: a9f93f97424c64f8d5d94b653a2133e491498680
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:18:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a9f93f97424c64f8d5d94b653a2133e491498680
Gitweb:     http://git.kernel.org/tip/a9f93f97424c64f8d5d94b653a2133e491498680
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 1 Feb 2013 20:37:11 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:23 -0300

perf tests: Add parse events tests for leader sampling

Adding 2 more tests to the automated parse events suite for following
event config:

  '{cycles,cache-misses,branch-misses}:S'
  '{instructions,branch-misses}:Su'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-tmcy0ir7i8id2t54qg5ifbio@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/parse-events.c | 115 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 115 insertions(+)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 344c844..b46379c 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -520,6 +520,7 @@ static int test__group1(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
 	TEST_ASSERT_VAL("wrong nr_members", evsel->nr_members == 2);
 	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 0);
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	/* cycles:upp */
 	evsel = perf_evsel__next(evsel);
@@ -535,6 +536,7 @@ static int test__group1(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 2);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
 	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 1);
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	return 0;
 }
@@ -560,6 +562,7 @@ static int test__group2(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
 	TEST_ASSERT_VAL("wrong nr_members", evsel->nr_members == 2);
 	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 0);
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	/* cache-references + :u modifier */
 	evsel = perf_evsel__next(evsel);
@@ -574,6 +577,7 @@ static int test__group2(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
 	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 1);
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	/* cycles:k */
 	evsel = perf_evsel__next(evsel);
@@ -587,6 +591,7 @@ static int test__group2(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	return 0;
 }
@@ -615,6 +620,7 @@ static int test__group3(struct perf_evlist *evlist __maybe_unused)
 		!strcmp(leader->group_name, "group1"));
 	TEST_ASSERT_VAL("wrong nr_members", evsel->nr_members == 2);
 	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 0);
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	/* group1 cycles:kppp */
 	evsel = perf_evsel__next(evsel);
@@ -631,6 +637,7 @@ static int test__group3(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
 	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
 	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 1);
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	/* group2 cycles + G modifier */
 	evsel = leader = perf_evsel__next(evsel);
@@ -648,6 +655,7 @@ static int test__group3(struct perf_evlist *evlist __maybe_unused)
 		!strcmp(leader->group_name, "group2"));
 	TEST_ASSERT_VAL("wrong nr_members", evsel->nr_members == 2);
 	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 0);
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	/* group2 1:3 + G modifier */
 	evsel = perf_evsel__next(evsel);
@@ -661,6 +669,7 @@ static int test__group3(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
 	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 1);
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	/* instructions:u */
 	evsel = perf_evsel__next(evsel);
@@ -674,6 +683,7 @@ static int test__group3(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	return 0;
 }
@@ -701,6 +711,7 @@ static int test__group4(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
 	TEST_ASSERT_VAL("wrong nr_members", evsel->nr_members == 2);
 	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 0);
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	/* instructions:kp + p */
 	evsel = perf_evsel__next(evsel);
@@ -716,6 +727,7 @@ static int test__group4(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 2);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
 	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 1);
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	return 0;
 }
@@ -742,6 +754,7 @@ static int test__group5(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
 	TEST_ASSERT_VAL("wrong nr_members", evsel->nr_members == 2);
 	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 0);
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	/* instructions + G */
 	evsel = perf_evsel__next(evsel);
@@ -756,6 +769,7 @@ static int test__group5(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
 	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 1);
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	/* cycles:G */
 	evsel = leader = perf_evsel__next(evsel);
@@ -772,6 +786,7 @@ static int test__group5(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
 	TEST_ASSERT_VAL("wrong nr_members", evsel->nr_members == 2);
 	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 0);
+	TEST_ASSERT_VAL("wrong sample_read", !evsel->sample_read);
 
 	/* instructions:G */
 	evsel = perf_evsel__next(evsel);
@@ -963,6 +978,98 @@ static int test__group_gh4(struct perf_evlist *evlist)
 	return 0;
 }
 
+static int test__leader_sample1(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel, *leader;
+
+	TEST_ASSERT_VAL("wrong number of entries", 3 == evlist->nr_entries);
+
+	/* cycles - sampling group leader */
+	evsel = leader = perf_evlist__first(evlist);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong sample_read", evsel->sample_read);
+
+	/* cache-misses - not sampling */
+	evsel = perf_evsel__next(evsel);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_CACHE_MISSES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong sample_read", evsel->sample_read);
+
+	/* branch-misses - not sampling */
+	evsel = perf_evsel__next(evsel);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_BRANCH_MISSES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", !evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", !evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong sample_read", evsel->sample_read);
+
+	return 0;
+}
+
+static int test__leader_sample2(struct perf_evlist *evlist __maybe_unused)
+{
+	struct perf_evsel *evsel, *leader;
+
+	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
+
+	/* instructions - sampling group leader */
+	evsel = leader = perf_evlist__first(evlist);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong sample_read", evsel->sample_read);
+
+	/* branch-misses - not sampling */
+	evsel = perf_evsel__next(evsel);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_BRANCH_MISSES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong exclude_user", !evsel->attr.exclude_user);
+	TEST_ASSERT_VAL("wrong exclude_kernel", evsel->attr.exclude_kernel);
+	TEST_ASSERT_VAL("wrong exclude_hv", evsel->attr.exclude_hv);
+	TEST_ASSERT_VAL("wrong exclude guest", evsel->attr.exclude_guest);
+	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
+	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
+	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong sample_read", evsel->sample_read);
+
+	return 0;
+}
+
 static int count_tracepoints(void)
 {
 	char events_path[PATH_MAX];
@@ -1179,6 +1286,14 @@ static struct evlist_test test__events[] = {
 		.name  = "{cycles:G,cache-misses:H}:uG",
 		.check = test__group_gh4,
 	},
+	[38] = {
+		.name  = "{cycles,cache-misses,branch-misses}:S",
+		.check = test__leader_sample1,
+	},
+	[39] = {
+		.name  = "{instructions,branch-misses}:Su",
+		.check = test__leader_sample2,
+	},
 };
 
 static struct evlist_test test__events_pmu[] = {
