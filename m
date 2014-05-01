Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbaEAKHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 06:07:34 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:55646 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631AbaEAJ5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:57:42 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 17/47] mtd: nand: stm_nand_bch: derive some working variables for latter use
Date: Thu,  1 May 2014 10:56:24 +0100
Message-Id: <1398938214-17847-18-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few of the working variables can either be taken or derived from
existing knowledge about the connected chip. Rather than attempt to
provide each specification manually, here we make assumptions based
on information already obtained.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index a1c25d0..8302273 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -930,6 +930,15 @@ static int stm_nand_bch_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	/* Derive some working variables */
+	nandi->sectors_per_page = mtd->writesize / NANDI_BCH_SECTOR_SIZE;
+	nandi->blocks_per_device = mtd->size >> chip->phys_erase_shift;
+	nandi->page_shift = chip->page_shift;
+	nandi->block_shift = chip->phys_erase_shift;
+	nandi->extra_addr = ((chip->chipsize >> nandi->page_shift) >
+			     0x10000) ? true : false;
+	mtd->writebufsize = mtd->writesize;
+
 	return 0;
 }
 
-- 
1.8.3.2

