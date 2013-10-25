Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab3JYKcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:32:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52376 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab3JYKc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:32:28 -0400
Date: Fri, 25 Oct 2013 03:32:04 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-8a39df8faa1cb130f136d5e404332c16fbb936c0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1382427258-17495-12-git-send-email-adrian.hunter@intel.com>
References: <1382427258-17495-12-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sched:
  Make struct perf_sched sched a local variable
Git-Commit-ID: 8a39df8faa1cb130f136d5e404332c16fbb936c0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 25 Oct 2013 03:32:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8a39df8faa1cb130f136d5e404332c16fbb936c0
Gitweb:     http://git.kernel.org/tip/8a39df8faa1cb130f136d5e404332c16fbb936c0
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 22 Oct 2013 10:34:15 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Oct 2013 10:24:19 -0300

perf sched: Make struct perf_sched sched a local variable

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
