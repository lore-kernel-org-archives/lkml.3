Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab3KNQva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:51:30 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:33237 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258Ab3KNQnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:43:39 -0500
From: Pekka Enberg <penberg@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@kernel.org>
Subject: [PATCH] perf trace: Remove thread summary coloring
Date: Thu, 14 Nov 2013 18:43:30 +0200
Message-Id: <1384447410-1771-1-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thread summary line coloring looks ugly.  It doesn't add much value so
remove coloring completely.

Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 tools/perf/builtin-trace.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 943087f..b03551e 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2150,7 +2150,6 @@ static int trace__fprintf_one_thread(struct thread *thread, void *priv)
 	size_t printed = data->printed;
 	struct trace *trace = data->trace;
 	struct thread_trace *ttrace = thread->priv;
-	const char *color;
 	double ratio;
 
 	if (ttrace == NULL)
@@ -2158,17 +2157,9 @@ static int trace__fprintf_one_thread(struct thread *thread, void *priv)
 
 	ratio = (double)ttrace->nr_events / trace->nr_events * 100.0;
 
-	color = PERF_COLOR_NORMAL;
-	if (ratio > 50.0)
-		color = PERF_COLOR_RED;
-	else if (ratio > 25.0)
-		color = PERF_COLOR_GREEN;
-	else if (ratio > 5.0)
-		color = PERF_COLOR_YELLOW;
-
-	printed += color_fprintf(fp, color, " %s (%d), ", thread__comm_str(thread), thread->tid);
+	printed += fprintf(fp, " %s (%d), ", thread__comm_str(thread), thread->tid);
 	printed += fprintf(fp, "%lu events, ", ttrace->nr_events);
-	printed += color_fprintf(fp, color, "%.1f%%", ratio);
+	printed += fprintf(fp, "%.1f%%", ratio);
 	printed += fprintf(fp, ", %.3f msec\n", ttrace->runtime_ms);
 	printed += thread__dump_stats(ttrace, trace, fp);
 
-- 
1.8.3.1

