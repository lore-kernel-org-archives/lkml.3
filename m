Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab3CUVx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:53:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:33314 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab3CUVx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:26 -0400
Message-Id: <20130321215235.546600507@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:53:24 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>, Chris Zankel <chris@zankel.net>
Subject: [patch 34/34] xtensa: Use generic idle loop
References: <20130321214930.752934102@linutronix.de>
Content-Disposition: inline; filename=xtensa-use-generic-idle-loop.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately this arch does not compile at all :(

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Zankel <chris@zankel.net>
---
 arch/xtensa/Kconfig          |    1 +
 arch/xtensa/kernel/process.c |   14 ++------------
 2 files changed, 3 insertions(+), 12 deletions(-)

Index: linux-2.6/arch/xtensa/Kconfig
===================================================================
--- linux-2.6.orig/arch/xtensa/Kconfig
+++ linux-2.6/arch/xtensa/Kconfig
@@ -19,6 +19,7 @@ config XTENSA
 	select CLONE_BACKWARDS
 	select IRQ_DOMAIN
 	select HAVE_OPROFILE
+	select GENERIC_IDLE_LOOP
 	help
 	  Xtensa processors are 32-bit RISC machines designed by Tensilica
 	  primarily for embedded systems.  These processors are both
Index: linux-2.6/arch/xtensa/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/xtensa/kernel/process.c
+++ linux-2.6/arch/xtensa/kernel/process.c
@@ -105,19 +105,9 @@ void coprocessor_flush_all(struct thread
 /*
  * Powermanagement idle function, if any is provided by the platform.
  */
-
-void cpu_idle(void)
+void arch_cpu_idle(void)
 {
-	local_irq_enable();
-
-	/* endless idle loop with no priority at all */
-	while (1) {
-		rcu_idle_enter();
-		while (!need_resched())
-			platform_idle();
-		rcu_idle_exit();
-		schedule_preempt_disabled();
-	}
+	platform_idle();
 }
 
 /*


