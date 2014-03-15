Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359AbaCODSc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 23:18:32 -0400
Received: from mail-yk0-f178.google.com ([209.85.160.178]:34015 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741AbaCODRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 23:17:17 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/4] perf kmem: introduce --list-cmds for use by scripts
Date: Fri, 14 Mar 2014 23:17:51 -0400
Message-Id: <1394853474-31019-2-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.9.rc0.1.g9d22d25
In-Reply-To: <1394853474-31019-1-git-send-email-artagnon@gmail.com>
References: <1394853474-31019-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
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
-- 
1.9.rc0.1.g9d22d25

