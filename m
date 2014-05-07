Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933705AbaEGPsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:48:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:48626 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756870AbaEGPoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:44:03 -0400
Message-Id: <20140507154338.967285614@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:18 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 23/32] x86, irq: Remove pointless irq_reserve_irqs() call
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline;
 filename=x86-remove-pointless-reserve-irq-call.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's a leftover from the time where x86 supported SPARSE_IRQ=n.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
---
 arch/x86/kernel/apic/io_apic.c |    3 ---
 1 file changed, 3 deletions(-)

Index: tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/io_apic.c
+++ tip/arch/x86/kernel/apic/io_apic.c
@@ -206,9 +206,6 @@ int __init arch_early_irq_init(void)
 	count = ARRAY_SIZE(irq_cfgx);
 	node = cpu_to_node(0);
 
-	/* Make sure the legacy interrupts are marked in the bitmap */
-	irq_reserve_irqs(0, legacy_pic->nr_legacy_irqs);
-
 	for (i = 0; i < count; i++) {
 		irq_set_chip_data(i, &cfg[i]);
 		zalloc_cpumask_var_node(&cfg[i].domain, GFP_KERNEL, node);


