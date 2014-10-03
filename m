Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbaJCQQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 12:16:33 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:49335 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbaJCQQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 12:16:27 -0400
Message-ID: <542ECBCD.3050209@gmail.com>
Date: Fri, 03 Oct 2014 19:16:13 +0300
From: Giedrius Statkevicius <giedrius.statkevicius@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: micky_ching@realsil.com.cn, fabio.falzoi84@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] staging: rts5208: Clean up coding style in rtsx_chip.c
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the second line of a divided line match the opening paranthesis.
Combine two if's in form of 'if (a) if (b) { [...] }' into one to lower the indentation level.
To further lower indentation level and make the code more concise use the ternary operator where possible and sensible.
Make the names of labels all lower case to avoid Camel Case.
Remove unnecessary parantheses around variables that are after a dereference operator i.e. &(a) => &a
Switch the if condition around in 'if (0 == (value & (1 << bit))) {' to make it have the same form as the rest of the code.
Remove unnecessary braces in rtsx_enable_aspm() around one statement

After this patch checkpatch.pl without --strict doesn't complain about rtsx_chip.c at all and with --strict it only complains about the unmatched parantheses.
I am reluctant to move that code with unmatched parantheses into another function because I don't have the hardware needed to test this driver and don't have
enough experience to do it properly. Doing so would just probably hide the other problems this code has. My patch should be purely about changing the code style without
creating more functions and moving code to them. 

This patch is against Greg KH's staging-next tree.

Signed-off-by: Giedrius Statkevicius <giedrius.statkevicius@gmail.com>
---
Changes in v3:
  - Change blocks that have form of if (a) { b = 1; } else { b = 0; } to 'b = a ? 1 : 0;' and use ternary operator other where possible and sensible to reduce the indentation level
  - Align more lines to the opening paranthesis
  - Combined more if's into one to reduce indentation
  - Converted the two labels that were written in Camel Case to lower case
  - Removed parantheses that were around a variable after a dereference operator: &(a) => &a
  - Switched one if condition to make it have the form of 'if (some_calculation == value)' instead of a unorthodox 'if (value == some_calculation)'
Thank you Joe Perches for the tips.

Changes in v2:
  - Combines two if statements into one in rtsx_reset_chip() (thanks Dan Carpenter)
  - Aligns the second line of a if statement to the opening parenthesis in rtsx_polling_func() (thanks Dan Carpenter)

 drivers/staging/rts5208/rtsx_chip.c | 321 +++++++++++++++---------------------
 1 file changed, 135 insertions(+), 186 deletions(-)

diff --git a/drivers/staging/rts5208/rtsx_chip.c b/drivers/staging/rts5208/rtsx_chip.c
index a7ade8b..92a9225 100644
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
@@ -289,17 +290,16 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 	/* Enable ASPM */
 	if (chip->aspm_l0s_l1_en) {
 		if (chip->dynamic_aspm) {
-			if (CHK_SDIO_EXIST(chip)) {
-				if (CHECK_PID(chip, 0x5288)) {
-					retval = rtsx_write_cfg_dw(chip, 2, 0xC0, 0xFF, chip->aspm_l0s_l1_en);
-					if (retval != STATUS_SUCCESS)
-						TRACE_RET(chip, STATUS_FAIL);
-				}
+			if (CHK_SDIO_EXIST(chip) && CHECK_PID(chip, 0x5288)) {
+				retval = rtsx_write_cfg_dw(chip, 2, 0xC0, 0xFF,
+						   chip->aspm_l0s_l1_en);
+				if (retval != STATUS_SUCCESS)
+					TRACE_RET(chip, STATUS_FAIL);
 			}
 		} else {
 			if (CHECK_PID(chip, 0x5208))
 				RTSX_WRITE_REG(chip, ASPM_FORCE_CTL,
-					0xFF, 0x3F);
+					       0xFF, 0x3F);
 
 			retval = rtsx_write_config_byte(chip, LCTLR,
 							chip->aspm_l0s_l1_en);
@@ -309,14 +309,13 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 			chip->aspm_level[0] = chip->aspm_l0s_l1_en;
 			if (CHK_SDIO_EXIST(chip)) {
 				chip->aspm_level[1] = chip->aspm_l0s_l1_en;
-				if (CHECK_PID(chip, 0x5288))
-					retval = rtsx_write_cfg_dw(chip, 2, 0xC0, 0xFF, chip->aspm_l0s_l1_en);
-				else
-					retval = rtsx_write_cfg_dw(chip, 1, 0xC0, 0xFF, chip->aspm_l0s_l1_en);
+				retval = rtsx_write_cfg_dw(chip,
+						CHECK_PID(chip, 0x5288) ? 2 : 1,
+						0xC0, 0xFF,
+						chip->aspm_l0s_l1_en);
 
 				if (retval != STATUS_SUCCESS)
 					TRACE_RET(chip, STATUS_FAIL);
-
 			}
 
 			chip->aspm_enabled = 1;
@@ -338,30 +337,22 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 		TRACE_RET(chip, STATUS_FAIL);
 
 	if (CHK_SDIO_EXIST(chip)) {
-		if (CHECK_PID(chip, 0x5288))
-			retval = rtsx_write_cfg_dw(chip, 2, 0xC0,
-						0xFF00, 0x0100);
-		else
-			retval = rtsx_write_cfg_dw(chip, 1, 0xC0,
-						0xFF00, 0x0100);
+		retval = rtsx_write_cfg_dw(chip,
+					   CHECK_PID(chip, 0x5288) ? 2 : 1,
+					   0xC0, 0xFF00, 0x0100);
 
 		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-
 	}
 
-	if (CHECK_PID(chip, 0x5288)) {
-		if (!CHK_SDIO_EXIST(chip)) {
-			retval = rtsx_write_cfg_dw(chip, 2, 0xC0, 0xFFFF,
-						0x0103);
-			if (retval != STATUS_SUCCESS)
-				TRACE_RET(chip, STATUS_FAIL);
-
-			retval = rtsx_write_cfg_dw(chip, 2, 0x84, 0xFF, 0x03);
-			if (retval != STATUS_SUCCESS)
-				TRACE_RET(chip, STATUS_FAIL);
+	if (CHECK_PID(chip, 0x5288) && !CHK_SDIO_EXIST(chip)) {
+		retval = rtsx_write_cfg_dw(chip, 2, 0xC0, 0xFFFF, 0x0103);
+		if (retval != STATUS_SUCCESS)
+			TRACE_RET(chip, STATUS_FAIL);
 
-		}
+		retval = rtsx_write_cfg_dw(chip, 2, 0x84, 0xFF, 0x03);
+		if (retval != STATUS_SUCCESS)
+			TRACE_RET(chip, STATUS_FAIL);
 	}
 
 	RTSX_WRITE_REG(chip, IRQSTAT0, LINK_RDY_INT, LINK_RDY_INT);
@@ -389,7 +380,7 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 				reg &= 0xFE7F;
 				reg |= 0x80;
 				retval = rtsx_write_phy_register(chip, 0x00,
-								reg);
+								 reg);
 				if (retval != STATUS_SUCCESS)
 					TRACE_RET(chip, STATUS_FAIL);
 
@@ -400,14 +391,13 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 
 				reg &= 0xFFF7;
 				retval = rtsx_write_phy_register(chip, 0x1C,
-								reg);
+								 reg);
 				if (retval != STATUS_SUCCESS)
 					TRACE_RET(chip, STATUS_FAIL);
-
 			}
 
 			if (chip->driver_first_load &&
-				(chip->ic_version < IC_VER_C))
+			    (chip->ic_version < IC_VER_C))
 				rtsx_calibration(chip);
 
 		} else {
@@ -422,7 +412,7 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 	chip->int_reg = rtsx_readl(chip, RTSX_BIPR);
 
 	if (chip->hw_bypass_sd)
-		goto NextCard;
+		goto nextcard;
 	dev_dbg(rtsx_dev(chip), "In %s, chip->int_reg = 0x%x\n", __func__,
 		chip->int_reg);
 	if (chip->int_reg & SD_EXIST) {
@@ -443,10 +433,10 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 	} else {
 		chip->sd_io = 0;
 		RTSX_WRITE_REG(chip, SDIO_CTRL, SDIO_BUS_CTRL | SDIO_CD_CTRL,
-			0);
+			       0);
 	}
 
-NextCard:
+nextcard:
 	if (chip->int_reg & XD_EXIST)
 		chip->need_reset |= XD_CARD;
 	if (chip->int_reg & MS_EXIST)
@@ -484,10 +474,10 @@ NextCard:
 
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
@@ -540,10 +530,7 @@ static int rts5208_init(struct rtsx_chip *chip)
 
 	RTSX_WRITE_REG(chip, CLK_SEL, 0x03, 0x03);
 	RTSX_READ_REG(chip, CLK_SEL, &val);
-	if (val == 0)
-		chip->asic_code = 1;
-	else
-		chip->asic_code = 0;
+	chip->asic_code = val == 0 ? 1 : 0;
 
 	if (chip->asic_code) {
 		retval = rtsx_read_phy_register(chip, 0x1C, &reg);
@@ -553,10 +540,7 @@ static int rts5208_init(struct rtsx_chip *chip)
 		dev_dbg(rtsx_dev(chip), "Value of phy register 0x1C is 0x%x\n",
 			reg);
 		chip->ic_version = (reg >> 4) & 0x07;
-		if (reg & PHY_DEBUG_MODE)
-			chip->phy_debug_mode = 1;
-		else
-			chip->phy_debug_mode = 0;
+		chip->phy_debug_mode = reg & PHY_DEBUG_MODE ? 1 : 0;
 
 	} else {
 		RTSX_READ_REG(chip, 0xFE80, &val);
@@ -566,16 +550,10 @@ static int rts5208_init(struct rtsx_chip *chip)
 
 	RTSX_READ_REG(chip, PDINFO, &val);
 	dev_dbg(rtsx_dev(chip), "PDINFO: 0x%x\n", val);
-	if (val & AUX_PWR_DETECTED)
-		chip->aux_pwr_exist = 1;
-	else
-		chip->aux_pwr_exist = 0;
+	chip->aux_pwr_exist = val & AUX_PWR_DETECTED ? 1 : 0;
 
 	RTSX_READ_REG(chip, 0xFE50, &val);
-	if (val & 0x01)
-		chip->hw_bypass_sd = 1;
-	else
-		chip->hw_bypass_sd = 0;
+	chip->hw_bypass_sd = val & 0x01 ? 1 : 0;
 
 	rtsx_read_config_byte(chip, 0x0E, &val);
 	if (val & 0x80)
@@ -585,10 +563,7 @@ static int rts5208_init(struct rtsx_chip *chip)
 
 	if (chip->use_hw_setting) {
 		RTSX_READ_REG(chip, CHANGE_LINK_STATE, &val);
-		if (val & 0x80)
-			chip->auto_delink_en = 1;
-		else
-			chip->auto_delink_en = 0;
+		chip->auto_delink_en = val & 0x80 ? 1 : 0;
 	}
 
 	return STATUS_SUCCESS;
@@ -602,20 +577,14 @@ static int rts5288_init(struct rtsx_chip *chip)
 
 	RTSX_WRITE_REG(chip, CLK_SEL, 0x03, 0x03);
 	RTSX_READ_REG(chip, CLK_SEL, &val);
-	if (val == 0)
-		chip->asic_code = 1;
-	else
-		chip->asic_code = 0;
+	chip->asic_code = val == 0 ? 1 : 0;
 
 	chip->ic_version = 0;
 	chip->phy_debug_mode = 0;
 
 	RTSX_READ_REG(chip, PDINFO, &val);
 	dev_dbg(rtsx_dev(chip), "PDINFO: 0x%x\n", val);
-	if (val & AUX_PWR_DETECTED)
-		chip->aux_pwr_exist = 1;
-	else
-		chip->aux_pwr_exist = 0;
+	chip->aux_pwr_exist = val & AUX_PWR_DETECTED ? 1 : 0;
 
 	RTSX_READ_REG(chip, CARD_SHARE_MODE, &val);
 	dev_dbg(rtsx_dev(chip), "CARD_SHARE_MODE: 0x%x\n", val);
@@ -625,10 +594,7 @@ static int rts5288_init(struct rtsx_chip *chip)
 		chip->baro_pkg = LQFP;
 
 	RTSX_READ_REG(chip, 0xFE5A, &val);
-	if (val & 0x10)
-		chip->hw_bypass_sd = 1;
-	else
-		chip->hw_bypass_sd = 0;
+	chip->hw_bypass_sd = val & 0x10 ? 1 : 0;
 
 	retval = rtsx_read_cfg_dw(chip, 0, 0x718, &lval);
 	if (retval != STATUS_SUCCESS)
@@ -643,16 +609,12 @@ static int rts5288_init(struct rtsx_chip *chip)
 
 	if (chip->use_hw_setting) {
 		RTSX_READ_REG(chip, CHANGE_LINK_STATE, &val);
-		if (val & 0x80)
-			chip->auto_delink_en = 1;
-		else
-			chip->auto_delink_en = 0;
+		chip->auto_delink_en = val & 0x80 ? 1 : 0;
 
 		if (CHECK_BARO_PKG(chip, LQFP))
 			chip->lun_mode = SD_MS_1LUN;
 		else
 			chip->lun_mode = DEFAULT_SINGLE;
-
 	}
 
 	return STATUS_SUCCESS;
@@ -660,9 +622,9 @@ static int rts5288_init(struct rtsx_chip *chip)
 
 int rtsx_init_chip(struct rtsx_chip *chip)
 {
-	struct sd_info *sd_card = &(chip->sd_card);
-	struct xd_info *xd_card = &(chip->xd_card);
-	struct ms_info *ms_card = &(chip->ms_card);
+	struct sd_info *sd_card = &chip->sd_card;
+	struct xd_info *xd_card = &chip->xd_card;
+	struct ms_info *ms_card = &chip->ms_card;
 	int retval;
 	unsigned int i;
 
@@ -740,7 +702,6 @@ int rtsx_init_chip(struct rtsx_chip *chip)
 		retval = rts5288_init(chip);
 		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-
 	}
 
 	if (chip->ss_en == 2)
@@ -842,7 +803,6 @@ static void rtsx_monitor_aspm_config(struct rtsx_chip *chip)
 	} else {
 		if (reg0 & 0x03)
 			maybe_support_aspm = 1;
-
 	}
 
 	if (reg_changed) {
@@ -859,15 +819,15 @@ static void rtsx_monitor_aspm_config(struct rtsx_chip *chip)
 			chip->sdio_aspm = 0;
 		}
 		rtsx_write_register(chip, ASPM_FORCE_CTL, 0xFF,
-				0x30 | chip->aspm_level[0] |
-				(chip->aspm_level[1] << 2));
+				    0x30 | chip->aspm_level[0] |
+				    (chip->aspm_level[1] << 2));
 	}
 }
 
 void rtsx_polling_func(struct rtsx_chip *chip)
 {
 #ifdef SUPPORT_SD_LOCK
-	struct sd_info *sd_card = &(chip->sd_card);
+	struct sd_info *sd_card = &chip->sd_card;
 #endif
 	int ss_allowed;
 
@@ -875,7 +835,7 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 		return;
 
 	if (rtsx_chk_stat(chip, RTSX_STAT_DELINK))
-		goto Delink_Stage;
+		goto delink_stage;
 
 	if (chip->polling_config) {
 		u8 val;
@@ -888,7 +848,7 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 
 #ifdef SUPPORT_OCP
 	if (chip->ocp_int) {
-		rtsx_read_register(chip, OCPSTAT, &(chip->ocp_stat));
+		rtsx_read_register(chip, OCPSTAT, &chip->ocp_stat);
 
 		if (chip->card_exist & SD_CARD)
 			sd_power_off_card3v3(chip);
@@ -932,7 +892,6 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 				rtsx_read_cfg_dw(chip, 1, 0x04, &val);
 				if (val & 0x07)
 					ss_allowed = 0;
-
 			}
 		}
 	} else {
@@ -958,7 +917,7 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 
 #ifdef SUPPORT_SDIO_ASPM
 		if (CHK_SDIO_EXIST(chip) && !CHK_SDIO_IGNORED(chip) &&
-				chip->aspm_l0s_l1_en && chip->dynamic_aspm) {
+		    chip->aspm_l0s_l1_en && chip->dynamic_aspm) {
 			if (chip->sd_io) {
 				dynamic_configure_sdio_aspm(chip);
 			} else {
@@ -966,7 +925,8 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 					dev_dbg(rtsx_dev(chip), "SDIO enter ASPM!\n");
 					rtsx_write_register(chip,
 						ASPM_FORCE_CTL, 0xFC,
-						0x30 | (chip->aspm_level[1] << 2));
+						0x30 |
+						(chip->aspm_level[1] << 2));
 					chip->sdio_aspm = 1;
 				}
 			}
@@ -988,9 +948,10 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 
 			turn_off_led(chip, LED_GPIO);
 
-			if (chip->auto_power_down && !chip->card_ready && !chip->sd_io)
-				rtsx_force_power_down(chip, SSC_PDCTL | OC_PDCTL);
-
+			if (chip->auto_power_down && !chip->card_ready &&
+			    !chip->sd_io)
+				rtsx_force_power_down(chip,
+						      SSC_PDCTL | OC_PDCTL);
 		}
 	}
 
@@ -1013,7 +974,6 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 		break;
 	}
 
-
 #ifdef SUPPORT_OCP
 	if (CHECK_LUN_MODE(chip, SD_MS_2LUN)) {
 		if (chip->ocp_stat &
@@ -1024,7 +984,7 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 		if (chip->ocp_stat & (SD_OC_NOW | SD_OC_EVER)) {
 			if (chip->card_exist & SD_CARD) {
 				rtsx_write_register(chip, CARD_OE, SD_OUTPUT_EN,
-						0);
+						    0);
 				card_power_off(chip, SD_CARD);
 				chip->card_fail |= SD_CARD;
 			}
@@ -1032,7 +992,7 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 		if (chip->ocp_stat & (MS_OC_NOW | MS_OC_EVER)) {
 			if (chip->card_exist & MS_CARD) {
 				rtsx_write_register(chip, CARD_OE, MS_OUTPUT_EN,
-						0);
+						    0);
 				card_power_off(chip, MS_CARD);
 				chip->card_fail |= MS_CARD;
 			}
@@ -1043,15 +1003,15 @@ void rtsx_polling_func(struct rtsx_chip *chip)
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
@@ -1059,9 +1019,9 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 	}
 #endif
 
-Delink_Stage:
+delink_stage:
 	if (chip->auto_delink_en && chip->auto_delink_allowed &&
-		!chip->card_ready && !chip->card_ejected && !chip->sd_io) {
+	    !chip->card_ready && !chip->card_ejected && !chip->sd_io) {
 		int enter_L1 = chip->auto_delink_in_L1 && (
 			chip->aspm_l0s_l1_en || chip->ss_en);
 		int delink_stage1_cnt = chip->delink_stage1_step;
@@ -1081,27 +1041,33 @@ Delink_Stage:
 					dev_dbg(rtsx_dev(chip), "False card inserted, do force delink\n");
 
 					if (enter_L1)
-						rtsx_write_register(chip, HOST_SLEEP_STATE, 0x03, 1);
+						rtsx_write_register(chip,
+							      HOST_SLEEP_STATE,
+							      0x03, 1);
 
 					rtsx_write_register(chip,
-							CHANGE_LINK_STATE, 0x0A,
-							0x0A);
+							    CHANGE_LINK_STATE,
+							    0x0A, 0x0A);
 
 					if (enter_L1)
 						rtsx_enter_L1(chip);
 
-					chip->auto_delink_cnt = delink_stage3_cnt + 1;
+					chip->auto_delink_cnt =
+						delink_stage3_cnt + 1;
 				} else {
 					dev_dbg(rtsx_dev(chip), "No card inserted, do delink\n");
 
 					if (enter_L1)
-						rtsx_write_register(chip, HOST_SLEEP_STATE, 0x03, 1);
+						rtsx_write_register(chip,
+							      HOST_SLEEP_STATE,
+							      0x03, 1);
 
-					rtsx_write_register(chip, CHANGE_LINK_STATE, 0x02, 0x02);
+					rtsx_write_register(chip,
+							    CHANGE_LINK_STATE,
+							    0x02, 0x02);
 
 					if (enter_L1)
 						rtsx_enter_L1(chip);
-
 				}
 			}
 
@@ -1115,7 +1081,7 @@ Delink_Stage:
 					rtsx_set_phy_reg_bit(chip, 0x1C, 2);
 
 				rtsx_write_register(chip, CHANGE_LINK_STATE,
-						0x0A, 0x0A);
+						    0x0A, 0x0A);
 			}
 
 			chip->auto_delink_cnt++;
@@ -1219,7 +1185,7 @@ int rtsx_read_register(struct rtsx_chip *chip, u16 addr, u8 *data)
 }
 
 int rtsx_write_cfg_dw(struct rtsx_chip *chip, u8 func_no, u16 addr, u32 mask,
-		u32 val)
+		      u32 val)
 {
 	u8 mode = 0, tmp;
 	int i;
@@ -1279,7 +1245,7 @@ int rtsx_read_cfg_dw(struct rtsx_chip *chip, u8 func_no, u16 addr, u32 *val)
 }
 
 int rtsx_write_cfg_seq(struct rtsx_chip *chip, u8 func, u16 addr, u8 *buf,
-		int len)
+		       int len)
 {
 	u32 *data, *mask;
 	u16 offset = addr % 4;
@@ -1324,7 +1290,7 @@ int rtsx_write_cfg_seq(struct rtsx_chip *chip, u8 func, u16 addr, u8 *buf,
 
 	for (i = 0; i < dw_len; i++) {
 		retval = rtsx_write_cfg_dw(chip, func, aligned_addr + i * 4,
-					mask[i], data[i]);
+					   mask[i], data[i]);
 		if (retval != STATUS_SUCCESS) {
 			vfree(data);
 			vfree(mask);
@@ -1339,7 +1305,7 @@ int rtsx_write_cfg_seq(struct rtsx_chip *chip, u8 func, u16 addr, u8 *buf,
 }
 
 int rtsx_read_cfg_seq(struct rtsx_chip *chip, u8 func, u16 addr, u8 *buf,
-		int len)
+		      int len)
 {
 	u32 *data;
 	u16 offset = addr % 4;
@@ -1360,7 +1326,7 @@ int rtsx_read_cfg_seq(struct rtsx_chip *chip, u8 func, u16 addr, u8 *buf,
 
 	for (i = 0; i < dw_len; i++) {
 		retval = rtsx_read_cfg_dw(chip, func, aligned_addr + i * 4,
-					data + i);
+					  data + i);
 		if (retval != STATUS_SUCCESS) {
 			vfree(data);
 			TRACE_RET(chip, STATUS_FAIL);
@@ -1522,7 +1488,7 @@ int rtsx_set_phy_reg_bit(struct rtsx_chip *chip, u8 reg, u8 bit)
 	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
 
-	if (0 == (value & (1 << bit))) {
+	if ((value & (1 << bit)) == 0) {
 		value |= (1 << bit);
 		retval = rtsx_write_phy_register(chip, reg, value);
 		if (retval != STATUS_SUCCESS)
@@ -1558,10 +1524,7 @@ static void rtsx_handle_pm_dstate(struct rtsx_chip *chip, u8 dstate)
 	if (CHK_SDIO_EXIST(chip)) {
 		u8 func_no;
 
-		if (CHECK_PID(chip, 0x5288))
-			func_no = 2;
-		else
-			func_no = 1;
+		func_no = CHECK_PID(chip, 0x5288) ? 2 : 1;
 
 		rtsx_read_cfg_dw(chip, func_no, 0x84, &ultmp);
 		dev_dbg(rtsx_dev(chip), "pm_dstate of function %d: 0x%x\n",
@@ -1595,12 +1558,9 @@ void rtsx_enter_ss(struct rtsx_chip *chip)
 		rtsx_force_power_down(chip, SSC_PDCTL | OC_PDCTL);
 	}
 
-	if (CHK_SDIO_EXIST(chip)) {
-		if (CHECK_PID(chip, 0x5288))
-			rtsx_write_cfg_dw(chip, 2, 0xC0, 0xFF00, 0x0100);
-		else
-			rtsx_write_cfg_dw(chip, 1, 0xC0, 0xFF00, 0x0100);
-	}
+	if (CHK_SDIO_EXIST(chip))
+		rtsx_write_cfg_dw(chip, CHECK_PID(chip, 0x5288) ? 2 : 1, 0xC0,
+				  0xFF00, 0x0100);
 
 	if (chip->auto_delink_en) {
 		rtsx_write_register(chip, HOST_SLEEP_STATE, 0x01, 0x01);
@@ -1666,7 +1626,7 @@ int rtsx_pre_handle_interrupt(struct rtsx_chip *chip)
 	chip->int_reg = rtsx_readl(chip, RTSX_BIPR);
 
 	if (((chip->int_reg & int_enable) == 0) ||
-		(chip->int_reg == 0xFFFFFFFF))
+	    (chip->int_reg == 0xFFFFFFFF))
 		return STATUS_FAIL;
 
 	status = chip->int_reg &= (int_enable | 0x7FFFFF);
@@ -1676,12 +1636,12 @@ int rtsx_pre_handle_interrupt(struct rtsx_chip *chip)
 
 		if (status & SD_INT) {
 			if (status & SD_EXIST) {
-				set_bit(SD_NR, &(chip->need_reset));
+				set_bit(SD_NR, &chip->need_reset);
 			} else {
-				set_bit(SD_NR, &(chip->need_release));
+				set_bit(SD_NR, &chip->need_release);
 				chip->sd_reset_counter = 0;
 				chip->sd_show_cnt = 0;
-				clear_bit(SD_NR, &(chip->need_reset));
+				clear_bit(SD_NR, &chip->need_reset);
 			}
 		} else {
 			/* If multi-luns, it's possible that
@@ -1691,35 +1651,35 @@ int rtsx_pre_handle_interrupt(struct rtsx_chip *chip)
 			   all existed cards should be reset.
 			*/
 			if (exit_ss && (status & SD_EXIST))
-				set_bit(SD_NR, &(chip->need_reinit));
+				set_bit(SD_NR, &chip->need_reinit);
 		}
 		if (!CHECK_PID(chip, 0x5288) || CHECK_BARO_PKG(chip, QFN)) {
 			if (status & XD_INT) {
 				if (status & XD_EXIST) {
-					set_bit(XD_NR, &(chip->need_reset));
+					set_bit(XD_NR, &chip->need_reset);
 				} else {
-					set_bit(XD_NR, &(chip->need_release));
+					set_bit(XD_NR, &chip->need_release);
 					chip->xd_reset_counter = 0;
 					chip->xd_show_cnt = 0;
-					clear_bit(XD_NR, &(chip->need_reset));
+					clear_bit(XD_NR, &chip->need_reset);
 				}
 			} else {
 				if (exit_ss && (status & XD_EXIST))
-					set_bit(XD_NR, &(chip->need_reinit));
+					set_bit(XD_NR, &chip->need_reinit);
 			}
 		}
 		if (status & MS_INT) {
 			if (status & MS_EXIST) {
-				set_bit(MS_NR, &(chip->need_reset));
+				set_bit(MS_NR, &chip->need_reset);
 			} else {
-				set_bit(MS_NR, &(chip->need_release));
+				set_bit(MS_NR, &chip->need_release);
 				chip->ms_reset_counter = 0;
 				chip->ms_show_cnt = 0;
-				clear_bit(MS_NR, &(chip->need_reset));
+				clear_bit(MS_NR, &chip->need_reset);
 			}
 		} else {
 			if (exit_ss && (status & MS_EXIST))
-				set_bit(MS_NR, &(chip->need_reinit));
+				set_bit(MS_NR, &chip->need_reinit);
 		}
 	}
 
@@ -1727,10 +1687,8 @@ int rtsx_pre_handle_interrupt(struct rtsx_chip *chip)
 	chip->ocp_int = ocp_int & status;
 #endif
 
-	if (chip->sd_io) {
-		if (chip->int_reg & DATA_DONE_INT)
-			chip->int_reg &= ~(u32)DATA_DONE_INT;
-	}
+	if (chip->sd_io && (chip->int_reg & DATA_DONE_INT))
+		chip->int_reg &= ~(u32)DATA_DONE_INT;
 
 	return STATUS_SUCCESS;
 }
@@ -1774,14 +1732,14 @@ void rtsx_do_before_power_down(struct rtsx_chip *chip, int pm_stat)
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
@@ -1796,31 +1754,25 @@ void rtsx_do_before_power_down(struct rtsx_chip *chip, int pm_stat)
 
 void rtsx_enable_aspm(struct rtsx_chip *chip)
 {
-	if (chip->aspm_l0s_l1_en && chip->dynamic_aspm) {
-		if (!chip->aspm_enabled) {
-			dev_dbg(rtsx_dev(chip), "Try to enable ASPM\n");
-			chip->aspm_enabled = 1;
+	if (chip->aspm_l0s_l1_en && chip->dynamic_aspm && !chip->aspm_enabled) {
+		dev_dbg(rtsx_dev(chip), "Try to enable ASPM\n");
+		chip->aspm_enabled = 1;
+
+		if (chip->asic_code && CHECK_PID(chip, 0x5208))
+			rtsx_write_phy_register(chip, 0x07, 0);
+		if (CHECK_PID(chip, 0x5208))
+			rtsx_write_register(chip, ASPM_FORCE_CTL, 0xF3,
+					    0x30 | chip->aspm_level[0]);
+		else {
+			rtsx_write_config_byte(chip, LCTLR,
+					       chip->aspm_l0s_l1_en);
+		}
 
-			if (chip->asic_code && CHECK_PID(chip, 0x5208))
-				rtsx_write_phy_register(chip, 0x07, 0);
-			if (CHECK_PID(chip, 0x5208)) {
-				rtsx_write_register(chip, ASPM_FORCE_CTL, 0xF3,
-					0x30 | chip->aspm_level[0]);
-			} else {
-				rtsx_write_config_byte(chip, LCTLR,
-						chip->aspm_l0s_l1_en);
-			}
+		if (CHK_SDIO_EXIST(chip)) {
+			u16 val = chip->aspm_l0s_l1_en | 0x0100;
 
-			if (CHK_SDIO_EXIST(chip)) {
-				u16 val = chip->aspm_l0s_l1_en | 0x0100;
-
-				if (CHECK_PID(chip, 0x5288))
-					rtsx_write_cfg_dw(chip, 2, 0xC0,
-							0xFFFF, val);
-				else
-					rtsx_write_cfg_dw(chip, 1, 0xC0,
-							0xFFFF, val);
-			}
+			rtsx_write_cfg_dw(chip, CHECK_PID(chip, 0x5288) ? 2 : 1,
+					  0xC0, 0xFFFF, val);
 		}
 	}
 }
@@ -1830,21 +1782,18 @@ void rtsx_disable_aspm(struct rtsx_chip *chip)
 	if (CHECK_PID(chip, 0x5208))
 		rtsx_monitor_aspm_config(chip);
 
-	if (chip->aspm_l0s_l1_en && chip->dynamic_aspm) {
-		if (chip->aspm_enabled) {
-			dev_dbg(rtsx_dev(chip), "Try to disable ASPM\n");
-			chip->aspm_enabled = 0;
+	if (chip->aspm_l0s_l1_en && chip->dynamic_aspm && chip->aspm_enabled) {
+		dev_dbg(rtsx_dev(chip), "Try to disable ASPM\n");
+		chip->aspm_enabled = 0;
 
-			if (chip->asic_code && CHECK_PID(chip, 0x5208))
-				rtsx_write_phy_register(chip, 0x07, 0x0129);
-			if (CHECK_PID(chip, 0x5208))
-				rtsx_write_register(chip, ASPM_FORCE_CTL,
-						0xF3, 0x30);
-			else
-				rtsx_write_config_byte(chip, LCTLR, 0x00);
+		if (chip->asic_code && CHECK_PID(chip, 0x5208))
+			rtsx_write_phy_register(chip, 0x07, 0x0129);
+		if (CHECK_PID(chip, 0x5208))
+			rtsx_write_register(chip, ASPM_FORCE_CTL, 0xF3, 0x30);
+		else
+			rtsx_write_config_byte(chip, LCTLR, 0x00);
 
-			wait_timeout(1);
-		}
+		wait_timeout(1);
 	}
 }
 
@@ -1907,7 +1856,7 @@ int rtsx_write_ppbuf(struct rtsx_chip *chip, u8 *buf, int buf_len)
 
 		for (j = 0; j < 256; j++) {
 			rtsx_add_cmd(chip, WRITE_REG_CMD, reg_addr++, 0xFF,
-				*ptr);
+				     *ptr);
 			ptr++;
 		}
 
@@ -1921,7 +1870,7 @@ int rtsx_write_ppbuf(struct rtsx_chip *chip, u8 *buf, int buf_len)
 
 		for (j = 0; j < buf_len%256; j++) {
 			rtsx_add_cmd(chip, WRITE_REG_CMD, reg_addr++, 0xFF,
-				*ptr);
+				     *ptr);
 			ptr++;
 		}
 
-- 
2.1.2
