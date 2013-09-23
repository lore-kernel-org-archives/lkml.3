Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab3IWPWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 11:22:32 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.164]:10770 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753191Ab3IWPV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 11:21:56 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-6.tower-38.messagelabs.com!1379949713!9660351!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.12; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Mon, 23 Sep 2013 17:21:53 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: <linux-edac@vger.kernel.org>
CC: Borislav Petkov <bp@alien8.de>, Dave Jiang <dave.jiang@gmail.com>,
        Doug Thompson <dougthompson@xmission.com>,
        Chunhe Lan <Chunhe.Lan@freescale.com>, <linux-kernel@vger.kernel.org>,
        Johannes Thumshirn <morbidrsa@gmail.com>,
        Johannes Thumshirn <johannes.thumshirn@men.de>
Subject: [PATCH 3/3] edac/85xx: Remove mpc85xx_pci_err_remove
Date: Mon, 23 Sep 2013 17:23:29 +0200
Message-ID: <1379949809-11083-4-git-send-email-johannes.thumshirn@men.de>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379949809-11083-1-git-send-email-johannes.thumshirn@men.de>
References: <1379949809-11083-1-git-send-email-johannes.thumshirn@men.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.1.1.31]
X-OriginalArrivalTime: 23 Sep 2013 15:21:52.0928 (UTC) FILETIME=[A1B6C200:01CEB870]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Thumshirn <morbidrsa@gmail.com>

Remove mpc85xx_pci_err_remove(...) which is obsolete, this removes the compiler
warning which can be seen when building the driver either statically or as a
module.

Signed-off-by: Johannes Thumshirn <morbidrsa@gmail.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
---
 drivers/edac/mpc85xx_edac.c |   22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index 8df5f4d..8f91821 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -403,28 +403,6 @@ err:
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
1.7.9.5

