Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965AbaDQJ5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:57:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52882 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbaDQJ5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:57:42 -0400
Date: Thu, 17 Apr 2014 02:57:29 -0700
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-a2368c3199eba493d72c6d0e5b804f908a09706c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, artagnon@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, artagnon@gmail.com
In-Reply-To: <1394853474-31019-4-git-send-email-artagnon@gmail.com>
References: <1394853474-31019-4-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf lock:
  Introduce --list-cmds for use by scripts
Git-Commit-ID: a2368c3199eba493d72c6d0e5b804f908a09706c
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

Commit-ID:  a2368c3199eba493d72c6d0e5b804f908a09706c
Gitweb:     http://git.kernel.org/tip/a2368c3199eba493d72c6d0e5b804f908a09706c
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Fri, 14 Mar 2014 23:17:53 -0400
Committer:  Jiri Olsa <jolsa@redhat.com>
CommitDate: Wed, 16 Apr 2014 17:16:04 +0200

perf lock: Introduce --list-cmds for use by scripts

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
