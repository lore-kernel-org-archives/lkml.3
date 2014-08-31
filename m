Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbaHaIkg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 04:40:36 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:57028 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaHaIjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 04:39:13 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 6/9] staging: rtl8188eu: Rework function get_rx_power_val_by_reg()
Date: Sun, 31 Aug 2014 14:08:26 +0530
Message-Id: <1409474309-24362-6-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409474309-24362-1-git-send-email-navin.patidar@gmail.com>
References: <1409474309-24362-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CamelCase variables.
Remove block of the code which is specific to the bluetooth.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c |   92 +++++++++++------------
 1 file changed, 45 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c b/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
index 7797b38..79a329d 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
@@ -154,65 +154,66 @@ static void getpowerbase88e(struct adapter *adapt, u8 *pwr_level_ofdm,
 		*(mcs_base+i) = powerbase1;
 	}
 }
-static void get_rx_power_val_by_reg(struct adapter *Adapter, u8 Channel,
-				    u8 index, u32 *powerBase0, u32 *powerBase1,
-				    u32 *pOutWriteVal)
+static void get_rx_power_val_by_reg(struct adapter *adapt, u8 channel,
+				    u8 index, u32 *powerbase0, u32 *powerbase1,
+				    u32 *out_val)
 {
-	struct hal_data_8188e *pHalData = GET_HAL_DATA(Adapter);
-	struct dm_priv	*pdmpriv = &pHalData->dmpriv;
-	u8	i, chnlGroup = 0, pwr_diff_limit[4], customer_pwr_limit;
-	s8	pwr_diff = 0;
-	u32	writeVal, customer_limit, rf;
-	u8	Regulatory = pHalData->EEPROMRegulatory;
+	struct hal_data_8188e *hal_data = GET_HAL_DATA(adapt);
+	struct dm_priv	*pdmpriv = &hal_data->dmpriv;
+	u8 i, chnlGroup = 0, pwr_diff_limit[4], customer_pwr_limit;
+	s8 pwr_diff = 0;
+	u32 write_val, customer_limit, rf;
+	u8 regulatory = hal_data->EEPROMRegulatory;
 
 	/*  Index 0 & 1= legacy OFDM, 2-5=HT_MCS rate */
 
 	for (rf = 0; rf < 2; rf++) {
-		switch (Regulatory) {
-		case 0:	/*  Realtek better performance */
-				/*  increase power diff defined by Realtek for large power */
+		u8 j = index + (rf ? 8 : 0);
+
+		switch (regulatory) {
+		case 0:
 			chnlGroup = 0;
-			writeVal = pHalData->MCSTxPowerLevelOriginalOffset[chnlGroup][index+(rf ? 8 : 0)] +
-				((index < 2) ? powerBase0[rf] : powerBase1[rf]);
+			write_val = hal_data->MCSTxPowerLevelOriginalOffset[chnlGroup][index+(rf ? 8 : 0)] +
+				((index < 2) ? powerbase0[rf] : powerbase1[rf]);
 			break;
-		case 1:	/*  Realtek regulatory */
+		case 1: /*  Realtek regulatory */
 			/*  increase power diff defined by Realtek for regulatory */
-			if (pHalData->pwrGroupCnt == 1)
+			if (hal_data->pwrGroupCnt == 1)
 				chnlGroup = 0;
-			if (pHalData->pwrGroupCnt >= pHalData->PGMaxGroup) {
-				if (Channel < 3)			/*  Channel 1-2 */
+			if (hal_data->pwrGroupCnt >= hal_data->PGMaxGroup) {
+				if (channel < 3)
 					chnlGroup = 0;
-				else if (Channel < 6)		/*  Channel 3-5 */
+				else if (channel < 6)
 					chnlGroup = 1;
-				else	 if (Channel < 9)		/*  Channel 6-8 */
+				else if (channel < 9)
 					chnlGroup = 2;
-				else if (Channel < 12)		/*  Channel 9-11 */
+				else if (channel < 12)
 					chnlGroup = 3;
-				else if (Channel < 14)		/*  Channel 12-13 */
+				else if (channel < 14)
 					chnlGroup = 4;
-				else if (Channel == 14)		/*  Channel 14 */
+				else if (channel == 14)
 					chnlGroup = 5;
 			}
-			writeVal = pHalData->MCSTxPowerLevelOriginalOffset[chnlGroup][index+(rf ? 8 : 0)] +
-					((index < 2) ? powerBase0[rf] : powerBase1[rf]);
+			write_val = hal_data->MCSTxPowerLevelOriginalOffset[chnlGroup][index+(rf ? 8 : 0)] +
+					((index < 2) ? powerbase0[rf] : powerbase1[rf]);
 			break;
 		case 2:	/*  Better regulatory */
 				/*  don't increase any power diff */
-			writeVal = ((index < 2) ? powerBase0[rf] : powerBase1[rf]);
+			write_val = ((index < 2) ? powerbase0[rf] : powerbase1[rf]);
 			break;
 		case 3:	/*  Customer defined power diff. */
 				/*  increase power diff defined by customer. */
 			chnlGroup = 0;
 
 			if (index < 2)
-				pwr_diff = pHalData->TxPwrLegacyHtDiff[rf][Channel-1];
-			else if (pHalData->CurrentChannelBW == HT_CHANNEL_WIDTH_20)
-				pwr_diff = pHalData->TxPwrHt20Diff[rf][Channel-1];
+				pwr_diff = hal_data->TxPwrLegacyHtDiff[rf][channel-1];
+			else if (hal_data->CurrentChannelBW == HT_CHANNEL_WIDTH_20)
+				pwr_diff = hal_data->TxPwrHt20Diff[rf][channel-1];
 
-			if (pHalData->CurrentChannelBW == HT_CHANNEL_WIDTH_40)
-				customer_pwr_limit = pHalData->PwrGroupHT40[rf][Channel-1];
+			if (hal_data->CurrentChannelBW == HT_CHANNEL_WIDTH_40)
+				customer_pwr_limit = hal_data->PwrGroupHT40[rf][channel-1];
 			else
-				customer_pwr_limit = pHalData->PwrGroupHT20[rf][Channel-1];
+				customer_pwr_limit = hal_data->PwrGroupHT20[rf][channel-1];
 
 			if (pwr_diff >= customer_pwr_limit)
 				pwr_diff = 0;
@@ -220,19 +221,22 @@ static void get_rx_power_val_by_reg(struct adapter *Adapter, u8 Channel,
 				pwr_diff = customer_pwr_limit - pwr_diff;
 
 			for (i = 0; i < 4; i++) {
-				pwr_diff_limit[i] = (u8)((pHalData->MCSTxPowerLevelOriginalOffset[chnlGroup][index+(rf ? 8 : 0)]&(0x7f<<(i*8)))>>(i*8));
+				pwr_diff_limit[i] = (u8)((hal_data->MCSTxPowerLevelOriginalOffset[chnlGroup][j] &
+							 (0x7f << (i * 8))) >> (i * 8));
 
 				if (pwr_diff_limit[i] > pwr_diff)
 					pwr_diff_limit[i] = pwr_diff;
 			}
-			customer_limit = (pwr_diff_limit[3]<<24) | (pwr_diff_limit[2]<<16) |
-					 (pwr_diff_limit[1]<<8) | (pwr_diff_limit[0]);
-			writeVal = customer_limit + ((index < 2) ? powerBase0[rf] : powerBase1[rf]);
+			customer_limit = (pwr_diff_limit[3]<<24) |
+					 (pwr_diff_limit[2]<<16) |
+					 (pwr_diff_limit[1]<<8) |
+					 (pwr_diff_limit[0]);
+			write_val = customer_limit + ((index < 2) ? powerbase0[rf] : powerbase1[rf]);
 			break;
 		default:
 			chnlGroup = 0;
-			writeVal = pHalData->MCSTxPowerLevelOriginalOffset[chnlGroup][index+(rf ? 8 : 0)] +
-					((index < 2) ? powerBase0[rf] : powerBase1[rf]);
+			write_val = hal_data->MCSTxPowerLevelOriginalOffset[chnlGroup][j] +
+					((index < 2) ? powerbase0[rf] : powerbase1[rf]);
 			break;
 		}
 /*  20100427 Joseph: Driver dynamic Tx power shall not affect Tx power. It shall be determined by power training mechanism. */
@@ -240,17 +244,11 @@ static void get_rx_power_val_by_reg(struct adapter *Adapter, u8 Channel,
 /*  In the future, two mechanism shall be separated from each other and maintained independently. Thanks for Lanhsin's reminder. */
 		/* 92d do not need this */
 		if (pdmpriv->DynamicTxHighPowerLvl == TxHighPwrLevel_Level1)
-			writeVal = 0x14141414;
+			write_val = 0x14141414;
 		else if (pdmpriv->DynamicTxHighPowerLvl == TxHighPwrLevel_Level2)
-			writeVal = 0x00000000;
+			write_val = 0x00000000;
 
-		/*  20100628 Joseph: High power mode for BT-Coexist mechanism. */
-		/*  This mechanism is only applied when Driver-Highpower-Mechanism is OFF. */
-		if (pdmpriv->DynamicTxHighPowerLvl == TxHighPwrLevel_BT1)
-			writeVal = writeVal - 0x06060606;
-		else if (pdmpriv->DynamicTxHighPowerLvl == TxHighPwrLevel_BT2)
-			writeVal = writeVal;
-		*(pOutWriteVal+rf) = writeVal;
+		*(out_val+rf) = write_val;
 	}
 }
 
-- 
1.7.10.4

