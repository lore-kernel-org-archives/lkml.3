Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901AbaGSNQk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 09:16:40 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:51597 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755381AbaGSNQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 09:16:15 -0400
Message-Id: <20140719131611.579175896@goodmis.org>
User-Agent: quilt/0.63-1
Date: Sat, 19 Jul 2014 09:15:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [for-next][PATCH 14/32] ftrace: Do no disable function tracing on enabling function tracing
References: <20140719131524.009152325@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0014-ftrace-Do-no-disable-function-tracing-on-enabling-fu.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When function tracing is being updated function_trace_stop is set to
keep from tracing the updates. This was fine when function tracing
was done from stop machine. But it is no longer done that way and
this can cause real tracing to be missed.

Remove it.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 8063280fd53d..0fa1b87db95c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2261,11 +2261,6 @@ static void ftrace_run_update_code(int command)
 	FTRACE_WARN_ON(ret);
 	if (ret)
 		return;
-	/*
-	 * Do not call function tracer while we update the code.
-	 * We are in stop machine.
-	 */
-	function_trace_stop++;
 
 	/*
 	 * By default we use stop_machine() to modify the code.
@@ -2275,8 +2270,6 @@ static void ftrace_run_update_code(int command)
 	 */
 	arch_ftrace_update_code(command);
 
-	function_trace_stop--;
-
 	ret = ftrace_arch_code_modify_post_process();
 	FTRACE_WARN_ON(ret);
 
-- 
2.0.1


