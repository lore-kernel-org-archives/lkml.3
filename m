Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbaDKAml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 20:42:41 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:45672 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbaDKAmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 20:42:40 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH v2] perf list: Fix --raw-dump argument
Date: Thu, 10 Apr 2014 20:42:33 -0400
Message-Id: <1397176953-2006-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.9.2.667.ge5b74e1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While adding usage information, 44d742e (perf list: Add usage,
2013-10-30) broke

  $ perf list --raw-dump

Fix this by making raw-dump a subcommand.

Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/builtin-list.c     | 2 +-
 tools/perf/perf-completion.sh | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index 011195e..c74aef5 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -53,7 +53,7 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 			print_hwcache_events(NULL, false);
 		else if (strcmp(argv[i], "pmu") == 0)
 			print_pmu_events(NULL, false);
-		else if (strcmp(argv[i], "--raw-dump") == 0)
+		else if (strcmp(argv[i], "raw-dump") == 0)
 			print_events(NULL, true);
 		else {
 			char *sep = strchr(argv[i], ':'), *s;
diff --git a/tools/perf/perf-completion.sh b/tools/perf/perf-completion.sh
index ae3a576..8f518f0 100644
--- a/tools/perf/perf-completion.sh
+++ b/tools/perf/perf-completion.sh
@@ -119,7 +119,7 @@ __perf_main ()
 		fi
 	# List possible events for -e option
 	elif [[ $prev == "-e" && "${words[1]}" == @(record|stat|top) ]]; then
-		evts=$($cmd list --raw-dump)
+		evts=$($cmd list raw-dump)
 		__perfcomp_colon "$evts" "$cur"
 	# List subcommands for 'perf kvm'
 	elif [[ $prev == "kvm" ]]; then
-- 
1.9.2.667.ge5b74e1

