Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964994AbaGSNQz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 09:16:55 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:11706 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755470AbaGSNQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 09:16:15 -0400
Message-Id: <20140719131613.788425361@goodmis.org>
User-Agent: quilt/0.63-1
Date: Sat, 19 Jul 2014 09:15:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>
Subject: [for-next][PATCH 25/32] Blackfin: ftrace: Remove check of obsolete variable
 function_trace_stop
References: <20140719131524.009152325@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0025-Blackfin-ftrace-Remove-check-of-obsolete-variable-fu.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Nothing sets function_trace_stop to disable function tracing anymore.
Remove the check for it in the arch code.

Link: http://lkml.kernel.org/r/3144266.ziutPk5CNZ@vapier

Acked-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/blackfin/Kconfig               |  1 -
 arch/blackfin/kernel/ftrace-entry.S | 18 ------------------
 2 files changed, 19 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index f81e7b989fff..ed30699cc635 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -18,7 +18,6 @@ config BLACKFIN
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_TRACER
-	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_IDE
 	select HAVE_KERNEL_GZIP if RAMKERNEL
 	select HAVE_KERNEL_BZIP2 if RAMKERNEL
diff --git a/arch/blackfin/kernel/ftrace-entry.S b/arch/blackfin/kernel/ftrace-entry.S
index 7eed00bbd26d..28d059540424 100644
--- a/arch/blackfin/kernel/ftrace-entry.S
+++ b/arch/blackfin/kernel/ftrace-entry.S
@@ -33,15 +33,6 @@ ENDPROC(__mcount)
  * function will be waiting there.  mmmm pie.
  */
 ENTRY(_ftrace_caller)
-# ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
-	/* optional micro optimization: return if stopped */
-	p1.l = _function_trace_stop;
-	p1.h = _function_trace_stop;
-	r3 = [p1];
-	cc = r3 == 0;
-	if ! cc jump _ftrace_stub (bp);
-# endif
-
 	/* save first/second/third function arg and the return register */
 	[--sp] = r2;
 	[--sp] = r0;
@@ -83,15 +74,6 @@ ENDPROC(_ftrace_caller)
 
 /* See documentation for _ftrace_caller */
 ENTRY(__mcount)
-# ifdef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
-	/* optional micro optimization: return if stopped */
-	p1.l = _function_trace_stop;
-	p1.h = _function_trace_stop;
-	r3 = [p1];
-	cc = r3 == 0;
-	if ! cc jump _ftrace_stub (bp);
-# endif
-
 	/* save third function arg early so we can do testing below */
 	[--sp] = r2;
 
-- 
2.0.1


