Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaDYPdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:33:17 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:40850 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbaDYPbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:31:46 -0400
From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
To: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        KVM <kvm@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Subject: [PATCH 2/3] perf-test: add numeric identifier to evlist_test
Date: Fri, 25 Apr 2014 17:34:06 +0200
Message-Id: <1398440047-6641-3-git-send-email-yarygin@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1398440047-6641-1-git-send-email-yarygin@linux.vnet.ibm.com>
References: <1398440047-6641-1-git-send-email-yarygin@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042515-1948-0000-0000-000008959FDF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In tests/parse-events.c test cases are declared in evlist_test[]
arrays. Elements of arrays are initialized in following pattern:
	[i] = {
 		.name  = ...,
 		.check = ...,
 	},

When perf-test is running with '-v' option, 'i' variable will be
printed for every existing test.

However, we can't add any arch specific tests inside #ifdefs, because it
will create collision between the element number inside #ifdef and the
next one outside.

This patch adds 'id' field in evlist_test, uses it as a test
identifier and removes explicit numbering of array elements. This helps
to number tests with gaps.

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
---
 tools/perf/tests/parse-events.c |  135 ++++++++++++++++++++++++++-------------
 1 file changed, 90 insertions(+), 45 deletions(-)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 8605ff5..81dbd5a 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -1174,188 +1174,233 @@ static int test__all_tracepoints(struct perf_evlist *evlist)
 struct evlist_test {
 	const char *name;
 	__u32 type;
+	const int id;
 	int (*check)(struct perf_evlist *evlist);
 };
 
 static struct evlist_test test__events[] = {
-	[0] = {
+	{
 		.name  = "syscalls:sys_enter_open",
 		.check = test__checkevent_tracepoint,
+		.id    = 0,
 	},
-	[1] = {
+	{
 		.name  = "syscalls:*",
 		.check = test__checkevent_tracepoint_multi,
+		.id    = 1,
 	},
-	[2] = {
+	{
 		.name  = "r1a",
 		.check = test__checkevent_raw,
+		.id    = 2,
 	},
-	[3] = {
+	{
 		.name  = "1:1",
 		.check = test__checkevent_numeric,
+		.id    = 3,
 	},
-	[4] = {
+	{
 		.name  = "instructions",
 		.check = test__checkevent_symbolic_name,
+		.id    = 4,
 	},
-	[5] = {
+	{
 		.name  = "cycles/period=100000,config2/",
 		.check = test__checkevent_symbolic_name_config,
+		.id    = 5,
 	},
-	[6] = {
+	{
 		.name  = "faults",
 		.check = test__checkevent_symbolic_alias,
+		.id    = 6,
 	},
-	[7] = {
+	{
 		.name  = "L1-dcache-load-miss",
 		.check = test__checkevent_genhw,
+		.id    = 7,
 	},
-	[8] = {
+	{
 		.name  = "mem:0",
 		.check = test__checkevent_breakpoint,
+		.id    = 8,
 	},
-	[9] = {
+	{
 		.name  = "mem:0:x",
 		.check = test__checkevent_breakpoint_x,
+		.id    = 9,
 	},
-	[10] = {
+	{
 		.name  = "mem:0:r",
 		.check = test__checkevent_breakpoint_r,
+		.id    = 10,
 	},
-	[11] = {
+	{
 		.name  = "mem:0:w",
 		.check = test__checkevent_breakpoint_w,
+		.id    = 11,
 	},
-	[12] = {
+	{
 		.name  = "syscalls:sys_enter_open:k",
 		.check = test__checkevent_tracepoint_modifier,
+		.id    = 12,
 	},
-	[13] = {
+	{
 		.name  = "syscalls:*:u",
 		.check = test__checkevent_tracepoint_multi_modifier,
+		.id    = 13,
 	},
-	[14] = {
+	{
 		.name  = "r1a:kp",
 		.check = test__checkevent_raw_modifier,
+		.id    = 14,
 	},
-	[15] = {
+	{
 		.name  = "1:1:hp",
 		.check = test__checkevent_numeric_modifier,
+		.id    = 15,
 	},
-	[16] = {
+	{
 		.name  = "instructions:h",
 		.check = test__checkevent_symbolic_name_modifier,
+		.id    = 16,
 	},
-	[17] = {
+	{
 		.name  = "faults:u",
 		.check = test__checkevent_symbolic_alias_modifier,
+		.id    = 17,
 	},
-	[18] = {
+	{
 		.name  = "L1-dcache-load-miss:kp",
 		.check = test__checkevent_genhw_modifier,
+		.id    = 18,
 	},
-	[19] = {
+	{
 		.name  = "mem:0:u",
 		.check = test__checkevent_breakpoint_modifier,
+		.id    = 19,
 	},
-	[20] = {
+	{
 		.name  = "mem:0:x:k",
 		.check = test__checkevent_breakpoint_x_modifier,
+		.id    = 20,
 	},
-	[21] = {
+	{
 		.name  = "mem:0:r:hp",
 		.check = test__checkevent_breakpoint_r_modifier,
+		.id    = 21,
 	},
-	[22] = {
+	{
 		.name  = "mem:0:w:up",
 		.check = test__checkevent_breakpoint_w_modifier,
+		.id    = 22,
 	},
-	[23] = {
+	{
 		.name  = "r1,syscalls:sys_enter_open:k,1:1:hp",
 		.check = test__checkevent_list,
+		.id    = 23,
 	},
-	[24] = {
+	{
 		.name  = "instructions:G",
 		.check = test__checkevent_exclude_host_modifier,
+		.id    = 24,
 	},
-	[25] = {
+	{
 		.name  = "instructions:H",
 		.check = test__checkevent_exclude_guest_modifier,
+		.id    = 25,
 	},
-	[26] = {
+	{
 		.name  = "mem:0:rw",
 		.check = test__checkevent_breakpoint_rw,
+		.id    = 26,
 	},
-	[27] = {
+	{
 		.name  = "mem:0:rw:kp",
 		.check = test__checkevent_breakpoint_rw_modifier,
+		.id    = 27,
 	},
-	[28] = {
+	{
 		.name  = "{instructions:k,cycles:upp}",
 		.check = test__group1,
+		.id    = 28,
 	},
-	[29] = {
+	{
 		.name  = "{faults:k,cache-references}:u,cycles:k",
 		.check = test__group2,
+		.id    = 29,
 	},
-	[30] = {
+	{
 		.name  = "group1{syscalls:sys_enter_open:H,cycles:kppp},group2{cycles,1:3}:G,instructions:u",
 		.check = test__group3,
+		.id    = 30,
 	},
-	[31] = {
+	{
 		.name  = "{cycles:u,instructions:kp}:p",
 		.check = test__group4,
+		.id    = 31,
 	},
-	[32] = {
+	{
 		.name  = "{cycles,instructions}:G,{cycles:G,instructions:G},cycles",
 		.check = test__group5,
+		.id    = 32,
 	},
-	[33] = {
+	{
 		.name  = "*:*",
 		.check = test__all_tracepoints,
+		.id    = 33,
 	},
-	[34] = {
+	{
 		.name  = "{cycles,cache-misses:G}:H",
 		.check = test__group_gh1,
+		.id    = 34,
 	},
-	[35] = {
+	{
 		.name  = "{cycles,cache-misses:H}:G",
 		.check = test__group_gh2,
+		.id    = 35,
 	},
-	[36] = {
+	{
 		.name  = "{cycles:G,cache-misses:H}:u",
 		.check = test__group_gh3,
+		.id    = 36,
 	},
-	[37] = {
+	{
 		.name  = "{cycles:G,cache-misses:H}:uG",
 		.check = test__group_gh4,
+		.id    = 37,
 	},
-	[38] = {
+	{
 		.name  = "{cycles,cache-misses,branch-misses}:S",
 		.check = test__leader_sample1,
+		.id    = 38,
 	},
-	[39] = {
+	{
 		.name  = "{instructions,branch-misses}:Su",
 		.check = test__leader_sample2,
+		.id    = 39,
 	},
-	[40] = {
+	{
 		.name  = "instructions:uDp",
 		.check = test__checkevent_pinned_modifier,
+		.id    = 40,
 	},
-	[41] = {
+	{
 		.name  = "{cycles,cache-misses,branch-misses}:D",
 		.check = test__pinned_group,
+		.id    = 41,
 	},
 };
 
 static struct evlist_test test__events_pmu[] = {
-	[0] = {
+	{
 		.name  = "cpu/config=10,config1,config2=3,period=1000/u",
 		.check = test__checkevent_pmu,
+		.id    = 0,
 	},
-	[1] = {
+	{
 		.name  = "cpu/config=1,name=krava/u,cpu/config=2/u",
 		.check = test__checkevent_pmu_name,
+		.id    = 1,
 	},
 };
 
@@ -1402,7 +1447,7 @@ static int test_events(struct evlist_test *events, unsigned cnt)
 	for (i = 0; i < cnt; i++) {
 		struct evlist_test *e = &events[i];
 
-		pr_debug("running test %d '%s'\n", i, e->name);
+		pr_debug("running test %d '%s'\n", e->id, e->name);
 		ret1 = test_event(e);
 		if (ret1)
 			ret2 = ret1;
-- 
1.7.9.5

