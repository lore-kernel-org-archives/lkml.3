Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbaEZWQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:16:50 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:51062 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbaEZWQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:16:46 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 22/27] mtd: nand: fsl_ifc: show device structure in sysfs
Date: Tue, 27 May 2014 00:12:47 +0200
Message-Id: <1401142372-14148-23-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401142372-14148-1-git-send-email-holler@ahsoftware.de>
References: <1401142372-14148-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a common error in nand-drivers which do not set up a parent device for
the mtd-device by using a new inline function.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/mtd/nand/fsl_ifc_nand.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/fsl_ifc_nand.c b/drivers/mtd/nand/fsl_ifc_nand.c
index cb45d2f..c1aaccb 100644
--- a/drivers/mtd/nand/fsl_ifc_nand.c
+++ b/drivers/mtd/nand/fsl_ifc_nand.c
@@ -874,10 +874,6 @@ static int fsl_ifc_chip_init(struct fsl_ifc_mtd *priv)
 	struct nand_ecclayout *layout;
 	u32 csor, ver;
 
-	/* Fill in fsl_ifc_mtd structure */
-	priv->mtd.priv = chip;
-	priv->mtd.owner = THIS_MODULE;
-
 	/* fill in nand_chip structure */
 	/* set up function call table */
 	if ((ioread32be(&ifc->cspr_cs[priv->bank].cspr)) & CSPR_PORT_SIZE_16)
@@ -1099,6 +1095,7 @@ static int fsl_ifc_nand_probe(struct platform_device *dev)
 		    IFC_NAND_EVTER_INTR_FTOERIR_EN |
 		    IFC_NAND_EVTER_INTR_WPERIR_EN,
 		    &ifc->ifc_nand.nand_evter_intr_en);
+	mtd_setup_common_members(&priv->mtd, &priv->chip, dev);
 	priv->mtd.name = kasprintf(GFP_KERNEL, "%llx.flash", (u64)res.start);
 	if (!priv->mtd.name) {
 		ret = -ENOMEM;
-- 
1.8.3.2

