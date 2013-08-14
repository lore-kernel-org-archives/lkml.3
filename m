Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760265Ab3HNSZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:25:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34340 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760201Ab3HNSZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:25:26 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/21] perf evsel: Add option to print stack trace on single line
Date: Wed, 14 Aug 2013 15:25:02 -0300
Message-Id: <1376504715-28107-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376504715-28107-1-git-send-email-acme@infradead.org>
References: <1376504715-28107-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Option is used by upcoming timehist command.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1375930261-77273-11-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 8 ++++++--
 tools/perf/util/session.h | 1 +
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
1.8.1.4

