Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbaEZWOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:14:06 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:50498 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbaEZWOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:14:01 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 02/27] mtd: nand: orion_nand: show device structure in sysfs
Date: Tue, 27 May 2014 00:12:27 +0200
Message-Id: <1401142372-14148-3-git-send-email-holler@ahsoftware.de>
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
 drivers/mtd/nand/orion_nand.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/orion_nand.c b/drivers/mtd/nand/orion_nand.c
index dd7fe81..3cd43f7 100644
--- a/drivers/mtd/nand/orion_nand.c
+++ b/drivers/mtd/nand/orion_nand.c
@@ -91,6 +91,7 @@ static int __init orion_nand_probe(struct platform_device *pdev)
 		goto no_res;
 	}
 	mtd = (struct mtd_info *)(nc + 1);
+	mtd_setup_common_members(mtd, nc, pdev);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
@@ -132,9 +133,6 @@ static int __init orion_nand_probe(struct platform_device *pdev)
 		board = dev_get_platdata(&pdev->dev);
 	}
 
-	mtd->priv = nc;
-	mtd->owner = THIS_MODULE;
-
 	nc->priv = board;
 	nc->IO_ADDR_R = nc->IO_ADDR_W = io_base;
 	nc->cmd_ctrl = orion_nand_cmd_ctrl;
@@ -169,7 +167,6 @@ static int __init orion_nand_probe(struct platform_device *pdev)
 		goto no_dev;
 	}
 
-	mtd->name = "orion_nand";
 	ppdata.of_node = pdev->dev.of_node;
 	ret = mtd_device_parse_register(mtd, NULL, &ppdata,
 			board->parts, board->nr_parts);
-- 
1.8.3.2

