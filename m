Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab3JGPP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 11:15:57 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:62206 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab3JGPPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 11:15:54 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Doug Thompson <dougthompson@xmission.com>
Cc: Borislav Petkov <bp@suse.de>, Baruch Siach <baruch@tkos.co.il>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mpc85xx_edac: Remove unused function
Date: Mon,  7 Oct 2013 17:13:55 +0200
Message-Id: <1381158835-10804-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 905e75c (powerpc/fsl-pci: Unify pci/pcie initialization code)
removed the struct platform_driver that held the last reference to the
mpc85xx_pci_err_remove() function. Remove the function since it is
effectively dead code.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/edac/mpc85xx_edac.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index 3eb32f6..b1e7106 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -326,29 +326,6 @@ err:
 	return res;
 }
 EXPORT_SYMBOL(mpc85xx_pci_err_probe);
-
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
1.8.4

