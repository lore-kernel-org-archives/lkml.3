Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbaDQJ5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:57:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52864 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbaDQJ5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:57:15 -0400
Date: Thu, 17 Apr 2014 02:57:00 -0700
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-3bca23543b910a84d3c58a819663e0a4fad72bb6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, artagnon@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, artagnon@gmail.com
In-Reply-To: <1394853474-31019-2-git-send-email-artagnon@gmail.com>
References: <1394853474-31019-2-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kmem:
  Introduce --list-cmds for use by scripts
Git-Commit-ID: 3bca23543b910a84d3c58a819663e0a4fad72bb6
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

Commit-ID:  3bca23543b910a84d3c58a819663e0a4fad72bb6
Gitweb:     http://git.kernel.org/tip/3bca23543b910a84d3c58a819663e0a4fad72bb6
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Fri, 14 Mar 2014 23:17:51 -0400
Committer:  Jiri Olsa <jolsa@redhat.com>
CommitDate: Wed, 16 Apr 2014 17:16:04 +0200

perf kmem: Introduce --list-cmds for use by scripts

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1394853474-31019-2-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-kmem.c     | 8 +++++---
 tools/perf/perf-completion.sh | 4 ++--
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 929462a..bd91de0 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -756,11 +756,13 @@ int cmd_kmem(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN(0, "raw-ip", &raw_ip, "show raw ip instead of symbol"),
 	OPT_END()
 	};
-	const char * const kmem_usage[] = {
-		"perf kmem [<options>] {record|stat}",
+	const char *const kmem_subcommands[] = { "record", "stat", NULL };
+	const char *kmem_usage[] = {
+		NULL,
 		NULL
 	};
-	argc = parse_options(argc, argv, kmem_options, kmem_usage, 0);
+	argc = parse_options_subcommand(argc, argv, kmem_options,
+					kmem_subcommands, kmem_usage, 0);
 
 	if (!argc)
 		usage_with_options(kmem_usage, kmem_options);
diff --git a/tools/perf/perf-completion.sh b/tools/perf/perf-completion.sh
index ae3a576..0ef59dd 100644
--- a/tools/perf/perf-completion.sh
+++ b/tools/perf/perf-completion.sh
@@ -121,8 +121,8 @@ __perf_main ()
 	elif [[ $prev == "-e" && "${words[1]}" == @(record|stat|top) ]]; then
 		evts=$($cmd list --raw-dump)
 		__perfcomp_colon "$evts" "$cur"
-	# List subcommands for 'perf kvm'
-	elif [[ $prev == "kvm" ]]; then
+	# List subcommands for perf commands
+	elif [[ $prev == @(kvm|kmem) ]]; then
 		subcmds=$($cmd $prev --list-cmds)
 		__perfcomp_colon "$subcmds" "$cur"
 	# List long option names
