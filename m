Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115AbaFZRDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:03:39 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:25973 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757836AbaFZQ6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:58:53 -0400
Message-Id: <20140626165852.160038235@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 26 Jun 2014 12:52:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [RFA][PATCH 18/27] sparc64,ftrace: Remove check of obsolete variable function_trace_stop
References: <20140626165221.736847419@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0018-sparc64-ftrace-Remove-check-of-obsolete-variable-fun.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Nothing sets function_trace_stop to disable function tracing anymore.
Remove the check for it in the arch code.

[ Please test this on your arch ]

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/sparc/Kconfig      |  1 -
 arch/sparc/lib/mcount.S | 10 ++--------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 29f2e988c56a..abd7d5575a7d 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -55,7 +55,6 @@ config SPARC64
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_GRAPH_FP_TEST
-	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_KRETPROBES
 	select HAVE_KPROBES
 	select HAVE_RCU_TABLE_FREE if SMP
diff --git a/arch/sparc/lib/mcount.S b/arch/sparc/lib/mcount.S
index 3ad6cbdc2163..0b0ed4d34219 100644
--- a/arch/sparc/lib/mcount.S
+++ b/arch/sparc/lib/mcount.S
@@ -24,10 +24,7 @@ mcount:
 #ifdef CONFIG_DYNAMIC_FTRACE
 	/* Do nothing, the retl/nop below is all we need.  */
 #else
-	sethi		%hi(function_trace_stop), %g1
-	lduw		[%g1 + %lo(function_trace_stop)], %g2
-	brnz,pn		%g2, 2f
-	 sethi		%hi(ftrace_trace_function), %g1
+	sethi		%hi(ftrace_trace_function), %g1
 	sethi		%hi(ftrace_stub), %g2
 	ldx		[%g1 + %lo(ftrace_trace_function)], %g1
 	or		%g2, %lo(ftrace_stub), %g2
@@ -80,11 +77,8 @@ ftrace_stub:
 	.globl		ftrace_caller
 	.type		ftrace_caller,#function
 ftrace_caller:
-	sethi		%hi(function_trace_stop), %g1
 	mov		%i7, %g2
-	lduw		[%g1 + %lo(function_trace_stop)], %g1
-	brnz,pn		%g1, ftrace_stub
-	 mov		%fp, %g3
+	mov		%fp, %g3
 	save		%sp, -176, %sp
 	mov		%g2, %o1
 	mov		%g2, %l0
-- 
2.0.0


