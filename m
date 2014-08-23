Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbaHWOUq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 10:20:46 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:38934 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbaHWOUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 10:20:44 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 13/20] staging: rtl8188eu: Rework function _PHY_SwChnl8192C()
Date: Sat, 23 Aug 2014 19:48:34 +0530
Message-Id: <1408803521-13715-13-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
References: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CamelCase variables and function name.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
index 89ec958..1aa5a56 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
@@ -367,24 +367,24 @@ void PHY_SetBWMode8188E(struct adapter *Adapter, enum ht_channel_width Bandwidth
 		pHalData->CurrentChannelBW = tmpBW;
 }
 
-static void _PHY_SwChnl8192C(struct adapter *Adapter, u8 channel)
+static void phy_sw_chnl_callback(struct adapter *adapt, u8 channel)
 {
-	u8 eRFPath;
+	u8 rf_path;
 	u32 param1, param2;
-	struct hal_data_8188e	*pHalData = GET_HAL_DATA(Adapter);
+	struct hal_data_8188e *hal_data = GET_HAL_DATA(adapt);
 
-	if (Adapter->bNotifyChannelChange)
+	if (adapt->bNotifyChannelChange)
 		DBG_88E("[%s] ch = %d\n", __func__, channel);
 
-	/* s1. pre common command - CmdID_SetTxPowerLevel */
-	PHY_SetTxPowerLevel8188E(Adapter, channel);
+	PHY_SetTxPowerLevel8188E(adapt, channel);
 
-	/* s2. RF dependent command - CmdID_RF_WriteReg, param1=RF_CHNLBW, param2=channel */
 	param1 = RF_CHNLBW;
 	param2 = channel;
-	for (eRFPath = 0; eRFPath < pHalData->NumTotalRFPath; eRFPath++) {
-		pHalData->RfRegChnlVal[eRFPath] = ((pHalData->RfRegChnlVal[eRFPath] & 0xfffffc00) | param2);
-		phy_set_rf_reg(Adapter, (enum rf_radio_path)eRFPath, param1, bRFRegOffsetMask, pHalData->RfRegChnlVal[eRFPath]);
+	for (rf_path = 0; rf_path < hal_data->NumTotalRFPath; rf_path++) {
+		hal_data->RfRegChnlVal[rf_path] = (hal_data->RfRegChnlVal[rf_path] &
+						  0xfffffc00) | param2;
+		phy_set_rf_reg(adapt, (enum rf_radio_path)rf_path, param1,
+			       bRFRegOffsetMask, hal_data->RfRegChnlVal[rf_path]);
 	}
 }
 
@@ -404,7 +404,7 @@ void PHY_SwChnl8188E(struct adapter *Adapter, u8 channel)
 	pHalData->CurrentChannel = channel;
 
 	if ((!Adapter->bDriverStopped) && (!Adapter->bSurpriseRemoved)) {
-		_PHY_SwChnl8192C(Adapter, channel);
+		phy_sw_chnl_callback(Adapter, channel);
 
 		if (bResult)
 			;
-- 
1.7.10.4

