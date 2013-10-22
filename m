Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab3JVHfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 03:35:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:12361 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936Ab3JVHfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 03:35:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="310958538"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V2 11/14] perf sched: Make struct perf_sched sched a local variable
Date: Tue, 22 Oct 2013 10:34:15 +0300
Message-Id: <1382427258-17495-12-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1382427258-17495-1-git-send-email-adrian.hunter@intel.com>
References: <1382427258-17495-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change "struct perf_sched sched" from being global
to being local.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-sched.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 5a46b10..5a33856 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1655,29 +1655,28 @@ static int __cmd_record(int argc, const char **argv)
 	return cmd_record(i, rec_argv, NULL);
 }
 
-static const char default_sort_order[] = "avg, max, switch, runtime";
-static struct perf_sched sched = {
-	.tool = {
-		.sample		 = perf_sched__process_tracepoint_sample,
-		.comm		 = perf_event__process_comm,
-		.lost		 = perf_event__process_lost,
-		.fork		 = perf_sched__process_fork_event,
-		.ordered_samples = true,
-	},
-	.cmp_pid	      = LIST_HEAD_INIT(sched.cmp_pid),
-	.sort_list	      = LIST_HEAD_INIT(sched.sort_list),
-	.start_work_mutex     = PTHREAD_MUTEX_INITIALIZER,
-	.work_done_wait_mutex = PTHREAD_MUTEX_INITIALIZER,
-	.curr_pid	      = { [0 ... MAX_CPUS - 1] = -1 },
-	.sort_order	      = default_sort_order,
-	.replay_repeat	      = 10,
-	.profile_cpu	      = -1,
-	.next_shortname1      = 'A',
-	.next_shortname2      = '0',
-};
-
 int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 {
+	const char default_sort_order[] = "avg, max, switch, runtime";
+	struct perf_sched sched = {
+		.tool = {
+			.sample		 = perf_sched__process_tracepoint_sample,
+			.comm		 = perf_event__process_comm,
+			.lost		 = perf_event__process_lost,
+			.fork		 = perf_sched__process_fork_event,
+			.ordered_samples = true,
+		},
+		.cmp_pid	      = LIST_HEAD_INIT(sched.cmp_pid),
+		.sort_list	      = LIST_HEAD_INIT(sched.sort_list),
+		.start_work_mutex     = PTHREAD_MUTEX_INITIALIZER,
+		.work_done_wait_mutex = PTHREAD_MUTEX_INITIALIZER,
+		.curr_pid	      = { [0 ... MAX_CPUS - 1] = -1 },
+		.sort_order	      = default_sort_order,
+		.replay_repeat	      = 10,
+		.profile_cpu	      = -1,
+		.next_shortname1      = 'A',
+		.next_shortname2      = '0',
+	};
 	const struct option latency_options[] = {
 	OPT_STRING('s', "sort", &sched.sort_order, "key[,key2...]",
 		   "sort by key(s): runtime, switch, avg, max"),
-- 
1.7.11.7

