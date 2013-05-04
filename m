Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761958Ab3EDRxN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 13:53:13 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:53759 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761796Ab3EDRxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 13:53:11 -0400
Date: Sat, 4 May 2013 12:55:12 -0400
From: jake.champlin.27@gmail.com
To: gregkh@linuxfoundation.org, yunhong.jiang@intel.com, sheng@linux.intel.com,
        mikechan@google.com, xiaohui.xin@intel.com
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH] Staging: Goldfish: goldfish_nand: Fixed all checkpatch errors
Message-ID: <20130504165508.GA21935@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 37830ddd9548d298c0c846cd36181cdb97ceebd7 Mon Sep 17 00:00:00 2001
From: Jake Champlin <jake.champlin.27@gmail.com>
Date: Sat, 4 May 2013 12:50:27 -0400
Subject: [PATCH] Staging: Goldfish: goldfish_nand: Fixed all checkpatch errors

Fixed all checkpatch errors included inside goldfish_nand.c.
Checkpatch is now clean for goldfish_nand.c

Signed-off-by: "Jake Champlin" <jake.champlin.27@gmail.com>
---
 drivers/staging/goldfish/goldfish_nand.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/goldfish/goldfish_nand.c b/drivers/staging/goldfish/goldfish_nand.c
index ab1f019..81e2ad4 100644
--- a/drivers/staging/goldfish/goldfish_nand.c
+++ b/drivers/staging/goldfish/goldfish_nand.c
@@ -326,9 +326,10 @@ static int goldfish_nand_init_device(struct platform_device *pdev,
 			(mtd->writesize + mtd->oobsize) * mtd->writesize;
 	do_div(mtd->size, mtd->writesize + mtd->oobsize);
 	mtd->size *= mtd->writesize;
-	dev_dbg(&pdev->dev, 
+	dev_dbg(&pdev->dev,
 		"goldfish nand dev%d: size %llx, page %d, extra %d, erase %d\n",
-		       id, mtd->size, mtd->writesize, mtd->oobsize, mtd->erasesize);
+		       id, mtd->size, mtd->writesize,
+		       mtd->oobsize, mtd->erasesize);
 	spin_unlock_irqrestore(&nand->lock, irq_flags);
 
 	mtd->priv = nand;
@@ -340,7 +341,7 @@ static int goldfish_nand_init_device(struct platform_device *pdev,
 	result = goldfish_nand_cmd(mtd, NAND_CMD_GET_DEV_NAME, 0, name_len,
 									name);
 	if (result != name_len) {
-		dev_err(&pdev->dev, 
+		dev_err(&pdev->dev,
 			"goldfish_nand_init_device failed to get dev name %d != %d\n",
 			       result, name_len);
 		return -ENODEV;
@@ -391,7 +392,7 @@ static int goldfish_nand_probe(struct platform_device *pdev)
 
 	version = readl(base + NAND_VERSION);
 	if (version != NAND_VERSION_CURRENT) {
-		dev_err(&pdev->dev, 
+		dev_err(&pdev->dev,
 			"goldfish_nand_init: version mismatch, got %d, expected %d\n",
 				version, NAND_VERSION_CURRENT);
 		return -ENODEV;
@@ -400,7 +401,7 @@ static int goldfish_nand_probe(struct platform_device *pdev)
 	if (num_dev == 0)
 		return -ENODEV;
 
-	nand = devm_kzalloc(&pdev->dev, sizeof(*nand) + 
+	nand = devm_kzalloc(&pdev->dev, sizeof(*nand) +
 				sizeof(struct mtd_info) * num_dev, GFP_KERNEL);
 	if (nand == NULL)
 		return -ENOMEM;
-- 
1.8.2.1


-- 
Jake Champlin
jake.champlin.27@gmail.com
<MuttClient>
