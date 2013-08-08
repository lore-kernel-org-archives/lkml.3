Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933876Ab3HHCvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 22:51:24 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:60527 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933591Ab3HHCvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 22:51:20 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@kernel.org
Cc: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 04/19] perf sched: Remove sched_process_exit tracepoint
Date: Wed,  7 Aug 2013 22:50:46 -0400
Message-Id: <1375930261-77273-5-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
References: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Event is not needed nor analyzed. Since perf-sched leverages perf-record
to capture the sched data, we already capture task events like EXIT.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-sched.c |   11 -----------
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
-- 
1.7.10.1

