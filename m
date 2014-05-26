Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaEZWQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:16:16 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:50944 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbaEZWQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:16:12 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 17/27] mtd: nand: lpc32xx_slc: use mtd_setup_common_members()
Date: Tue, 27 May 2014 00:12:42 +0200
Message-Id: <1401142372-14148-18-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401142372-14148-1-git-send-email-holler@ahsoftware.de>
References: <1401142372-14148-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new common function mtd_setup_common_members()

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/mtd/nand/lpc32xx_slc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/lpc32xx_slc.c b/drivers/mtd/nand/lpc32xx_slc.c
index 53a6742..c8fb46b 100644
--- a/drivers/mtd/nand/lpc32xx_slc.c
+++ b/drivers/mtd/nand/lpc32xx_slc.c
@@ -799,9 +799,7 @@ static int lpc32xx_nand_probe(struct platform_device *pdev)
 	mtd = &host->mtd;
 	chip = &host->nand_chip;
 	chip->priv = host;
-	mtd->priv = chip;
-	mtd->owner = THIS_MODULE;
-	mtd->dev.parent = &pdev->dev;
+	mtd_setup_common_members(mtd, chip, pdev);
 
 	/* Get NAND clock */
 	host->clk = devm_clk_get(&pdev->dev, NULL);
-- 
1.8.3.2

