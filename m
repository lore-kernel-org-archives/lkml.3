Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbaEZWQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:16:56 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:51086 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbaEZWQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:16:52 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 23/27] mtd: nand: jz4740: show device structure in sysfs
Date: Tue, 27 May 2014 00:12:48 +0200
Message-Id: <1401142372-14148-24-git-send-email-holler@ahsoftware.de>
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
 drivers/mtd/nand/jz4740_nand.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/jz4740_nand.c b/drivers/mtd/nand/jz4740_nand.c
index a2c804d..a30a8e5 100644
--- a/drivers/mtd/nand/jz4740_nand.c
+++ b/drivers/mtd/nand/jz4740_nand.c
@@ -435,9 +435,7 @@ static int jz_nand_probe(struct platform_device *pdev)
 
 	mtd		= &nand->mtd;
 	chip		= &nand->chip;
-	mtd->priv	= chip;
-	mtd->owner	= THIS_MODULE;
-	mtd->name	= "jz4740-nand";
+	mtd_setup_common_members(mtd, chip, pdev);
 
 	chip->ecc.hwctl		= jz_nand_hwctl;
 	chip->ecc.calculate	= jz_nand_calculate_ecc_rs;
-- 
1.8.3.2

