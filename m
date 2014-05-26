Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbaEZWQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:16:37 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:51017 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbaEZWQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:16:32 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 20/27] mtd: nand: fsl_elbc: show device structure in sysfs
Date: Tue, 27 May 2014 00:12:45 +0200
Message-Id: <1401142372-14148-21-git-send-email-holler@ahsoftware.de>
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
 drivers/mtd/nand/fsl_elbc_nand.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/fsl_elbc_nand.c b/drivers/mtd/nand/fsl_elbc_nand.c
index ec549cd..dd2df90 100644
--- a/drivers/mtd/nand/fsl_elbc_nand.c
+++ b/drivers/mtd/nand/fsl_elbc_nand.c
@@ -732,10 +732,6 @@ static int fsl_elbc_chip_init(struct fsl_elbc_mtd *priv)
 
 	dev_dbg(priv->dev, "eLBC Set Information for bank %d\n", priv->bank);
 
-	/* Fill in fsl_elbc_mtd structure */
-	priv->mtd.priv = chip;
-	priv->mtd.owner = THIS_MODULE;
-
 	/* set timeout to maximum */
 	priv->fmr = 15 << FMR_CWTO_SHIFT;
 	if (in_be32(&lbc->bank[priv->bank].or) & OR_FCM_PGS)
@@ -873,6 +869,7 @@ static int fsl_elbc_nand_probe(struct platform_device *pdev)
 		goto err;
 	}
 
+	mtd_setup_common_members(&priv->mtd, &priv->chip, pdev);
 	priv->mtd.name = kasprintf(GFP_KERNEL, "%llx.flash", (u64)res.start);
 	if (!priv->mtd.name) {
 		ret = -ENOMEM;
-- 
1.8.3.2

