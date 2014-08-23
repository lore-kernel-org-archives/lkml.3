Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbaHWOUZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 10:20:25 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:34301 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbaHWOUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 10:20:23 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 10/20] staging: rtl8188eu: Rework function getTxPowerIndex88E()
Date: Sat, 23 Aug 2014 19:48:31 +0530
Message-Id: <1408803521-13715-10-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
References: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CamelCase variables and function name.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c |  105 ++++++++++-------------
 1 file changed, 45 insertions(+), 60 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
index 83cd19d..f4df9ef 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
@@ -150,78 +150,63 @@ void phy_set_rf_reg(struct adapter *adapt, enum rf_radio_path rf_path,
 	rf_serial_write(adapt, rf_path, reg_addr, data);
 }
 
-static void getTxPowerIndex88E(struct adapter *Adapter, u8 channel, u8 *cckPowerLevel,
-			       u8 *ofdmPowerLevel, u8 *BW20PowerLevel,
-			       u8 *BW40PowerLevel)
+static void get_tx_power_index(struct adapter *adapt, u8 channel, u8 *cck_pwr,
+			       u8 *ofdm_pwr, u8 *bw20_pwr, u8 *bw40_pwr)
 {
-	struct hal_data_8188e *pHalData = GET_HAL_DATA(Adapter);
+	struct hal_data_8188e *hal_data = GET_HAL_DATA(adapt);
 	u8 index = (channel - 1);
 	u8 TxCount = 0, path_nums;
 
-	if ((RF_1T2R == pHalData->rf_type) || (RF_1T1R == pHalData->rf_type))
+	if ((RF_1T2R == hal_data->rf_type) || (RF_1T1R == hal_data->rf_type))
 		path_nums = 1;
 	else
 		path_nums = 2;
 
 	for (TxCount = 0; TxCount < path_nums; TxCount++) {
 		if (TxCount == RF_PATH_A) {
-			/*  1. CCK */
-			cckPowerLevel[TxCount]	= pHalData->Index24G_CCK_Base[TxCount][index];
-			/* 2. OFDM */
-			ofdmPowerLevel[TxCount]	= pHalData->Index24G_BW40_Base[RF_PATH_A][index]+
-				pHalData->OFDM_24G_Diff[TxCount][RF_PATH_A];
-			/*  1. BW20 */
-			BW20PowerLevel[TxCount]	= pHalData->Index24G_BW40_Base[RF_PATH_A][index]+
-				pHalData->BW20_24G_Diff[TxCount][RF_PATH_A];
-			/* 2. BW40 */
-			BW40PowerLevel[TxCount]	= pHalData->Index24G_BW40_Base[TxCount][index];
+			cck_pwr[TxCount] = hal_data->Index24G_CCK_Base[TxCount][index];
+			ofdm_pwr[TxCount] = hal_data->Index24G_BW40_Base[RF_PATH_A][index]+
+					    hal_data->OFDM_24G_Diff[TxCount][RF_PATH_A];
+
+			bw20_pwr[TxCount] = hal_data->Index24G_BW40_Base[RF_PATH_A][index]+
+					    hal_data->BW20_24G_Diff[TxCount][RF_PATH_A];
+			bw40_pwr[TxCount] = hal_data->Index24G_BW40_Base[TxCount][index];
 		} else if (TxCount == RF_PATH_B) {
-			/*  1. CCK */
-			cckPowerLevel[TxCount]	= pHalData->Index24G_CCK_Base[TxCount][index];
-			/* 2. OFDM */
-			ofdmPowerLevel[TxCount]	= pHalData->Index24G_BW40_Base[RF_PATH_A][index]+
-			pHalData->BW20_24G_Diff[RF_PATH_A][index]+
-			pHalData->BW20_24G_Diff[TxCount][index];
-			/*  1. BW20 */
-			BW20PowerLevel[TxCount]	= pHalData->Index24G_BW40_Base[RF_PATH_A][index]+
-			pHalData->BW20_24G_Diff[TxCount][RF_PATH_A]+
-			pHalData->BW20_24G_Diff[TxCount][index];
-			/* 2. BW40 */
-			BW40PowerLevel[TxCount]	= pHalData->Index24G_BW40_Base[TxCount][index];
+			cck_pwr[TxCount] = hal_data->Index24G_CCK_Base[TxCount][index];
+			ofdm_pwr[TxCount] = hal_data->Index24G_BW40_Base[RF_PATH_A][index]+
+			hal_data->BW20_24G_Diff[RF_PATH_A][index]+
+			hal_data->BW20_24G_Diff[TxCount][index];
+
+			bw20_pwr[TxCount] = hal_data->Index24G_BW40_Base[RF_PATH_A][index]+
+			hal_data->BW20_24G_Diff[TxCount][RF_PATH_A]+
+			hal_data->BW20_24G_Diff[TxCount][index];
+			bw40_pwr[TxCount] = hal_data->Index24G_BW40_Base[TxCount][index];
 		} else if (TxCount == RF_PATH_C) {
-			/*  1. CCK */
-			cckPowerLevel[TxCount]	= pHalData->Index24G_CCK_Base[TxCount][index];
-			/* 2. OFDM */
-			ofdmPowerLevel[TxCount]	= pHalData->Index24G_BW40_Base[RF_PATH_A][index]+
-			pHalData->BW20_24G_Diff[RF_PATH_A][index]+
-			pHalData->BW20_24G_Diff[RF_PATH_B][index]+
-			pHalData->BW20_24G_Diff[TxCount][index];
-			/*  1. BW20 */
-			BW20PowerLevel[TxCount]	= pHalData->Index24G_BW40_Base[RF_PATH_A][index]+
-			pHalData->BW20_24G_Diff[RF_PATH_A][index]+
-			pHalData->BW20_24G_Diff[RF_PATH_B][index]+
-			pHalData->BW20_24G_Diff[TxCount][index];
-			/* 2. BW40 */
-			BW40PowerLevel[TxCount]	= pHalData->Index24G_BW40_Base[TxCount][index];
+			cck_pwr[TxCount] = hal_data->Index24G_CCK_Base[TxCount][index];
+			ofdm_pwr[TxCount] = hal_data->Index24G_BW40_Base[RF_PATH_A][index]+
+			hal_data->BW20_24G_Diff[RF_PATH_A][index]+
+			hal_data->BW20_24G_Diff[RF_PATH_B][index]+
+			hal_data->BW20_24G_Diff[TxCount][index];
+
+			bw20_pwr[TxCount] = hal_data->Index24G_BW40_Base[RF_PATH_A][index]+
+			hal_data->BW20_24G_Diff[RF_PATH_A][index]+
+			hal_data->BW20_24G_Diff[RF_PATH_B][index]+
+			hal_data->BW20_24G_Diff[TxCount][index];
+			bw40_pwr[TxCount] = hal_data->Index24G_BW40_Base[TxCount][index];
 		} else if (TxCount == RF_PATH_D) {
-			/*  1. CCK */
-			cckPowerLevel[TxCount]	= pHalData->Index24G_CCK_Base[TxCount][index];
-			/* 2. OFDM */
-			ofdmPowerLevel[TxCount]	= pHalData->Index24G_BW40_Base[RF_PATH_A][index]+
-			pHalData->BW20_24G_Diff[RF_PATH_A][index]+
-			pHalData->BW20_24G_Diff[RF_PATH_B][index]+
-			pHalData->BW20_24G_Diff[RF_PATH_C][index]+
-			pHalData->BW20_24G_Diff[TxCount][index];
-
-			/*  1. BW20 */
-			BW20PowerLevel[TxCount]	= pHalData->Index24G_BW40_Base[RF_PATH_A][index]+
-			pHalData->BW20_24G_Diff[RF_PATH_A][index]+
-			pHalData->BW20_24G_Diff[RF_PATH_B][index]+
-			pHalData->BW20_24G_Diff[RF_PATH_C][index]+
-			pHalData->BW20_24G_Diff[TxCount][index];
-
-			/* 2. BW40 */
-			BW40PowerLevel[TxCount]	= pHalData->Index24G_BW40_Base[TxCount][index];
+			cck_pwr[TxCount] = hal_data->Index24G_CCK_Base[TxCount][index];
+			ofdm_pwr[TxCount] = hal_data->Index24G_BW40_Base[RF_PATH_A][index]+
+			hal_data->BW20_24G_Diff[RF_PATH_A][index]+
+			hal_data->BW20_24G_Diff[RF_PATH_B][index]+
+			hal_data->BW20_24G_Diff[RF_PATH_C][index]+
+			hal_data->BW20_24G_Diff[TxCount][index];
+
+			bw20_pwr[TxCount] = hal_data->Index24G_BW40_Base[RF_PATH_A][index]+
+			hal_data->BW20_24G_Diff[RF_PATH_A][index]+
+			hal_data->BW20_24G_Diff[RF_PATH_B][index]+
+			hal_data->BW20_24G_Diff[RF_PATH_C][index]+
+			hal_data->BW20_24G_Diff[TxCount][index];
+			bw40_pwr[TxCount] = hal_data->Index24G_BW40_Base[TxCount][index];
 		}
 	}
 }
@@ -265,7 +250,7 @@ PHY_SetTxPowerLevel8188E(
 	u8 BW20PowerLevel[MAX_TX_COUNT] = {0};
 	u8 BW40PowerLevel[MAX_TX_COUNT] = {0};
 
-	getTxPowerIndex88E(Adapter, channel, &cckPowerLevel[0], &ofdmPowerLevel[0], &BW20PowerLevel[0], &BW40PowerLevel[0]);
+	get_tx_power_index(Adapter, channel, &cckPowerLevel[0], &ofdmPowerLevel[0], &BW20PowerLevel[0], &BW40PowerLevel[0]);
 
 	phy_PowerIndexCheck88E(Adapter, channel, &cckPowerLevel[0], &ofdmPowerLevel[0], &BW20PowerLevel[0], &BW40PowerLevel[0]);
 
-- 
1.7.10.4

