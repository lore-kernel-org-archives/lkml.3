Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933648AbaEGPq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:46:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:48650 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895AbaEGPoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:44:04 -0400
Message-Id: <20140507154339.189047829@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:18 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Simon Horman <horms@verge.net.au>
Subject: [patch 24/32] sh: intc: Remove pointless irq_reserve_irqs() invocation
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline;
 filename=sh-remove-pointless-reserve-irq-call.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The preceding call to irq_create_identity_mapping() marks the
interrupt as allocated already. Remove the leftover.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-sh@vger.kernel.org
Cc: Simon Horman <horms@verge.net.au>
---
 drivers/sh/intc/core.c |    6 ------
 1 file changed, 6 deletions(-)

Index: tip/drivers/sh/intc/core.c
===================================================================
--- tip.orig/drivers/sh/intc/core.c
+++ tip/drivers/sh/intc/core.c
@@ -80,12 +80,6 @@ static void __init intc_register_irq(str
 	unsigned int data[2], primary;
 	unsigned long flags;
 
-	/*
-	 * Register the IRQ position with the global IRQ map, then insert
-	 * it in to the radix tree.
-	 */
-	irq_reserve_irq(irq);
-
 	raw_spin_lock_irqsave(&intc_big_lock, flags);
 	radix_tree_insert(&d->tree, enum_id, intc_irq_xlate_get(irq));
 	raw_spin_unlock_irqrestore(&intc_big_lock, flags);


