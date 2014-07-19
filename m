Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031AbaGSNQl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 09:16:41 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:11686 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755369AbaGSNQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 09:16:15 -0400
Message-Id: <20140719131611.384448949@goodmis.org>
User-Agent: quilt/0.63-1
Date: Sat, 19 Jul 2014 09:15:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [for-next][PATCH 13/32] ftrace: Remove ftrace_start/stop()
References: <20140719131524.009152325@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0013-ftrace-Remove-ftrace_start-stop.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

There are no more kernel users of ftrace_stop() and ftrace_start().
Remove them.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h | 28 ----------------------------
 1 file changed, 28 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 18fb2c4a3f7f..b7333794554f 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -143,32 +143,6 @@ enum ftrace_tracing_type_t {
 /* Current tracing type, default is FTRACE_TYPE_ENTER */
 extern enum ftrace_tracing_type_t ftrace_tracing_type;
 
-/**
- * ftrace_stop - stop function tracer.
- *
- * A quick way to stop the function tracer. Note this an on off switch,
- * it is not something that is recursive like preempt_disable.
- * This does not disable the calling of mcount, it only stops the
- * calling of functions from mcount.
- */
-static inline void ftrace_stop(void)
-{
-	function_trace_stop = 1;
-}
-
-/**
- * ftrace_start - start the function tracer.
- *
- * This function is the inverse of ftrace_stop. This does not enable
- * the function tracing if the function tracer is disabled. This only
- * sets the function tracer flag to continue calling the functions
- * from mcount.
- */
-static inline void ftrace_start(void)
-{
-	function_trace_stop = 0;
-}
-
 /*
  * The ftrace_ops must be a static and should also
  * be read_mostly.  These functions do modify read_mostly variables
@@ -245,8 +219,6 @@ static inline int ftrace_nr_registered_ops(void)
 }
 static inline void clear_ftrace_function(void) { }
 static inline void ftrace_kill(void) { }
-static inline void ftrace_stop(void) { }
-static inline void ftrace_start(void) { }
 #endif /* CONFIG_FUNCTION_TRACER */
 
 #ifdef CONFIG_STACK_TRACER
-- 
2.0.1


