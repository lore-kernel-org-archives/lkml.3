Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbaEZWRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:17:21 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:51170 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaEZWRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:17:18 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 27/27] mtd: nand: socrates: use mtd_setup_common_members()
Date: Tue, 27 May 2014 00:12:52 +0200
Message-Id: <1401142372-14148-28-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401142372-14148-1-git-send-email-holler@ahsoftware.de>
References: <1401142372-14148-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new common function mtd_setup_common_members().

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/mtd/nand/socrates_nand.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/socrates_nand.c b/drivers/mtd/nand/socrates_nand.c
index fe8058a..0b87be2 100644
--- a/drivers/mtd/nand/socrates_nand.c
+++ b/drivers/mtd/nand/socrates_nand.c
@@ -165,10 +165,7 @@ static int socrates_nand_probe(struct platform_device *ofdev)
 	host->dev = &ofdev->dev;
 
 	nand_chip->priv = host;		/* link the private data structures */
-	mtd->priv = nand_chip;
-	mtd->name = "socrates_nand";
-	mtd->owner = THIS_MODULE;
-	mtd->dev.parent = &ofdev->dev;
+	mtd_setup_common_members(mtd, nand_chip, ofdev);
 	ppdata.of_node = ofdev->dev.of_node;
 
 	/*should never be accessed directly */
-- 
1.8.3.2

