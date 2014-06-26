Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014AbaFZQ7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 12:59:48 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:56063 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757894AbaFZQ64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:58:56 -0400
Message-Id: <20140626165853.685458770@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 26 Jun 2014 12:52:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [RFA][PATCH 26/27] s390/ftrace: remove check of obsolete variable function_trace_stop
References: <20140626165221.736847419@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0026-s390-ftrace-remove-check-of-obsolete-variable-functi.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Remove check of obsolete variable function_trace_stop as requested by
Steven Rostedt.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/s390/Kconfig           |  1 -
 arch/s390/kernel/mcount.S   | 10 +++-------
 arch/s390/kernel/mcount64.S |  3 ---
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index bb63499fc5d3..f5af5f6ef0f4 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -116,7 +116,6 @@ config S390
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_TRACER
-	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_FUTEX_CMPXCHG if FUTEX
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_GZIP
diff --git a/arch/s390/kernel/mcount.S b/arch/s390/kernel/mcount.S
index 08dcf21cb8df..433c6dbfa442 100644
--- a/arch/s390/kernel/mcount.S
+++ b/arch/s390/kernel/mcount.S
@@ -21,13 +21,9 @@ ENTRY(_mcount)
 ENTRY(ftrace_caller)
 #endif
 	stm	%r2,%r5,16(%r15)
-	bras	%r1,2f
+	bras	%r1,1f
 0:	.long	ftrace_trace_function
-1:	.long	function_trace_stop
-2:	l	%r2,1b-0b(%r1)
-	icm	%r2,0xf,0(%r2)
-	jnz	3f
-	st	%r14,56(%r15)
+1:	st	%r14,56(%r15)
 	lr	%r0,%r15
 	ahi	%r15,-96
 	l	%r3,100(%r15)
@@ -50,7 +46,7 @@ ENTRY(ftrace_graph_caller)
 #endif
 	ahi	%r15,96
 	l	%r14,56(%r15)
-3:	lm	%r2,%r5,16(%r15)
+	lm	%r2,%r5,16(%r15)
 	br	%r14
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
diff --git a/arch/s390/kernel/mcount64.S b/arch/s390/kernel/mcount64.S
index 1c52eae3396a..c67a8bf0fd9a 100644
--- a/arch/s390/kernel/mcount64.S
+++ b/arch/s390/kernel/mcount64.S
@@ -20,9 +20,6 @@ ENTRY(_mcount)
 
 ENTRY(ftrace_caller)
 #endif
-	larl	%r1,function_trace_stop
-	icm	%r1,0xf,0(%r1)
-	bnzr	%r14
 	stmg	%r2,%r5,32(%r15)
 	stg	%r14,112(%r15)
 	lgr	%r1,%r15
-- 
2.0.0


