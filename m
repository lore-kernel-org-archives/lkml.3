Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbaDPSmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:42:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756070AbaDPSmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:42:02 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 11/11] perf sched: Introduce --list-cmds for use by scripts
Date: Wed, 16 Apr 2014 20:41:39 +0200
Message-Id: <1397673699-25824-12-git-send-email-jolsa@redhat.com>
In-Reply-To: <1397673699-25824-1-git-send-email-jolsa@redhat.com>
References: <1397673699-25824-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkumar Ramachandra <artagnon@gmail.com>

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1394853474-31019-5-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-sched.c    | 10 ++++++----
 tools/perf/perf-completion.sh |  2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 9ac0a49..d3fb0ed 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1713,8 +1713,10 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 		"perf sched replay [<options>]",
 		NULL
 	};
-	const char * const sched_usage[] = {
-		"perf sched [<options>] {record|latency|map|replay|script}",
+	const char *const sched_subcommands[] = { "record", "latency", "map",
+						  "replay", "script", NULL };
+	const char *sched_usage[] = {
+		NULL,
 		NULL
 	};
 	struct trace_sched_handler lat_ops  = {
@@ -1736,8 +1738,8 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 	for (i = 0; i < ARRAY_SIZE(sched.curr_pid); i++)
 		sched.curr_pid[i] = -1;
 
-	argc = parse_options(argc, argv, sched_options, sched_usage,
-			     PARSE_OPT_STOP_AT_NON_OPTION);
+	argc = parse_options_subcommand(argc, argv, sched_options, sched_subcommands,
+					sched_usage, PARSE_OPT_STOP_AT_NON_OPTION);
 	if (!argc)
 		usage_with_options(sched_usage, sched_options);
 
diff --git a/tools/perf/perf-completion.sh b/tools/perf/perf-completion.sh
index ecedab6..3356984 100644
--- a/tools/perf/perf-completion.sh
+++ b/tools/perf/perf-completion.sh
@@ -122,7 +122,7 @@ __perf_main ()
 		evts=$($cmd list --raw-dump)
 		__perfcomp_colon "$evts" "$cur"
 	# List subcommands for perf commands
-	elif [[ $prev == @(kvm|kmem|mem|lock) ]]; then
+	elif [[ $prev == @(kvm|kmem|mem|lock|sched) ]]; then
 		subcmds=$($cmd $prev --list-cmds)
 		__perfcomp_colon "$subcmds" "$cur"
 	# List long option names
-- 
1.8.3.1

