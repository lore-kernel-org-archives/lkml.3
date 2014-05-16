Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbaEPNdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:33:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54066 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbaEPNdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:33:02 -0400
Date: Fri, 16 May 2014 06:31:35 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-465665f78a7f47d46d7fe18195f3548b4911547f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tony.luck@intel.com,
        jchandra@broadcom.com, ralf@linux-mips.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        tony.luck@intel.com, jchandra@broadcom.com, ralf@linux-mips.org,
        tglx@linutronix.de
In-Reply-To: <20140507154334.008113902@linutronix.de>
References: <20140507154334.008113902@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] mips: Kill pointless destroy_irq()
Git-Commit-ID: 465665f78a7f47d46d7fe18195f3548b4911547f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  465665f78a7f47d46d7fe18195f3548b4911547f
Gitweb:     http://git.kernel.org/tip/465665f78a7f47d46d7fe18195f3548b4911547f
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:05 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:18 +0200

mips: Kill pointless destroy_irq()

Copy and paste leftovers with no functionality at all.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Jayachandran C <jchandra@broadcom.com>
Cc: linux-mips@linux-mips.org
Link: http://lkml.kernel.org/r/20140507154334.008113902@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/mips/pci/msi-xlp.c | 10 +---------
 arch/mips/pci/pci-xlr.c | 10 +---------
 2 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/arch/mips/pci/msi-xlp.c b/arch/mips/pci/msi-xlp.c
index afd8405..3249685 100644
--- a/arch/mips/pci/msi-xlp.c
+++ b/arch/mips/pci/msi-xlp.c
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
@@ -298,10 +292,8 @@ static int xlp_setup_msi(uint64_t lnkbase, int node, int link,
 
 	xirq = xirq + msivec;		/* msi mapped to global irq space */
 	ret = irq_set_msi_desc(xirq, desc);
-	if (ret < 0) {
-		destroy_irq(xirq);
+	if (ret < 0)
 		return ret;
-	}
 
 	write_msi_msg(xirq, &msg);
 	return 0;
diff --git a/arch/mips/pci/pci-xlr.c b/arch/mips/pci/pci-xlr.c
index 4427abb..0dde803 100644
--- a/arch/mips/pci/pci-xlr.c
+++ b/arch/mips/pci/pci-xlr.c
@@ -214,14 +214,8 @@ static int get_irq_vector(const struct pci_dev *dev)
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
@@ -263,10 +257,8 @@ int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
 		MSI_DATA_DELIVERY_FIXED;
 
 	ret = irq_set_msi_desc(irq, desc);
-	if (ret < 0) {
-		destroy_irq(irq);
+	if (ret < 0)
 		return ret;
-	}
 
 	write_msi_msg(irq, &msg);
 	return 0;
