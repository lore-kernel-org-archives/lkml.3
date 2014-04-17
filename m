Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422667AbaDQJ5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:57:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52871 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268AbaDQJ53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:57:29 -0400
Date: Thu, 17 Apr 2014 02:57:15 -0700
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-8d2a2a1d885d36e978c4619a3db8791f9768dd6a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, artagnon@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, artagnon@gmail.com
In-Reply-To: <1394853474-31019-3-git-send-email-artagnon@gmail.com>
References: <1394853474-31019-3-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf mem:
  Introduce --list-cmds for use by scripts
Git-Commit-ID: 8d2a2a1d885d36e978c4619a3db8791f9768dd6a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d2a2a1d885d36e978c4619a3db8791f9768dd6a
Gitweb:     http://git.kernel.org/tip/8d2a2a1d885d36e978c4619a3db8791f9768dd6a
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Fri, 14 Mar 2014 23:17:52 -0400
Committer:  Jiri Olsa <jolsa@redhat.com>
CommitDate: Wed, 16 Apr 2014 17:16:04 +0200

perf mem: Introduce --list-cmds for use by scripts

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1394853474-31019-3-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
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
