Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaEZWOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:14:18 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:50547 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbaEZWOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:14:16 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 04/27] mtd: nand: atmel_nand: show device structure in sysfs
Date: Tue, 27 May 2014 00:12:29 +0200
Message-Id: <1401142372-14148-5-git-send-email-holler@ahsoftware.de>
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
 drivers/mtd/nand/atmel_nand.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index 4ce181a..8056c36 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -1980,6 +1980,7 @@ static int atmel_nand_probe(struct platform_device *pdev)
 	host->io_phys = (dma_addr_t)mem->start;
 
 	mtd = &host->mtd;
+	mtd_setup_common_members(mtd, nand_chip, pdev);
 	nand_chip = &host->nand_chip;
 	host->dev = &pdev->dev;
 	if (IS_ENABLED(CONFIG_OF) && pdev->dev.of_node) {
@@ -1993,8 +1994,6 @@ static int atmel_nand_probe(struct platform_device *pdev)
 	}
 
 	nand_chip->priv = host;		/* link the private data structures */
-	mtd->priv = nand_chip;
-	mtd->owner = THIS_MODULE;
 
 	/* Set address of NAND IO lines */
 	nand_chip->IO_ADDR_R = host->io_base;
@@ -2124,7 +2123,6 @@ static int atmel_nand_probe(struct platform_device *pdev)
 		goto err_scan_tail;
 	}
 
-	mtd->name = "atmel_nand";
 	ppdata.of_node = pdev->dev.of_node;
 	res = mtd_device_parse_register(mtd, NULL, &ppdata,
 			host->board.parts, host->board.num_parts);
-- 
1.8.3.2

