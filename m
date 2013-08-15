Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab3HOHz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 03:55:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53859 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768Ab3HOHz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 03:55:56 -0400
Date: Thu, 15 Aug 2013 00:55:25 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-4a957e4df1a212c447fd162d18dc7ee6320c1621@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1375930261-77273-5-git-send-email-dsahern@gmail.com>
References: <1375930261-77273-5-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sched: Remove sched_process_exit tracepoint
Git-Commit-ID: 4a957e4df1a212c447fd162d18dc7ee6320c1621
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 15 Aug 2013 00:55:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4a957e4df1a212c447fd162d18dc7ee6320c1621
Gitweb:     http://git.kernel.org/tip/4a957e4df1a212c447fd162d18dc7ee6320c1621
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Wed, 7 Aug 2013 22:50:46 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 12 Aug 2013 10:31:06 -0300

perf sched: Remove sched_process_exit tracepoint

Event is not needed nor analyzed. Since perf-sched leverages perf-record
to capture the sched data, we already capture task events like EXIT.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1375930261-77273-5-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-sched.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 5285024..42f4587 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1392,15 +1392,6 @@ static int process_sched_fork_event(struct perf_tool *tool,
 	return 0;
 }
 
-static int process_sched_exit_event(struct perf_tool *tool __maybe_unused,
-				    struct perf_evsel *evsel,
-				    struct perf_sample *sample __maybe_unused,
-				    struct machine *machine __maybe_unused)
-{
-	pr_debug("sched_exit event %p\n", evsel);
-	return 0;
-}
-
 static int process_sched_migrate_task_event(struct perf_tool *tool,
 					    struct perf_evsel *evsel,
 					    struct perf_sample *sample,
@@ -1447,7 +1438,6 @@ static int perf_sched__read_events(struct perf_sched *sched,
 		{ "sched:sched_wakeup",	      process_sched_wakeup_event, },
 		{ "sched:sched_wakeup_new",   process_sched_wakeup_event, },
 		{ "sched:sched_process_fork", process_sched_fork_event, },
-		{ "sched:sched_process_exit", process_sched_exit_event, },
 		{ "sched:sched_migrate_task", process_sched_migrate_task_event, },
 	};
 	struct perf_session *session;
@@ -1634,7 +1624,6 @@ static int __cmd_record(int argc, const char **argv)
 		"-e", "sched:sched_stat_sleep",
 		"-e", "sched:sched_stat_iowait",
 		"-e", "sched:sched_stat_runtime",
-		"-e", "sched:sched_process_exit",
 		"-e", "sched:sched_process_fork",
 		"-e", "sched:sched_wakeup",
 		"-e", "sched:sched_migrate_task",
