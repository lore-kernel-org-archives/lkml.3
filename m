Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbaEAKA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 06:00:58 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:39271 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071AbaEAJ63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:58:29 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 41/47] mtd: nand: stm_nand_bch: MTD erase (BCH)
Date: Thu,  1 May 2014 10:56:48 +0100
Message-Id: <1398938214-17847-42-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carry out the normal checks, then attempt to erase a given block.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index e742655..11735ee 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -529,6 +529,16 @@ static uint8_t bch_erase_block(struct nandi_controller *nandi,
 	return status;
 }
 
+static int bch_erase(struct mtd_info *mtd, int page)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct nandi_controller *nandi = chip->priv;
+	uint32_t page_size = mtd->writesize;
+	loff_t offs = page * page_size;
+
+	return bch_erase_block(nandi, offs);
+}
+
 /*
  * Detect an erased page, tolerating and correcting up to a specified number of
  * bits at '0'.  (For many devices, it is now deemed within spec for an erased
@@ -1370,6 +1380,7 @@ static void nandi_set_mtd_defaults(struct nandi_controller *nandi,
 
 	chip->ecc.read_page = bch_read;
 	chip->write_page = bch_write;
+	chip->erase = bch_erase;
 
 	chip->scan_bbt = bch_scan_bbt;
 }
-- 
1.8.3.2

