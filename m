Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab3JWU7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 16:59:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55440 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab3JWU6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 16:58:32 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/16] perf sched: Make struct perf_sched sched a local variable
Date: Wed, 23 Oct 2013 17:58:06 -0300
Message-Id: <1382561895-8237-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382561895-8237-1-git-send-email-acme@infradead.org>
References: <1382561895-8237-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Change "struct perf_sched sched" from being global to being local.

The build slowdown cured by f36f83f947ed is dealt with in the following
patch, by programatically setting perf_sched.curr_pid.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1382427258-17495-12-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-sched.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 5a46b102eb08..5a338566195e 100644
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
1.8.1.4

