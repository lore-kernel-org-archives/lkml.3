Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaEZWP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:15:26 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:50798 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbaEZWPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:15:22 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 14/27] mtd: nand: docg4: show device structure in sysfs
Date: Tue, 27 May 2014 00:12:39 +0200
Message-Id: <1401142372-14148-15-git-send-email-holler@ahsoftware.de>
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
 drivers/mtd/nand/docg4.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/docg4.c b/drivers/mtd/nand/docg4.c
index 1b0265e..50ad7a7 100644
--- a/drivers/mtd/nand/docg4.c
+++ b/drivers/mtd/nand/docg4.c
@@ -1312,9 +1312,8 @@ static int __init probe_docg4(struct platform_device *pdev)
 	}
 	nand = (struct nand_chip *) (mtd + 1);
 	doc = (struct docg4_priv *) (nand + 1);
-	mtd->priv = nand;
+	mtd_setup_common_members(mtd, nand, pdev);
 	nand->priv = doc;
-	mtd->owner = THIS_MODULE;
 	doc->virtadr = virtadr;
 	doc->dev = dev;
 
-- 
1.8.3.2

