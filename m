Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbaHWOUe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 10:20:34 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:52970 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbaHWOUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 10:20:30 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 11/20] staging: rtl8188eu: Rework function phy_PowerIndexCheck88E()
Date: Sat, 23 Aug 2014 19:48:32 +0530
Message-Id: <1408803521-13715-11-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
References: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CamelCase variables and function name.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
index f4df9ef..c33da36 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
@@ -211,15 +211,16 @@ static void get_tx_power_index(struct adapter *adapt, u8 channel, u8 *cck_pwr,
 	}
 }
 
-static void phy_PowerIndexCheck88E(struct adapter *Adapter, u8 channel, u8 *cckPowerLevel,
-				   u8 *ofdmPowerLevel, u8 *BW20PowerLevel, u8 *BW40PowerLevel)
+static void phy_power_index_check(struct adapter *adapt, u8 channel,
+				  u8 *cck_pwr, u8 *ofdm_pwr, u8 *bw20_pwr,
+				  u8 *bw40_pwr)
 {
-	struct hal_data_8188e		*pHalData = GET_HAL_DATA(Adapter);
+	struct hal_data_8188e *hal_data = GET_HAL_DATA(adapt);
 
-	pHalData->CurrentCckTxPwrIdx = cckPowerLevel[0];
-	pHalData->CurrentOfdm24GTxPwrIdx = ofdmPowerLevel[0];
-	pHalData->CurrentBW2024GTxPwrIdx = BW20PowerLevel[0];
-	pHalData->CurrentBW4024GTxPwrIdx = BW40PowerLevel[0];
+	hal_data->CurrentCckTxPwrIdx = cck_pwr[0];
+	hal_data->CurrentOfdm24GTxPwrIdx = ofdm_pwr[0];
+	hal_data->CurrentBW2024GTxPwrIdx = bw20_pwr[0];
+	hal_data->CurrentBW4024GTxPwrIdx = bw40_pwr[0];
 }
 
 /*-----------------------------------------------------------------------------
@@ -252,7 +253,7 @@ PHY_SetTxPowerLevel8188E(
 
 	get_tx_power_index(Adapter, channel, &cckPowerLevel[0], &ofdmPowerLevel[0], &BW20PowerLevel[0], &BW40PowerLevel[0]);
 
-	phy_PowerIndexCheck88E(Adapter, channel, &cckPowerLevel[0], &ofdmPowerLevel[0], &BW20PowerLevel[0], &BW40PowerLevel[0]);
+	phy_power_index_check(Adapter, channel, &cckPowerLevel[0], &ofdmPowerLevel[0], &BW20PowerLevel[0], &BW40PowerLevel[0]);
 
 	rtl8188e_PHY_RF6052SetCckTxPower(Adapter, &cckPowerLevel[0]);
 	rtl8188e_PHY_RF6052SetOFDMTxPower(Adapter, &ofdmPowerLevel[0], &BW20PowerLevel[0], &BW40PowerLevel[0], channel);
-- 
1.7.10.4

