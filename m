Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab3CUVzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:55:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:33257 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358Ab3CUVxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:20 -0400
Message-Id: <20130321215235.147909863@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:53:19 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: [patch 28/34] score: Use generic idle loop
References: <20130321214930.752934102@linutronix.de>
Content-Disposition: inline; filename=score-use-generic-idle-loop.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Lennox Wu <lennox.wu@gmail.com>
---
 arch/score/Kconfig          |    1 +
 arch/score/kernel/process.c |   18 ------------------
 2 files changed, 1 insertion(+), 18 deletions(-)

Index: linux-2.6/arch/score/Kconfig
===================================================================
--- linux-2.6.orig/arch/score/Kconfig
+++ linux-2.6/arch/score/Kconfig
@@ -11,6 +11,7 @@ config SCORE
        select ARCH_DISCARD_MEMBLOCK
        select GENERIC_CPU_DEVICES
        select GENERIC_CLOCKEVENTS
+       select GENERIC_IDLE_LOOP
        select HAVE_MOD_ARCH_SPECIFIC
 	select VIRT_TO_BUS
 	select MODULES_USE_ELF_REL
Index: linux-2.6/arch/score/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/score/kernel/process.c
+++ linux-2.6/arch/score/kernel/process.c
@@ -41,24 +41,6 @@ void machine_halt(void) {}
 /* If or when software machine-power-off is implemented, add code here. */
 void machine_power_off(void) {}
 
-/*
- * The idle thread. There's no useful work to be
- * done, so just try to conserve power and have a
- * low exit latency (ie sit in a loop waiting for
- * somebody to say that they'd like to reschedule)
- */
-void __noreturn cpu_idle(void)
-{
-	/* endless idle loop with no priority at all */
-	while (1) {
-		rcu_idle_enter();
-		while (!need_resched())
-			barrier();
-		rcu_idle_exit();
-		schedule_preempt_disabled();
-	}
-}
-
 void ret_from_fork(void);
 void ret_from_kernel_thread(void);
 


