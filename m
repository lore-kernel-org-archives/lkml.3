Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbaE0G3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 02:29:12 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:59541 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaE0G3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 02:29:09 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 09/27 v2] mtd: nand: pxa3xx: show device structure in sysfs
Date: Tue, 27 May 2014 08:28:30 +0200
Message-Id: <1401172110-3910-1-git-send-email-holler@ahsoftware.de>
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
 Changes to v1: add owner to module

 drivers/mtd/nand/pxa3xx_nand.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
index 7588fe2..9d4c914 100644
--- a/drivers/mtd/nand/pxa3xx_nand.c
+++ b/drivers/mtd/nand/pxa3xx_nand.c
@@ -1584,8 +1584,7 @@ static int alloc_nand_resource(struct platform_device *pdev)
 		host->mtd = mtd;
 		host->cs = cs;
 		host->info_data = info;
-		mtd->priv = host;
-		mtd->owner = THIS_MODULE;
+		mtd_setup_common_members(mtd, host, pdev);
 
 		chip->ecc.read_page	= pxa3xx_nand_read_page_hwecc;
 		chip->ecc.write_page	= pxa3xx_nand_write_page_hwecc;
@@ -1862,6 +1861,7 @@ static int pxa3xx_nand_resume(struct platform_device *pdev)
 static struct platform_driver pxa3xx_nand_driver = {
 	.driver = {
 		.name	= "pxa3xx-nand",
+		.owner	= THIS_MODULE,
 		.of_match_table = pxa3xx_nand_dt_ids,
 	},
 	.probe		= pxa3xx_nand_probe,
-- 
1.8.3.2

