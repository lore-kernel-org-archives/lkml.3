Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbaIPLFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 07:05:54 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:42750 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbaIPLFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 07:05:51 -0400
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-mtd@lists.infradead.org
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Jiri Kosina <trivial@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Huang Shijie <shijie8@gmail.com>,
        "grmoore@altera.com" <grmoore@altera.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 7/7] mtd: denali: fix indents and other trivial things
Date: Tue, 16 Sep 2014 20:04:25 +0900
Message-Id: <1410865465-17941-8-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410865465-17941-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1410865465-17941-1-git-send-email-yamada.m@jp.panasonic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Fix indents
- Do not break a line unless it is longer than 80 columns
- Do not insert a whitespace before ';'
- Use whitespaces around operators
- Use braces for a "else" block where the "if" block uses ones.

Besides, eliminate all the warnings reported by checkpatch.pl:
- WARNING: quoted string split across lines
- WARNING: else is not generally useful after a break or return
- WARNING: Missing a blank line after declarations
- WARNING: Avoid line continuations in quoted strings

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---

Changes in v3:
  - Rebase on l2-mtd.git

Changes in v2:
  - Join quotes strings into a single line

 drivers/mtd/nand/denali.c | 138 ++++++++++++++++++++--------------------------
 1 file changed, 61 insertions(+), 77 deletions(-)

diff --git a/drivers/mtd/nand/denali.c b/drivers/mtd/nand/denali.c
index 945943e..b3b7ca1 100644
--- a/drivers/mtd/nand/denali.c
+++ b/drivers/mtd/nand/denali.c
@@ -37,8 +37,8 @@ MODULE_LICENSE("GPL");
 
 static int onfi_timing_mode = NAND_DEFAULT_TIMINGS;
 module_param(onfi_timing_mode, int, S_IRUGO);
-MODULE_PARM_DESC(onfi_timing_mode, "Overrides default ONFI setting."
-			" -1 indicates use default timings");
+MODULE_PARM_DESC(onfi_timing_mode,
+	   "Overrides default ONFI setting. -1 indicates use default timings");
 
 #define DENALI_NAND_NAME    "denali-nand"
 
@@ -162,8 +162,7 @@ static void read_status(struct denali_nand_info *denali)
 static void reset_bank(struct denali_nand_info *denali)
 {
 	uint32_t irq_status;
-	uint32_t irq_mask = INTR_STATUS__RST_COMP |
-			    INTR_STATUS__TIME_OUT;
+	uint32_t irq_mask = INTR_STATUS__RST_COMP | INTR_STATUS__TIME_OUT;
 
 	clear_interrupts(denali);
 
@@ -181,16 +180,15 @@ static uint16_t denali_nand_reset(struct denali_nand_info *denali)
 	int i;
 
 	dev_dbg(denali->dev, "%s, Line %d, Function: %s\n",
-		       __FILE__, __LINE__, __func__);
+		__FILE__, __LINE__, __func__);
 
-	for (i = 0 ; i < denali->max_banks; i++)
+	for (i = 0; i < denali->max_banks; i++)
 		iowrite32(INTR_STATUS__RST_COMP | INTR_STATUS__TIME_OUT,
 		denali->flash_reg + INTR_STATUS(i));
 
-	for (i = 0 ; i < denali->max_banks; i++) {
+	for (i = 0; i < denali->max_banks; i++) {
 		iowrite32(1 << i, denali->flash_reg + DEVICE_RESET);
-		while (!(ioread32(denali->flash_reg +
-				INTR_STATUS(i)) &
+		while (!(ioread32(denali->flash_reg + INTR_STATUS(i)) &
 			(INTR_STATUS__RST_COMP | INTR_STATUS__TIME_OUT)))
 			cpu_relax();
 		if (ioread32(denali->flash_reg + INTR_STATUS(i)) &
@@ -201,7 +199,7 @@ static uint16_t denali_nand_reset(struct denali_nand_info *denali)
 
 	for (i = 0; i < denali->max_banks; i++)
 		iowrite32(INTR_STATUS__RST_COMP | INTR_STATUS__TIME_OUT,
-			denali->flash_reg + INTR_STATUS(i));
+			  denali->flash_reg + INTR_STATUS(i));
 
 	return PASS;
 }
@@ -235,7 +233,7 @@ static void nand_onfi_timing_set(struct denali_nand_info *denali,
 	uint16_t addr_2_data, re_2_we, re_2_re, we_2_re, cs_cnt;
 
 	dev_dbg(denali->dev, "%s, Line %d, Function: %s\n",
-		       __FILE__, __LINE__, __func__);
+		__FILE__, __LINE__, __func__);
 
 	en_lo = CEIL_DIV(Trp[mode], CLK_X);
 	en_hi = CEIL_DIV(Treh[mode], CLK_X);
@@ -255,9 +253,8 @@ static void nand_onfi_timing_set(struct denali_nand_info *denali,
 
 		data_invalid_rloh = (en_lo + en_hi) * CLK_X + Trloh[mode];
 
-		data_invalid =
-		    data_invalid_rhoh <
-		    data_invalid_rloh ? data_invalid_rhoh : data_invalid_rloh;
+		data_invalid = data_invalid_rhoh < data_invalid_rloh ?
+					data_invalid_rhoh : data_invalid_rloh;
 
 		dv_window = data_invalid - Trea[mode];
 
@@ -272,7 +269,7 @@ static void nand_onfi_timing_set(struct denali_nand_info *denali,
 
 	if (data_invalid - acc_clks * CLK_X < 2)
 		dev_warn(denali->dev, "%s, Line %d: Warning!\n",
-			__FILE__, __LINE__);
+			 __FILE__, __LINE__);
 
 	addr_2_data = CEIL_DIV(Tadl[mode], CLK_X);
 	re_2_we = CEIL_DIV(Trhw[mode], CLK_X);
@@ -406,9 +403,9 @@ static void get_hynix_nand_para(struct denali_nand_info *denali,
 		break;
 	default:
 		dev_warn(denali->dev,
-			"Spectra: Unknown Hynix NAND (Device ID: 0x%x)."
-			"Will use default parameter values instead.\n",
-			device_id);
+			 "Spectra: Unknown Hynix NAND (Device ID: 0x%x).\n"
+			 "Will use default parameter values instead.\n",
+			 device_id);
 	}
 }
 
@@ -425,8 +422,7 @@ static void find_valid_banks(struct denali_nand_info *denali)
 	for (i = 0; i < denali->max_banks; i++) {
 		index_addr(denali, MODE_11 | (i << 24) | 0, 0x90);
 		index_addr(denali, MODE_11 | (i << 24) | 1, 0);
-		index_addr_read_data(denali,
-				MODE_11 | (i << 24) | 2, &id[i]);
+		index_addr_read_data(denali, MODE_11 | (i << 24) | 2, &id[i]);
 
 		dev_dbg(denali->dev,
 			"Return 1st ID for bank[%d]: %x\n", i, id[i]);
@@ -450,8 +446,7 @@ static void find_valid_banks(struct denali_nand_info *denali)
 		 */
 		if (denali->total_used_banks != 1) {
 			dev_err(denali->dev,
-					"Sorry, Intel CE4100 only supports "
-					"a single NAND device.\n");
+				"Sorry, Intel CE4100 only supports a single NAND device.\n");
 			BUG();
 		}
 	}
@@ -489,10 +484,12 @@ static void detect_partition_feature(struct denali_nand_info *denali)
 			    +
 			    (ioread32(denali->flash_reg + MIN_BLK_ADDR(1)) &
 			    MIN_BLK_ADDR__VALUE);
-		} else
+		} else {
 			denali->fwblks = SPECTRA_START_BLOCK;
-	} else
+		}
+	} else {
 		denali->fwblks = SPECTRA_START_BLOCK;
+	}
 }
 
 static uint16_t denali_nand_timing_set(struct denali_nand_info *denali)
@@ -502,8 +499,7 @@ static uint16_t denali_nand_timing_set(struct denali_nand_info *denali)
 	uint8_t maf_id, device_id;
 	int i;
 
-	dev_dbg(denali->dev,
-			"%s, Line %d, Function: %s\n",
+	dev_dbg(denali->dev, "%s, Line %d, Function: %s\n",
 			__FILE__, __LINE__, __func__);
 
 	/*
@@ -532,7 +528,7 @@ static uint16_t denali_nand_timing_set(struct denali_nand_info *denali)
 	}
 
 	dev_info(denali->dev,
-			"Dump timing register values:"
+			"Dump timing register values:\n"
 			"acc_clks: %d, re_2_we: %d, re_2_re: %d\n"
 			"we_2_re: %d, addr_2_data: %d, rdwr_en_lo_cnt: %d\n"
 			"rdwr_en_hi_cnt: %d, cs_setup_cnt: %d\n",
@@ -563,7 +559,7 @@ static void denali_set_intr_modes(struct denali_nand_info *denali,
 					uint16_t INT_ENABLE)
 {
 	dev_dbg(denali->dev, "%s, Line %d, Function: %s\n",
-		       __FILE__, __LINE__, __func__);
+		__FILE__, __LINE__, __func__);
 
 	if (INT_ENABLE)
 		iowrite32(1, denali->flash_reg + GLOBAL_INT_ENABLE);
@@ -710,13 +706,13 @@ static uint32_t wait_for_irq(struct denali_nand_info *denali, uint32_t irq_mask)
 			spin_unlock_irq(&denali->irq_lock);
 			/* our interrupt was detected */
 			break;
-		} else {
-			/*
-			 * these are not the interrupts you are looking for -
-			 * need to wait again
-			 */
-			spin_unlock_irq(&denali->irq_lock);
 		}
+
+		/*
+		 * these are not the interrupts you are looking for -
+		 * need to wait again
+		 */
+		spin_unlock_irq(&denali->irq_lock);
 	} while (comp_res != 0);
 
 	if (comp_res == 0) {
@@ -744,8 +740,7 @@ static void setup_ecc_for_xfer(struct denali_nand_info *denali, bool ecc_en,
 
 	/* Enable spare area/ECC per user's request. */
 	iowrite32(ecc_en_flag, denali->flash_reg + ECC_ENABLE);
-	iowrite32(transfer_spare_flag,
-			denali->flash_reg + TRANSFER_SPARE_REG);
+	iowrite32(transfer_spare_flag, denali->flash_reg + TRANSFER_SPARE_REG);
 }
 
 /*
@@ -753,10 +748,8 @@ static void setup_ecc_for_xfer(struct denali_nand_info *denali, bool ecc_en,
  * controller's user guide for more information (section 4.2.3.6).
  */
 static int denali_send_pipeline_cmd(struct denali_nand_info *denali,
-							bool ecc_en,
-							bool transfer_spare,
-							int access_type,
-							int op)
+				    bool ecc_en, bool transfer_spare,
+				    int access_type, int op)
 {
 	int status = PASS;
 	uint32_t page_count = 1;
@@ -811,9 +804,8 @@ static int denali_send_pipeline_cmd(struct denali_nand_info *denali,
 
 			if (irq_status == 0) {
 				dev_err(denali->dev,
-						"cmd, page, addr on timeout "
-						"(0x%x, 0x%x, 0x%x)\n",
-						cmd, denali->page, addr);
+					"cmd, page, addr on timeout (0x%x, 0x%x, 0x%x)\n",
+					cmd, denali->page, addr);
 				status = FAIL;
 			} else {
 				cmd = MODE_01 | addr;
@@ -826,8 +818,7 @@ static int denali_send_pipeline_cmd(struct denali_nand_info *denali,
 
 /* helper function that simply writes a buffer to the flash */
 static int write_data_to_flash_mem(struct denali_nand_info *denali,
-							const uint8_t *buf,
-							int len)
+				   const uint8_t *buf, int len)
 {
 	uint32_t *buf32;
 	int i;
@@ -842,13 +833,12 @@ static int write_data_to_flash_mem(struct denali_nand_info *denali,
 	buf32 = (uint32_t *)buf;
 	for (i = 0; i < len / 4; i++)
 		iowrite32(*buf32++, denali->flash_mem + 0x10);
-	return i*4; /* intent is to return the number of bytes read */
+	return i * 4; /* intent is to return the number of bytes read */
 }
 
 /* helper function that simply reads a buffer from the flash */
 static int read_data_from_flash_mem(struct denali_nand_info *denali,
-								uint8_t *buf,
-								int len)
+				    uint8_t *buf, int len)
 {
 	uint32_t *buf32;
 	int i;
@@ -865,7 +855,7 @@ static int read_data_from_flash_mem(struct denali_nand_info *denali,
 	buf32 = (uint32_t *)buf;
 	for (i = 0; i < len / 4; i++)
 		*buf32++ = ioread32(denali->flash_mem + 0x10);
-	return i*4; /* intent is to return the number of bytes read */
+	return i * 4; /* intent is to return the number of bytes read */
 }
 
 /* writes OOB data to the device */
@@ -941,6 +931,7 @@ static void read_oob_data(struct mtd_info *mtd, uint8_t *buf, int page)
 static bool is_erased(uint8_t *buf, int len)
 {
 	int i;
+
 	for (i = 0; i < len; i++)
 		if (buf[i] != 0xFF)
 			return false;
@@ -990,6 +981,7 @@ static bool handle_ecc(struct denali_nand_info *denali, uint8_t *buf,
 				 */
 				if (err_byte < ECC_SECTOR_SIZE) {
 					int offset;
+
 					offset = (err_sector *
 							ECC_SECTOR_SIZE +
 							err_byte) *
@@ -1063,10 +1055,8 @@ static int write_page(struct mtd_info *mtd, struct nand_chip *chip,
 			const uint8_t *buf, bool raw_xfer)
 {
 	struct denali_nand_info *denali = mtd_to_denali(mtd);
-
 	dma_addr_t addr = denali->buf.dma_buf;
 	size_t size = denali->mtd.writesize + denali->mtd.oobsize;
-
 	uint32_t irq_status;
 	uint32_t irq_mask = INTR_STATUS__DMA_CMD_COMP |
 						INTR_STATUS__PROGRAM_FAIL;
@@ -1099,9 +1089,8 @@ static int write_page(struct mtd_info *mtd, struct nand_chip *chip,
 	irq_status = wait_for_irq(denali, irq_mask);
 
 	if (irq_status == 0) {
-		dev_err(denali->dev,
-				"timeout on write_page (type = %d)\n",
-				raw_xfer);
+		dev_err(denali->dev, "timeout on write_page (type = %d)\n",
+			raw_xfer);
 		denali->status = NAND_STATUS_FAIL;
 	}
 
@@ -1172,9 +1161,9 @@ static int denali_read_page(struct mtd_info *mtd, struct nand_chip *chip,
 	bool check_erased_page = false;
 
 	if (page != denali->page) {
-		dev_err(denali->dev, "IN %s: page %d is not"
-				" equal to denali->page %d, investigate!!",
-				__func__, page, denali->page);
+		dev_err(denali->dev,
+			"IN %s: page %d is not equal to denali->page %d",
+			__func__, page, denali->page);
 		BUG();
 	}
 
@@ -1214,16 +1203,14 @@ static int denali_read_page_raw(struct mtd_info *mtd, struct nand_chip *chip,
 				uint8_t *buf, int oob_required, int page)
 {
 	struct denali_nand_info *denali = mtd_to_denali(mtd);
-
 	dma_addr_t addr = denali->buf.dma_buf;
 	size_t size = denali->mtd.writesize + denali->mtd.oobsize;
-
 	uint32_t irq_mask = INTR_STATUS__DMA_CMD_COMP;
 
 	if (page != denali->page) {
-		dev_err(denali->dev, "IN %s: page %d is not"
-				" equal to denali->page %d, investigate!!",
-				__func__, page, denali->page);
+		dev_err(denali->dev,
+			"IN %s: page %d is not equal to denali->page %d",
+			__func__, page, denali->page);
 		BUG();
 	}
 
@@ -1272,6 +1259,7 @@ static int denali_waitfunc(struct mtd_info *mtd, struct nand_chip *chip)
 {
 	struct denali_nand_info *denali = mtd_to_denali(mtd);
 	int status = denali->status;
+
 	denali->status = 0;
 
 	return status;
@@ -1321,9 +1309,7 @@ static void denali_cmdfunc(struct mtd_info *mtd, unsigned int cmd, int col,
 		index_addr(denali, addr | 0, 0x90);
 		index_addr(denali, addr | 1, 0);
 		for (i = 0; i < 8; i++) {
-			index_addr_read_data(denali,
-						addr | 2,
-						&id);
+			index_addr_read_data(denali, addr | 2, &id);
 			write_byte_to_buf(denali, id);
 		}
 		break;
@@ -1348,8 +1334,8 @@ static int denali_ecc_calculate(struct mtd_info *mtd, const uint8_t *data,
 				uint8_t *ecc_code)
 {
 	struct denali_nand_info *denali = mtd_to_denali(mtd);
-	dev_err(denali->dev,
-			"denali_ecc_calculate called unexpectedly\n");
+
+	dev_err(denali->dev, "denali_ecc_calculate called unexpectedly\n");
 	BUG();
 	return -EIO;
 }
@@ -1358,8 +1344,8 @@ static int denali_ecc_correct(struct mtd_info *mtd, uint8_t *data,
 				uint8_t *read_ecc, uint8_t *calc_ecc)
 {
 	struct denali_nand_info *denali = mtd_to_denali(mtd);
-	dev_err(denali->dev,
-			"denali_ecc_correct called unexpectedly\n");
+
+	dev_err(denali->dev, "denali_ecc_correct called unexpectedly\n");
 	BUG();
 	return -EIO;
 }
@@ -1367,8 +1353,8 @@ static int denali_ecc_correct(struct mtd_info *mtd, uint8_t *data,
 static void denali_ecc_hwctl(struct mtd_info *mtd, int mode)
 {
 	struct denali_nand_info *denali = mtd_to_denali(mtd);
-	dev_err(denali->dev,
-			"denali_ecc_hwctl called unexpectedly\n");
+
+	dev_err(denali->dev, "denali_ecc_hwctl called unexpectedly\n");
 	BUG();
 }
 /* end NAND core entry points */
@@ -1596,8 +1582,7 @@ int denali_init(struct denali_nand_info *denali)
 	} else if (denali->mtd.oobsize < (denali->bbtskipbytes +
 			ECC_8BITS * (denali->mtd.writesize /
 			ECC_SECTOR_SIZE))) {
-		pr_err("Your NAND chip OOB is not large enough to \
-				contain 8bit ECC correction codes");
+		pr_err("Your NAND chip OOB is not large enough to contain 8bit ECC correction codes");
 		goto failed_req_irq;
 	} else {
 		denali->nand.ecc.strength = 8;
@@ -1621,8 +1606,7 @@ int denali_init(struct denali_nand_info *denali)
 	 * contained by each nand chip. blksperchip will help driver to
 	 * know how many blocks is taken by FW.
 	 */
-	denali->totalblks = denali->mtd.size >>
-				denali->nand.phys_erase_shift;
+	denali->totalblks = denali->mtd.size >> denali->nand.phys_erase_shift;
 	denali->blksperchip = denali->totalblks / denali->nand.numchips;
 
 	/*
@@ -1669,7 +1653,7 @@ void denali_remove(struct denali_nand_info *denali)
 {
 	denali_irq_cleanup(denali->irq, denali);
 	dma_unmap_single(denali->dev, denali->buf.dma_buf,
-			denali->mtd.writesize + denali->mtd.oobsize,
-			DMA_BIDIRECTIONAL);
+			 denali->mtd.writesize + denali->mtd.oobsize,
+			 DMA_BIDIRECTIONAL);
 }
 EXPORT_SYMBOL(denali_remove);
-- 
1.9.1

