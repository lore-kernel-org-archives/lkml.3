Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007AbaDQJ57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:57:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52889 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422673AbaDQJ5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:57:54 -0400
Date: Thu, 17 Apr 2014 02:57:41 -0700
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-a83edb2dfc5989fbadc594109c933bae528a2809@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, artagnon@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, artagnon@gmail.com
In-Reply-To: <1394853474-31019-5-git-send-email-artagnon@gmail.com>
References: <1394853474-31019-5-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sched:
  Introduce --list-cmds for use by scripts
Git-Commit-ID: a83edb2dfc5989fbadc594109c933bae528a2809
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

Commit-ID:  a83edb2dfc5989fbadc594109c933bae528a2809
Gitweb:     http://git.kernel.org/tip/a83edb2dfc5989fbadc594109c933bae528a2809
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Fri, 14 Mar 2014 23:17:54 -0400
Committer:  Jiri Olsa <jolsa@redhat.com>
CommitDate: Wed, 16 Apr 2014 17:16:05 +0200

perf sched: Introduce --list-cmds for use by scripts

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
