Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbaDPSmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:42:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756070AbaDPSl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:41:57 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 08/11] perf kmem: Introduce --list-cmds for use by scripts
Date: Wed, 16 Apr 2014 20:41:36 +0200
Message-Id: <1397673699-25824-9-git-send-email-jolsa@redhat.com>
In-Reply-To: <1397673699-25824-1-git-send-email-jolsa@redhat.com>
References: <1397673699-25824-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkumar Ramachandra <artagnon@gmail.com>

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
-- 
1.8.3.1

