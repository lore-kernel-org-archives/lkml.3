Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354AbaFZRAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:00:10 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:60346 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757908AbaFZQ6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:58:55 -0400
Message-Id: <20140626165853.970373284@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 26 Jun 2014 12:52:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>
Subject: [RFA][PATCH 27/27] tracing: Remove function_trace_stop and
 HAVE_FUNCTION_TRACE_MCOUNT_TEST
References: <20140626165221.736847419@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0027-tracing-Remove-function_trace_stop-and-HAVE_FUNCTION.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

All users of function_trace_stop and HAVE_FUNCTION_TRACE_MCOUNT_TEST have
been removed. We can safely remove them from the kernel.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h | 2 --
 kernel/trace/Kconfig   | 5 -----
 kernel/trace/ftrace.c  | 3 ---
 3 files changed, 10 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 7a21d5358b74..ff860dbff75a 100644
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
index 34994885bb1d..2241bfbe4fbc 100644
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
2.0.0


