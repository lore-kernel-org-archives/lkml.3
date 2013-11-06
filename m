Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab3KFFoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 00:44:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44264 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab3KFFoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 00:44:20 -0500
Date: Tue, 5 Nov 2013 21:43:34 -0800
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-8e00ddc9dfe09ee131144fdaf6c96ebe95bbbbcb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1383149707-1008-1-git-send-email-dsahern@gmail.com>
References: <1383149707-1008-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf list: Remove a level of indentation
Git-Commit-ID: 8e00ddc9dfe09ee131144fdaf6c96ebe95bbbbcb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 05 Nov 2013 21:43:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8e00ddc9dfe09ee131144fdaf6c96ebe95bbbbcb
Gitweb:     http://git.kernel.org/tip/8e00ddc9dfe09ee131144fdaf6c96ebe95bbbbcb
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Wed, 30 Oct 2013 10:15:06 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 5 Nov 2013 14:25:26 -0300

perf list: Remove a level of indentation

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
index e79f423..45000e7 100644
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
