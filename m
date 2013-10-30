Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab3J3QPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:15:17 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:52971 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab3J3QPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:15:14 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/2] perf list: Remove a level of indentation
Date: Wed, 30 Oct 2013 10:15:06 -0600
Message-Id: <1383149707-1008-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a return after the if check an indentation level can be removed.
Indentation shift only; no functional changes.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-list.c | 73 ++++++++++++++++++++++++-----------------------
 1 file changed, 37 insertions(+), 36 deletions(-)

diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index e79f423cc302..45000e7d4398 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -17,48 +17,49 @@
 
 int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 {
+	int i;
+
 	setup_pager();
 
-	if (argc == 1)
+	if (argc == 1) {
 		print_events(NULL, false);
-	else {
-		int i;
-
-		for (i = 1; i < argc; ++i) {
-			if (i > 2)
-				putchar('\n');
-			if (strncmp(argv[i], "tracepoint", 10) == 0)
-				print_tracepoint_events(NULL, NULL, false);
-			else if (strcmp(argv[i], "hw") == 0 ||
-				 strcmp(argv[i], "hardware") == 0)
-				print_events_type(PERF_TYPE_HARDWARE);
-			else if (strcmp(argv[i], "sw") == 0 ||
-				 strcmp(argv[i], "software") == 0)
-				print_events_type(PERF_TYPE_SOFTWARE);
-			else if (strcmp(argv[i], "cache") == 0 ||
-				 strcmp(argv[i], "hwcache") == 0)
-				print_hwcache_events(NULL, false);
-			else if (strcmp(argv[i], "pmu") == 0)
-				print_pmu_events(NULL, false);
-			else if (strcmp(argv[i], "--raw-dump") == 0)
-				print_events(NULL, true);
-			else {
-				char *sep = strchr(argv[i], ':'), *s;
-				int sep_idx;
+		return 0;
+	}
 
-				if (sep == NULL) {
-					print_events(argv[i], false);
-					continue;
-				}
-				sep_idx = sep - argv[i];
-				s = strdup(argv[i]);
-				if (s == NULL)
-					return -1;
+	for (i = 1; i < argc; ++i) {
+		if (i > 2)
+			putchar('\n');
+		if (strncmp(argv[i], "tracepoint", 10) == 0)
+			print_tracepoint_events(NULL, NULL, false);
+		else if (strcmp(argv[i], "hw") == 0 ||
+			 strcmp(argv[i], "hardware") == 0)
+			print_events_type(PERF_TYPE_HARDWARE);
+		else if (strcmp(argv[i], "sw") == 0 ||
+			 strcmp(argv[i], "software") == 0)
+			print_events_type(PERF_TYPE_SOFTWARE);
+		else if (strcmp(argv[i], "cache") == 0 ||
+			 strcmp(argv[i], "hwcache") == 0)
+			print_hwcache_events(NULL, false);
+		else if (strcmp(argv[i], "pmu") == 0)
+			print_pmu_events(NULL, false);
+		else if (strcmp(argv[i], "--raw-dump") == 0)
+			print_events(NULL, true);
+		else {
+			char *sep = strchr(argv[i], ':'), *s;
+			int sep_idx;
 
-				s[sep_idx] = '\0';
-				print_tracepoint_events(s, s + sep_idx + 1, false);
-				free(s);
+			if (sep == NULL) {
+				print_events(argv[i], false);
+				continue;
 			}
+			sep_idx = sep - argv[i];
+			s = strdup(argv[i]);
+			if (s == NULL)
+				return -1;
+
+			s[sep_idx] = '\0';
+			print_tracepoint_events(s, s + sep_idx + 1, false);
+			free(s);
 		}
 	}
 	return 0;
-- 
1.8.3.4 (Apple Git-47)

