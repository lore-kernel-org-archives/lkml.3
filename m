Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933986Ab3HHCvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 22:51:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50792 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933946Ab3HHCvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 22:51:35 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@kernel.org
Cc: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 10/19] perf tool: Add option to print stack trace on single line
Date: Wed,  7 Aug 2013 22:50:52 -0400
Message-Id: <1375930261-77273-11-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
References: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Option is used by upcoming timehist command.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/session.c |    8 ++++++--
 tools/perf/util/session.h |    1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index e5fd658..0d895e7 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1497,6 +1497,8 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 	int print_sym = print_opts & PRINT_IP_OPT_SYM;
 	int print_dso = print_opts & PRINT_IP_OPT_DSO;
 	int print_symoffset = print_opts & PRINT_IP_OPT_SYMOFFSET;
+	int print_oneline = print_opts & PRINT_IP_OPT_ONELINE;
+	char s = print_oneline ? ' ' : '\t';
 
 	if (perf_event__preprocess_sample(event, machine, &al, sample,
 					  NULL) < 0) {
@@ -1521,7 +1523,7 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 				break;
 
 			if (print_ip)
-				printf("%16" PRIx64, node->ip);
+				printf("%c%16" PRIx64, s, node->ip);
 
 			if (print_sym) {
 				printf(" ");
@@ -1537,7 +1539,9 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 				map__fprintf_dsoname(node->map, stdout);
 				printf(")");
 			}
-			printf("\n");
+
+			if (!print_oneline)
+				printf("\n");
 
 			callchain_cursor_advance(&callchain_cursor);
 		}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 69e554a..7c00ccb 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -45,6 +45,7 @@ struct perf_session {
 #define PRINT_IP_OPT_SYM		(1<<1)
 #define PRINT_IP_OPT_DSO		(1<<2)
 #define PRINT_IP_OPT_SYMOFFSET	(1<<3)
+#define PRINT_IP_OPT_ONELINE	(1<<4)
 
 struct perf_tool;
 
-- 
1.7.10.1

