Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbaJCVcI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:32:08 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:36215 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804AbaJCVbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:31:42 -0400
From: Giedrius Statkevicius <giedrius.statkevicius@gmail.com>
To: gregkh@linuxfoundation.org
Cc: micky_ching@realsil.com.cn, fabio.falzoi84@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] staging: rts5208: use ternary operators to reduce indentation level
Date: Sat,  4 Oct 2014 00:31:21 +0300
Message-Id: <8b66af59308ad7195006048b59273d74dd397e3f.1412369676.git.giedrius.statkevicius@gmail.com>
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

Convert code in format of if (a) if(b) { [...] } to one line with a
simple ternary operation to avoid unnecesary increase of indentation
level.

Signed-off-by: Giedrius Statkevičius <giedrius.statkevicius@gmail.com>
---
 drivers/staging/rts5208/rtsx_chip.c | 90 ++++++++++---------------------------
 1 file changed, 23 insertions(+), 67 deletions(-)

diff --git a/drivers/staging/rts5208/rtsx_chip.c b/drivers/staging/rts5208/rtsx_chip.c
index 71dc6ee..ffcf5de 100644
--- a/drivers/staging/rts5208/rtsx_chip.c
+++ b/drivers/staging/rts5208/rtsx_chip.c
@@ -309,14 +309,10 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 			chip->aspm_level[0] = chip->aspm_l0s_l1_en;
 			if (CHK_SDIO_EXIST(chip)) {
 				chip->aspm_level[1] = chip->aspm_l0s_l1_en;
-				if (CHECK_PID(chip, 0x5288))
-					retval = rtsx_write_cfg_dw(chip, 2,
-							0xC0, 0xFF,
-							chip->aspm_l0s_l1_en);
-				else
-					retval = rtsx_write_cfg_dw(chip, 1,
-							0xC0, 0xFF,
-							chip->aspm_l0s_l1_en);
+				retval = rtsx_write_cfg_dw(chip,
+						CHECK_PID(chip, 0x5288) ? 2 : 1,
+						0xC0, 0xFF,
+						chip->aspm_l0s_l1_en);
 
 				if (retval != STATUS_SUCCESS)
 					TRACE_RET(chip, STATUS_FAIL);
@@ -341,12 +337,9 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 		TRACE_RET(chip, STATUS_FAIL);
 
 	if (CHK_SDIO_EXIST(chip)) {
-		if (CHECK_PID(chip, 0x5288))
-			retval = rtsx_write_cfg_dw(chip, 2, 0xC0,
-						   0xFF00, 0x0100);
-		else
-			retval = rtsx_write_cfg_dw(chip, 1, 0xC0,
-						   0xFF00, 0x0100);
+		retval = rtsx_write_cfg_dw(chip,
+					   CHECK_PID(chip, 0x5288) ? 2 : 1,
+					   0xC0, 0xFF00, 0x0100);
 
 		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
@@ -537,10 +530,7 @@ static int rts5208_init(struct rtsx_chip *chip)
 
 	RTSX_WRITE_REG(chip, CLK_SEL, 0x03, 0x03);
 	RTSX_READ_REG(chip, CLK_SEL, &val);
-	if (val == 0)
-		chip->asic_code = 1;
-	else
-		chip->asic_code = 0;
+	chip->asic_code = val == 0 ? 1 : 0;
 
 	if (chip->asic_code) {
 		retval = rtsx_read_phy_register(chip, 0x1C, &reg);
@@ -550,10 +540,7 @@ static int rts5208_init(struct rtsx_chip *chip)
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
@@ -563,16 +550,10 @@ static int rts5208_init(struct rtsx_chip *chip)
 
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
@@ -582,10 +563,7 @@ static int rts5208_init(struct rtsx_chip *chip)
 
 	if (chip->use_hw_setting) {
 		RTSX_READ_REG(chip, CHANGE_LINK_STATE, &val);
-		if (val & 0x80)
-			chip->auto_delink_en = 1;
-		else
-			chip->auto_delink_en = 0;
+		chip->auto_delink_en = val & 0x80 ? 1 : 0;
 	}
 
 	return STATUS_SUCCESS;
@@ -599,33 +577,21 @@ static int rts5288_init(struct rtsx_chip *chip)
 
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
-	if (val & 0x04)
-		chip->baro_pkg = QFN;
-	else
-		chip->baro_pkg = LQFP;
+	chip->baro_pkg = val & 0x04 ? QFN : LQFP;
 
 	RTSX_READ_REG(chip, 0xFE5A, &val);
-	if (val & 0x10)
-		chip->hw_bypass_sd = 1;
-	else
-		chip->hw_bypass_sd = 0;
+	chip->hw_bypass_sd = val & 0x10 ? 1 : 0;
 
 	retval = rtsx_read_cfg_dw(chip, 0, 0x718, &lval);
 	if (retval != STATUS_SUCCESS)
@@ -640,10 +606,7 @@ static int rts5288_init(struct rtsx_chip *chip)
 
 	if (chip->use_hw_setting) {
 		RTSX_READ_REG(chip, CHANGE_LINK_STATE, &val);
-		if (val & 0x80)
-			chip->auto_delink_en = 1;
-		else
-			chip->auto_delink_en = 0;
+		chip->auto_delink_en = val & 0x80 ? 1 : 0;
 
 		if (CHECK_BARO_PKG(chip, LQFP))
 			chip->lun_mode = SD_MS_1LUN;
@@ -1522,7 +1485,7 @@ int rtsx_set_phy_reg_bit(struct rtsx_chip *chip, u8 reg, u8 bit)
 	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
 
-	if (0 == (value & (1 << bit))) {
+	if ((value & (1 << bit)) == 0) {
 		value |= (1 << bit);
 		retval = rtsx_write_phy_register(chip, reg, value);
 		if (retval != STATUS_SUCCESS)
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
+		rtsx_write_cfg_dw(chip, CHECK_PID(chip, 0x5288) ? 2 : 1,
+				  0xC0, 0xFF00, 0x0100);
 
 	if (chip->auto_delink_en) {
 		rtsx_write_register(chip, HOST_SLEEP_STATE, 0x01, 0x01);
@@ -1811,12 +1771,8 @@ void rtsx_enable_aspm(struct rtsx_chip *chip)
 		if (CHK_SDIO_EXIST(chip)) {
 			u16 val = chip->aspm_l0s_l1_en | 0x0100;
 
-			if (CHECK_PID(chip, 0x5288))
-				rtsx_write_cfg_dw(chip, 2, 0xC0,
-						  0xFFFF, val);
-			else
-				rtsx_write_cfg_dw(chip, 1, 0xC0,
-						  0xFFFF, val);
+			rtsx_write_cfg_dw(chip, CHECK_PID(chip, 0x5288) ? 2 : 1,
+					  0xC0, 0xFFF, val);
 		}
 	}
 }
-- 
2.1.2

