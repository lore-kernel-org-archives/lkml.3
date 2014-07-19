Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965803AbaGSNRD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 09:17:03 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:62021 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755494AbaGSNQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 09:16:16 -0400
Message-Id: <20140719131613.241421466@goodmis.org>
User-Agent: quilt/0.63-1
Date: Sat, 19 Jul 2014 09:15:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <james.hogan@imgtec.com>
Subject: [for-next][PATCH 22/32] MIPS: ftrace: Remove check of obsolete variable function_trace_stop
References: <20140719131524.009152325@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0022-MIPS-ftrace-Remove-check-of-obsolete-variable-functi.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Nothing sets function_trace_stop to disable function tracing anymore.
Remove the check for it in the arch code.

Cc: Ralf Baechle <ralf@linux-mips.org>
Tested-by: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/mips/Kconfig         | 1 -
 arch/mips/kernel/mcount.S | 7 -------
 2 files changed, 8 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 4e238e6e661c..10f270bd3e25 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -15,7 +15,6 @@ config MIPS
 	select HAVE_BPF_JIT if !CPU_MICROMIPS
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select HAVE_FUNCTION_TRACER
-	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_C_RECORDMCOUNT
diff --git a/arch/mips/kernel/mcount.S b/arch/mips/kernel/mcount.S
index 539b6294b613..00940d1d5c4f 100644
--- a/arch/mips/kernel/mcount.S
+++ b/arch/mips/kernel/mcount.S
@@ -74,10 +74,6 @@ _mcount:
 #endif
 
 	/* When tracing is activated, it calls ftrace_caller+8 (aka here) */
-	lw	t1, function_trace_stop
-	bnez	t1, ftrace_stub
-	 nop
-
 	MCOUNT_SAVE_REGS
 #ifdef KBUILD_MCOUNT_RA_ADDRESS
 	PTR_S	MCOUNT_RA_ADDRESS_REG, PT_R12(sp)
@@ -105,9 +101,6 @@ ftrace_stub:
 #else	/* ! CONFIG_DYNAMIC_FTRACE */
 
 NESTED(_mcount, PT_SIZE, ra)
-	lw	t1, function_trace_stop
-	bnez	t1, ftrace_stub
-	 nop
 	PTR_LA	t1, ftrace_stub
 	PTR_L	t2, ftrace_trace_function /* Prepare t2 for (1) */
 	bne	t1, t2, static_trace
-- 
2.0.1


