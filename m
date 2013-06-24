Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab3FXSzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 14:55:52 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:41198 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3FXSzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 14:55:50 -0400
From: Johannes Thumshirn <morbidrsa@gmail.com>
To: dougthompson@xmission.com
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Thumshirn <morbidrsa@gmail.com>
Subject: [PATCH] edac: mpc85xx_edac.c: Remove mpc85xx_pci_err_remove
Date: Mon, 24 Jun 2013 20:59:34 +0200
Message-Id: <1372100374-17726-1-git-send-email-morbidrsa@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove mpc85xx_pci_err_remove(...) which is obsolete, this removes the compiler
warning which can be seen when building the driver either statically or as a
module.

Signed-off-by: Johannes Thumshirn <morbidrsa@gmail.com>
---
 drivers/edac/mpc85xx_edac.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index 3eb32f6..fd46b0b 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -327,28 +327,6 @@ err:
 }
 EXPORT_SYMBOL(mpc85xx_pci_err_probe);
 
-static int mpc85xx_pci_err_remove(struct platform_device *op)
-{
-	struct edac_pci_ctl_info *pci = dev_get_drvdata(&op->dev);
-	struct mpc85xx_pci_pdata *pdata = pci->pvt_info;
-
-	edac_dbg(0, "\n");
-
-	out_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_CAP_DR,
-		 orig_pci_err_cap_dr);
-
-	out_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_EN, orig_pci_err_en);
-
-	edac_pci_del_device(pci->dev);
-
-	if (edac_op_state == EDAC_OPSTATE_INT)
-		irq_dispose_mapping(pdata->irq);
-
-	edac_pci_free_ctl_info(pci);
-
-	return 0;
-}
-
 #endif				/* CONFIG_PCI */
 
 /**************************** L2 Err device ***************************/
-- 
1.8.3.1

