Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab3CJKMH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 06:12:07 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:32778 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab3CJKMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 06:12:05 -0400
From: Tao Hou <hotforest@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Tao Hou <hotforest@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mtd: nand: fix the partial page write condition
Date: Sun, 10 Mar 2013 18:18:24 +0800
Message-Id: <1362910704-24133-1-git-send-email-hotforest@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When writelen is mtd->writesize - 1, it is still a partial page write

Signed-off-by: Tao Hou <hotforest@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/mtd/nand/nand_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 4321415..c6161eb 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -2210,7 +2210,7 @@ static int nand_do_write_ops(struct mtd_info *mtd, loff_t to,
 		uint8_t *wbuf = buf;
 
 		/* Partial page write? */
-		if (unlikely(column || writelen < (mtd->writesize - 1))) {
+		if (unlikely(column || writelen < mtd->writesize)) {
 			cached = 0;
 			bytes = min_t(int, bytes - column, (int) writelen);
 			chip->pagebuf = -1;
-- 
1.7.9.5

