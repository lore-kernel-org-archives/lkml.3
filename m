Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbbAAP3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 10:29:10 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44703 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbbAAP3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 10:29:07 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ralf Baechle <ralf@linux-mips.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        John Crispin <blogic@openwrt.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: mips: pci: pci-ip27.c:  Remove unused function
Date: Thu,  1 Jan 2015 16:32:06 +0100
Message-Id: <1420126326-27198-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function pci_enable_swapping() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/mips/pci/pci-ip27.c |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/mips/pci/pci-ip27.c b/arch/mips/pci/pci-ip27.c
index 0f09eaf..55e3332 100644
--- a/arch/mips/pci/pci-ip27.c
+++ b/arch/mips/pci/pci-ip27.c
@@ -200,17 +200,6 @@ static inline void pci_disable_swapping(struct pci_dev *dev)
 	bridge->b_widget.w_tflush;	/* Flush */
 }
 
-static inline void pci_enable_swapping(struct pci_dev *dev)
-{
-	struct bridge_controller *bc = BRIDGE_CONTROLLER(dev->bus);
-	bridge_t *bridge = bc->base;
-	int slot = PCI_SLOT(dev->devfn);
-
-	/* Turn on byte swapping */
-	bridge->b_device[slot].reg |= BRIDGE_DEV_SWAP_DIR;
-	bridge->b_widget.w_tflush;	/* Flush */
-}
-
 static void pci_fixup_ioc3(struct pci_dev *d)
 {
 	pci_disable_swapping(d);
-- 
1.7.10.4

