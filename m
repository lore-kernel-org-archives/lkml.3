Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab3HZPLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:11:23 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:35808 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794Ab3HZPLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:11:19 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, ikerpedrosam@gmail.com,
        justinmattock@gmail.com, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, mujeeb.adil@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/24] Staging: winbond: phy_calibration: fixed some lines over 80 characters
Date: Mon, 26 Aug 2013 17:10:03 +0200
Message-Id: <1377529823-5116-5-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
References: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First of the patches that fixes the lines over 80 characters in phy_calibration.c

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/phy_calibration.c | 46 ++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/winbond/phy_calibration.c b/drivers/staging/winbond/phy_calibration.c
index cfbfbbb..6635c85 100644
--- a/drivers/staging/winbond/phy_calibration.c
+++ b/drivers/staging/winbond/phy_calibration.c
@@ -27,10 +27,12 @@
 #define DEG2RAD(X)      (0.017453 * (X))
 
 static const s32 Angles[] = {
-	FIXED(DEG2RAD(45.0)),     FIXED(DEG2RAD(26.565)),   FIXED(DEG2RAD(14.0362)),
-	FIXED(DEG2RAD(7.12502)),  FIXED(DEG2RAD(3.57633)),  FIXED(DEG2RAD(1.78991)),
-	FIXED(DEG2RAD(0.895174)), FIXED(DEG2RAD(0.447614)), FIXED(DEG2RAD(0.223811)),
-	FIXED(DEG2RAD(0.111906)), FIXED(DEG2RAD(0.055953)), FIXED(DEG2RAD(0.027977))
+	FIXED(DEG2RAD(45.0)),     FIXED(DEG2RAD(26.565)),
+	FIXED(DEG2RAD(14.0362)),  FIXED(DEG2RAD(7.12502)),
+	FIXED(DEG2RAD(3.57633)),  FIXED(DEG2RAD(1.78991)),
+	FIXED(DEG2RAD(0.895174)), FIXED(DEG2RAD(0.447614)),
+	FIXED(DEG2RAD(0.223811)), FIXED(DEG2RAD(0.111906)),
+	FIXED(DEG2RAD(0.055953)), FIXED(DEG2RAD(0.027977))
 };
 
 /****************** LOCAL FUNCTION DECLARATION SECTION **********************/
@@ -296,7 +298,8 @@ void _sin_cos(s32 angle, s32 *sin, s32 *cos)
 	}
 }
 
-static unsigned char hal_get_dxx_reg(struct hw_data *pHwData, u16 number, u32 *pValue)
+static unsigned char hal_get_dxx_reg(struct hw_data *pHwData, u16 number,
+				     u32 *pValue)
 {
 	if (number < 0x1000)
 		number += 0x1000;
@@ -304,7 +307,8 @@ static unsigned char hal_get_dxx_reg(struct hw_data *pHwData, u16 number, u32 *p
 }
 #define hw_get_dxx_reg(_A, _B, _C) hal_get_dxx_reg(_A, _B, (u32 *)_C)
 
-static unsigned char hal_set_dxx_reg(struct hw_data *pHwData, u16 number, u32 value)
+static unsigned char hal_set_dxx_reg(struct hw_data *pHwData, u16 number,
+				     u32 value)
 {
 	unsigned char ret;
 
@@ -407,7 +411,8 @@ void _rxadc_dc_offset_cancellation_winbond(struct hw_data *phw_data, u32 frequen
 	PHY_DEBUG(("[CAL]    ** adc_dc_cal_i = %d (0x%04X)\n",
 			   _s9_to_s32(val&0x000001FF), val&0x000001FF));
 	PHY_DEBUG(("[CAL]    ** adc_dc_cal_q = %d (0x%04X)\n",
-			   _s9_to_s32((val&0x0003FE00)>>9), (val&0x0003FE00)>>9));
+			   _s9_to_s32((val&0x0003FE00)>>9),
+			   (val&0x0003FE00)>>9));
 #endif
 
 	hw_get_dxx_reg(phw_data, REG_MODE_CTRL, &val);
@@ -535,7 +540,8 @@ void _txidac_dc_offset_cancellation_winbond(struct hw_data *phw_data)
 		}
 
 		PHY_DEBUG(("[CAL]    ** fix_cancel_dc_i = %d (0x%04X)\n",
-				   fix_cancel_dc_i, _s32_to_s5(fix_cancel_dc_i)));
+				   fix_cancel_dc_i,
+				   _s32_to_s5(fix_cancel_dc_i)));
 
 		if ((abs(mag_1-mag_0)*6) > mag_0)
 			break;
@@ -711,7 +717,8 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 	loop = LOOP_TIMES;
 
 	while (loop > 0) {
-		PHY_DEBUG(("[CAL] [%d.] <_tx_iq_calibration_loop>\n", (LOOP_TIMES-loop+1)));
+		PHY_DEBUG(("[CAL] [%d.] <_tx_iq_calibration_loop>\n",
+				   (LOOP_TIMES-loop+1)));
 
 		iqcal_tone_i_avg = 0;
 		iqcal_tone_q_avg = 0;
@@ -719,8 +726,8 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 			return 0;
 		for (capture_time = 0; capture_time < 10; capture_time++) {
 			/*
-			 * a. Set iqcal_mode[1:0] to 0x2 and set "calib_start" to 0x1 to
-			 *    enable "IQ calibration Mode II"
+			 * a. Set iqcal_mode[1:0] to 0x2 and set "calib_start"
+			 *    to 0x1 to enable "IQ calibration Mode II"
 			 */
 			reg_mode_ctrl &= ~(MASK_IQCAL_TONE_SEL|MASK_IQCAL_MODE);
 			reg_mode_ctrl &= ~MASK_IQCAL_MODE;
@@ -749,8 +756,8 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 			PHY_DEBUG(("[CAL]    MODE_CTRL (write) = 0x%08X\n", reg_mode_ctrl));
 
 			/*
-			 * d. Set iqcal_mode[1:0] to 0x3 and set "calib_start" to 0x1 to
-			 *    enable "IQ calibration Mode II"
+			 * d. Set iqcal_mode[1:0] to 0x3 and set "calib_start"
+			 *    to 0x1 to enable "IQ calibration Mode II"
 			 */
 			/* hw_get_dxx_reg(phw_data, REG_MODE_CTRL, &val); */
 			hw_get_dxx_reg(phw_data, REG_MODE_CTRL, &reg_mode_ctrl);
@@ -766,7 +773,7 @@ u8 _tx_iq_calibration_loop_winbond(struct hw_data *phw_data,
 			iqcal_tone_i = _s13_to_s32(val & 0x00001FFF);
 			iqcal_tone_q = _s13_to_s32((val & 0x03FFE000) >> 13);
 			PHY_DEBUG(("[CAL]    ** iqcal_tone_i = %d, iqcal_tone_q = %d\n",
-			iqcal_tone_i, iqcal_tone_q));
+					   iqcal_tone_i, iqcal_tone_q));
 			if (capture_time == 0)
 				continue;
 			else {
@@ -1146,7 +1153,8 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
 	/* for (loop = 0; loop < LOOP_TIMES; loop++) */
 	loop = LOOP_TIMES;
 	while (loop > 0) {
-		PHY_DEBUG(("[CAL] [%d.] <_rx_iq_calibration_loop>\n", (LOOP_TIMES-loop+1)));
+		PHY_DEBUG(("[CAL] [%d.] <_rx_iq_calibration_loop>\n",
+				   (LOOP_TIMES-loop+1)));
 		iqcal_tone_i_avg = 0;
 		iqcal_tone_q_avg = 0;
 		iqcal_image_i_avg = 0;
@@ -1199,13 +1207,13 @@ u8 _rx_iq_calibration_loop_winbond(struct hw_data *phw_data, u16 factor, u32 fre
 
 		/* d. */
 		rot_tone_i_b = (iqcal_tone_i * iqcal_tone_i +
-						iqcal_tone_q * iqcal_tone_q) / 1024;
+					iqcal_tone_q * iqcal_tone_q) / 1024;
 		rot_tone_q_b = (iqcal_tone_i * iqcal_tone_q * (-1) +
-						iqcal_tone_q * iqcal_tone_i) / 1024;
+					iqcal_tone_q * iqcal_tone_i) / 1024;
 		rot_image_i_b = (iqcal_image_i * iqcal_tone_i -
-						 iqcal_image_q * iqcal_tone_q) / 1024;
+					iqcal_image_q * iqcal_tone_q) / 1024;
 		rot_image_q_b = (iqcal_image_i * iqcal_tone_q +
-						 iqcal_image_q * iqcal_tone_i) / 1024;
+					iqcal_image_q * iqcal_tone_i) / 1024;
 
 		PHY_DEBUG(("[CAL]    ** rot_tone_i_b  = %d\n", rot_tone_i_b));
 		PHY_DEBUG(("[CAL]    ** rot_tone_q_b  = %d\n", rot_tone_q_b));
-- 
1.8.1.2

