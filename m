Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab3HZPPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:15:51 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:50928 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794Ab3HZPL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:11:28 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, ikerpedrosam@gmail.com,
        justinmattock@gmail.com, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, mujeeb.adil@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/24] Staging: winbond: reg: changed sleep function from msleep to usleep
Date: Mon, 26 Aug 2013 17:10:07 +0200
Message-Id: <1377529823-5116-9-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
References: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the documentation it is not recommended to use msleep for 1ms - 20ms because it may sleep longer than 20ms. So, it is recommended to use usleep instead.

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/reg.c | 52 +++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/winbond/reg.c b/drivers/staging/winbond/reg.c
index 80b4b34..61916f5 100644
--- a/drivers/staging/winbond/reg.c
+++ b/drivers/staging/winbond/reg.c
@@ -890,9 +890,9 @@ void Uxx_power_on_procedure(struct hw_data *pHwData)
 	else {
 		Wb35Reg_WriteSync(pHwData, 0x03f4, 0xFF5807FF);
 		Wb35Reg_WriteSync(pHwData, 0x03d4, 0x80); /* regulator on only */
-		msleep(10);
+		usleep(10000);
 		Wb35Reg_WriteSync(pHwData, 0x03d4, 0xb8); /* REG_ON RF_RSTN on, and */
-		msleep(10);
+		usleep(10000);
 		ltmp = 0x4968;
 		if ((pHwData->phy_type == RF_WB_242) ||
 			(RF_WB_242_1 == pHwData->phy_type))
@@ -905,7 +905,7 @@ void Uxx_power_on_procedure(struct hw_data *pHwData)
 		Wb35Reg_ReadSync(pHwData, 0x03d0, &ltmp);
 		loop = 500; /* Wait for 5 second */
 		while (!(ltmp & 0x20) && loop--) {
-			msleep(10);
+			usleep(10000);
 			if (!Wb35Reg_ReadSync(pHwData, 0x03d0, &ltmp))
 				break;
 		}
@@ -914,7 +914,7 @@ void Uxx_power_on_procedure(struct hw_data *pHwData)
 	}
 
 	Wb35Reg_WriteSync(pHwData, 0x03b0, 1); /* Reset hardware first */
-	msleep(10);
+	usleep(10000);
 
 	/* Set burst write delay */
 	Wb35Reg_WriteSync(pHwData, 0x03f8, 0x7ff);
@@ -1055,18 +1055,18 @@ void RFSynthesizer_initial(struct hw_data *pHwData)
 	case RF_AIROHA_2230:
 		ltmp = (1 << 31) | (0 << 30) | (20 << 24) | BitReverse((0x07 << 20) | 0xE168E, 20);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
-		msleep(10);
+		usleep(10000);
 		ltmp = (1 << 31) | (0 << 30) | (20 << 24) | BitReverse(al2230_rf_data[7], 20);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
-		msleep(10);
+		usleep(10000);
 	case RF_AIROHA_2230S:
 		Wb35Reg_WriteSync(pHwData, 0x03d4, 0x80); /* regulator on only */
-		msleep(10);
+		usleep(10000);
 		Wb35Reg_WriteSync(pHwData, 0x03d4, 0xa0); /* PLL_PD REF_PD set to 0 */
-		msleep(10);
+		usleep(10000);
 		Wb35Reg_WriteSync(pHwData, 0x03d4, 0xe0); /* MLK_EN */
 		Wb35Reg_WriteSync(pHwData, 0x03b0, 1); /* Reset hardware first */
-		msleep(10);
+		usleep(10000);
 		/* ========================================================= */
 
 		/* The follow code doesn't use the burst-write mode */
@@ -1077,15 +1077,15 @@ void RFSynthesizer_initial(struct hw_data *pHwData)
 		Wb35Reg_WriteSync(pHwData, 0x105c, ltmp);
 		pHwData->reg.BB50 |= 0x13; /* (MASK_IQCAL_MODE|MASK_CALIB_START) */
 		Wb35Reg_WriteSync(pHwData, 0x1050, pHwData->reg.BB50);
-		msleep(5);
+		usleep(5000);
 
 		ltmp = (1 << 31) | (0 << 30) | (20 << 24) | BitReverse((0x0F << 20) | 0xF01B0, 20);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
-		msleep(5);
+		usleep(5000);
 
 		ltmp = (1 << 31) | (0 << 30) | (20 << 24) | BitReverse((0x0F << 20) | 0xF01E0, 20);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
-		msleep(5);
+		usleep(5000);
 
 		ltmp = (1 << 31) | (0 << 30) | (20 << 24) | BitReverse((0x0F << 20) | 0xF01A0, 20);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
@@ -1102,13 +1102,13 @@ void RFSynthesizer_initial(struct hw_data *pHwData)
 		/* 2.4GHz */
 		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | 0x9ABA8F;
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
-		msleep(5);
+		usleep(5000);
 		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | 0x3ABA8F;
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
-		msleep(5);
+		usleep(5000);
 		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | 0x1ABA8F;
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
-		msleep(5);
+		usleep(5000);
 
 		/* 5GHz */
 		Wb35Reg_WriteSync(pHwData, 0x03dc, 0x00000000);
@@ -1119,20 +1119,20 @@ void RFSynthesizer_initial(struct hw_data *pHwData)
 		/* Write to register. number must less and equal than 16 */
 		for (i = 0; i < number; i++)
 			Wb35Reg_WriteSync(pHwData, 0x0864, pltmp[i]);
-		msleep(5);
+		usleep(5000);
 
 		Wb35Reg_WriteSync(pHwData, 0x03dc, 0x00000080);
 		pr_debug("* PLL_ON    high\n");
 
 		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | 0x9ABA8F;
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
-		msleep(5);
+		usleep(5000);
 		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | 0x3ABA8F;
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
-		msleep(5);
+		usleep(5000);
 		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | 0x12BACF;
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
-		msleep(5);
+		usleep(5000);
 		break;
 	case RF_WB_242:
 	case RF_WB_242_1:
@@ -1147,11 +1147,11 @@ void RFSynthesizer_initial(struct hw_data *pHwData)
 		/* Calibration (1a.0). Synthesizer reset */
 		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x0F<<24) | 0x00101E, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
-		msleep(5);
+		usleep(5000);
 		/* Calibration (1a). VCO frequency calibration mode ; waiting 2msec VCO calibration time */
 		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x00<<24) | 0xFE69c0, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
-		msleep(2);
+		usleep(2000);
 
 		/* ----- Calibration (2). TX baseband Gm-C filter auto-tuning */
 		/* Calibration (2a). turn off ENCAL signal */
@@ -1210,7 +1210,7 @@ void RFSynthesizer_initial(struct hw_data *pHwData)
 		/* Calibration (5d). turn on RX DC offset cal function; and waiting 2 msec cal time */
 		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x00<<24) | 0xFF6DC0, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
-		msleep(2);
+		usleep(2000);
 		/* Calibration (5f). turn off ENCAL signal */
 		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x00<<24) | 0xFAEDC0, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
@@ -1222,7 +1222,7 @@ void RFSynthesizer_initial(struct hw_data *pHwData)
 		/* Calibration (5d). turn on RX DC offset cal function; and waiting 2 msec cal time */
 		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x00<<24) | 0xFF6DC0, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
-		msleep(2);
+		usleep(2000);
 		/* Calibration (5f). turn off ENCAL signal */
 		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x00<<24) | 0xFAEDC0, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
@@ -1234,7 +1234,7 @@ void RFSynthesizer_initial(struct hw_data *pHwData)
 		/* Calibration (5d). turn on RX DC offset cal function; and waiting 2 msec cal time */
 		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x00<<24) | 0xFF6DC0, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
-		msleep(2);
+		usleep(2000);
 		/* Calibration (5f). turn off ENCAL signal */
 		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x00<<24) | 0xFAEDC0, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
@@ -1246,7 +1246,7 @@ void RFSynthesizer_initial(struct hw_data *pHwData)
 		/* Calibration (5d). turn on RX DC offset cal function; and waiting 2 msec cal time */
 		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x00<<24) | 0xFF6DC0, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
-		msleep(2);
+		usleep(2000);
 		/* Calibration (5f). turn off ENCAL signal */
 		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x00<<24) | 0xFAEDC0, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
@@ -1258,7 +1258,7 @@ void RFSynthesizer_initial(struct hw_data *pHwData)
 		/* 0x00 0xF86100 ; 3E184   ; Switch RF chip to normal mode */
 		ltmp = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse((0x00<<24) | 0xF86100, 24);
 		Wb35Reg_WriteSync(pHwData, 0x0864, ltmp);
-		msleep(5);
+		usleep(5000);
 		break;
 	}
 }
-- 
1.8.1.2

