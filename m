Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaEZWP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:15:29 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:50776 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbaEZWPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:15:16 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 13/27] mtd: nand: tmio: show device structure in sysfs
Date: Tue, 27 May 2014 00:12:38 +0200
Message-Id: <1401142372-14148-14-git-send-email-holler@ahsoftware.de>
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
 drivers/mtd/nand/tmio_nand.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/tmio_nand.c b/drivers/mtd/nand/tmio_nand.c
index fb8fd35..ff22a31 100644
--- a/drivers/mtd/nand/tmio_nand.c
+++ b/drivers/mtd/nand/tmio_nand.c
@@ -380,8 +380,7 @@ static int tmio_probe(struct platform_device *dev)
 	platform_set_drvdata(dev, tmio);
 	mtd = &tmio->mtd;
 	nand_chip = &tmio->chip;
-	mtd->priv = nand_chip;
-	mtd->name = "tmio-nand";
+	mtd_setup_common_members(mtd, nand_chip, dev);
 
 	tmio->ccr = devm_ioremap(&dev->dev, ccr->start, resource_size(ccr));
 	if (!tmio->ccr)
-- 
1.8.3.2

