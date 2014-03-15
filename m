Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbaCODRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 23:17:24 -0400
Received: from mail-yk0-f174.google.com ([209.85.160.174]:44511 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972AbaCODRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 23:17:21 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/4] perf mem: introduce --list-cmds for use by scripts
Date: Fri, 14 Mar 2014 23:17:52 -0400
Message-Id: <1394853474-31019-3-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.9.rc0.1.g9d22d25
In-Reply-To: <1394853474-31019-1-git-send-email-artagnon@gmail.com>
References: <1394853474-31019-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/builtin-mem.c      | 15 ++++++++-------
 tools/perf/perf-completion.sh |  2 +-
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
index 2e3ade69..4a1a6c9 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -21,11 +21,6 @@ struct perf_mem {
 	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 };
 
-static const char * const mem_usage[] = {
-	"perf mem [<options>] {record <command> |report}",
-	NULL
-};
-
 static int __cmd_record(int argc, const char **argv)
 {
 	int rec_argc, i = 0, j;
@@ -220,9 +215,15 @@ int cmd_mem(int argc, const char **argv, const char *prefix __maybe_unused)
 		   " between columns '.' is reserved."),
 	OPT_END()
 	};
+	const char *const mem_subcommands[] = { "record", "report", NULL };
+	const char *mem_usage[] = {
+		NULL,
+		NULL
+	};
+
 
-	argc = parse_options(argc, argv, mem_options, mem_usage,
-			     PARSE_OPT_STOP_AT_NON_OPTION);
+	argc = parse_options_subcommand(argc, argv, mem_options, mem_subcommands,
+					mem_usage, PARSE_OPT_STOP_AT_NON_OPTION);
 
 	if (!argc || !(strncmp(argv[0], "rec", 3) || mem_operation))
 		usage_with_options(mem_usage, mem_options);
diff --git a/tools/perf/perf-completion.sh b/tools/perf/perf-completion.sh
index 0ef59dd..f44c04b 100644
--- a/tools/perf/perf-completion.sh
+++ b/tools/perf/perf-completion.sh
@@ -122,7 +122,7 @@ __perf_main ()
 		evts=$($cmd list --raw-dump)
 		__perfcomp_colon "$evts" "$cur"
 	# List subcommands for perf commands
-	elif [[ $prev == @(kvm|kmem) ]]; then
+	elif [[ $prev == @(kvm|kmem|mem) ]]; then
 		subcmds=$($cmd $prev --list-cmds)
 		__perfcomp_colon "$subcmds" "$cur"
 	# List long option names
-- 
1.9.rc0.1.g9d22d25

