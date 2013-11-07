Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab3KGEB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 23:01:28 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:38763 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753320Ab3KGEAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 23:00:54 -0500
Message-Id: <20131107040050.532736581@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 06 Nov 2013 23:00:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 4/5] tracing: Remove unused function ftrace_off_permanent()
References: <20131107040002.605895766@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Remove-unused-function-ftrace_off_permanent.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

In the past, ftrace_off_permanent() was called if something
strange was detected. But the ftrace_bug() now handles all the
anomolies that can happen with ftrace (function tracing), and there
are no uses of ftrace_off_permanent(). Get rid of it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/kernel.h |  2 --
 kernel/trace/trace.c   | 15 ---------------
 2 files changed, 17 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 672ddc4..d4e98d1 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -501,7 +501,6 @@ void tracing_snapshot_alloc(void);
 
 extern void tracing_start(void);
 extern void tracing_stop(void);
-extern void ftrace_off_permanent(void);
 
 static inline __printf(1, 2)
 void ____trace_printk_check_format(const char *fmt, ...)
@@ -639,7 +638,6 @@ extern void ftrace_dump(enum ftrace_dump_mode oops_dump_mode);
 #else
 static inline void tracing_start(void) { }
 static inline void tracing_stop(void) { }
-static inline void ftrace_off_permanent(void) { }
 static inline void trace_dump_stack(int skip) { }
 
 static inline void tracing_on(void) { }
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 2a595cf..d72a15c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1284,21 +1284,6 @@ int is_tracing_stopped(void)
 }
 
 /**
- * ftrace_off_permanent - disable all ftrace code permanently
- *
- * This should only be called when a serious anomally has
- * been detected.  This will turn off the function tracing,
- * ring buffers, and other tracing utilites. It takes no
- * locks and can be called from any context.
- */
-void ftrace_off_permanent(void)
-{
-	tracing_disabled = 1;
-	ftrace_stop();
-	tracing_off_permanent();
-}
-
-/**
  * tracing_start - quick start of the tracer
  *
  * If tracing is enabled but was stopped by tracing_stop,
-- 
1.8.4.rc3


