Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758414Ab3K0UZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 15:25:08 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60951 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757695Ab3K0UQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 15:16:52 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/34] perf trace: Remove thread summary coloring
Date: Wed, 27 Nov 2013 17:16:02 -0300
Message-Id: <1385583394-3703-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385583394-3703-1-git-send-email-acme@infradead.org>
References: <1385583394-3703-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@kernel.org>

Thread summary line coloring looks ugly.  It doesn't add much value so
remove coloring completely.

Signed-off-by: Pekka Enberg <penberg@kernel.org>
Acked-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1384447410-1771-1-git-send-email-penberg@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 8be17fc462ba..e9f345e2551a 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2158,7 +2158,6 @@ static int trace__fprintf_one_thread(struct thread *thread, void *priv)
 	size_t printed = data->printed;
 	struct trace *trace = data->trace;
 	struct thread_trace *ttrace = thread->priv;
-	const char *color;
 	double ratio;
 
 	if (ttrace == NULL)
@@ -2166,17 +2165,9 @@ static int trace__fprintf_one_thread(struct thread *thread, void *priv)
 
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
1.8.1.4

