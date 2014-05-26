Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbaEZWQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:16:31 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:50997 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbaEZWQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:16:25 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 19/27] mtd: nand: bcm47: show device structure in sysfs
Date: Tue, 27 May 2014 00:12:44 +0200
Message-Id: <1401142372-14148-20-git-send-email-holler@ahsoftware.de>
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
 drivers/mtd/nand/bcm47xxnflash/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/bcm47xxnflash/main.c b/drivers/mtd/nand/bcm47xxnflash/main.c
index 1074459..f995d5c 100644
--- a/drivers/mtd/nand/bcm47xxnflash/main.c
+++ b/drivers/mtd/nand/bcm47xxnflash/main.c
@@ -34,8 +34,7 @@ static int bcm47xxnflash_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	b47n->nand_chip.priv = b47n;
-	b47n->mtd.owner = THIS_MODULE;
-	b47n->mtd.priv = &b47n->nand_chip; /* Required */
+	mtd_setup_common_members(&b47n->mtd, &b47n->nand_chip, pdev);
 	b47n->cc = container_of(nflash, struct bcma_drv_cc, nflash);
 
 	if (b47n->cc->core->bus->chipinfo.id == BCMA_CHIP_ID_BCM4706) {
-- 
1.8.3.2

