Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935099AbaEaBk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 21:40:58 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:54987 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932340AbaEaBj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 21:39:27 -0400
Message-Id: <20140531013925.575251571@goodmis.org>
User-Agent: quilt/0.63-1
Date: Fri, 30 May 2014 21:38:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Robert Elliott <elliott@hp.com>
Subject: [for-next][PATCH 1/7] tracing: Eliminate duplicate TRACE_GRAPH_PRINT_xx defines
References: <20140531013857.160310242@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0000-tracing-Eliminate-duplicate-TRACE_GRAPH_PRINT_xx-def.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Elliott <elliott@hp.com>

Eliminate duplicate TRACE_GRAPH_PRINT_xx defines
in trace_functions_graph.c that are already in
trace.h.

Add TRACE_GRAPH_PRINT_IRQS to trace.h, which is
the only one that is missing.

Link: http://lkml.kernel.org/p/20140520221031.8359.24733.stgit@beardog.cce.hp.com

Signed-off-by: Robert Elliott <elliott@hp.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h                 | 1 +
 kernel/trace/trace_functions_graph.c | 9 ---------
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 3b3e09e61f33..68050633255e 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -724,6 +724,7 @@ extern unsigned long trace_flags;
 #define TRACE_GRAPH_PRINT_PROC          0x8
 #define TRACE_GRAPH_PRINT_DURATION      0x10
 #define TRACE_GRAPH_PRINT_ABS_TIME      0x20
+#define TRACE_GRAPH_PRINT_IRQS          0x40
 #define TRACE_GRAPH_PRINT_FILL_SHIFT	28
 #define TRACE_GRAPH_PRINT_FILL_MASK	(0x3 << TRACE_GRAPH_PRINT_FILL_SHIFT)
 
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index b86dd4d8c6a6..af08dd531cb8 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -38,15 +38,6 @@ struct fgraph_data {
 
 #define TRACE_GRAPH_INDENT	2
 
-/* Flag options */
-#define TRACE_GRAPH_PRINT_OVERRUN	0x1
-#define TRACE_GRAPH_PRINT_CPU		0x2
-#define TRACE_GRAPH_PRINT_OVERHEAD	0x4
-#define TRACE_GRAPH_PRINT_PROC		0x8
-#define TRACE_GRAPH_PRINT_DURATION	0x10
-#define TRACE_GRAPH_PRINT_ABS_TIME	0x20
-#define TRACE_GRAPH_PRINT_IRQS		0x40
-
 static unsigned int max_depth;
 
 static struct tracer_opt trace_opts[] = {
-- 
2.0.0.rc2


