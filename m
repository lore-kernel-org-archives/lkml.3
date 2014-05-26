Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbaEZWQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:16:44 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:51039 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbaEZWQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:16:39 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 21/27] mtd: nand: fsl_upm: show device structure in sysfs
Date: Tue, 27 May 2014 00:12:46 +0200
Message-Id: <1401142372-14148-22-git-send-email-holler@ahsoftware.de>
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
 drivers/mtd/nand/fsl_upm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/fsl_upm.c b/drivers/mtd/nand/fsl_upm.c
index 4d203e8..bc2a188 100644
--- a/drivers/mtd/nand/fsl_upm.c
+++ b/drivers/mtd/nand/fsl_upm.c
@@ -175,9 +175,6 @@ static int fun_chip_init(struct fsl_upm_nand *fun,
 	if (fun->rnb_gpio[0] >= 0)
 		fun->chip.dev_ready = fun_chip_ready;
 
-	fun->mtd.priv = &fun->chip;
-	fun->mtd.owner = THIS_MODULE;
-
 	flash_np = of_get_next_child(upm_np, NULL);
 	if (!flash_np)
 		return -ENODEV;
@@ -300,6 +297,7 @@ static int fun_probe(struct platform_device *ofdev)
 	fun->dev = &ofdev->dev;
 	fun->last_ctrl = NAND_CLE;
 
+	mtd_setup_common_members(&fun->mtd, &fun->chip, ofdev);
 	ret = fun_chip_init(fun, ofdev->dev.of_node, &io_res);
 	if (ret)
 		goto err2;
-- 
1.8.3.2

