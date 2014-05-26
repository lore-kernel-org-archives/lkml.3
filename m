Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaEZWRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:17:16 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:51148 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbaEZWRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:17:12 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 26/27] mtd: nand: txx9ndfmc: show device structure in sysfs
Date: Tue, 27 May 2014 00:12:51 +0200
Message-Id: <1401142372-14148-27-git-send-email-holler@ahsoftware.de>
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
 drivers/mtd/nand/txx9ndfmc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/txx9ndfmc.c b/drivers/mtd/nand/txx9ndfmc.c
index c1622a5..88b8d34 100644
--- a/drivers/mtd/nand/txx9ndfmc.c
+++ b/drivers/mtd/nand/txx9ndfmc.c
@@ -323,9 +323,7 @@ static int __init txx9ndfmc_probe(struct platform_device *dev)
 			continue;
 		chip = &txx9_priv->chip;
 		mtd = &txx9_priv->mtd;
-		mtd->owner = THIS_MODULE;
-
-		mtd->priv = chip;
+		mtd_setup_common_members(mtd, chip, dev);
 
 		chip->read_byte = txx9ndfmc_read_byte;
 		chip->read_buf = txx9ndfmc_read_buf;
-- 
1.8.3.2

