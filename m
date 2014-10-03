Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbaJCVbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:31:46 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:51992 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527AbaJCVbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:31:41 -0400
From: Giedrius Statkevicius <giedrius.statkevicius@gmail.com>
To: gregkh@linuxfoundation.org
Cc: micky_ching@realsil.com.cn, fabio.falzoi84@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] staging: rts5208: divide lines to make them less than 80 characters long
Date: Sat,  4 Oct 2014 00:31:20 +0300
Message-Id: <5befea8fb3f77d139a108acc0e5c4214f9cea960.1412369676.git.giedrius.statkevicius@gmail.com>
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

Make a couple of lines shorter than the max limit by diving them and
also make sure to align them properly where possible.

Signed-off-by: Giedrius Statkevičius <giedrius.statkevicius@gmail.com>
---
 drivers/staging/rts5208/rtsx_chip.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/rts5208/rtsx_chip.c b/drivers/staging/rts5208/rtsx_chip.c
index b47eade..71dc6ee 100644
--- a/drivers/staging/rts5208/rtsx_chip.c
+++ b/drivers/staging/rts5208/rtsx_chip.c
@@ -291,7 +291,8 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
 	if (chip->aspm_l0s_l1_en) {
 		if (chip->dynamic_aspm) {
 			if (CHK_SDIO_EXIST(chip) && CHECK_PID(chip, 0x5288)) {
-				retval = rtsx_write_cfg_dw(chip, 2, 0xC0, 0xFF, chip->aspm_l0s_l1_en);
+				retval = rtsx_write_cfg_dw(chip, 2, 0xC0, 0xFF,
+						chip->aspm_l0s_l1_en);
 				if (retval != STATUS_SUCCESS)
 					TRACE_RET(chip, STATUS_FAIL);
 			}
@@ -309,9 +310,13 @@ int rtsx_reset_chip(struct rtsx_chip *chip)
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
@@ -954,7 +959,8 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 					dev_dbg(rtsx_dev(chip), "SDIO enter ASPM!\n");
 					rtsx_write_register(chip,
 						ASPM_FORCE_CTL, 0xFC,
-						0x30 | (chip->aspm_level[1] << 2));
+						0x30 |
+						(chip->aspm_level[1] << 2));
 					chip->sdio_aspm = 1;
 				}
 			}
@@ -976,8 +982,10 @@ void rtsx_polling_func(struct rtsx_chip *chip)
 
 			turn_off_led(chip, LED_GPIO);
 
-			if (chip->auto_power_down && !chip->card_ready && !chip->sd_io)
-				rtsx_force_power_down(chip, SSC_PDCTL | OC_PDCTL);
+			if (chip->auto_power_down && !chip->card_ready &&
+			    !chip->sd_io)
+				rtsx_force_power_down(chip,
+						      SSC_PDCTL | OC_PDCTL);
 		}
 	}
 
@@ -1067,7 +1075,9 @@ delink_stage:
 					dev_dbg(rtsx_dev(chip), "False card inserted, do force delink\n");
 
 					if (enter_L1)
-						rtsx_write_register(chip, HOST_SLEEP_STATE, 0x03, 1);
+						rtsx_write_register(chip,
+							      HOST_SLEEP_STATE,
+							      0x03, 1);
 
 					rtsx_write_register(chip,
 							    CHANGE_LINK_STATE,
@@ -1076,12 +1086,15 @@ delink_stage:
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
 
 					rtsx_write_register(chip,
 							    CHANGE_LINK_STATE,
-- 
2.1.2

