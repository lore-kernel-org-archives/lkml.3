Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaHWOTk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 10:19:40 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:51551 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbaHWOTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 10:19:36 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 03/20] staging: rtl8188eu: Rework function PHY_QueryBBReg()
Date: Sat, 23 Aug 2014 19:48:24 +0530
Message-Id: <1408803521-13715-3-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
References: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CamelCase variables and function name.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c   |    8 +--
 drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c     |   69 ++++++++++----------
 drivers/staging/rtl8188eu/hal/odm.c                |   31 ++++-----
 drivers/staging/rtl8188eu/hal/odm_RTL8188E.c       |    9 +--
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c    |   44 ++++---------
 drivers/staging/rtl8188eu/hal/usb_halinit.c        |    2 +-
 drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h |    3 -
 drivers/staging/rtl8188eu/include/phy.h            |    2 +
 8 files changed, 75 insertions(+), 93 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c b/drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c
index 94ee740..0284602 100644
--- a/drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c
+++ b/drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c
@@ -245,13 +245,13 @@ static bool rf6052_conf_para(struct adapter *adapt)
 		switch (rfpath) {
 		case RF90_PATH_A:
 		case RF90_PATH_C:
-			u4val = PHY_QueryBBReg(adapt, pphyreg->rfintfs,
-						    BRFSI_RFENV);
+			u4val = phy_query_bb_reg(adapt, pphyreg->rfintfs,
+						 BRFSI_RFENV);
 			break;
 		case RF90_PATH_B:
 		case RF90_PATH_D:
-			u4val = PHY_QueryBBReg(adapt, pphyreg->rfintfs,
-						    BRFSI_RFENV << 16);
+			u4val = phy_query_bb_reg(adapt, pphyreg->rfintfs,
+						 BRFSI_RFENV << 16);
 			break;
 		}
 
diff --git a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
index d2bcc16..e36fa5e 100644
--- a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
+++ b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
@@ -17,6 +17,7 @@
  */
 
 #include "odm_precomp.h"
+#include "phy.h"
 
 /*  2010/04/25 MH Define the max tx power tracking tx agc power. */
 #define		ODM_TXPWRTRACK_MAX_IDX_88E		6
@@ -181,7 +182,7 @@ odm_TXPowerTrackingCallback_ThermalMeter_8188E(
 
 	if (ThermalValue) {
 		/* Query OFDM path A default setting */
-		ele_D = PHY_QueryBBReg(Adapter, rOFDM0_XATxIQImbalance, bMaskDWord)&bMaskOFDM_D;
+		ele_D = phy_query_bb_reg(Adapter, rOFDM0_XATxIQImbalance, bMaskDWord)&bMaskOFDM_D;
 		for (i = 0; i < OFDM_TABLE_SIZE_92D; i++) {	/* find the index */
 			if (ele_D == (OFDMSwingTable[i]&bMaskOFDM_D)) {
 				OFDM_index_old[0] = (u8)i;
@@ -195,7 +196,7 @@ odm_TXPowerTrackingCallback_ThermalMeter_8188E(
 
 		/* Query OFDM path B default setting */
 		if (is2t) {
-			ele_D = PHY_QueryBBReg(Adapter, rOFDM0_XBTxIQImbalance, bMaskDWord)&bMaskOFDM_D;
+			ele_D = phy_query_bb_reg(Adapter, rOFDM0_XBTxIQImbalance, bMaskDWord)&bMaskOFDM_D;
 			for (i = 0; i < OFDM_TABLE_SIZE_92D; i++) {	/* find the index */
 				if (ele_D == (OFDMSwingTable[i]&bMaskOFDM_D)) {
 					OFDM_index_old[1] = (u8)i;
@@ -444,7 +445,7 @@ odm_TXPowerTrackingCallback_ThermalMeter_8188E(
 
 				ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD,
 					     ("TxPwrTracking 0xc80 = 0x%x, 0xc94 = 0x%x RF 0x24 = 0x%x\n",
-					     PHY_QueryBBReg(Adapter, 0xc80, bMaskDWord), PHY_QueryBBReg(Adapter,
+					     phy_query_bb_reg(Adapter, 0xc80, bMaskDWord), phy_query_bb_reg(Adapter,
 					     0xc94, bMaskDWord), PHY_QueryRFReg(Adapter, RF_PATH_A, 0x24, bRFRegOffsetMask)));
 			}
 		}
@@ -497,13 +498,13 @@ phy_PathA_IQK_8188E(struct adapter *adapt, bool configPathB)
 	mdelay(IQK_DELAY_TIME_88E);
 
 	/*  Check failed */
-	regeac = PHY_QueryBBReg(adapt, rRx_Power_After_IQK_A_2, bMaskDWord);
+	regeac = phy_query_bb_reg(adapt, rRx_Power_After_IQK_A_2, bMaskDWord);
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("0xeac = 0x%x\n", regeac));
-	regE94 = PHY_QueryBBReg(adapt, rTx_Power_Before_IQK_A, bMaskDWord);
+	regE94 = phy_query_bb_reg(adapt, rTx_Power_Before_IQK_A, bMaskDWord);
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("0xe94 = 0x%x\n", regE94));
-	regE9C = PHY_QueryBBReg(adapt, rTx_Power_After_IQK_A, bMaskDWord);
+	regE9C = phy_query_bb_reg(adapt, rTx_Power_After_IQK_A, bMaskDWord);
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD,  ("0xe9c = 0x%x\n", regE9C));
-	regEA4 = PHY_QueryBBReg(adapt, rRx_Power_Before_IQK_A_2, bMaskDWord);
+	regEA4 = phy_query_bb_reg(adapt, rRx_Power_Before_IQK_A_2, bMaskDWord);
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("0xea4 = 0x%x\n", regEA4));
 
 	if (!(regeac & BIT28) &&
@@ -563,13 +564,13 @@ phy_PathA_RxIQK(struct adapter *adapt, bool configPathB)
 	mdelay(IQK_DELAY_TIME_88E);
 
 	/*  Check failed */
-	regeac = PHY_QueryBBReg(adapt, rRx_Power_After_IQK_A_2, bMaskDWord);
+	regeac = phy_query_bb_reg(adapt, rRx_Power_After_IQK_A_2, bMaskDWord);
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD,
 		     ("0xeac = 0x%x\n", regeac));
-	regE94 = PHY_QueryBBReg(adapt, rTx_Power_Before_IQK_A, bMaskDWord);
+	regE94 = phy_query_bb_reg(adapt, rTx_Power_Before_IQK_A, bMaskDWord);
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD,
 		     ("0xe94 = 0x%x\n", regE94));
-	regE9C = PHY_QueryBBReg(adapt, rTx_Power_After_IQK_A, bMaskDWord);
+	regE9C = phy_query_bb_reg(adapt, rTx_Power_After_IQK_A, bMaskDWord);
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD,
 		     ("0xe9c = 0x%x\n", regE9C));
 
@@ -582,7 +583,7 @@ phy_PathA_RxIQK(struct adapter *adapt, bool configPathB)
 
 	u4tmp = 0x80007C00 | (regE94&0x3FF0000)  | ((regE9C&0x3FF0000) >> 16);
 	PHY_SetBBReg(adapt, rTx_IQK, bMaskDWord, u4tmp);
-	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("0xe40 = 0x%x u4tmp = 0x%x\n", PHY_QueryBBReg(adapt, rTx_IQK, bMaskDWord), u4tmp));
+	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("0xe40 = 0x%x u4tmp = 0x%x\n", phy_query_bb_reg(adapt, rTx_IQK, bMaskDWord), u4tmp));
 
 	/* 1 RX IQK */
 	/* modify RXIQK mode table */
@@ -618,13 +619,13 @@ phy_PathA_RxIQK(struct adapter *adapt, bool configPathB)
 	mdelay(IQK_DELAY_TIME_88E);
 
 	/*  Check failed */
-	regeac = PHY_QueryBBReg(adapt, rRx_Power_After_IQK_A_2, bMaskDWord);
+	regeac = phy_query_bb_reg(adapt, rRx_Power_After_IQK_A_2, bMaskDWord);
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD,  ("0xeac = 0x%x\n", regeac));
-	regE94 = PHY_QueryBBReg(adapt, rTx_Power_Before_IQK_A, bMaskDWord);
+	regE94 = phy_query_bb_reg(adapt, rTx_Power_Before_IQK_A, bMaskDWord);
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD,  ("0xe94 = 0x%x\n", regE94));
-	regE9C = PHY_QueryBBReg(adapt, rTx_Power_After_IQK_A, bMaskDWord);
+	regE9C = phy_query_bb_reg(adapt, rTx_Power_After_IQK_A, bMaskDWord);
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD,  ("0xe9c = 0x%x\n", regE9C));
-	regEA4 = PHY_QueryBBReg(adapt, rRx_Power_Before_IQK_A_2, bMaskDWord);
+	regEA4 = phy_query_bb_reg(adapt, rRx_Power_Before_IQK_A_2, bMaskDWord);
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD,  ("0xea4 = 0x%x\n", regEA4));
 
 	/* reload RF 0xdf */
@@ -662,19 +663,19 @@ phy_PathB_IQK_8188E(struct adapter *adapt)
 	mdelay(IQK_DELAY_TIME_88E);
 
 	/*  Check failed */
-	regeac = PHY_QueryBBReg(adapt, rRx_Power_After_IQK_A_2, bMaskDWord);
+	regeac = phy_query_bb_reg(adapt, rRx_Power_After_IQK_A_2, bMaskDWord);
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD,
 		     ("0xeac = 0x%x\n", regeac));
-	regeb4 = PHY_QueryBBReg(adapt, rTx_Power_Before_IQK_B, bMaskDWord);
+	regeb4 = phy_query_bb_reg(adapt, rTx_Power_Before_IQK_B, bMaskDWord);
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD,
 		     ("0xeb4 = 0x%x\n", regeb4));
-	regebc = PHY_QueryBBReg(adapt, rTx_Power_After_IQK_B, bMaskDWord);
+	regebc = phy_query_bb_reg(adapt, rTx_Power_After_IQK_B, bMaskDWord);
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD,
 		     ("0xebc = 0x%x\n", regebc));
-	regec4 = PHY_QueryBBReg(adapt, rRx_Power_Before_IQK_B_2, bMaskDWord);
+	regec4 = phy_query_bb_reg(adapt, rRx_Power_Before_IQK_B_2, bMaskDWord);
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD,
 		     ("0xec4 = 0x%x\n", regec4));
-	regecc = PHY_QueryBBReg(adapt, rRx_Power_After_IQK_B_2, bMaskDWord);
+	regecc = phy_query_bb_reg(adapt, rRx_Power_After_IQK_B_2, bMaskDWord);
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD,
 		     ("0xecc = 0x%x\n", regecc));
 
@@ -707,7 +708,7 @@ static void patha_fill_iqk(struct adapter *adapt, bool iqkok, s32 result[][8], u
 	if (final_candidate == 0xFF) {
 		return;
 	} else if (iqkok) {
-		Oldval_0 = (PHY_QueryBBReg(adapt, rOFDM0_XATxIQImbalance, bMaskDWord) >> 22) & 0x3FF;
+		Oldval_0 = (phy_query_bb_reg(adapt, rOFDM0_XATxIQImbalance, bMaskDWord) >> 22) & 0x3FF;
 
 		X = result[final_candidate][0];
 		if ((X & 0x00000200) != 0)
@@ -760,7 +761,7 @@ static void pathb_fill_iqk(struct adapter *adapt, bool iqkok, s32 result[][8], u
 	if (final_candidate == 0xFF) {
 		return;
 	} else if (iqkok) {
-		Oldval_1 = (PHY_QueryBBReg(adapt, rOFDM0_XBTxIQImbalance, bMaskDWord) >> 22) & 0x3FF;
+		Oldval_1 = (phy_query_bb_reg(adapt, rOFDM0_XBTxIQImbalance, bMaskDWord) >> 22) & 0x3FF;
 
 		X = result[final_candidate][4];
 		if ((X & 0x00000200) != 0)
@@ -804,7 +805,7 @@ void _PHY_SaveADDARegisters(struct adapter *adapt, u32 *ADDAReg, u32 *ADDABackup
 
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("Save ADDA parameters.\n"));
 	for (i = 0; i < RegisterNum; i++) {
-		ADDABackup[i] = PHY_QueryBBReg(adapt, ADDAReg[i], bMaskDWord);
+		ADDABackup[i] = phy_query_bb_reg(adapt, ADDAReg[i], bMaskDWord);
 	}
 }
 
@@ -1077,7 +1078,7 @@ static void phy_IQCalibrate_8188E(struct adapter *adapt, s32 result[][8], u8 t,
 
 	_PHY_PathADDAOn(adapt, ADDA_REG, true, is2t);
 	if (t == 0)
-		dm_odm->RFCalibrateInfo.bRfPiEnable = (u8)PHY_QueryBBReg(adapt, rFPGA0_XA_HSSIParameter1, BIT(8));
+		dm_odm->RFCalibrateInfo.bRfPiEnable = (u8)phy_query_bb_reg(adapt, rFPGA0_XA_HSSIParameter1, BIT(8));
 
 	if (!dm_odm->RFCalibrateInfo.bRfPiEnable) {
 		/*  Switch BB to PI mode to do IQ Calibration. */
@@ -1120,8 +1121,8 @@ static void phy_IQCalibrate_8188E(struct adapter *adapt, s32 result[][8], u8 t,
 		PathAOK = phy_PathA_IQK_8188E(adapt, is2t);
 		if (PathAOK == 0x01) {
 			ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("Path A Tx IQK Success!!\n"));
-				result[t][0] = (PHY_QueryBBReg(adapt, rTx_Power_Before_IQK_A, bMaskDWord)&0x3FF0000)>>16;
-				result[t][1] = (PHY_QueryBBReg(adapt, rTx_Power_After_IQK_A, bMaskDWord)&0x3FF0000)>>16;
+				result[t][0] = (phy_query_bb_reg(adapt, rTx_Power_Before_IQK_A, bMaskDWord)&0x3FF0000)>>16;
+				result[t][1] = (phy_query_bb_reg(adapt, rTx_Power_After_IQK_A, bMaskDWord)&0x3FF0000)>>16;
 			break;
 		}
 	}
@@ -1130,8 +1131,8 @@ static void phy_IQCalibrate_8188E(struct adapter *adapt, s32 result[][8], u8 t,
 		PathAOK = phy_PathA_RxIQK(adapt, is2t);
 		if (PathAOK == 0x03) {
 			ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD,  ("Path A Rx IQK Success!!\n"));
-				result[t][2] = (PHY_QueryBBReg(adapt, rRx_Power_Before_IQK_A_2, bMaskDWord)&0x3FF0000)>>16;
-				result[t][3] = (PHY_QueryBBReg(adapt, rRx_Power_After_IQK_A_2, bMaskDWord)&0x3FF0000)>>16;
+				result[t][2] = (phy_query_bb_reg(adapt, rRx_Power_Before_IQK_A_2, bMaskDWord)&0x3FF0000)>>16;
+				result[t][3] = (phy_query_bb_reg(adapt, rRx_Power_After_IQK_A_2, bMaskDWord)&0x3FF0000)>>16;
 			break;
 		} else {
 			ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("Path A Rx IQK Fail!!\n"));
@@ -1152,15 +1153,15 @@ static void phy_IQCalibrate_8188E(struct adapter *adapt, s32 result[][8], u8 t,
 			PathBOK = phy_PathB_IQK_8188E(adapt);
 			if (PathBOK == 0x03) {
 				ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("Path B IQK Success!!\n"));
-				result[t][4] = (PHY_QueryBBReg(adapt, rTx_Power_Before_IQK_B, bMaskDWord)&0x3FF0000)>>16;
-				result[t][5] = (PHY_QueryBBReg(adapt, rTx_Power_After_IQK_B, bMaskDWord)&0x3FF0000)>>16;
-				result[t][6] = (PHY_QueryBBReg(adapt, rRx_Power_Before_IQK_B_2, bMaskDWord)&0x3FF0000)>>16;
-				result[t][7] = (PHY_QueryBBReg(adapt, rRx_Power_After_IQK_B_2, bMaskDWord)&0x3FF0000)>>16;
+				result[t][4] = (phy_query_bb_reg(adapt, rTx_Power_Before_IQK_B, bMaskDWord)&0x3FF0000)>>16;
+				result[t][5] = (phy_query_bb_reg(adapt, rTx_Power_After_IQK_B, bMaskDWord)&0x3FF0000)>>16;
+				result[t][6] = (phy_query_bb_reg(adapt, rRx_Power_Before_IQK_B_2, bMaskDWord)&0x3FF0000)>>16;
+				result[t][7] = (phy_query_bb_reg(adapt, rRx_Power_After_IQK_B_2, bMaskDWord)&0x3FF0000)>>16;
 				break;
 			} else if (i == (retryCount - 1) && PathBOK == 0x01) {	/* Tx IQK OK */
 				ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("Path B Only Tx IQK Success!!\n"));
-				result[t][4] = (PHY_QueryBBReg(adapt, rTx_Power_Before_IQK_B, bMaskDWord)&0x3FF0000)>>16;
-				result[t][5] = (PHY_QueryBBReg(adapt, rTx_Power_After_IQK_B, bMaskDWord)&0x3FF0000)>>16;
+				result[t][4] = (phy_query_bb_reg(adapt, rTx_Power_Before_IQK_B, bMaskDWord)&0x3FF0000)>>16;
+				result[t][5] = (phy_query_bb_reg(adapt, rTx_Power_After_IQK_B, bMaskDWord)&0x3FF0000)>>16;
 			}
 		}
 
diff --git a/drivers/staging/rtl8188eu/hal/odm.c b/drivers/staging/rtl8188eu/hal/odm.c
index f8dcfda..4dea303 100644
--- a/drivers/staging/rtl8188eu/hal/odm.c
+++ b/drivers/staging/rtl8188eu/hal/odm.c
@@ -21,6 +21,7 @@
 /*  include files */
 
 #include "odm_precomp.h"
+#include "phy.h"
 
 static const u16 dB_Invert_Table[8][12] = {
 	{1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4, 4},
@@ -429,8 +430,8 @@ void odm_CommonInfoSelfInit(struct odm_dm_struct *pDM_Odm)
 {
 	struct adapter *adapter = pDM_Odm->Adapter;
 
-	pDM_Odm->bCckHighPower = (bool) PHY_QueryBBReg(adapter, 0x824, BIT9);
-	pDM_Odm->RFPathRxEnable = (u8) PHY_QueryBBReg(adapter, 0xc04, 0x0F);
+	pDM_Odm->bCckHighPower = (bool) phy_query_bb_reg(adapter, 0x824, BIT9);
+	pDM_Odm->RFPathRxEnable = (u8) phy_query_bb_reg(adapter, 0xc04, 0x0F);
 
 	ODM_InitDebugSetting(pDM_Odm);
 }
@@ -521,7 +522,7 @@ void odm_DIGInit(struct odm_dm_struct *pDM_Odm)
 	struct adapter *adapter = pDM_Odm->Adapter;
 	struct rtw_dig *pDM_DigTable = &pDM_Odm->DM_DigTable;
 
-	pDM_DigTable->CurIGValue = (u8) PHY_QueryBBReg(adapter, ODM_REG_IGI_A_11N, ODM_BIT_IGI_11N);
+	pDM_DigTable->CurIGValue = (u8) phy_query_bb_reg(adapter, ODM_REG_IGI_A_11N, ODM_BIT_IGI_11N);
 	pDM_DigTable->RssiLowThresh	= DM_DIG_THRESH_LOW;
 	pDM_DigTable->RssiHighThresh	= DM_DIG_THRESH_HIGH;
 	pDM_DigTable->FALowThresh	= DM_false_ALARM_THRESH_LOW;
@@ -736,23 +737,23 @@ void odm_FalseAlarmCounterStatistics(struct odm_dm_struct *pDM_Odm)
 	PHY_SetBBReg(adapter, ODM_REG_OFDM_FA_HOLDC_11N, BIT31, 1); /* hold page C counter */
 	PHY_SetBBReg(adapter, ODM_REG_OFDM_FA_RSTD_11N, BIT31, 1); /* hold page D counter */
 
-	ret_value = PHY_QueryBBReg(adapter, ODM_REG_OFDM_FA_TYPE1_11N, bMaskDWord);
+	ret_value = phy_query_bb_reg(adapter, ODM_REG_OFDM_FA_TYPE1_11N, bMaskDWord);
 	FalseAlmCnt->Cnt_Fast_Fsync = (ret_value&0xffff);
 	FalseAlmCnt->Cnt_SB_Search_fail = ((ret_value&0xffff0000)>>16);
-	ret_value = PHY_QueryBBReg(adapter, ODM_REG_OFDM_FA_TYPE2_11N, bMaskDWord);
+	ret_value = phy_query_bb_reg(adapter, ODM_REG_OFDM_FA_TYPE2_11N, bMaskDWord);
 	FalseAlmCnt->Cnt_OFDM_CCA = (ret_value&0xffff);
 	FalseAlmCnt->Cnt_Parity_Fail = ((ret_value&0xffff0000)>>16);
-	ret_value = PHY_QueryBBReg(adapter, ODM_REG_OFDM_FA_TYPE3_11N, bMaskDWord);
+	ret_value = phy_query_bb_reg(adapter, ODM_REG_OFDM_FA_TYPE3_11N, bMaskDWord);
 	FalseAlmCnt->Cnt_Rate_Illegal = (ret_value&0xffff);
 	FalseAlmCnt->Cnt_Crc8_fail = ((ret_value&0xffff0000)>>16);
-	ret_value = PHY_QueryBBReg(adapter, ODM_REG_OFDM_FA_TYPE4_11N, bMaskDWord);
+	ret_value = phy_query_bb_reg(adapter, ODM_REG_OFDM_FA_TYPE4_11N, bMaskDWord);
 	FalseAlmCnt->Cnt_Mcs_fail = (ret_value&0xffff);
 
 	FalseAlmCnt->Cnt_Ofdm_fail = FalseAlmCnt->Cnt_Parity_Fail + FalseAlmCnt->Cnt_Rate_Illegal +
 				     FalseAlmCnt->Cnt_Crc8_fail + FalseAlmCnt->Cnt_Mcs_fail +
 				     FalseAlmCnt->Cnt_Fast_Fsync + FalseAlmCnt->Cnt_SB_Search_fail;
 
-	ret_value = PHY_QueryBBReg(adapter, ODM_REG_SC_CNT_11N, bMaskDWord);
+	ret_value = phy_query_bb_reg(adapter, ODM_REG_SC_CNT_11N, bMaskDWord);
 	FalseAlmCnt->Cnt_BW_LSC = (ret_value&0xffff);
 	FalseAlmCnt->Cnt_BW_USC = ((ret_value&0xffff0000)>>16);
 
@@ -760,12 +761,12 @@ void odm_FalseAlarmCounterStatistics(struct odm_dm_struct *pDM_Odm)
 	PHY_SetBBReg(adapter, ODM_REG_CCK_FA_RST_11N, BIT12, 1);
 	PHY_SetBBReg(adapter, ODM_REG_CCK_FA_RST_11N, BIT14, 1);
 
-	ret_value = PHY_QueryBBReg(adapter, ODM_REG_CCK_FA_LSB_11N, bMaskByte0);
+	ret_value = phy_query_bb_reg(adapter, ODM_REG_CCK_FA_LSB_11N, bMaskByte0);
 	FalseAlmCnt->Cnt_Cck_fail = ret_value;
-	ret_value = PHY_QueryBBReg(adapter, ODM_REG_CCK_FA_MSB_11N, bMaskByte3);
+	ret_value = phy_query_bb_reg(adapter, ODM_REG_CCK_FA_MSB_11N, bMaskByte3);
 	FalseAlmCnt->Cnt_Cck_fail +=  (ret_value & 0xff)<<8;
 
-	ret_value = PHY_QueryBBReg(adapter, ODM_REG_CCK_CCA_CNT_11N, bMaskDWord);
+	ret_value = phy_query_bb_reg(adapter, ODM_REG_CCK_CCA_CNT_11N, bMaskDWord);
 	FalseAlmCnt->Cnt_CCK_CCA = ((ret_value&0xFF)<<8) | ((ret_value&0xFF00)>>8);
 
 	FalseAlmCnt->Cnt_all = (FalseAlmCnt->Cnt_Fast_Fsync +
@@ -849,10 +850,10 @@ void ODM_RF_Saving(struct odm_dm_struct *pDM_Odm, u8 bForceInNormal)
 		Rssi_Low_bound = 45;
 	}
 	if (pDM_PSTable->initialize == 0) {
-		pDM_PSTable->Reg874 = (PHY_QueryBBReg(adapter, 0x874, bMaskDWord)&0x1CC000)>>14;
-		pDM_PSTable->RegC70 = (PHY_QueryBBReg(adapter, 0xc70, bMaskDWord)&BIT3)>>3;
-		pDM_PSTable->Reg85C = (PHY_QueryBBReg(adapter, 0x85c, bMaskDWord)&0xFF000000)>>24;
-		pDM_PSTable->RegA74 = (PHY_QueryBBReg(adapter, 0xa74, bMaskDWord)&0xF000)>>12;
+		pDM_PSTable->Reg874 = (phy_query_bb_reg(adapter, 0x874, bMaskDWord)&0x1CC000)>>14;
+		pDM_PSTable->RegC70 = (phy_query_bb_reg(adapter, 0xc70, bMaskDWord)&BIT3)>>3;
+		pDM_PSTable->Reg85C = (phy_query_bb_reg(adapter, 0x85c, bMaskDWord)&0xFF000000)>>24;
+		pDM_PSTable->RegA74 = (phy_query_bb_reg(adapter, 0xa74, bMaskDWord)&0xF000)>>12;
 		pDM_PSTable->initialize = 1;
 	}
 
diff --git a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
index a24d954..8111f93 100644
--- a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
+++ b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
@@ -19,6 +19,7 @@
  ******************************************************************************/
 
 #include "odm_precomp.h"
+#include "phy.h"
 
 static void odm_RX_HWAntDivInit(struct odm_dm_struct *dm_odm)
 {
@@ -34,7 +35,7 @@ static void odm_RX_HWAntDivInit(struct odm_dm_struct *dm_odm)
 	ODM_RT_TRACE(dm_odm, ODM_COMP_ANT_DIV, ODM_DBG_LOUD, ("odm_RX_HWAntDivInit()\n"));
 
 	/* MAC Setting */
-	value32 = PHY_QueryBBReg(adapter, ODM_REG_ANTSEL_PIN_11N, bMaskDWord);
+	value32 = phy_query_bb_reg(adapter, ODM_REG_ANTSEL_PIN_11N, bMaskDWord);
 	PHY_SetBBReg(adapter, ODM_REG_ANTSEL_PIN_11N, bMaskDWord, value32|(BIT23|BIT25)); /* Reg4C[25]=1, Reg4C[23]=1 for pin output */
 	/* Pin Settings */
 	PHY_SetBBReg(adapter, ODM_REG_PIN_CTRL_11N, BIT9|BIT8, 0);/* Reg870[8]=1'b0, Reg870[9]=1'b0	antsel antselb by HW */
@@ -64,7 +65,7 @@ static void odm_TRX_HWAntDivInit(struct odm_dm_struct *dm_odm)
 	ODM_RT_TRACE(dm_odm, ODM_COMP_ANT_DIV, ODM_DBG_LOUD, ("odm_TRX_HWAntDivInit()\n"));
 
 	/* MAC Setting */
-	value32 = PHY_QueryBBReg(adapter, ODM_REG_ANTSEL_PIN_11N, bMaskDWord);
+	value32 = phy_query_bb_reg(adapter, ODM_REG_ANTSEL_PIN_11N, bMaskDWord);
 	PHY_SetBBReg(adapter, ODM_REG_ANTSEL_PIN_11N, bMaskDWord, value32|(BIT23|BIT25)); /* Reg4C[25]=1, Reg4C[23]=1 for pin output */
 	/* Pin Settings */
 	PHY_SetBBReg(adapter, ODM_REG_PIN_CTRL_11N, BIT9|BIT8, 0);/* Reg870[8]=1'b0, Reg870[9]=1'b0		antsel antselb by HW */
@@ -113,9 +114,9 @@ static void odm_FastAntTrainingInit(struct odm_dm_struct *dm_odm)
 	dm_fat_tbl->FAT_State = FAT_NORMAL_STATE;
 
 	/* MAC Setting */
-	value32 = PHY_QueryBBReg(adapter, 0x4c, bMaskDWord);
+	value32 = phy_query_bb_reg(adapter, 0x4c, bMaskDWord);
 	PHY_SetBBReg(adapter, 0x4c, bMaskDWord, value32|(BIT23|BIT25)); /* Reg4C[25]=1, Reg4C[23]=1 for pin output */
-	value32 = PHY_QueryBBReg(adapter,  0x7B4, bMaskDWord);
+	value32 = phy_query_bb_reg(adapter,  0x7B4, bMaskDWord);
 	PHY_SetBBReg(adapter, 0x7b4, bMaskDWord, value32|(BIT16|BIT17)); /* Reg7B4[16]=1 enable antenna training, Reg7B4[17]=1 enable A2 match */
 
 	/* Match MAC ADDR */
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
index 522f185..1e982c1 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
@@ -41,36 +41,16 @@ static u32 cal_bit_shift(u32 bitmask)
 	return i;
 }
 
-/**
-* Function:	PHY_QueryBBReg
-*
-* OverView:	Read "sepcific bits" from BB register
-*
-* Input:
-*			struct adapter *Adapter,
-*			u32			RegAddr,	The target address to be readback
-*			u32			BitMask		The target bit position in the target address
-*								to be readback
-* Output:	None
-* Return:		u32			Data		The readback register value
-* Note:		This function is equal to "GetRegSetting" in PHY programming guide
-*/
-u32
-rtl8188e_PHY_QueryBBReg(
-		struct adapter *Adapter,
-		u32 RegAddr,
-		u32 BitMask
-	)
+u32 phy_query_bb_reg(struct adapter *adapt, u32 regaddr, u32 bitmask)
 {
-	u32 ReturnValue = 0, OriginalValue, BitShift;
+	u32 return_value = 0, original_value, bit_shift;
 
-	OriginalValue = usb_read32(Adapter, RegAddr);
-	BitShift = cal_bit_shift(BitMask);
-	ReturnValue = (OriginalValue & BitMask) >> BitShift;
-	return ReturnValue;
+	original_value = usb_read32(adapt, regaddr);
+	bit_shift = cal_bit_shift(bitmask);
+	return_value = (original_value & bitmask) >> bit_shift;
+	return return_value;
 }
 
-
 /**
 * Function:	PHY_SetBBReg
 *
@@ -151,11 +131,11 @@ phy_RFSerialRead(
 	/*  For 92S LSSI Read RFLSSIRead */
 	/*  For RF A/B write 0x824/82c(does not work in the future) */
 	/*  We must use 0x824 for RF A and B to execute read trigger */
-	tmplong = PHY_QueryBBReg(Adapter, rFPGA0_XA_HSSIParameter2, bMaskDWord);
+	tmplong = phy_query_bb_reg(Adapter, rFPGA0_XA_HSSIParameter2, bMaskDWord);
 	if (eRFPath == RF_PATH_A)
 		tmplong2 = tmplong;
 	else
-		tmplong2 = PHY_QueryBBReg(Adapter, pPhyReg->rfHSSIPara2, bMaskDWord);
+		tmplong2 = phy_query_bb_reg(Adapter, pPhyReg->rfHSSIPara2, bMaskDWord);
 
 	tmplong2 = (tmplong2 & (~bLSSIReadAddress)) | (NewOffset<<23) | bLSSIReadEdge;	/* T65 RF */
 
@@ -168,14 +148,14 @@ phy_RFSerialRead(
 	udelay(10);/* PlatformStallExecution(10); */
 
 	if (eRFPath == RF_PATH_A)
-		RfPiEnable = (u8)PHY_QueryBBReg(Adapter, rFPGA0_XA_HSSIParameter1, BIT8);
+		RfPiEnable = (u8)phy_query_bb_reg(Adapter, rFPGA0_XA_HSSIParameter1, BIT8);
 	else if (eRFPath == RF_PATH_B)
-		RfPiEnable = (u8)PHY_QueryBBReg(Adapter, rFPGA0_XB_HSSIParameter1, BIT8);
+		RfPiEnable = (u8)phy_query_bb_reg(Adapter, rFPGA0_XB_HSSIParameter1, BIT8);
 
 	if (RfPiEnable) {	/*  Read from BBreg8b8, 12 bits for 8190, 20bits for T65 RF */
-		retValue = PHY_QueryBBReg(Adapter, pPhyReg->rfLSSIReadBackPi, bLSSIReadBackData);
+		retValue = phy_query_bb_reg(Adapter, pPhyReg->rfLSSIReadBackPi, bLSSIReadBackData);
 	} else {	/* Read from BBreg8a0, 12 bits for 8190, 20 bits for T65 RF */
-		retValue = PHY_QueryBBReg(Adapter, pPhyReg->rfLSSIReadBack, bLSSIReadBackData);
+		retValue = phy_query_bb_reg(Adapter, pPhyReg->rfLSSIReadBack, bLSSIReadBackData);
 	}
 	return retValue;
 }
diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index 1f057b3..5dec8e6 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -633,7 +633,7 @@ static void _InitAntenna_Selection(struct adapter *Adapter)
 	usb_write32(Adapter, REG_LEDCFG0, usb_read32(Adapter, REG_LEDCFG0)|BIT23);
 	PHY_SetBBReg(Adapter, rFPGA0_XAB_RFParameter, BIT13, 0x01);
 
-	if (PHY_QueryBBReg(Adapter, rFPGA0_XA_RFInterfaceOE, 0x300) == Antenna_A)
+	if (phy_query_bb_reg(Adapter, rFPGA0_XA_RFInterfaceOE, 0x300) == Antenna_A)
 		haldata->CurAntenna = Antenna_A;
 	else
 		haldata->CurAntenna = Antenna_B;
diff --git a/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h b/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
index 161ad76..3e2135e 100644
--- a/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
+++ b/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
@@ -198,7 +198,6 @@ struct ant_sel_cck {
 /*  */
 /*  BB and RF register read/write */
 /*  */
-u32 rtl8188e_PHY_QueryBBReg(struct adapter *adapter, u32 regaddr, u32 mask);
 void rtl8188e_PHY_SetBBReg(struct adapter *Adapter, u32 RegAddr,
 			   u32 mask, u32 data);
 u32 rtl8188e_PHY_QueryRFReg(struct adapter *adapter, enum rf_radio_path rfpath,
@@ -235,8 +234,6 @@ bool SetAntennaConfig92C(struct adapter *adapter, u8 defaultant);
 
 /*--------------------------Exported Function prototype---------------------*/
 
-#define PHY_QueryBBReg(adapt, regaddr, mask)			\
-	 rtl8188e_PHY_QueryBBReg((adapt), (regaddr), (mask))
 #define PHY_SetBBReg(adapt, regaddr, bitmask, data)		\
 	 rtl8188e_PHY_SetBBReg((adapt), (regaddr), (bitmask), (data))
 #define PHY_QueryRFReg(adapt, rfpath, regaddr, bitmask)	\
diff --git a/drivers/staging/rtl8188eu/include/phy.h b/drivers/staging/rtl8188eu/include/phy.h
index e3efa8f..cefcc74 100644
--- a/drivers/staging/rtl8188eu/include/phy.h
+++ b/drivers/staging/rtl8188eu/include/phy.h
@@ -1,3 +1,5 @@
 bool rtl88eu_phy_mac_config(struct adapter *adapt);
 bool rtl88eu_phy_rf_config(struct adapter *adapt);
 bool rtl88eu_phy_bb_config(struct adapter *adapt);
+
+u32 phy_query_bb_reg(struct adapter *adapt, u32 regaddr, u32 bitmask);
-- 
1.7.10.4

