Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbaBWVmK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 16:42:10 -0500
Received: from www.linutronix.de ([62.245.132.108]:52350 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbaBWVkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 16:40:14 -0500
Message-Id: <20140223212737.635609567@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Feb 2014 21:40:15 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        sparc <sparclinux@vger.kernel.org>
Subject: [patch 13/26] sparc: Use the core irq stats function
References: <20140223212703.511977310@linutronix.de>
Content-Disposition: inline; filename=sparc-use-core-irq-stats-function.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the core do the irq_desc resolution.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: sparc <sparclinux@vger.kernel.org>
---
 arch/sparc/kernel/time_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: tip/arch/sparc/kernel/time_64.c
===================================================================
--- tip.orig/arch/sparc/kernel/time_64.c
+++ tip/arch/sparc/kernel/time_64.c
@@ -733,7 +733,7 @@ void __irq_entry timer_interrupt(int irq
 	irq_enter();
 
 	local_cpu_data().irq0_irqs++;
-	kstat_incr_irqs_this_cpu(0, irq_to_desc(0));
+	kstat_incr_irq_this_cpu(0);
 
 	if (unlikely(!evt->event_handler)) {
 		printk(KERN_WARNING


