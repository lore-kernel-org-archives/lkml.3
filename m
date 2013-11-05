Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153Ab3KEUMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 15:12:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38808 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab3KEUKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 15:10:11 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/10] perf list: Remove a level of indentation
Date: Tue,  5 Nov 2013 17:09:55 -0300
Message-Id: <1383682201-19399-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383682201-19399-1-git-send-email-acme@infradead.org>
References: <1383682201-19399-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

With a return after the if check an indentation level can be removed.
Indentation shift only; no functional changes.

Signed-off-by: David Ahern <dsahern@gmail.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1383149707-1008-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.8.1.4

