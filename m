Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbaEZWQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:16:21 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:50968 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbaEZWQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:16:18 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 18/27] mtd: nand: mxc: use mtd_setup_common_members()
Date: Tue, 27 May 2014 00:12:43 +0200
Message-Id: <1401142372-14148-19-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401142372-14148-1-git-send-email-holler@ahsoftware.de>
References: <1401142372-14148-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new common function mtd_setup_common_members()

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/mtd/nand/mxc_nand.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
index dba262b..31114db4 100644
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -1413,10 +1413,7 @@ static int mxcnd_probe(struct platform_device *pdev)
 	/* structures must be linked */
 	this = &host->nand;
 	mtd = &host->mtd;
-	mtd->priv = this;
-	mtd->owner = THIS_MODULE;
-	mtd->dev.parent = &pdev->dev;
-	mtd->name = DRIVER_NAME;
+	mtd_setup_common_members(mtd, this, pdev);
 
 	/* 50 us command delay time */
 	this->chip_delay = 5;
-- 
1.8.3.2

