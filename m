Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301Ab3JMFSD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 01:18:03 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56122 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750850Ab3JMFSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 01:18:01 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: dougthompson@xmission.com
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] EDAC: remove deprecated IRQF_DISABLED
Date: Sun, 13 Oct 2013 07:17:57 +0200
Message-Id: <1381641477-7373-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/edac/mpc85xx_edac.c | 7 +++----
 drivers/edac/mv64x60_edac.c | 8 ++++----
 drivers/edac/ppc4xx_edac.c  | 4 ++--
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index 3eb32f6..7785807 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -297,7 +297,7 @@ int mpc85xx_pci_err_probe(struct platform_device *op)
 	if (edac_op_state == EDAC_OPSTATE_INT) {
 		pdata->irq = irq_of_parse_and_map(op->dev.of_node, 0);
 		res = devm_request_irq(&op->dev, pdata->irq,
-				       mpc85xx_pci_isr, IRQF_DISABLED,
+				       mpc85xx_pci_isr, 0,
 				       "[EDAC] PCI err", pci);
 		if (res < 0) {
 			printk(KERN_ERR
@@ -579,7 +579,7 @@ static int mpc85xx_l2_err_probe(struct platform_device *op)
 	if (edac_op_state == EDAC_OPSTATE_INT) {
 		pdata->irq = irq_of_parse_and_map(op->dev.of_node, 0);
 		res = devm_request_irq(&op->dev, pdata->irq,
-				       mpc85xx_l2_isr, IRQF_DISABLED,
+				       mpc85xx_l2_isr, 0,
 				       "[EDAC] L2 err", edac_dev);
 		if (res < 0) {
 			printk(KERN_ERR
@@ -1078,8 +1078,7 @@ static int mpc85xx_mc_err_probe(struct platform_device *op)
 		/* register interrupts */
 		pdata->irq = irq_of_parse_and_map(op->dev.of_node, 0);
 		res = devm_request_irq(&op->dev, pdata->irq,
-				       mpc85xx_mc_isr,
-					IRQF_DISABLED | IRQF_SHARED,
+				       mpc85xx_mc_isr, IRQF_SHARED,
 				       "[EDAC] MC err", mci);
 		if (res < 0) {
 			printk(KERN_ERR "%s: Unable to request irq %d for "
diff --git a/drivers/edac/mv64x60_edac.c b/drivers/edac/mv64x60_edac.c
index 542fad7..6366e88 100644
--- a/drivers/edac/mv64x60_edac.c
+++ b/drivers/edac/mv64x60_edac.c
@@ -178,7 +178,7 @@ static int mv64x60_pci_err_probe(struct platform_device *pdev)
 		res = devm_request_irq(&pdev->dev,
 				       pdata->irq,
 				       mv64x60_pci_isr,
-				       IRQF_DISABLED,
+				       0,
 				       "[EDAC] PCI err",
 				       pci);
 		if (res < 0) {
@@ -345,7 +345,7 @@ static int mv64x60_sram_err_probe(struct platform_device *pdev)
 		res = devm_request_irq(&pdev->dev,
 				       pdata->irq,
 				       mv64x60_sram_isr,
-				       IRQF_DISABLED,
+				       0,
 				       "[EDAC] SRAM err",
 				       edac_dev);
 		if (res < 0) {
@@ -540,7 +540,7 @@ static int mv64x60_cpu_err_probe(struct platform_device *pdev)
 		res = devm_request_irq(&pdev->dev,
 				       pdata->irq,
 				       mv64x60_cpu_isr,
-				       IRQF_DISABLED,
+				       0,
 				       "[EDAC] CPU err",
 				       edac_dev);
 		if (res < 0) {
@@ -800,7 +800,7 @@ static int mv64x60_mc_err_probe(struct platform_device *pdev)
 		res = devm_request_irq(&pdev->dev,
 				       pdata->irq,
 				       mv64x60_mc_isr,
-				       IRQF_DISABLED,
+				       0,
 				       "[EDAC] MC err",
 				       mci);
 		if (res < 0) {
diff --git a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
index ef6b7e0..7023944 100644
--- a/drivers/edac/ppc4xx_edac.c
+++ b/drivers/edac/ppc4xx_edac.c
@@ -1120,7 +1120,7 @@ static int ppc4xx_edac_register_irq(struct platform_device *op,
 
 	status = request_irq(ded_irq,
 			     ppc4xx_edac_isr,
-			     IRQF_DISABLED,
+			     0,
 			     "[EDAC] MC ECCDED",
 			     mci);
 
@@ -1134,7 +1134,7 @@ static int ppc4xx_edac_register_irq(struct platform_device *op,
 
 	status = request_irq(sec_irq,
 			     ppc4xx_edac_isr,
-			     IRQF_DISABLED,
+			     0,
 			     "[EDAC] MC ECCSEC",
 			     mci);
 
-- 
1.8.1.2

