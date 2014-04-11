Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262AbaDKNN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:13:29 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:35783 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbaDKNN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:13:26 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH v3] perf list: Fix --raw-dump argument
Date: Fri, 11 Apr 2014 09:13:46 -0400
Message-Id: <1397222026-4588-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.9.2.667.ge5b74e1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While adding usage information, 44d742e (perf list: Add usage,
2013-10-30) broke

  $ perf list --raw-dump

Fix this by making raw-dump a subcommand. Also update the completion
script and manpage.

Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/Documentation/perf-list.txt | 3 +++
 tools/perf/builtin-list.c              | 2 +-
 tools/perf/perf-completion.sh          | 2 +-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index 6fce6a6..13fe4f4 100644
--- a/tools/perf/Documentation/perf-list.txt
+++ b/tools/perf/Documentation/perf-list.txt
@@ -108,6 +108,9 @@ To limit the list use:
 
 . 'pmu' to print the kernel supplied PMU events.
 
+. 'raw-dump' to print out the names of all events. For internal use by
+  the completion script.
+
 . If none of the above is matched, it will apply the supplied glob to all
   events, printing the ones that match.
 
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

