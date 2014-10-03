Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934274AbaJDA5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:57:30 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:46037 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbaJCVbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:31:40 -0400
From: Giedrius Statkevicius <giedrius.statkevicius@gmail.com>
To: gregkh@linuxfoundation.org
Cc: micky_ching@realsil.com.cn, fabio.falzoi84@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] staging: rts5208: align divided lines to opening paranthesis
Date: Sat,  4 Oct 2014 00:31:19 +0300
Message-Id: <13eef93ea8de7a837ed3893b812aa46e7c0e06b3.1412369676.git.giedrius.statkevicius@gmail.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <cover.1412369676.git.giedrius.statkevicius@gmail.com>
References: <cover.1412369676.git.giedrius.statkevicius@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Giedrius Statkevičius <giedrius.statkevicius@gmail.com>

Make all divided lines aligned to the opening paranthesis.

Basically makes all lines aligned to the opening paranthesis to make the
code more readable and it also gets rid of a lot of checkpatch.pl
"checks".

Signed-off-by: Giedrius Statkevičius <giedrius.statkevicius@gmail.com>
---
 drivers/staging/rts5208/rtsx_chip.c | 87 +++++++++++++++++++------------------
 1 file changed, 45 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/rts5208/rtsx_chip.c b/drivers/staging/rts5208/rtsx_chip.c
index 146b337..b47eade 100644
--- a/drivers/staging/rts5208/rtsx_chip.c
+++ b/drivers/staging/rts5208/rtsx_chip.c
@@ -126,10 +126,11 @@ static int rtsx_pre_handle_sdio_old(struct rtsx_chip *chip)
 	if (chip->ignore_sd && CHK_SDIO_EXIST(chip)) {
 		if (chip->asic_code) {
 			RTSX_WRITE_REG(chip, CARD_PULL_CTL5, 0xFF,
-				MS_INS_PU | SD_WP_PU | SD_CD_PU | SD_CMD_PU);
+				       MS_INS_PU | SD_WP_PU |
+				       SD_CD_PU | SD_CMD_PU);
 		} else {
 			RTSX_WRITE_REG(chip, FPGA_PULL_CTL, 0xFF,
-				FPGA_SD_PULL_CTL_EN);
+				       FPGA_SD_PULL_CTL_EN);
 		}
 		RTSX_WRITE_REG(chip, CARD_SHARE_MODE, 0xFF, CARD_SHARE_48_SD);
 
@@ -137,7 +138,7 @@ static int rtsx_pre_handle_sdio_old(struct rtsx_chip *chip)
 		RTSX_WRITE_REG(chip, 0xFF2C, 0x01, 0x01);
 
 		RTSX_WRITE_REG(chip, SDIO_CTRL, 0xFF,
-			SDIO_BUS_CTRL | SDIO_CD_CTRL);
+			       SDIO_BUS_CTRL | SDIO_CD_CTRL);
 
 		chip->sd_int = 1;
 		chip->sd_io = 1;
@@ -201,7 +202,7 @@ static int rtsx_pre_handle_sdio_new(struct rtsx_chip *chip)
 					TRACE_RET(chip, STATUS_FAIL);
 			} else {
 				RTSX_WRITE_REG(chip, FPGA_PULL_CTL,
-					FPGA_SD_PULL_CTL_BIT | 0x20, 0);
+					       FPGA_SD_PULL_CTL_BIT | 0x20, 0);
 			}
 			retval = card_share_mode(chip, SD_CARD);
 			if (retval != STATUS_SUCCESS)
@@ -268,7 +269,7 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 
 #ifdef LED_AUTO_BLINK
 	RTSX_WRITE_REG(chip, CARD_AUTO_BLINK, 0xFF,
-			LED_BLINK_SPEED | BLINK_EN | LED_GPIO0);
+		       LED_BLINK_SPEED | BLINK_EN | LED_GPIO0);
 #endif
 
 	if (chip->asic_code) {
@@ -297,7 +298,7 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 		} else {
 			if (CHECK_PID(chip, 0x5208))
 				RTSX_WRITE_REG(chip, ASPM_FORCE_CTL,
-					0xFF, 0x3F);
+					       0xFF, 0x3F);
 
 			retval = rtsx_write_config_byte(chip, LCTLR,
 							chip->aspm_l0s_l1_en);
@@ -337,10 +338,10 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 	if (CHK_SDIO_EXIST(chip)) {
 		if (CHECK_PID(chip, 0x5288))
 			retval = rtsx_write_cfg_dw(chip, 2, 0xC0,
-						0xFF00, 0x0100);
+						   0xFF00, 0x0100);
 		else
 			retval = rtsx_write_cfg_dw(chip, 1, 0xC0,
-						0xFF00, 0x0100);
+						   0xFF00, 0x0100);
 
 		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
@@ -381,7 +382,7 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 				reg &= 0xFE7F;
 				reg |= 0x80;
 				retval = rtsx_write_phy_register(chip, 0x00,
-								reg);
+								 reg);
 				if (retval != STATUS_SUCCESS)
 					TRACE_RET(chip, STATUS_FAIL);
 
@@ -392,13 +393,13 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 
 				reg &= 0xFFF7;
 				retval = rtsx_write_phy_register(chip, 0x1C,
-								reg);
+								 reg);
 				if (retval != STATUS_SUCCESS)
 					TRACE_RET(chip, STATUS_FAIL);
 			}
 
 			if (chip->driver_first_load &&
-				(chip->ic_version < IC_VER_C))
+			    (chip->ic_version < IC_VER_C))
 				rtsx_calibration(chip);
 
 		} else {
@@ -434,7 +435,7 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 	} else {
 		chip->sd_io = 0;
 		RTSX_WRITE_REG(chip, SDIO_CTRL, SDIO_BUS_CTRL | SDIO_CD_CTRL,
-			0);
+			       0);
 	}
 
 nextcard:
@@ -475,10 +476,10 @@ nextcard:
 
 	if (chip->ft2_fast_mode) {
 		RTSX_WRITE_REG(chip, CARD_PWR_CTL, 0xFF,
-			MS_PARTIAL_POWER_ON | SD_PARTIAL_POWER_ON);
+			       MS_PARTIAL_POWER_ON | SD_PARTIAL_POWER_ON);
 		udelay(chip->pmos_pwr_on_interval);
 		RTSX_WRITE_REG(chip, CARD_PWR_CTL, 0xFF,
-			MS_POWER_ON | SD_POWER_ON);
+			       MS_POWER_ON | SD_POWER_ON);
 
 		wait_timeout(200);
 	}
@@ -847,8 +848,8 @@ static void rtsx_monitor_aspm_config(struct rtsx_chip *chip)
 			chip->sdio_aspm = 0;
 		}
 		rtsx_write_register(chip, ASPM_FORCE_CTL, 0xFF,
-				0x30 | chip->aspm_level[0] |
-				(chip->aspm_level[1] << 2));
+				    0x30 | chip->aspm_level[0] |
+				    (chip->aspm_level[1] << 2));
 	}
 }
 
@@ -945,7 +946,7 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 
 #ifdef SUPPORT_SDIO_ASPM
 		if (CHK_SDIO_EXIST(chip) && !CHK_SDIO_IGNORED(chip) &&
-				chip->aspm_l0s_l1_en && chip->dynamic_aspm) {
+		    chip->aspm_l0s_l1_en && chip->dynamic_aspm) {
 			if (chip->sd_io) {
 				dynamic_configure_sdio_aspm(chip);
 			} else {
@@ -1009,7 +1010,7 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 		if (chip->ocp_stat & (SD_OC_NOW | SD_OC_EVER)) {
 			if (chip->card_exist & SD_CARD) {
 				rtsx_write_register(chip, CARD_OE, SD_OUTPUT_EN,
-						0);
+						    0);
 				card_power_off(chip, SD_CARD);
 				chip->card_fail |= SD_CARD;
 			}
@@ -1017,7 +1018,7 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 		if (chip->ocp_stat & (MS_OC_NOW | MS_OC_EVER)) {
 			if (chip->card_exist & MS_CARD) {
 				rtsx_write_register(chip, CARD_OE, MS_OUTPUT_EN,
-						0);
+						    0);
 				card_power_off(chip, MS_CARD);
 				chip->card_fail |= MS_CARD;
 			}
@@ -1028,15 +1029,15 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 				chip->ocp_stat);
 			if (chip->card_exist & SD_CARD) {
 				rtsx_write_register(chip, CARD_OE, SD_OUTPUT_EN,
-						0);
+						    0);
 				chip->card_fail |= SD_CARD;
 			} else if (chip->card_exist & MS_CARD) {
 				rtsx_write_register(chip, CARD_OE, MS_OUTPUT_EN,
-						0);
+						    0);
 				chip->card_fail |= MS_CARD;
 			} else if (chip->card_exist & XD_CARD) {
 				rtsx_write_register(chip, CARD_OE, XD_OUTPUT_EN,
-						0);
+						    0);
 				chip->card_fail |= XD_CARD;
 			}
 			card_power_off(chip, SD_CARD);
@@ -1046,7 +1047,7 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 
 delink_stage:
 	if (chip->auto_delink_en && chip->auto_delink_allowed &&
-		!chip->card_ready && !chip->card_ejected && !chip->sd_io) {
+	    !chip->card_ready && !chip->card_ejected && !chip->sd_io) {
 		int enter_L1 = chip->auto_delink_in_L1 && (
 			chip->aspm_l0s_l1_en || chip->ss_en);
 		int delink_stage1_cnt = chip->delink_stage1_step;
@@ -1069,8 +1070,8 @@ delink_stage:
 						rtsx_write_register(chip, HOST_SLEEP_STATE, 0x03, 1);
 
 					rtsx_write_register(chip,
-							CHANGE_LINK_STATE, 0x0A,
-							0x0A);
+							    CHANGE_LINK_STATE,
+							    0x0A, 0x0A);
 
 					if (enter_L1)
 						rtsx_enter_L1(chip);
@@ -1082,7 +1083,9 @@ delink_stage:
 					if (enter_L1)
 						rtsx_write_register(chip, HOST_SLEEP_STATE, 0x03, 1);
 
-					rtsx_write_register(chip, CHANGE_LINK_STATE, 0x02, 0x02);
+					rtsx_write_register(chip,
+							    CHANGE_LINK_STATE,
+							    0x02, 0x02);
 
 					if (enter_L1)
 						rtsx_enter_L1(chip);
@@ -1099,7 +1102,7 @@ delink_stage:
 					rtsx_set_phy_reg_bit(chip, 0x1C, 2);
 
 				rtsx_write_register(chip, CHANGE_LINK_STATE,
-						0x0A, 0x0A);
+						    0x0A, 0x0A);
 			}
 
 			chip->auto_delink_cnt++;
@@ -1203,7 +1206,7 @@ int rtsx_read_register(struct rtsx_chip *chip, u16 addr, u8 *data)
 }
 
 int rtsx_write_cfg_dw(struct rtsx_chip *chip, u8 func_no, u16 addr, u32 mask,
-		u32 val)
+		      u32 val)
 {
 	u8 mode = 0, tmp;
 	int i;
@@ -1263,7 +1266,7 @@ int rtsx_read_cfg_dw(struct rtsx_chip *chip, u8 func_no, u16 addr, u32 *val)
 }
 
 int rtsx_write_cfg_seq(struct rtsx_chip *chip, u8 func, u16 addr, u8 *buf,
-		int len)
+		       int len)
 {
 	u32 *data, *mask;
 	u16 offset = addr % 4;
@@ -1308,7 +1311,7 @@ int rtsx_write_cfg_seq(struct rtsx_chip *chip, u8 func, u16 addr, u8 *buf,
 
 	for (i = 0; i < dw_len; i++) {
 		retval = rtsx_write_cfg_dw(chip, func, aligned_addr + i * 4,
-					mask[i], data[i]);
+					   mask[i], data[i]);
 		if (retval != STATUS_SUCCESS) {
 			vfree(data);
 			vfree(mask);
@@ -1323,7 +1326,7 @@ int rtsx_write_cfg_seq(struct rtsx_chip *chip, u8 func, u16 addr, u8 *buf,
 }
 
 int rtsx_read_cfg_seq(struct rtsx_chip *chip, u8 func, u16 addr, u8 *buf,
-		int len)
+		      int len)
 {
 	u32 *data;
 	u16 offset = addr % 4;
@@ -1344,7 +1347,7 @@ int rtsx_read_cfg_seq(struct rtsx_chip *chip, u8 func, u16 addr, u8 *buf,
 
 	for (i = 0; i < dw_len; i++) {
 		retval = rtsx_read_cfg_dw(chip, func, aligned_addr + i * 4,
-					data + i);
+					  data + i);
 		if (retval != STATUS_SUCCESS) {
 			vfree(data);
 			TRACE_RET(chip, STATUS_FAIL);
@@ -1650,7 +1653,7 @@ int rtsx_pre_handle_interrupt(struct rtsx_chip *chip)
 	chip->int_reg = rtsx_readl(chip, RTSX_BIPR);
 
 	if (((chip->int_reg & int_enable) == 0) ||
-		(chip->int_reg == 0xFFFFFFFF))
+	    (chip->int_reg == 0xFFFFFFFF))
 		return STATUS_FAIL;
 
 	status = chip->int_reg &= (int_enable | 0x7FFFFF);
@@ -1756,14 +1759,14 @@ void rtsx_do_before_power_down(struct rtsx_chip *chip, int pm_stat)
 	if (pm_stat == PM_S1) {
 		dev_dbg(rtsx_dev(chip), "Host enter S1\n");
 		rtsx_write_register(chip, HOST_SLEEP_STATE, 0x03,
-				HOST_ENTER_S1);
+				    HOST_ENTER_S1);
 	} else if (pm_stat == PM_S3) {
 		if (chip->s3_pwr_off_delay > 0)
 			wait_timeout(chip->s3_pwr_off_delay);
 
 		dev_dbg(rtsx_dev(chip), "Host enter S3\n");
 		rtsx_write_register(chip, HOST_SLEEP_STATE, 0x03,
-				HOST_ENTER_S3);
+				    HOST_ENTER_S3);
 	}
 
 	if (chip->do_delink_before_power_down && chip->auto_delink_en)
@@ -1786,10 +1789,10 @@ void rtsx_enable_aspm(struct rtsx_chip *chip)
 			rtsx_write_phy_register(chip, 0x07, 0);
 		if (CHECK_PID(chip, 0x5208)) {
 			rtsx_write_register(chip, ASPM_FORCE_CTL, 0xF3,
-				0x30 | chip->aspm_level[0]);
+					    0x30 | chip->aspm_level[0]);
 		} else {
 			rtsx_write_config_byte(chip, LCTLR,
-					chip->aspm_l0s_l1_en);
+					       chip->aspm_l0s_l1_en);
 		}
 
 		if (CHK_SDIO_EXIST(chip)) {
@@ -1797,10 +1800,10 @@ void rtsx_enable_aspm(struct rtsx_chip *chip)
 
 			if (CHECK_PID(chip, 0x5288))
 				rtsx_write_cfg_dw(chip, 2, 0xC0,
-						0xFFFF, val);
+						  0xFFFF, val);
 			else
 				rtsx_write_cfg_dw(chip, 1, 0xC0,
-					0xFFFF, val);
+						  0xFFFF, val);
 		}
 	}
 }
@@ -1818,7 +1821,7 @@ void rtsx_disable_aspm(struct rtsx_chip *chip)
 			rtsx_write_phy_register(chip, 0x07, 0x0129);
 		if (CHECK_PID(chip, 0x5208))
 			rtsx_write_register(chip, ASPM_FORCE_CTL,
-					0xF3, 0x30);
+					    0xF3, 0x30);
 		else
 			rtsx_write_config_byte(chip, LCTLR, 0x00);
 
@@ -1885,7 +1888,7 @@ int rtsx_write_ppbuf(struct rtsx_chip *chip, u8 *buf, int buf_len)
 
 		for (j = 0; j < 256; j++) {
 			rtsx_add_cmd(chip, WRITE_REG_CMD, reg_addr++, 0xFF,
-				*ptr);
+				     *ptr);
 			ptr++;
 		}
 
@@ -1899,7 +1902,7 @@ int rtsx_write_ppbuf(struct rtsx_chip *chip, u8 *buf, int buf_len)
 
 		for (j = 0; j < buf_len%256; j++) {
 			rtsx_add_cmd(chip, WRITE_REG_CMD, reg_addr++, 0xFF,
-				*ptr);
+				     *ptr);
 			ptr++;
 		}
 
-- 
2.1.2

