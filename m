Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbaIICCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 22:02:42 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:48350 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755633AbaIICCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 22:02:40 -0400
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
Subject: [PATCH v2 3/7] mtd: denali: remove unnecessary casts
Date: Tue,  9 Sep 2014 11:01:53 +0900
Message-Id: <1410228117-14820-4-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410228117-14820-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1410228117-14820-1-git-send-email-yamada.m@jp.panasonic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Useless casts result in unreadable source code.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---

Changes in v2: None

 drivers/mtd/nand/denali.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/mtd/nand/denali.c b/drivers/mtd/nand/denali.c
index 3836828..dcd6771 100644
--- a/drivers/mtd/nand/denali.c
+++ b/drivers/mtd/nand/denali.c
@@ -423,10 +423,10 @@ static void find_valid_banks(struct denali_nand_info *denali)
 
 	denali->total_used_banks = 1;
 	for (i = 0; i < denali->max_banks; i++) {
-		index_addr(denali, (uint32_t)(MODE_11 | (i << 24) | 0), 0x90);
-		index_addr(denali, (uint32_t)(MODE_11 | (i << 24) | 1), 0);
+		index_addr(denali, MODE_11 | (i << 24) | 0, 0x90);
+		index_addr(denali, MODE_11 | (i << 24) | 1, 0);
 		index_addr_read_data(denali,
-				(uint32_t)(MODE_11 | (i << 24) | 2), &id[i]);
+				MODE_11 | (i << 24) | 2, &id[i]);
 
 		dev_dbg(denali->dev,
 			"Return 1st ID for bank[%d]: %x\n", i, id[i]);
@@ -510,9 +510,9 @@ static uint16_t denali_nand_timing_set(struct denali_nand_info *denali)
 	 * For some NAND chips, controller can't report the correct
 	 * device ID by reading from DEVICE_ID register
 	 */
-	addr = (uint32_t)MODE_11 | BANK(denali->flash_bank);
-	index_addr(denali, (uint32_t)addr | 0, 0x90);
-	index_addr(denali, (uint32_t)addr | 1, 0);
+	addr = MODE_11 | BANK(denali->flash_bank);
+	index_addr(denali, addr | 0, 0x90);
+	index_addr(denali, addr | 1, 0);
 	for (i = 0; i < 8; i++)
 		index_addr_read_data(denali, addr | 2, &id_bytes[i]);
 	maf_id = id_bytes[0];
@@ -782,14 +782,14 @@ static int denali_send_pipeline_cmd(struct denali_nand_info *denali,
 	} else if (op == DENALI_WRITE && access_type == SPARE_ACCESS) {
 		/* read spare area */
 		cmd = MODE_10 | addr;
-		index_addr(denali, (uint32_t)cmd, access_type);
+		index_addr(denali, cmd, access_type);
 
 		cmd = MODE_01 | addr;
 		iowrite32(cmd, denali->flash_mem);
 	} else if (op == DENALI_READ) {
 		/* setup page read request for access type */
 		cmd = MODE_10 | addr;
-		index_addr(denali, (uint32_t)cmd, access_type);
+		index_addr(denali, cmd, access_type);
 
 		/*
 		 * page 33 of the NAND controller spec indicates we should not
@@ -800,7 +800,7 @@ static int denali_send_pipeline_cmd(struct denali_nand_info *denali,
 			cmd = MODE_01 | addr;
 			iowrite32(cmd, denali->flash_mem);
 		} else {
-			index_addr(denali, (uint32_t)cmd,
+			index_addr(denali, cmd,
 					PIPELINE_ACCESS | op | page_count);
 
 			/*
@@ -929,7 +929,7 @@ static void read_oob_data(struct mtd_info *mtd, uint8_t *buf, int page)
 		 */
 		addr = BANK(denali->flash_bank) | denali->page;
 		cmd = MODE_10 | addr;
-		index_addr(denali, (uint32_t)cmd, MAIN_ACCESS);
+		index_addr(denali, cmd, MAIN_ACCESS);
 	}
 }
 
@@ -1035,7 +1035,7 @@ static void denali_setup_dma(struct denali_nand_info *denali, int op)
 {
 	uint32_t mode;
 	const int page_count = 1;
-	dma_addr_t addr = denali->buf.dma_buf;
+	uint32_t addr = denali->buf.dma_buf;
 
 	mode = MODE_10 | BANK(denali->flash_bank);
 
@@ -1045,10 +1045,10 @@ static void denali_setup_dma(struct denali_nand_info *denali, int op)
 	index_addr(denali, mode | denali->page, 0x2000 | op | page_count);
 
 	/* 2. set memory high address bits 23:8 */
-	index_addr(denali, mode | ((uint16_t)(addr >> 16) << 8), 0x2200);
+	index_addr(denali, mode | ((addr >> 16) << 8), 0x2200);
 
 	/* 3. set memory low address bits 23:8 */
-	index_addr(denali, mode | ((uint16_t)addr << 8), 0x2300);
+	index_addr(denali, mode | ((addr & 0xff) << 8), 0x2300);
 
 	/* 4. interrupt when complete, burst len = 64 bytes */
 	index_addr(denali, mode | 0x14000, 0x2400);
@@ -1289,7 +1289,7 @@ static int denali_erase(struct mtd_info *mtd, int page)
 
 	/* setup page read request for access type */
 	cmd = MODE_10 | BANK(denali->flash_bank) | page;
-	index_addr(denali, (uint32_t)cmd, 0x1);
+	index_addr(denali, cmd, 0x1);
 
 	/* wait for erase to complete or failure to occur */
 	irq_status = wait_for_irq(denali, INTR_STATUS__ERASE_COMP |
@@ -1319,12 +1319,12 @@ static void denali_cmdfunc(struct mtd_info *mtd, unsigned int cmd, int col,
 		 * e.g. some of Micron MT29F32G08QAA MLC NAND chips
 		 * So here we send READID cmd to NAND insteand
 		 */
-		addr = (uint32_t)MODE_11 | BANK(denali->flash_bank);
-		index_addr(denali, (uint32_t)addr | 0, 0x90);
-		index_addr(denali, (uint32_t)addr | 1, 0);
+		addr = MODE_11 | BANK(denali->flash_bank);
+		index_addr(denali, addr | 0, 0x90);
+		index_addr(denali, addr | 1, 0);
 		for (i = 0; i < 8; i++) {
 			index_addr_read_data(denali,
-						(uint32_t)addr | 2,
+						addr | 2,
 						&id);
 			write_byte_to_buf(denali, id);
 		}
-- 
1.9.1

