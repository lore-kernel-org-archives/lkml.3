Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbaHQRfl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 13:35:41 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:36161 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379AbaHQRbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 13:31:23 -0400
Message-Id: <20140817173036.021525676@linux.com>
Date: Sun, 17 Aug 2014 12:30:43 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <david.daney@cavium.com>
Subject: [PATCH 20/35] [PATCH 20/36] MIPS: Replace __get_cpu_var uses in FPU emulator.
References: <20140817173023.439660246@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0020-MIPS-Replace-__get_cpu_var-uses-in-FPU-emulator.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of __this_cpu_inc() requires a fundamental integer type, so
change the type of all the counters to unsigned long, which is the
same width they were before, but not wrapped in local_t.

Signed-off-by: David Daney <david.daney@cavium.com>
Signed-off-by: Christoph Lameter <cl@linux.com>
---
 arch/mips/include/asm/fpu_emulator.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

Index: linux/arch/mips/include/asm/fpu_emulator.h
===================================================================
--- linux.orig/arch/mips/include/asm/fpu_emulator.h
+++ linux/arch/mips/include/asm/fpu_emulator.h
@@ -33,17 +33,17 @@
 #ifdef CONFIG_DEBUG_FS
 
 struct mips_fpu_emulator_stats {
-	local_t emulated;
-	local_t loads;
-	local_t stores;
-	local_t cp1ops;
-	local_t cp1xops;
-	local_t errors;
-	local_t ieee754_inexact;
-	local_t ieee754_underflow;
-	local_t ieee754_overflow;
-	local_t ieee754_zerodiv;
-	local_t ieee754_invalidop;
+	unsigned long emulated;
+	unsigned long loads;
+	unsigned long stores;
+	unsigned long cp1ops;
+	unsigned long cp1xops;
+	unsigned long errors;
+	unsigned long ieee754_inexact;
+	unsigned long ieee754_underflow;
+	unsigned long ieee754_overflow;
+	unsigned long ieee754_zerodiv;
+	unsigned long ieee754_invalidop;
 };
 
 DECLARE_PER_CPU(struct mips_fpu_emulator_stats, fpuemustats);
@@ -51,7 +51,7 @@ DECLARE_PER_CPU(struct mips_fpu_emulator
 #define MIPS_FPU_EMU_INC_STATS(M)					\
 do {									\
 	preempt_disable();						\
-	__local_inc(&__get_cpu_var(fpuemustats).M);			\
+	__this_cpu_inc(fpuemustats.M);					\
 	preempt_enable();						\
 } while (0)
 

