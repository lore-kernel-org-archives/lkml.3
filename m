Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaEZWOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:14:31 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:50597 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbaEZWO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:14:28 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 06/27] mtd: nand: fsmc: show device structure in sysfs
Date: Tue, 27 May 2014 00:12:31 +0200
Message-Id: <1401142372-14148-7-git-send-email-holler@ahsoftware.de>
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
 drivers/mtd/nand/fsmc_nand.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/fsmc_nand.c b/drivers/mtd/nand/fsmc_nand.c
index 1550692..33c9cce 100644
--- a/drivers/mtd/nand/fsmc_nand.c
+++ b/drivers/mtd/nand/fsmc_nand.c
@@ -1009,10 +1009,9 @@ static int __init fsmc_nand_probe(struct platform_device *pdev)
 	/* Link all private pointers */
 	mtd = &host->mtd;
 	nand = &host->nand;
-	mtd->priv = nand;
+	mtd_setup_common_members(mtd, nand, pdev);
 	nand->priv = host;
 
-	host->mtd.owner = THIS_MODULE;
 	nand->IO_ADDR_R = host->data_va;
 	nand->IO_ADDR_W = host->data_va;
 	nand->cmd_ctrl = fsmc_cmd_ctrl;
-- 
1.8.3.2

