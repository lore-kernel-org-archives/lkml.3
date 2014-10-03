Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbaJCVbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:31:43 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:39391 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747AbaJCVbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:31:38 -0400
From: Giedrius Statkevicius <giedrius.statkevicius@gmail.com>
To: gregkh@linuxfoundation.org
Cc: micky_ching@realsil.com.cn, fabio.falzoi84@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] staging: rts5208: get rid of Camel Case, remove unneeded lines and parantheses
Date: Sat,  4 Oct 2014 00:31:18 +0300
Message-Id: <e22e8e005805b4d5accb42048e8faa2c45a4d6ba.1412369676.git.giedrius.statkevicius@gmail.com>
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

Convert labels from Camel Case to lower case, remove unnecessary
parantheses around operands of dereference operators and remove unneeded
empty lines before }.

Gets rid of a checkpatch.pl "check" that code should avoid Camel Case,
also the code had a bunch of &(a) where a is some variable so it gets
rid of them too.  Finally, in a few places there were a empty line
before } so remove them.

Signed-off-by: Giedrius Statkevičius <giedrius.statkevicius@gmail.com>
---
 drivers/staging/rts5208/rtsx_chip.c | 52 +++++++++++++++----------------------
 1 file changed, 21 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/rts5208/rtsx_chip.c b/drivers/staging/rts5208/rtsx_chip.c
index 0db63fb..146b337 100644
--- a/drivers/staging/rts5208/rtsx_chip.c
+++ b/drivers/staging/rts5208/rtsx_chip.c
@@ -314,7 +314,6 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 
 				if (retval != STATUS_SUCCESS)
 					TRACE_RET(chip, STATUS_FAIL);
-
 			}
 
 			chip->aspm_enabled = 1;
@@ -345,7 +344,6 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 
 		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-
 	}
 
 	if (CHECK_PID(chip, 0x5288) && !CHK_SDIO_EXIST(chip)) {
@@ -397,7 +395,6 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 								reg);
 				if (retval != STATUS_SUCCESS)
 					TRACE_RET(chip, STATUS_FAIL);
-
 			}
 
 			if (chip->driver_first_load &&
@@ -416,7 +413,7 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 	chip->int_reg = rtsx_readl(chip, RTSX_BIPR);
 
 	if (chip->hw_bypass_sd)
-		goto NextCard;
+		goto nextcard;
 	dev_dbg(rtsx_dev(chip), "In %s, chip->int_reg = 0x%x\n", __func__,
 		chip->int_reg);
 	if (chip->int_reg & SD_EXIST) {
@@ -440,7 +437,7 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 			0);
 	}
 
-NextCard:
+nextcard:
 	if (chip->int_reg & XD_EXIST)
 		chip->need_reset |= XD_CARD;
 	if (chip->int_reg & MS_EXIST)
@@ -646,7 +643,6 @@ static int rts5288_init(struct rtsx_chip *chip)
 			chip->lun_mode = SD_MS_1LUN;
 		else
 			chip->lun_mode = DEFAULT_SINGLE;
-
 	}
 
 	return STATUS_SUCCESS;
@@ -654,9 +650,9 @@ static int rts5288_init(struct rtsx_chip *chip)
 
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
 
@@ -734,7 +730,6 @@ int rtsx_init_chip(struct rtsx_chip *chip)
 		retval = rts5288_init(chip);
 		if (retval != STATUS_SUCCESS)
 			TRACE_RET(chip, STATUS_FAIL);
-
 	}
 
 	if (chip->ss_en == 2)
@@ -836,7 +831,6 @@ static void rtsx_monitor_aspm_config(struct rtsx_chip *chip)
 	} else {
 		if (reg0 & 0x03)
 			maybe_support_aspm = 1;
-
 	}
 
 	if (reg_changed) {
@@ -861,7 +855,7 @@ static void rtsx_monitor_aspm_config(struct rtsx_chip *chip)
 void rtsx_polling_func(struct rtsx_chip *chip)
 {
 #ifdef SUPPORT_SD_LOCK
-	struct sd_info *sd_card = &(chip->sd_card);
+	struct sd_info *sd_card = &chip->sd_card;
 #endif
 	int ss_allowed;
 
@@ -869,7 +863,7 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 		return;
 
 	if (rtsx_chk_stat(chip, RTSX_STAT_DELINK))
-		goto Delink_Stage;
+		goto delink_stage;
 
 	if (chip->polling_config) {
 		u8 val;
@@ -882,7 +876,7 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 
 #ifdef SUPPORT_OCP
 	if (chip->ocp_int) {
-		rtsx_read_register(chip, OCPSTAT, &(chip->ocp_stat));
+		rtsx_read_register(chip, OCPSTAT, &chip->ocp_stat);
 
 		if (chip->card_exist & SD_CARD)
 			sd_power_off_card3v3(chip);
@@ -926,7 +920,6 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 				rtsx_read_cfg_dw(chip, 1, 0x04, &val);
 				if (val & 0x07)
 					ss_allowed = 0;
-
 			}
 		}
 	} else {
@@ -984,7 +977,6 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 
 			if (chip->auto_power_down && !chip->card_ready && !chip->sd_io)
 				rtsx_force_power_down(chip, SSC_PDCTL | OC_PDCTL);
-
 		}
 	}
 
@@ -1007,7 +999,6 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 		break;
 	}
 
-
 #ifdef SUPPORT_OCP
 	if (CHECK_LUN_MODE(chip, SD_MS_2LUN)) {
 		if (chip->ocp_stat &
@@ -1053,7 +1044,7 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 	}
 #endif
 
-Delink_Stage:
+delink_stage:
 	if (chip->auto_delink_en && chip->auto_delink_allowed &&
 		!chip->card_ready && !chip->card_ejected && !chip->sd_io) {
 		int enter_L1 = chip->auto_delink_in_L1 && (
@@ -1095,7 +1086,6 @@ Delink_Stage:
 
 					if (enter_L1)
 						rtsx_enter_L1(chip);
-
 				}
 			}
 
@@ -1670,12 +1660,12 @@ int rtsx_pre_handle_interrupt(struct rtsx_chip *chip)
 
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
@@ -1685,35 +1675,35 @@ int rtsx_pre_handle_interrupt(struct rtsx_chip *chip)
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
 
-- 
2.1.2

