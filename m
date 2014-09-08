Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbaIHILV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:11:21 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:56806 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbaIHILT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:11:19 -0400
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-mtd@lists.infradead.org
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Huang Shijie <shijie8@gmail.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        "grmoore@altera.com" <grmoore@altera.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] mtd: denali: change the type of iterators to int
Date: Mon,  8 Sep 2014 17:10:10 +0900
Message-Id: <1410163813-31783-5-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410163813-31783-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1410163813-31783-1-git-send-email-yamada.m@jp.panasonic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should rathar use "int" type for loop iterators.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---

 drivers/mtd/nand/denali.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/denali.c b/drivers/mtd/nand/denali.c
index dcd6771..259ca0ba 100644
--- a/drivers/mtd/nand/denali.c
+++ b/drivers/mtd/nand/denali.c
@@ -178,7 +178,7 @@ static void reset_bank(struct denali_nand_info *denali)
 /* Reset the flash controller */
 static uint16_t denali_nand_reset(struct denali_nand_info *denali)
 {
-	uint32_t i;
+	int i;
 
 	dev_dbg(denali->dev, "%s, Line %d, Function: %s\n",
 		       __FILE__, __LINE__, __func__);
@@ -499,7 +499,8 @@ static uint16_t denali_nand_timing_set(struct denali_nand_info *denali)
 {
 	uint16_t status = PASS;
 	uint32_t id_bytes[8], addr;
-	uint8_t i, maf_id, device_id;
+	uint8_t maf_id, device_id;
+	int i;
 
 	dev_dbg(denali->dev,
 			"%s, Line %d, Function: %s\n",
@@ -830,7 +831,8 @@ static int write_data_to_flash_mem(struct denali_nand_info *denali,
 							const uint8_t *buf,
 							int len)
 {
-	uint32_t i, *buf32;
+	uint32_t *buf32;
+	int i;
 
 	/*
 	 * verify that the len is a multiple of 4.
@@ -850,7 +852,8 @@ static int read_data_from_flash_mem(struct denali_nand_info *denali,
 								uint8_t *buf,
 								int len)
 {
-	uint32_t i, *buf32;
+	uint32_t *buf32;
+	int i;
 
 	/*
 	 * we assume that len will be a multiple of 4, if not it would be nice
-- 
1.9.1

