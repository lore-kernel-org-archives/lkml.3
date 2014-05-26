Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbaEZWOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:14:46 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:50636 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaEZWOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:14:42 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 08/27] mtd: nand: plat: show device structure in sysfs
Date: Tue, 27 May 2014 00:12:33 +0200
Message-Id: <1401142372-14148-9-git-send-email-holler@ahsoftware.de>
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
 drivers/mtd/nand/plat_nand.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/plat_nand.c b/drivers/mtd/nand/plat_nand.c
index 0b068a5..4d4cc25 100644
--- a/drivers/mtd/nand/plat_nand.c
+++ b/drivers/mtd/nand/plat_nand.c
@@ -60,8 +60,7 @@ static int plat_nand_probe(struct platform_device *pdev)
 		return PTR_ERR(data->io_base);
 
 	data->chip.priv = &data;
-	data->mtd.priv = &data->chip;
-	data->mtd.owner = THIS_MODULE;
+	mtd_setup_common_members(&data->mtd, &data->chip, pdev);
 	data->mtd.name = dev_name(&pdev->dev);
 
 	data->chip.IO_ADDR_R = data->io_base;
-- 
1.8.3.2

