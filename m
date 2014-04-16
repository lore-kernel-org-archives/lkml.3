Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbaDPSmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:42:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756191AbaDPSmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:42:01 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 10/11] perf lock: Introduce --list-cmds for use by scripts
Date: Wed, 16 Apr 2014 20:41:38 +0200
Message-Id: <1397673699-25824-11-git-send-email-jolsa@redhat.com>
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
Link: http://lkml.kernel.org/r/1394853474-31019-4-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-lock.c     | 10 ++++++----
 tools/perf/perf-completion.sh |  2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index c852c7a..6148afc 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -961,8 +961,10 @@ int cmd_lock(int argc, const char **argv, const char *prefix __maybe_unused)
 		"perf lock info [<options>]",
 		NULL
 	};
-	const char * const lock_usage[] = {
-		"perf lock [<options>] {record|report|script|info}",
+	const char *const lock_subcommands[] = { "record", "report", "script",
+						 "info", NULL };
+	const char *lock_usage[] = {
+		NULL,
 		NULL
 	};
 	const char * const report_usage[] = {
@@ -976,8 +978,8 @@ int cmd_lock(int argc, const char **argv, const char *prefix __maybe_unused)
 	for (i = 0; i < LOCKHASH_SIZE; i++)
 		INIT_LIST_HEAD(lockhash_table + i);
 
-	argc = parse_options(argc, argv, lock_options, lock_usage,
-			     PARSE_OPT_STOP_AT_NON_OPTION);
+	argc = parse_options_subcommand(argc, argv, lock_options, lock_subcommands,
+					lock_usage, PARSE_OPT_STOP_AT_NON_OPTION);
 	if (!argc)
 		usage_with_options(lock_usage, lock_options);
 
diff --git a/tools/perf/perf-completion.sh b/tools/perf/perf-completion.sh
index f44c04b..ecedab6 100644
--- a/tools/perf/perf-completion.sh
+++ b/tools/perf/perf-completion.sh
@@ -122,7 +122,7 @@ __perf_main ()
 		evts=$($cmd list --raw-dump)
 		__perfcomp_colon "$evts" "$cur"
 	# List subcommands for perf commands
-	elif [[ $prev == @(kvm|kmem|mem) ]]; then
+	elif [[ $prev == @(kvm|kmem|mem|lock) ]]; then
 		subcmds=$($cmd $prev --list-cmds)
 		__perfcomp_colon "$subcmds" "$cur"
 	# List long option names
-- 
1.8.3.1

