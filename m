Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbaEZWRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:17:08 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:51133 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbaEZWRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:17:06 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 25/27] mtd: nand: ndfc: show device structure in sysfs
Date: Tue, 27 May 2014 00:12:50 +0200
Message-Id: <1401142372-14148-26-git-send-email-holler@ahsoftware.de>
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
 drivers/mtd/nand/ndfc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/ndfc.c b/drivers/mtd/nand/ndfc.c
index 69eaba6..66366e0 100644
--- a/drivers/mtd/nand/ndfc.c
+++ b/drivers/mtd/nand/ndfc.c
@@ -170,9 +170,6 @@ static int ndfc_chip_init(struct ndfc_controller *ndfc,
 	chip->ecc.strength = 1;
 	chip->priv = ndfc;
 
-	ndfc->mtd.priv = chip;
-	ndfc->mtd.owner = THIS_MODULE;
-
 	flash_np = of_get_next_child(node, NULL);
 	if (!flash_np)
 		return -ENODEV;
@@ -248,6 +245,7 @@ static int ndfc_probe(struct platform_device *ofdev)
 		out_be32(ndfc->ndfcbase + offset, be32_to_cpup(reg));
 	}
 
+	mtd_setup_common_members(&ndfc->mtd, &ndfc->chip, ofdev);
 	err = ndfc_chip_init(ndfc, ofdev->dev.of_node);
 	if (err) {
 		iounmap(ndfc->ndfcbase);
-- 
1.8.3.2

