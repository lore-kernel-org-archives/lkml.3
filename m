Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaEZWPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:15:35 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:50828 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbaEZWP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:15:29 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 15/27] mtd: nand: davinci: use mtd_setup_common_members()
Date: Tue, 27 May 2014 00:12:40 +0200
Message-Id: <1401142372-14148-16-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401142372-14148-1-git-send-email-holler@ahsoftware.de>
References: <1401142372-14148-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new common function mtd_setup_common_members()

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/mtd/nand/davinci_nand.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
index b922c8e..ce409fc 100644
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -656,11 +656,8 @@ static int nand_davinci_probe(struct platform_device *pdev)
 	info->base		= base;
 	info->vaddr		= vaddr;
 
-	info->mtd.priv		= &info->chip;
+	mtd_setup_common_members(&info->mtd, &info->chip, pdev);
 	info->mtd.name		= dev_name(&pdev->dev);
-	info->mtd.owner		= THIS_MODULE;
-
-	info->mtd.dev.parent	= &pdev->dev;
 
 	info->chip.IO_ADDR_R	= vaddr;
 	info->chip.IO_ADDR_W	= vaddr;
-- 
1.8.3.2

