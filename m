Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaEZWOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:14:39 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:50616 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaEZWOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:14:36 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 07/27] mtd: nand: gpmi: show device structure in sysfs
Date: Tue, 27 May 2014 00:12:32 +0200
Message-Id: <1401142372-14148-8-git-send-email-holler@ahsoftware.de>
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
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
index bb77f75..35b0a60 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
@@ -1682,11 +1682,6 @@ static int gpmi_nand_init(struct gpmi_nand_data *this)
 	/* init current chip */
 	this->current_chip	= -1;
 
-	/* init the MTD data structures */
-	mtd->priv		= chip;
-	mtd->name		= "gpmi-nand";
-	mtd->owner		= THIS_MODULE;
-
 	/* init the nand_chip{}, we don't support a 16-bit NAND Flash bus. */
 	chip->priv		= this;
 	chip->select_chip	= gpmi_select_chip;
@@ -1791,6 +1786,7 @@ static int gpmi_nand_probe(struct platform_device *pdev)
 	if (ret)
 		goto exit_nfc_init;
 
+	mtd_setup_common_members(&this->mtd, &this->nand, pdev);
 	ret = gpmi_nand_init(this);
 	if (ret)
 		goto exit_nfc_init;
-- 
1.8.3.2

