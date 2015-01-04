Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbbADTMV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 14:12:21 -0500
Received: from khitomer.mortis.eu ([185.27.175.75]:11416 "EHLO
	khitomer.mortis.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbbADTK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 14:10:28 -0500
From: Giel van Schijndel <me@mortis.eu>
To: linux-kernel@vger.kernel.org
Cc: Giel van Schijndel <me@mortis.eu>, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org (open list:MEMORY TECHNOLOGY...)
Subject: [PATCH] Fix error-code overwrite bug
Date: Sun,  4 Jan 2015 19:04:22 +0100
Message-Id: <1420394662-20011-1-git-send-email-me@mortis.eu>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't overwrite the returned error code with the boolean test used by
the if-statement (otherwise it'd be 1 or 0 always, 1 in the if-block).
---
 drivers/mtd/nftlmount.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nftlmount.c b/drivers/mtd/nftlmount.c
index 51b9d6a..1cbeb6b 100644
--- a/drivers/mtd/nftlmount.c
+++ b/drivers/mtd/nftlmount.c
@@ -91,7 +91,7 @@ static int find_boot_record(struct NFTLrecord *nftl)
 		/* To be safer with BIOS, also use erase mark as discriminant */
 		if ((ret = nftl_read_oob(mtd, block * nftl->EraseSize +
 					 SECTORSIZE + 8, 8, &retlen,
-					 (char *)&h1) < 0)) {
+					 (char *)&h1)) < 0) {
 			printk(KERN_WARNING "ANAND header found at 0x%x in mtd%d, but OOB data read failed (err %d)\n",
 			       block * nftl->EraseSize, nftl->mbd.mtd->index, ret);
 			continue;
-- 
2.1.4

