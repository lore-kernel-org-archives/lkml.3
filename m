Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933375AbaBASKk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 13:10:40 -0500
Received: from mail-we0-f193.google.com ([74.125.82.193]:46243 "EHLO
	mail-we0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933242AbaBASKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 13:10:39 -0500
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
To: Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: [PATCH] mtd: nand: fix erronous read_buf call in nand_write_page_raw_syndrome
Date: Sat,  1 Feb 2014 19:10:28 +0100
Message-Id: <1391278228-12701-1-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

read_buf is called in place of write_buf in the
nand_write_page_raw_syndrome function.

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
---
 drivers/mtd/nand/nand_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 15069ec..f59a465 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -1902,7 +1902,7 @@ static int nand_write_page_raw_syndrome(struct mtd_info *mtd,
 			oob += chip->ecc.prepad;
 		}
 
-		chip->read_buf(mtd, oob, eccbytes);
+		chip->write_buf(mtd, oob, eccbytes);
 		oob += eccbytes;
 
 		if (chip->ecc.postpad) {
-- 
1.7.9.5

