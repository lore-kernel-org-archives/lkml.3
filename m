Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbaELWTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 18:19:47 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:34723 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbaELWTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 18:19:45 -0400
Subject: [PATCH 1/2] Eliminate duplicate TRACE_GRAPH_PRINT_xx defines
To: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org
From: Robert Elliott <elliott@hp.com>
Date: Mon, 12 May 2014 17:18:36 -0500
Message-ID: <20140512221836.14555.14663.stgit@beardog.cce.hp.com>
In-Reply-To: <20140512221729.14555.57686.stgit@beardog.cce.hp.com>
References: <20140512221729.14555.57686.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in trace_functions_graph.c that are already in
trace.h.

Add TRACE_GRAPH_PRINT_IRQS to trace.h, which is
the only one that is missing.

Signed-off-by: Robert Elliott <elliott@hp.com>
---
 kernel/trace/trace.h                 |    1 +
 kernel/trace/trace_functions_graph.c |    9 ---------
 2 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 2e29d7b..861668a 100644
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
index deff112..ab78221 100644
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

