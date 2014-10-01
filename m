Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbaJAWMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 18:12:50 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:41533 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbaJAWMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 18:12:48 -0400
Message-ID: <542C7C53.7060609@gmail.com>
Date: Thu, 02 Oct 2014 01:12:35 +0300
From: Giedrius Statkevicius <giedrius.statkevicius@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: micky_ching@realsil.com.cn, fabio.falzoi84@gmail.com,
        mahati.chamarthy@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rts5208: Clean up coding style in rtsx_chip.c to
 get rid of checkpatch.pl warnings
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix 10 occurences of coding style errors where the line exceeds 80 characters by breaking them into more lines.
Checkpatch.pl reports these errors as: 'WARNING: line over 80 characters'
Also, removes unnecessary returns in two void functions by removing the return statements.
Checkpatch.pl reports these errors as: 'WARNING: void function return statements are not generally useful'

Patch is against Greg KH's staging-next tree.

Signed-off-by: Giedrius Statkevicius <giedrius.statkevicius@gmail.com>
---
 drivers/staging/rts5208/rtsx_chip.c | 40 ++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/rts5208/rtsx_chip.c b/drivers/staging/rts5208/rtsx_chip.c
index 1411471..d604341 100644
--- a/drivers/staging/rts5208/rtsx_chip.c
+++ b/drivers/staging/rts5208/rtsx_chip.c
@@ -291,7 +291,9 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 		if (chip->dynamic_aspm) {
 			if (CHK_SDIO_EXIST(chip)) {
 				if (CHECK_PID(chip, 0x5288)) {
-					retval = rtsx_write_cfg_dw(chip, 2, 0xC0, 0xFF, chip->aspm_l0s_l1_en);
+					retval = rtsx_write_cfg_dw(chip, 2,
+							0xC0, 0xFF,
+							chip->aspm_l0s_l1_en);
 					if (retval != STATUS_SUCCESS)
 						TRACE_RET(chip, STATUS_FAIL);
 				}
@@ -310,9 +312,13 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 			if (CHK_SDIO_EXIST(chip)) {
 				chip->aspm_level[1] = chip->aspm_l0s_l1_en;
 				if (CHECK_PID(chip, 0x5288))
-					retval = rtsx_write_cfg_dw(chip, 2, 0xC0, 0xFF, chip->aspm_l0s_l1_en);
+					retval = rtsx_write_cfg_dw(chip, 2,
+							0xC0, 0xFF,
+							chip->aspm_l0s_l1_en);
 				else
-					retval = rtsx_write_cfg_dw(chip, 1, 0xC0, 0xFF, chip->aspm_l0s_l1_en);
+					retval = rtsx_write_cfg_dw(chip, 1,
+							0xC0, 0xFF,
+							chip->aspm_l0s_l1_en);
 
 				if (retval != STATUS_SUCCESS)
 					TRACE_RET(chip, STATUS_FAIL);
@@ -966,7 +972,8 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 					dev_dbg(rtsx_dev(chip), "SDIO enter ASPM!\n");
 					rtsx_write_register(chip,
 						ASPM_FORCE_CTL, 0xFC,
-						0x30 | (chip->aspm_level[1] << 2));
+						0x30 |
+						(chip->aspm_level[1] << 2));
 					chip->sdio_aspm = 1;
 				}
 			}
@@ -988,8 +995,10 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 
 			turn_off_led(chip, LED_GPIO);
 
-			if (chip->auto_power_down && !chip->card_ready && !chip->sd_io)
-				rtsx_force_power_down(chip, SSC_PDCTL | OC_PDCTL);
+			if (chip->auto_power_down && !chip->card_ready &&
+					!chip->sd_io)
+				rtsx_force_power_down(chip,
+						SSC_PDCTL | OC_PDCTL);
 
 		}
 	}
@@ -1081,7 +1090,9 @@ Delink_Stage:
 					dev_dbg(rtsx_dev(chip), "False card inserted, do force delink\n");
 
 					if (enter_L1)
-						rtsx_write_register(chip, HOST_SLEEP_STATE, 0x03, 1);
+						rtsx_write_register(chip,
+							      HOST_SLEEP_STATE,
+							      0x03, 1);
 
 					rtsx_write_register(chip,
 							CHANGE_LINK_STATE, 0x0A,
@@ -1090,14 +1101,19 @@ Delink_Stage:
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
+							CHANGE_LINK_STATE, 0x02,
+							0x02);
 
 					if (enter_L1)
 						rtsx_enter_L1(chip);
@@ -1823,8 +1839,6 @@ void rtsx_enable_aspm(struct rtsx_chip *chip)
 			}
 		}
 	}
-
-	return;
 }
 
 void rtsx_disable_aspm(struct rtsx_chip *chip)
@@ -1848,8 +1862,6 @@ void rtsx_disable_aspm(struct rtsx_chip *chip)
 			wait_timeout(1);
 		}
 	}
-
-	return;
 }
 
 int rtsx_read_ppbuf(struct rtsx_chip *chip, u8 *buf, int buf_len)
-- 
2.1.2
