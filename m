Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965693AbaGSNRA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 09:17:00 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:10810 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755481AbaGSNQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 09:16:15 -0400
Message-Id: <20140719131613.055515975@goodmis.org>
User-Agent: quilt/0.63-1
Date: Sat, 19 Jul 2014 09:15:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>
Subject: [for-next][PATCH 21/32] parisc: ftrace: Remove check of obsolete variable function_trace_stop
References: <20140719131524.009152325@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0021-parisc-ftrace-Remove-check-of-obsolete-variable-func.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Nothing sets function_trace_stop to disable function tracing anymore.
Remove the check for it in the arch code.

Link: http://lkml.kernel.org/r/53B08317.7010501@gmx.de

Cc: Kyle McMartin <kyle@mcmartin.ca>
Acked-by: Helge Deller <deller@gmx.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/parisc/Kconfig         | 1 -
 arch/parisc/kernel/ftrace.c | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 108d48e652af..6e75e2030927 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -6,7 +6,6 @@ config PARISC
 	select HAVE_OPROFILE
 	select HAVE_FUNCTION_TRACER if 64BIT
 	select HAVE_FUNCTION_GRAPH_TRACER if 64BIT
-	select HAVE_FUNCTION_TRACE_MCOUNT_TEST if 64BIT
 	select ARCH_WANT_FRAME_POINTERS
 	select RTC_CLASS
 	select RTC_DRV_GENERIC
diff --git a/arch/parisc/kernel/ftrace.c b/arch/parisc/kernel/ftrace.c
index 5512ab32c5e0..559d400f9385 100644
--- a/arch/parisc/kernel/ftrace.c
+++ b/arch/parisc/kernel/ftrace.c
@@ -155,9 +155,6 @@ void ftrace_function_trampoline(unsigned long parent,
 {
 	extern ftrace_func_t ftrace_trace_function;
 
-	if (function_trace_stop)
-		return;
-
 	if (ftrace_trace_function != ftrace_stub) {
 		ftrace_trace_function(parent, self_addr);
 		return;
-- 
2.0.1


