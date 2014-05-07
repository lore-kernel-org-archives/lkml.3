Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934160AbaEGP4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:56:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:48505 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165AbaEGPnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:43:52 -0400
Message-Id: <20140507154334.008113902@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:05 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Jayachandran C <jchandra@broadcom.com>
Subject: [patch 02/32] mips: Kill pointless destroy_irq() 
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline; filename=mips-kill-pointless-destroy-irq.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copy and paste leftovers with no functionality at all.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Jayachandran C <jchandra@broadcom.com>
Cc: linux-mips@linux-mips.org
---
 arch/mips/pci/msi-xlp.c |   10 +---------
 arch/mips/pci/pci-xlr.c |   10 +---------
 2 files changed, 2 insertions(+), 18 deletions(-)

Index: tip/arch/mips/pci/msi-xlp.c
===================================================================
--- tip.orig/arch/mips/pci/msi-xlp.c
+++ tip/arch/mips/pci/msi-xlp.c
@@ -206,14 +206,8 @@ static struct irq_chip xlp_msix_chip = {
 	.irq_unmask	= unmask_msi_irq,
 };
 
-void destroy_irq(unsigned int irq)
-{
-	    /* nothing to do yet */
-}
-
 void arch_teardown_msi_irq(unsigned int irq)
 {
-	destroy_irq(irq);
 }
 
 /*
@@ -298,10 +292,8 @@ static int xlp_setup_msi(uint64_t lnkbas
 
 	xirq = xirq + msivec;		/* msi mapped to global irq space */
 	ret = irq_set_msi_desc(xirq, desc);
-	if (ret < 0) {
-		destroy_irq(xirq);
+	if (ret < 0)
 		return ret;
-	}
 
 	write_msi_msg(xirq, &msg);
 	return 0;
Index: tip/arch/mips/pci/pci-xlr.c
===================================================================
--- tip.orig/arch/mips/pci/pci-xlr.c
+++ tip/arch/mips/pci/pci-xlr.c
@@ -214,14 +214,8 @@ static int get_irq_vector(const struct p
 }
 
 #ifdef CONFIG_PCI_MSI
-void destroy_irq(unsigned int irq)
-{
-	    /* nothing to do yet */
-}
-
 void arch_teardown_msi_irq(unsigned int irq)
 {
-	destroy_irq(irq);
 }
 
 int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
@@ -263,10 +257,8 @@ int arch_setup_msi_irq(struct pci_dev *d
 		MSI_DATA_DELIVERY_FIXED;
 
 	ret = irq_set_msi_desc(irq, desc);
-	if (ret < 0) {
-		destroy_irq(irq);
+	if (ret < 0)
 		return ret;
-	}
 
 	write_msi_msg(irq, &msg);
 	return 0;


