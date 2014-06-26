Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448AbaFZRAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:00:54 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:58678 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757875AbaFZQ6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:58:55 -0400
Message-Id: <20140626165853.211937817@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 26 Jun 2014 12:52:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>,
        Mike Frysinger <vapier@gentoo.org>
Subject: [RFA][PATCH 24/27] Blackfin: ftrace: Remove check of obsolete variable
 function_trace_stop
References: <20140626165221.736847419@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0024-Blackfin-ftrace-Remove-check-of-obsolete-variable-fu.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Nothing sets function_trace_stop to disable function tracing anymore.
Remove the check for it in the arch code.

[ Please test this on your arch ]

Cc: Mike Frysinger <vapier@gentoo.org>
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
2.0.0


