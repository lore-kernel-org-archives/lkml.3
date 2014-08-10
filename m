Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaHJOqc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 10:46:32 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:43858 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbaHJOq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 10:46:29 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 09/22] staging: rtl8188eu: Remove unused function storePwrIndexDiffRateOffset()
Date: Sun, 10 Aug 2014 20:14:22 +0530
Message-Id: <1407681875-2611-9-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
References: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c    |   44 --------------------
 drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h |    2 -
 2 files changed, 46 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
index 96361b8..0f90cf4 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
@@ -354,50 +354,6 @@ rtl8188e_PHY_SetRFReg(
 	phy_RFSerialWrite(Adapter, eRFPath, RegAddr, Data);
 }
 
-void storePwrIndexDiffRateOffset(struct adapter *Adapter, u32 RegAddr, u32 BitMask, u32 Data)
-{
-	struct hal_data_8188e	*pHalData = GET_HAL_DATA(Adapter);
-
-	if (RegAddr == rTxAGC_A_Rate18_06)
-		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][0] = Data;
-	if (RegAddr == rTxAGC_A_Rate54_24)
-		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][1] = Data;
-	if (RegAddr == rTxAGC_A_CCK1_Mcs32)
-		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][6] = Data;
-	if (RegAddr == rTxAGC_B_CCK11_A_CCK2_11 && BitMask == 0xffffff00)
-		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][7] = Data;
-	if (RegAddr == rTxAGC_A_Mcs03_Mcs00)
-		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][2] = Data;
-	if (RegAddr == rTxAGC_A_Mcs07_Mcs04)
-		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][3] = Data;
-	if (RegAddr == rTxAGC_A_Mcs11_Mcs08)
-		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][4] = Data;
-	if (RegAddr == rTxAGC_A_Mcs15_Mcs12) {
-		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][5] = Data;
-		if (pHalData->rf_type == RF_1T1R)
-			pHalData->pwrGroupCnt++;
-	}
-	if (RegAddr == rTxAGC_B_Rate18_06)
-		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][8] = Data;
-	if (RegAddr == rTxAGC_B_Rate54_24)
-		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][9] = Data;
-	if (RegAddr == rTxAGC_B_CCK1_55_Mcs32)
-		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][14] = Data;
-	if (RegAddr == rTxAGC_B_CCK11_A_CCK2_11 && BitMask == 0x000000ff)
-		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][15] = Data;
-	if (RegAddr == rTxAGC_B_Mcs03_Mcs00)
-		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][10] = Data;
-	if (RegAddr == rTxAGC_B_Mcs07_Mcs04)
-		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][11] = Data;
-	if (RegAddr == rTxAGC_B_Mcs11_Mcs08)
-		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][12] = Data;
-	if (RegAddr == rTxAGC_B_Mcs15_Mcs12) {
-		pHalData->MCSTxPowerLevelOriginalOffset[pHalData->pwrGroupCnt][13] = Data;
-		if (pHalData->rf_type != RF_1T1R)
-			pHalData->pwrGroupCnt++;
-	}
-}
-
 static void getTxPowerIndex88E(struct adapter *Adapter, u8 channel, u8 *cckPowerLevel,
 			       u8 *ofdmPowerLevel, u8 *BW20PowerLevel,
 			       u8 *BW40PowerLevel)
diff --git a/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h b/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
index ed156d3..49e1825 100644
--- a/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
+++ b/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
@@ -244,8 +244,6 @@ void PHY_EnableHostClkReq(struct adapter *adapter);
 
 bool SetAntennaConfig92C(struct adapter *adapter, u8 defaultant);
 
-void storePwrIndexDiffRateOffset(struct adapter *adapter, u32 regaddr,
-				 u32 mask, u32 data);
 /*--------------------------Exported Function prototype---------------------*/
 
 #define PHY_QueryBBReg(adapt, regaddr, mask)			\
-- 
1.7.10.4

