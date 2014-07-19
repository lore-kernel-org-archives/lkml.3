Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933497AbaGSNQr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 09:16:47 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:62021 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755350AbaGSNQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 09:16:14 -0400
Message-Id: <20140719131611.184458018@goodmis.org>
User-Agent: quilt/0.63-1
Date: Sat, 19 Jul 2014 09:15:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [for-next][PATCH 12/32] ftrace-graph: Remove usage of ftrace_stop() in ftrace_graph_stop()
References: <20140719131524.009152325@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0012-ftrace-graph-Remove-usage-of-ftrace_stop-in-ftrace_g.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

All archs now use ftrace_graph_is_dead() to stop function graph
tracing. Remove the usage of ftrace_stop() as that is no longer
needed.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions_graph.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 3604690be70b..2c944e6c4a9d 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -40,11 +40,6 @@ bool ftrace_graph_is_dead(void)
 void ftrace_graph_stop(void)
 {
 	kill_ftrace_graph = true;
-	/*
-	 * ftrace_stop() will be removed when all archs are updated to
-	 * use ftrace_graph_is_dead()
-	 */
-	ftrace_stop();
 }
 
 /* When set, irq functions will be ignored */
-- 
2.0.1


