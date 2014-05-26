Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaEZWO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:14:59 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:50684 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaEZWOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:14:55 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 10/27] mtd: nand: s3c2410: show device structure in sysfs
Date: Tue, 27 May 2014 00:12:35 +0200
Message-Id: <1401142372-14148-11-git-send-email-holler@ahsoftware.de>
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
 drivers/mtd/nand/s3c2410.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/s3c2410.c b/drivers/mtd/nand/s3c2410.c
index 79acbb8..c3227f4 100644
--- a/drivers/mtd/nand/s3c2410.c
+++ b/drivers/mtd/nand/s3c2410.c
@@ -831,8 +831,6 @@ static void s3c2410_nand_init_chip(struct s3c2410_nand_info *info,
 	chip->IO_ADDR_R = chip->IO_ADDR_W;
 
 	nmtd->info	   = info;
-	nmtd->mtd.priv	   = chip;
-	nmtd->mtd.owner    = THIS_MODULE;
 	nmtd->set	   = set;
 
 #ifdef CONFIG_MTD_NAND_S3C2410_HWECC
@@ -1018,6 +1016,7 @@ static int s3c24xx_nand_probe(struct platform_device *pdev)
 		pr_debug("initialising set %d (%p, info %p)\n",
 			 setno, nmtd, info);
 
+		mtd_setup_common_members(&nmtd->mtd, &nmtd->chip, pdev);
 		s3c2410_nand_init_chip(info, nmtd, sets);
 
 		nmtd->scan_res = nand_scan_ident(&nmtd->mtd,
-- 
1.8.3.2

