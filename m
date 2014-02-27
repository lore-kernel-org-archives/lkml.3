Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaB0MM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:12:27 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:38246 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaB0MM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:12:26 -0500
Date: Thu, 27 Feb 2014 17:40:11 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, josh@joshtriplett.org
Subject: [PATCH 29/46] kernel: Mark functions as static in
 trace/trace_functions_graph.c
Message-ID: <4cd6a5e920322b37f250cf3d3fae3feb8e5ef2f6.1393493277.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions as static in kernel/trace/trace_functions_graph.c because
they are not used outside this file.

This eliminates the following warning in
kernel/trace/trace_functions_graph.c:
kernel/trace/trace_functions_graph.c:333:5: warning: no previous prototype for ‘trace_graph_thresh_entry’ [-Wmissing-prototypes]
kernel/trace/trace_functions_graph.c:422:6: warning: no previous prototype for ‘trace_graph_thresh_return’ [-Wmissing-prototypes]
kernel/trace/trace_functions_graph.c:1408:6: warning: no previous prototype for ‘print_graph_headers’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/trace/trace_functions_graph.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 0b99120..9e9b5c2 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -330,7 +330,7 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
 	return ret;
 }
 
-int trace_graph_thresh_entry(struct ftrace_graph_ent *trace)
+static int trace_graph_thresh_entry(struct ftrace_graph_ent *trace)
 {
 	if (tracing_thresh)
 		return 1;
@@ -419,7 +419,7 @@ void set_graph_array(struct trace_array *tr)
 	smp_mb();
 }
 
-void trace_graph_thresh_return(struct ftrace_graph_ret *trace)
+static void trace_graph_thresh_return(struct ftrace_graph_ret *trace)
 {
 	if (tracing_thresh &&
 	    (trace->rettime - trace->calltime < tracing_thresh))
@@ -1405,7 +1405,7 @@ static void __print_graph_headers_flags(struct seq_file *s, u32 flags)
 	seq_printf(s, "               |   |   |   |\n");
 }
 
-void print_graph_headers(struct seq_file *s)
+static void print_graph_headers(struct seq_file *s)
 {
 	print_graph_headers_flags(s, tracer_flags.val);
 }
-- 
1.7.9.5

