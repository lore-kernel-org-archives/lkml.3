Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab3BAKjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:39:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51767 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980Ab3BAKjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:39:35 -0500
Date: Fri, 1 Feb 2013 02:39:17 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-8d7d8474d7b04dc89aa653d67425b61d3ff5c6f0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, tglx@linutronix.de,
        namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1358845787-1350-3-git-send-email-namhyung@kernel.org>
References: <1358845787-1350-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Add group test conditions
Git-Commit-ID: 8d7d8474d7b04dc89aa653d67425b61d3ff5c6f0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 01 Feb 2013 02:39:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d7d8474d7b04dc89aa653d67425b61d3ff5c6f0
Gitweb:     http://git.kernel.org/tip/8d7d8474d7b04dc89aa653d67425b61d3ff5c6f0
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 22 Jan 2013 18:09:30 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 31 Jan 2013 13:07:44 -0300

perf tests: Add group test conditions

As some new fields for handling groups added, check them to be sure to
have valid values in test__group* cases.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1358845787-1350-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/parse-events.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 20acaff..80a8daf 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -23,6 +23,7 @@ static int test__checkevent_tracepoint(struct perf_evlist *evlist)
 	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
 	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong number of groups", 0 == evlist->nr_groups);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_TRACEPOINT == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong sample_type",
 		PERF_TP_SAMPLE_TYPE == evsel->attr.sample_type);
@@ -35,6 +36,7 @@ static int test__checkevent_tracepoint_multi(struct perf_evlist *evlist)
 	struct perf_evsel *evsel;
 
 	TEST_ASSERT_VAL("wrong number of entries", evlist->nr_entries > 1);
+	TEST_ASSERT_VAL("wrong number of groups", 0 == evlist->nr_groups);
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		TEST_ASSERT_VAL("wrong type",
@@ -510,6 +512,7 @@ static int test__group1(struct perf_evlist *evlist)
 	struct perf_evsel *evsel, *leader;
 
 	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong number of groups", 1 == evlist->nr_groups);
 
 	/* instructions:k */
 	evsel = leader = perf_evlist__first(evlist);
@@ -523,6 +526,8 @@ static int test__group1(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
+	TEST_ASSERT_VAL("wrong nr_members", evsel->nr_members == 2);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 0);
 
 	/* cycles:upp */
 	evsel = perf_evsel__next(evsel);
@@ -537,6 +542,7 @@ static int test__group1(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 2);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 1);
 
 	return 0;
 }
@@ -546,6 +552,7 @@ static int test__group2(struct perf_evlist *evlist)
 	struct perf_evsel *evsel, *leader;
 
 	TEST_ASSERT_VAL("wrong number of entries", 3 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong number of groups", 1 == evlist->nr_groups);
 
 	/* faults + :ku modifier */
 	evsel = leader = perf_evlist__first(evlist);
@@ -559,6 +566,8 @@ static int test__group2(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
+	TEST_ASSERT_VAL("wrong nr_members", evsel->nr_members == 2);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 0);
 
 	/* cache-references + :u modifier */
 	evsel = perf_evsel__next(evsel);
@@ -572,6 +581,7 @@ static int test__group2(struct perf_evlist *evlist)
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 1);
 
 	/* cycles:k */
 	evsel = perf_evsel__next(evsel);
@@ -594,6 +604,7 @@ static int test__group3(struct perf_evlist *evlist __maybe_unused)
 	struct perf_evsel *evsel, *leader;
 
 	TEST_ASSERT_VAL("wrong number of entries", 5 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong number of groups", 2 == evlist->nr_groups);
 
 	/* group1 syscalls:sys_enter_open:H */
 	evsel = leader = perf_evlist__first(evlist);
@@ -610,6 +621,8 @@ static int test__group3(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
 	TEST_ASSERT_VAL("wrong group name",
 		!strcmp(leader->group_name, "group1"));
+	TEST_ASSERT_VAL("wrong nr_members", evsel->nr_members == 2);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 0);
 
 	/* group1 cycles:kppp */
 	evsel = perf_evsel__next(evsel);
@@ -625,6 +638,7 @@ static int test__group3(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 3);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
 	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 1);
 
 	/* group2 cycles + G modifier */
 	evsel = leader = perf_evsel__next(evsel);
@@ -640,6 +654,8 @@ static int test__group3(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
 	TEST_ASSERT_VAL("wrong group name",
 		!strcmp(leader->group_name, "group2"));
+	TEST_ASSERT_VAL("wrong nr_members", evsel->nr_members == 2);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 0);
 
 	/* group2 1:3 + G modifier */
 	evsel = perf_evsel__next(evsel);
@@ -652,6 +668,7 @@ static int test__group3(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 1);
 
 	/* instructions:u */
 	evsel = perf_evsel__next(evsel);
@@ -674,6 +691,7 @@ static int test__group4(struct perf_evlist *evlist __maybe_unused)
 	struct perf_evsel *evsel, *leader;
 
 	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong number of groups", 1 == evlist->nr_groups);
 
 	/* cycles:u + p */
 	evsel = leader = perf_evlist__first(evlist);
@@ -689,6 +707,8 @@ static int test__group4(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 1);
 	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
 	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
+	TEST_ASSERT_VAL("wrong nr_members", evsel->nr_members == 2);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 0);
 
 	/* instructions:kp + p */
 	evsel = perf_evsel__next(evsel);
@@ -703,6 +723,7 @@ static int test__group4(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude host", !evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", evsel->attr.precise_ip == 2);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 1);
 
 	return 0;
 }
@@ -712,6 +733,7 @@ static int test__group5(struct perf_evlist *evlist __maybe_unused)
 	struct perf_evsel *evsel, *leader;
 
 	TEST_ASSERT_VAL("wrong number of entries", 5 == evlist->nr_entries);
+	TEST_ASSERT_VAL("wrong number of groups", 2 == evlist->nr_groups);
 
 	/* cycles + G */
 	evsel = leader = perf_evlist__first(evlist);
@@ -726,6 +748,8 @@ static int test__group5(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
 	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
+	TEST_ASSERT_VAL("wrong nr_members", evsel->nr_members == 2);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 0);
 
 	/* instructions + G */
 	evsel = perf_evsel__next(evsel);
@@ -739,6 +763,7 @@ static int test__group5(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 1);
 
 	/* cycles:G */
 	evsel = leader = perf_evsel__next(evsel);
@@ -753,6 +778,8 @@ static int test__group5(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong group name", !evsel->group_name);
 	TEST_ASSERT_VAL("wrong leader", perf_evsel__is_group_leader(evsel));
+	TEST_ASSERT_VAL("wrong nr_members", evsel->nr_members == 2);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 0);
 
 	/* instructions:G */
 	evsel = perf_evsel__next(evsel);
@@ -766,6 +793,7 @@ static int test__group5(struct perf_evlist *evlist __maybe_unused)
 	TEST_ASSERT_VAL("wrong exclude host", evsel->attr.exclude_host);
 	TEST_ASSERT_VAL("wrong precise_ip", !evsel->attr.precise_ip);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+	TEST_ASSERT_VAL("wrong group_idx", perf_evsel__group_idx(evsel) == 1);
 
 	/* cycles */
 	evsel = perf_evsel__next(evsel);
