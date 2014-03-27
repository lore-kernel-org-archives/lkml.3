Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140AbaC0V0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 17:26:33 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:62227 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279AbaC0V0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 17:26:31 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] perf list: Fix --raw-dump argument
Date: Thu, 27 Mar 2014 17:27:41 -0400
Message-Id: <1395955661-10056-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.9.0.431.g014438b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While adding usage information, 44d742e (perf list: Add usage,
2013-10-30) broke

  $ perf list --raw-dump

Fix this by making raw-dump a proper argument.

Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 I sent this patch earlier, but it didn't get picked up due to some
 confusion.

 tools/perf/builtin-list.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index 011195e..2629c24 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -19,7 +19,9 @@
 int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	int i;
+	bool raw_dump = false;
 	const struct option list_options[] = {
+		OPT_BOOLEAN(0, "raw-dump", &raw_dump, "raw dump for completion"),
 		OPT_END()
 	};
 	const char * const list_usage[] = {
@@ -32,6 +34,10 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	setup_pager();
 
+	if (raw_dump) {
+		print_events(NULL, true);
+		return 0;
+	}
 	if (argc == 0) {
 		print_events(NULL, false);
 		return 0;
@@ -53,8 +59,6 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 			print_hwcache_events(NULL, false);
 		else if (strcmp(argv[i], "pmu") == 0)
 			print_pmu_events(NULL, false);
-		else if (strcmp(argv[i], "--raw-dump") == 0)
-			print_events(NULL, true);
 		else {
 			char *sep = strchr(argv[i], ':'), *s;
 			int sep_idx;
-- 
1.9.0.431.g014438b

