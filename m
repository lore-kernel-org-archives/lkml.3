Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbaCODRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 23:17:30 -0400
Received: from mail-yk0-f176.google.com ([209.85.160.176]:33320 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972AbaCODR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 23:17:28 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/4] perf sched: introduce --list-cmds for use by scripts
Date: Fri, 14 Mar 2014 23:17:54 -0400
Message-Id: <1394853474-31019-5-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.9.rc0.1.g9d22d25
In-Reply-To: <1394853474-31019-1-git-send-email-artagnon@gmail.com>
References: <1394853474-31019-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/builtin-sched.c    | 10 ++++++----
 tools/perf/perf-completion.sh |  2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 6a76a07..347bd32 100644
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
1.9.rc0.1.g9d22d25

