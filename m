Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbaHaIjB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 04:39:01 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:33507 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaHaIiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 04:38:52 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 3/9] staging: rtl8188eu: Rework function getpowerbase88e()
Date: Sun, 31 Aug 2014 14:08:23 +0530
Message-Id: <1409474309-24362-3-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409474309-24362-1-git-send-email-navin.patidar@gmail.com>
References: <1409474309-24362-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CamelCase variables.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c |   33 ++++++++++++-----------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c b/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
index 8959ac3..6a1731c 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
@@ -125,32 +125,33 @@ void rtl88eu_phy_rf6052_set_cck_txpower(struct adapter *adapt, u8 *powerlevel)
 	phy_set_bb_reg(adapt, rTxAGC_B_CCK1_55_Mcs32, 0xffffff00, tmpval);
 }
 
-/*  */
 /*  powerbase0 for OFDM rates */
 /*  powerbase1 for HT MCS rates */
-/*  */
-static void getpowerbase88e(struct adapter *Adapter, u8 *pPowerLevelOFDM,
-			    u8 *pPowerLevelBW20, u8 *pPowerLevelBW40, u8 Channel, u32 *OfdmBase, u32 *MCSBase)
+static void getpowerbase88e(struct adapter *adapt, u8 *pwr_level_ofdm,
+			    u8 *pwr_level_bw20, u8 *pwr_level_bw40,
+			    u8 channel,u32 *ofdmbase, u32 *mcs_base)
 {
-	struct hal_data_8188e *pHalData = GET_HAL_DATA(Adapter);
-	u32 powerBase0, powerBase1;
+	struct hal_data_8188e *hal_data = GET_HAL_DATA(adapt);
+	u32 powerbase0, powerbase1;
 	u8 i, powerlevel[2];
 
 	for (i = 0; i < 2; i++) {
-		powerBase0 = pPowerLevelOFDM[i];
+		powerbase0 = pwr_level_ofdm[i];
 
-		powerBase0 = (powerBase0<<24) | (powerBase0<<16) | (powerBase0<<8) | powerBase0;
-		*(OfdmBase+i) = powerBase0;
+		powerbase0 = (powerbase0<<24) | (powerbase0<<16) |
+			     (powerbase0<<8) | powerbase0;
+		*(ofdmbase+i) = powerbase0;
 	}
-	for (i = 0; i < pHalData->NumTotalRFPath; i++) {
+	for (i = 0; i < hal_data->NumTotalRFPath; i++) {
 		/* Check HT20 to HT40 diff */
-		if (pHalData->CurrentChannelBW == HT_CHANNEL_WIDTH_20)
-			powerlevel[i] = pPowerLevelBW20[i];
+		if (hal_data->CurrentChannelBW == HT_CHANNEL_WIDTH_20)
+			powerlevel[i] = pwr_level_bw20[i];
 		else
-			powerlevel[i] = pPowerLevelBW40[i];
-		powerBase1 = powerlevel[i];
-		powerBase1 = (powerBase1<<24) | (powerBase1<<16) | (powerBase1<<8) | powerBase1;
-		*(MCSBase+i) = powerBase1;
+			powerlevel[i] = pwr_level_bw40[i];
+		powerbase1 = powerlevel[i];
+		powerbase1 = (powerbase1<<24) | (powerbase1<<16) |
+			     (powerbase1<<8) | powerbase1;
+		*(mcs_base+i) = powerbase1;
 	}
 }
 static void get_rx_power_val_by_reg(struct adapter *Adapter, u8 Channel,
-- 
1.7.10.4

