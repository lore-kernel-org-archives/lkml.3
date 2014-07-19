Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966000AbaGSNRL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 09:17:11 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:11706 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755532AbaGSNQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 09:16:17 -0400
Message-Id: <20140719131615.036510835@goodmis.org>
User-Agent: quilt/0.63-1
Date: Sat, 19 Jul 2014 09:15:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        kbuild test robot <fengguang.wu@intel.com>
Subject: [for-next][PATCH 32/32] tracing: Convert local function_graph functions to static
References: <20140719131524.009152325@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0032-tracing-Convert-local-function_graph-functions-to-st.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Local functions should be static.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions_graph.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 74d98820497c..f0a0c982cde3 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -353,7 +353,7 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
 	return ret;
 }
 
-int trace_graph_thresh_entry(struct ftrace_graph_ent *trace)
+static int trace_graph_thresh_entry(struct ftrace_graph_ent *trace)
 {
 	if (tracing_thresh)
 		return 1;
@@ -442,7 +442,7 @@ void set_graph_array(struct trace_array *tr)
 	smp_mb();
 }
 
-void trace_graph_thresh_return(struct ftrace_graph_ret *trace)
+static void trace_graph_thresh_return(struct ftrace_graph_ret *trace)
 {
 	if (tracing_thresh &&
 	    (trace->rettime - trace->calltime < tracing_thresh))
@@ -475,7 +475,7 @@ static void graph_trace_reset(struct trace_array *tr)
 	unregister_ftrace_graph();
 }
 
-int graph_trace_update_thresh(struct trace_array *tr)
+static int graph_trace_update_thresh(struct trace_array *tr)
 {
 	graph_trace_reset(tr);
 	return graph_trace_init(tr);
@@ -1435,7 +1435,7 @@ static void __print_graph_headers_flags(struct seq_file *s, u32 flags)
 	seq_printf(s, "               |   |   |   |\n");
 }
 
-void print_graph_headers(struct seq_file *s)
+static void print_graph_headers(struct seq_file *s)
 {
 	print_graph_headers_flags(s, tracer_flags.val);
 }
-- 
2.0.1


