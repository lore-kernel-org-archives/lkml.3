Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422696AbaGSNRR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 09:17:17 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:62021 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755530AbaGSNQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 09:16:17 -0400
Message-Id: <20140719131614.323173589@goodmis.org>
User-Agent: quilt/0.63-1
Date: Sat, 19 Jul 2014 09:15:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [for-next][PATCH 28/32] tracing: Remove function_trace_stop and
 HAVE_FUNCTION_TRACE_MCOUNT_TEST
References: <20140719131524.009152325@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0028-tracing-Remove-function_trace_stop-and-HAVE_FUNCTION.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

All users of function_trace_stop and HAVE_FUNCTION_TRACE_MCOUNT_TEST have
been removed. We can safely remove them from the kernel.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h | 2 --
 kernel/trace/Kconfig   | 5 -----
 kernel/trace/ftrace.c  | 3 ---
 3 files changed, 10 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index c800906235e1..7a5b7b97e539 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -129,8 +129,6 @@ struct ftrace_ops {
 #endif
 };
 
-extern int function_trace_stop;
-
 /*
  * Type of the current tracing.
  */
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index d4409356f40d..a5da09c899dd 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -29,11 +29,6 @@ config HAVE_FUNCTION_GRAPH_FP_TEST
 	help
 	  See Documentation/trace/ftrace-design.txt
 
-config HAVE_FUNCTION_TRACE_MCOUNT_TEST
-	bool
-	help
-	  See Documentation/trace/ftrace-design.txt
-
 config HAVE_DYNAMIC_FTRACE
 	bool
 	help
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 70abf97d6e84..4c61f28a08e0 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -80,9 +80,6 @@ static struct ftrace_ops ftrace_list_end __read_mostly = {
 int ftrace_enabled __read_mostly;
 static int last_ftrace_enabled;
 
-/* Quick disabling of function tracer. */
-int function_trace_stop __read_mostly;
-
 /* Current function tracing op */
 struct ftrace_ops *function_trace_op __read_mostly = &ftrace_list_end;
 /* What to set function_trace_op to */
-- 
2.0.1


