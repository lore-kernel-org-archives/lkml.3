Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933628AbaEGPzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:55:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:48508 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699AbaEGPnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:43:53 -0400
Message-Id: <20140507154334.991589924@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:07 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 06/32] x86: hpet: Use irq_alloc/free_hwirq()
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline; filename=x86-hpet-use-irq-alloc-free-hwirq.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new interfaces. No functional change.

This does not replace the requirement to move x86 to irq domains, but
it limits the mess to some degree.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
---
 arch/x86/kernel/hpet.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: tip/arch/x86/kernel/hpet.c
===================================================================
--- tip.orig/arch/x86/kernel/hpet.c
+++ tip/arch/x86/kernel/hpet.c
@@ -479,7 +479,7 @@ static int hpet_msi_next_event(unsigned
 static int hpet_setup_msi_irq(unsigned int irq)
 {
 	if (x86_msi.setup_hpet_msi(irq, hpet_blockid)) {
-		destroy_irq(irq);
+		irq_free_hwirq(irq);
 		return -EINVAL;
 	}
 	return 0;
@@ -487,9 +487,8 @@ static int hpet_setup_msi_irq(unsigned i
 
 static int hpet_assign_irq(struct hpet_dev *dev)
 {
-	unsigned int irq;
+	unsigned int irq = irq_alloc_hwirq(-1);
 
-	irq = create_irq_nr(0, -1);
 	if (!irq)
 		return -EINVAL;
 


