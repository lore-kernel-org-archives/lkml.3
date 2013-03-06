Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab3CFLSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 06:18:39 -0500
Received: from www.linutronix.de ([62.245.132.108]:42494 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210Ab3CFLSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 06:18:35 -0500
Message-Id: <20130306111537.304379448@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 06 Mar 2013 11:18:33 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        Arjan van de Veen <arjan@infradead.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Jason Liu <liu.h.jason@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 1/7] tick: Call tick_init late
References: <20130306111351.883117670@linutronix.de>
Content-Disposition: inline; filename=tick-call-init-late.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To convert the clockevents code to cpumask_var_t we need to move the
init call after the allocator setup. 

Clockevents are earliest registered from time_init() as they need
interrupts being set up, so this is safe.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: tip/init/main.c
===================================================================
--- tip.orig/init/main.c
+++ tip/init/main.c
@@ -494,7 +494,6 @@ asmlinkage void __init start_kernel(void
  * Interrupts are still disabled. Do necessary setups, then
  * enable them
  */
-	tick_init();
 	boot_cpu_init();
 	page_address_init();
 	printk(KERN_NOTICE "%s", linux_banner);
@@ -551,6 +550,7 @@ asmlinkage void __init start_kernel(void
 	/* init some links before init_ISA_irqs() */
 	early_irq_init();
 	init_IRQ();
+	tick_init();
 	init_timers();
 	hrtimers_init();
 	softirq_init();


