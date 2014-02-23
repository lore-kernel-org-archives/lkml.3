Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbaBWVlX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 16:41:23 -0500
Received: from www.linutronix.de ([62.245.132.108]:52374 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbaBWVkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 16:40:19 -0500
Message-Id: <20140223212736.987803648@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Feb 2014 21:40:11 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Jingoo Han <jg1.han@samsung.com>,
        Mohit Kumar <mohit.kumar@st.com>, pci <linux-pci@vger.kernel.org>
Subject: [patch 07/26] pci: pcie-designware: Remove irq_desc abuse
References: <20140223212703.511977310@linutronix.de>
Content-Disposition: inline;
 filename=pci-pcie-designware-remove-irq-desc-abuse.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason to care about irq_desc in that context, escpecially
as irq_data for that interrupt is retrieved as well.

Use the proper accessor for the msi descriptor

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Mohit Kumar <mohit.kumar@st.com>
Cc: pci <linux-pci@vger.kernel.org>
---
 drivers/pci/host/pcie-designware.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: tip/drivers/pci/host/pcie-designware.c
===================================================================
--- tip.orig/drivers/pci/host/pcie-designware.c
+++ tip/drivers/pci/host/pcie-designware.c
@@ -294,14 +294,12 @@ no_valid_irq:
 static void clear_irq(unsigned int irq)
 {
 	unsigned int pos, nvec;
-	struct irq_desc *desc;
 	struct msi_desc *msi;
 	struct pcie_port *pp;
 	struct irq_data *data = irq_get_irq_data(irq);
 
 	/* get the port structure */
-	desc = irq_to_desc(irq);
-	msi = irq_desc_get_msi_desc(desc);
+	msi = irq_data_get_msi(data);
 	pp = sys_to_pcie(msi->dev->bus->sysdata);
 	if (!pp) {
 		BUG();


