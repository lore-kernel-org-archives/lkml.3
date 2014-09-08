Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbaIHILt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:11:49 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:50265 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194AbaIHIL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:11:26 -0400
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
Subject: [PATCH 2/7] mtd: denali: remove unnecessary variable initializations
Date: Mon,  8 Sep 2014 17:10:08 +0900
Message-Id: <1410163813-31783-3-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410163813-31783-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1410163813-31783-1-git-send-email-yamada.m@jp.panasonic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All of these variables are initialized to zero and then
set to a different value below.
Zero-initializing is redundant.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---

 drivers/mtd/nand/denali.c | 59 ++++++++++++++++++++++-------------------------
 1 file changed, 27 insertions(+), 32 deletions(-)

diff --git a/drivers/mtd/nand/denali.c b/drivers/mtd/nand/denali.c
index 44a5f159..3836828 100644
--- a/drivers/mtd/nand/denali.c
+++ b/drivers/mtd/nand/denali.c
@@ -146,7 +146,7 @@ static void write_byte_to_buf(struct denali_nand_info *denali, uint8_t byte)
 /* reads the status of the device */
 static void read_status(struct denali_nand_info *denali)
 {
-	uint32_t cmd = 0x0;
+	uint32_t cmd;
 
 	/* initialize the data buffer to store status */
 	reset_buf(denali);
@@ -161,7 +161,7 @@ static void read_status(struct denali_nand_info *denali)
 /* resets a specific device connected to the core */
 static void reset_bank(struct denali_nand_info *denali)
 {
-	uint32_t irq_status = 0;
+	uint32_t irq_status;
 	uint32_t irq_mask = INTR_STATUS__RST_COMP |
 			    INTR_STATUS__TIME_OUT;
 
@@ -581,7 +581,7 @@ static inline bool is_flash_bank_valid(int flash_bank)
 
 static void denali_irq_init(struct denali_nand_info *denali)
 {
-	uint32_t int_mask = 0;
+	uint32_t int_mask;
 	int i;
 
 	/* Disable global interrupts */
@@ -624,7 +624,7 @@ static inline uint32_t denali_irq_detected(struct denali_nand_info *denali)
 static inline void clear_interrupt(struct denali_nand_info *denali,
 							uint32_t irq_mask)
 {
-	uint32_t intr_status_reg = 0;
+	uint32_t intr_status_reg;
 
 	intr_status_reg = INTR_STATUS(denali->flash_bank);
 
@@ -633,7 +633,8 @@ static inline void clear_interrupt(struct denali_nand_info *denali,
 
 static void clear_interrupts(struct denali_nand_info *denali)
 {
-	uint32_t status = 0x0;
+	uint32_t status;
+
 	spin_lock_irq(&denali->irq_lock);
 
 	status = read_interrupt_status(denali);
@@ -645,7 +646,7 @@ static void clear_interrupts(struct denali_nand_info *denali)
 
 static uint32_t read_interrupt_status(struct denali_nand_info *denali)
 {
-	uint32_t intr_status_reg = 0;
+	uint32_t intr_status_reg;
 
 	intr_status_reg = INTR_STATUS(denali->flash_bank);
 
@@ -659,7 +660,7 @@ static uint32_t read_interrupt_status(struct denali_nand_info *denali)
 static irqreturn_t denali_isr(int irq, void *dev_id)
 {
 	struct denali_nand_info *denali = dev_id;
-	uint32_t irq_status = 0x0;
+	uint32_t irq_status;
 	irqreturn_t result = IRQ_NONE;
 
 	spin_lock(&denali->irq_lock);
@@ -693,8 +694,8 @@ static irqreturn_t denali_isr(int irq, void *dev_id)
 
 static uint32_t wait_for_irq(struct denali_nand_info *denali, uint32_t irq_mask)
 {
-	unsigned long comp_res = 0;
-	uint32_t intr_status = 0;
+	unsigned long comp_res;
+	uint32_t intr_status;
 	bool retry = false;
 	unsigned long timeout = msecs_to_jiffies(1000);
 
@@ -736,7 +737,7 @@ static uint32_t wait_for_irq(struct denali_nand_info *denali, uint32_t irq_mask)
 static void setup_ecc_for_xfer(struct denali_nand_info *denali, bool ecc_en,
 				bool transfer_spare)
 {
-	int ecc_en_flag = 0, transfer_spare_flag = 0;
+	int ecc_en_flag, transfer_spare_flag;
 
 	/* set ECC, transfer spare bits if needed */
 	ecc_en_flag = ecc_en ? ECC_ENABLE__FLAG : 0;
@@ -759,8 +760,8 @@ static int denali_send_pipeline_cmd(struct denali_nand_info *denali,
 							int op)
 {
 	int status = PASS;
-	uint32_t addr = 0x0, cmd = 0x0, page_count = 1, irq_status = 0,
-		 irq_mask = 0;
+	uint32_t page_count = 1;
+	uint32_t addr, cmd, irq_status, irq_mask;
 
 	if (op == DENALI_READ)
 		irq_mask = INTR_STATUS__LOAD_COMP;
@@ -829,7 +830,7 @@ static int write_data_to_flash_mem(struct denali_nand_info *denali,
 							const uint8_t *buf,
 							int len)
 {
-	uint32_t i = 0, *buf32;
+	uint32_t i, *buf32;
 
 	/*
 	 * verify that the len is a multiple of 4.
@@ -849,7 +850,7 @@ static int read_data_from_flash_mem(struct denali_nand_info *denali,
 								uint8_t *buf,
 								int len)
 {
-	uint32_t i = 0, *buf32;
+	uint32_t i, *buf32;
 
 	/*
 	 * we assume that len will be a multiple of 4, if not it would be nice
@@ -870,7 +871,7 @@ static int read_data_from_flash_mem(struct denali_nand_info *denali,
 static int write_oob_data(struct mtd_info *mtd, uint8_t *buf, int page)
 {
 	struct denali_nand_info *denali = mtd_to_denali(mtd);
-	uint32_t irq_status = 0;
+	uint32_t irq_status;
 	uint32_t irq_mask = INTR_STATUS__PROGRAM_COMP |
 						INTR_STATUS__PROGRAM_FAIL;
 	int status = 0;
@@ -899,8 +900,8 @@ static int write_oob_data(struct mtd_info *mtd, uint8_t *buf, int page)
 static void read_oob_data(struct mtd_info *mtd, uint8_t *buf, int page)
 {
 	struct denali_nand_info *denali = mtd_to_denali(mtd);
-	uint32_t irq_mask = INTR_STATUS__LOAD_COMP,
-			 irq_status = 0, addr = 0x0, cmd = 0x0;
+	uint32_t irq_mask = INTR_STATUS__LOAD_COMP;
+	uint32_t irq_status, addr, cmd;
 
 	denali->page = page;
 
@@ -938,7 +939,7 @@ static void read_oob_data(struct mtd_info *mtd, uint8_t *buf, int page)
  */
 static bool is_erased(uint8_t *buf, int len)
 {
-	int i = 0;
+	int i;
 	for (i = 0; i < len; i++)
 		if (buf[i] != 0xFF)
 			return false;
@@ -961,9 +962,8 @@ static bool handle_ecc(struct denali_nand_info *denali, uint8_t *buf,
 
 	if (irq_status & INTR_STATUS__ECC_ERR) {
 		/* read the ECC errors. we'll ignore them for now */
-		uint32_t err_address = 0, err_correction_info = 0;
-		uint32_t err_byte = 0, err_sector = 0, err_device = 0;
-		uint32_t err_correction_value = 0;
+		uint32_t err_address, err_correction_info, err_byte,
+			 err_sector, err_device, err_correction_value;
 		denali_set_intr_modes(denali, false);
 
 		do {
@@ -1026,19 +1026,14 @@ static bool handle_ecc(struct denali_nand_info *denali, uint8_t *buf,
 /* programs the controller to either enable/disable DMA transfers */
 static void denali_enable_dma(struct denali_nand_info *denali, bool en)
 {
-	uint32_t reg_val = 0x0;
-
-	if (en)
-		reg_val = DMA_ENABLE__FLAG;
-
-	iowrite32(reg_val, denali->flash_reg + DMA_ENABLE);
+	iowrite32(en ? DMA_ENABLE__FLAG : 0, denali->flash_reg + DMA_ENABLE);
 	ioread32(denali->flash_reg + DMA_ENABLE);
 }
 
 /* setups the HW to perform the data DMA */
 static void denali_setup_dma(struct denali_nand_info *denali, int op)
 {
-	uint32_t mode = 0x0;
+	uint32_t mode;
 	const int page_count = 1;
 	dma_addr_t addr = denali->buf.dma_buf;
 
@@ -1071,7 +1066,7 @@ static int write_page(struct mtd_info *mtd, struct nand_chip *chip,
 	dma_addr_t addr = denali->buf.dma_buf;
 	size_t size = denali->mtd.writesize + denali->mtd.oobsize;
 
-	uint32_t irq_status = 0;
+	uint32_t irq_status;
 	uint32_t irq_mask = INTR_STATUS__DMA_CMD_COMP |
 						INTR_STATUS__PROGRAM_FAIL;
 
@@ -1172,7 +1167,7 @@ static int denali_read_page(struct mtd_info *mtd, struct nand_chip *chip,
 	dma_addr_t addr = denali->buf.dma_buf;
 	size_t size = denali->mtd.writesize + denali->mtd.oobsize;
 
-	uint32_t irq_status = 0;
+	uint32_t irq_status;
 	uint32_t irq_mask = INTR_STATUS__ECC_TRANSACTION_DONE |
 			    INTR_STATUS__ECC_ERR;
 	bool check_erased_page = false;
@@ -1224,7 +1219,7 @@ static int denali_read_page_raw(struct mtd_info *mtd, struct nand_chip *chip,
 	dma_addr_t addr = denali->buf.dma_buf;
 	size_t size = denali->mtd.writesize + denali->mtd.oobsize;
 
-	uint32_t irq_status = 0;
+	uint32_t irq_status;
 	uint32_t irq_mask = INTR_STATUS__DMA_CMD_COMP;
 
 	if (page != denali->page) {
@@ -1288,7 +1283,7 @@ static int denali_erase(struct mtd_info *mtd, int page)
 {
 	struct denali_nand_info *denali = mtd_to_denali(mtd);
 
-	uint32_t cmd = 0x0, irq_status = 0;
+	uint32_t cmd, irq_status;
 
 	clear_interrupts(denali);
 
-- 
1.9.1

