Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaEZWQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:16:09 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:50920 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaEZWQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:16:06 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 16/27] mtd: nand: lpc32xx_mlc: use mtd_setup_common_members()
Date: Tue, 27 May 2014 00:12:41 +0200
Message-Id: <1401142372-14148-17-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401142372-14148-1-git-send-email-holler@ahsoftware.de>
References: <1401142372-14148-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new common function mtd_setup_common_members()

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/mtd/nand/lpc32xx_mlc.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/mtd/nand/lpc32xx_mlc.c b/drivers/mtd/nand/lpc32xx_mlc.c
index 687478c..4fa7b13 100644
--- a/drivers/mtd/nand/lpc32xx_mlc.c
+++ b/drivers/mtd/nand/lpc32xx_mlc.c
@@ -681,9 +681,7 @@ static int lpc32xx_nand_probe(struct platform_device *pdev)
 	host->pdata = dev_get_platdata(&pdev->dev);
 
 	nand_chip->priv = host;		/* link the private data structures */
-	mtd->priv = nand_chip;
-	mtd->owner = THIS_MODULE;
-	mtd->dev.parent = &pdev->dev;
+	mtd_setup_common_members(mtd, nand_chip, pdev);
 
 	/* Get NAND clock */
 	host->clk = clk_get(&pdev->dev, NULL);
@@ -790,8 +788,6 @@ static int lpc32xx_nand_probe(struct platform_device *pdev)
 		goto err_exit4;
 	}
 
-	mtd->name = DRV_NAME;
-
 	ppdata.of_node = pdev->dev.of_node;
 	res = mtd_device_parse_register(mtd, NULL, &ppdata, host->ncfg->parts,
 					host->ncfg->num_parts);
-- 
1.8.3.2

