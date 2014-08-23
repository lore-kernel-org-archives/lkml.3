Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbaHWOTx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 10:19:53 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35023 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaHWOTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 10:19:49 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 05/20] staging: rtl8188eu: Rework function PHY_SetBBReg()
Date: Sat, 23 Aug 2014 19:48:26 +0530
Message-Id: <1408803521-13715-5-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
References: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CamelCase variables and function name.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/HalHWImg8188E_BB.c   |    6 +-
 drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c   |   16 +-
 drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c     |  176 ++++++++++----------
 drivers/staging/rtl8188eu/hal/odm.c                |   34 ++--
 drivers/staging/rtl8188eu/hal/odm_RTL8188E.c       |  144 ++++++++--------
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c    |   53 ++----
 drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c    |   12 +-
 drivers/staging/rtl8188eu/hal/usb_halinit.c        |    6 +-
 drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h |    4 -
 drivers/staging/rtl8188eu/include/phy.h            |    1 +
 10 files changed, 216 insertions(+), 236 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/HalHWImg8188E_BB.c b/drivers/staging/rtl8188eu/hal/HalHWImg8188E_BB.c
index 0c5dc26..80e8cc9 100644
--- a/drivers/staging/rtl8188eu/hal/HalHWImg8188E_BB.c
+++ b/drivers/staging/rtl8188eu/hal/HalHWImg8188E_BB.c
@@ -174,7 +174,7 @@ static bool set_baseband_agc_config(struct adapter *adapt)
 		u32 v2 = array[i+1];
 
 		if (v1 < 0xCDCDCDCD){
-			PHY_SetBBReg(adapt, v1, bMaskDWord, v2);
+			phy_set_bb_reg(adapt, v1, bMaskDWord, v2);
 			udelay(1);
 		}
 	}
@@ -392,7 +392,7 @@ static void rtl_bb_delay(struct adapter *adapt, u32 addr, u32 data)
 	} else if (addr == 0xf9) {
 		udelay(1);
 	} else {
-		PHY_SetBBReg(adapt, addr, bMaskDWord, data);
+		phy_set_bb_reg(adapt, addr, bMaskDWord, data);
 		/*  Add 1us delay between BB/RF register setting. */
 		udelay(1);
 	}
@@ -709,7 +709,7 @@ bool rtl88eu_phy_bb_config(struct adapter *adapt)
 
 	/*  write 0x24[16:11] = 0x24[22:17] = crystal_cap */
 	crystal_cap = hal_data->CrystalCap & 0x3F;
-	PHY_SetBBReg(adapt, REG_AFE_XTAL_CTRL, 0x7ff800, (crystal_cap | (crystal_cap << 6)));
+	phy_set_bb_reg(adapt, REG_AFE_XTAL_CTRL, 0x7ff800, (crystal_cap | (crystal_cap << 6)));
 
 	return rtstatus;
 }
diff --git a/drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c b/drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c
index 0284602..670ded7 100644
--- a/drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c
+++ b/drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c
@@ -255,17 +255,18 @@ static bool rf6052_conf_para(struct adapter *adapt)
 			break;
 		}
 
-		PHY_SetBBReg(adapt, pphyreg->rfintfe, BRFSI_RFENV << 16, 0x1);
+		phy_set_bb_reg(adapt, pphyreg->rfintfe, BRFSI_RFENV << 16, 0x1);
 		udelay(1);
 
-		PHY_SetBBReg(adapt, pphyreg->rfintfo, BRFSI_RFENV, 0x1);
+		phy_set_bb_reg(adapt, pphyreg->rfintfo, BRFSI_RFENV, 0x1);
 		udelay(1);
 
-		PHY_SetBBReg(adapt, pphyreg->rfHSSIPara2,
+		phy_set_bb_reg(adapt, pphyreg->rfHSSIPara2,
 			      B3WIREADDREAALENGTH, 0x0);
 		udelay(1);
 
-		PHY_SetBBReg(adapt, pphyreg->rfHSSIPara2, B3WIREDATALENGTH, 0x0);
+		phy_set_bb_reg(adapt, pphyreg->rfHSSIPara2,
+			       B3WIREDATALENGTH, 0x0);
 		udelay(1);
 
 		switch (rfpath) {
@@ -284,12 +285,13 @@ static bool rf6052_conf_para(struct adapter *adapt)
 		switch (rfpath) {
 		case RF90_PATH_A:
 		case RF90_PATH_C:
-			PHY_SetBBReg(adapt, pphyreg->rfintfs, BRFSI_RFENV, u4val);
+			phy_set_bb_reg(adapt, pphyreg->rfintfs,
+				       BRFSI_RFENV, u4val);
 			break;
 		case RF90_PATH_B:
 		case RF90_PATH_D:
-			PHY_SetBBReg(adapt, pphyreg->rfintfs, BRFSI_RFENV << 16,
-				      u4val);
+			phy_set_bb_reg(adapt, pphyreg->rfintfs,
+				       BRFSI_RFENV << 16, u4val);
 			break;
 		}
 
diff --git a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
index e36fa5e..f837c95 100644
--- a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
+++ b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
@@ -424,17 +424,17 @@ odm_TXPowerTrackingCallback_ThermalMeter_8188E(
 
 						/* wtite new elements A, C, D to regC88 and regC9C, element B is always 0 */
 						value32 = (ele_D<<22) | ((ele_C&0x3F)<<16) | ele_A;
-						PHY_SetBBReg(Adapter, rOFDM0_XBTxIQImbalance, bMaskDWord, value32);
+						phy_set_bb_reg(Adapter, rOFDM0_XBTxIQImbalance, bMaskDWord, value32);
 
 						value32 = (ele_C&0x000003C0)>>6;
-						PHY_SetBBReg(Adapter, rOFDM0_XDTxAFE, bMaskH4Bits, value32);
+						phy_set_bb_reg(Adapter, rOFDM0_XDTxAFE, bMaskH4Bits, value32);
 
 						value32 = ((X * ele_D)>>7)&0x01;
-						PHY_SetBBReg(Adapter, rOFDM0_ECCAThreshold, BIT28, value32);
+						phy_set_bb_reg(Adapter, rOFDM0_ECCAThreshold, BIT28, value32);
 					} else {
-						PHY_SetBBReg(Adapter, rOFDM0_XBTxIQImbalance, bMaskDWord, OFDMSwingTable[(u8)OFDM_index[1]]);
-						PHY_SetBBReg(Adapter, rOFDM0_XDTxAFE, bMaskH4Bits, 0x00);
-						PHY_SetBBReg(Adapter, rOFDM0_ECCAThreshold, BIT28, 0x00);
+						phy_set_bb_reg(Adapter, rOFDM0_XBTxIQImbalance, bMaskDWord, OFDMSwingTable[(u8)OFDM_index[1]]);
+						phy_set_bb_reg(Adapter, rOFDM0_XDTxAFE, bMaskH4Bits, 0x00);
+						phy_set_bb_reg(Adapter, rOFDM0_ECCAThreshold, BIT28, 0x00);
 					}
 
 					ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD,
@@ -478,19 +478,19 @@ phy_PathA_IQK_8188E(struct adapter *adapt, bool configPathB)
 	/* 1 Tx IQK */
 	/* path-A IQK setting */
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("Path-A IQK setting!\n"));
-	PHY_SetBBReg(adapt, rTx_IQK_Tone_A, bMaskDWord, 0x10008c1c);
-	PHY_SetBBReg(adapt, rRx_IQK_Tone_A, bMaskDWord, 0x30008c1c);
-	PHY_SetBBReg(adapt, rTx_IQK_PI_A, bMaskDWord, 0x8214032a);
-	PHY_SetBBReg(adapt, rRx_IQK_PI_A, bMaskDWord, 0x28160000);
+	phy_set_bb_reg(adapt, rTx_IQK_Tone_A, bMaskDWord, 0x10008c1c);
+	phy_set_bb_reg(adapt, rRx_IQK_Tone_A, bMaskDWord, 0x30008c1c);
+	phy_set_bb_reg(adapt, rTx_IQK_PI_A, bMaskDWord, 0x8214032a);
+	phy_set_bb_reg(adapt, rRx_IQK_PI_A, bMaskDWord, 0x28160000);
 
 	/* LO calibration setting */
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("LO calibration setting!\n"));
-	PHY_SetBBReg(adapt, rIQK_AGC_Rsp, bMaskDWord, 0x00462911);
+	phy_set_bb_reg(adapt, rIQK_AGC_Rsp, bMaskDWord, 0x00462911);
 
 	/* One shot, path A LOK & IQK */
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("One shot, path A LOK & IQK!\n"));
-	PHY_SetBBReg(adapt, rIQK_AGC_Pts, bMaskDWord, 0xf9000000);
-	PHY_SetBBReg(adapt, rIQK_AGC_Pts, bMaskDWord, 0xf8000000);
+	phy_set_bb_reg(adapt, rIQK_AGC_Pts, bMaskDWord, 0xf9000000);
+	phy_set_bb_reg(adapt, rIQK_AGC_Pts, bMaskDWord, 0xf8000000);
 
 	/*  delay x ms */
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("Delay %d ms for One shot, path A LOK & IQK.\n", IQK_DELAY_TIME_88E));
@@ -526,7 +526,7 @@ phy_PathA_RxIQK(struct adapter *adapt, bool configPathB)
 	/* 1 Get TXIMR setting */
 	/* modify RXIQK mode table */
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("Path-A Rx IQK modify RXIQK mode table!\n"));
-	PHY_SetBBReg(adapt, rFPGA0_IQK, bMaskDWord, 0x00000000);
+	phy_set_bb_reg(adapt, rFPGA0_IQK, bMaskDWord, 0x00000000);
 	PHY_SetRFReg(adapt, RF_PATH_A, RF_WE_LUT, bRFRegOffsetMask, 0x800a0);
 	PHY_SetRFReg(adapt, RF_PATH_A, RF_RCK_OS, bRFRegOffsetMask, 0x30000);
 	PHY_SetRFReg(adapt, RF_PATH_A, RF_TXPA_G1, bRFRegOffsetMask, 0x0000f);
@@ -536,26 +536,26 @@ phy_PathA_RxIQK(struct adapter *adapt, bool configPathB)
 	PHY_SetRFReg(adapt, RF_PATH_A, 0xdf, bRFRegOffsetMask, 0x980);
 	PHY_SetRFReg(adapt, RF_PATH_A, 0x56, bRFRegOffsetMask, 0x51000);
 
-	PHY_SetBBReg(adapt, rFPGA0_IQK, bMaskDWord, 0x80800000);
+	phy_set_bb_reg(adapt, rFPGA0_IQK, bMaskDWord, 0x80800000);
 
 	/* IQK setting */
-	PHY_SetBBReg(adapt, rTx_IQK, bMaskDWord, 0x01007c00);
-	PHY_SetBBReg(adapt, rRx_IQK, bMaskDWord, 0x81004800);
+	phy_set_bb_reg(adapt, rTx_IQK, bMaskDWord, 0x01007c00);
+	phy_set_bb_reg(adapt, rRx_IQK, bMaskDWord, 0x81004800);
 
 	/* path-A IQK setting */
-	PHY_SetBBReg(adapt, rTx_IQK_Tone_A, bMaskDWord, 0x10008c1c);
-	PHY_SetBBReg(adapt, rRx_IQK_Tone_A, bMaskDWord, 0x30008c1c);
-	PHY_SetBBReg(adapt, rTx_IQK_PI_A, bMaskDWord, 0x82160c1f);
-	PHY_SetBBReg(adapt, rRx_IQK_PI_A, bMaskDWord, 0x28160000);
+	phy_set_bb_reg(adapt, rTx_IQK_Tone_A, bMaskDWord, 0x10008c1c);
+	phy_set_bb_reg(adapt, rRx_IQK_Tone_A, bMaskDWord, 0x30008c1c);
+	phy_set_bb_reg(adapt, rTx_IQK_PI_A, bMaskDWord, 0x82160c1f);
+	phy_set_bb_reg(adapt, rRx_IQK_PI_A, bMaskDWord, 0x28160000);
 
 	/* LO calibration setting */
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("LO calibration setting!\n"));
-	PHY_SetBBReg(adapt, rIQK_AGC_Rsp, bMaskDWord, 0x0046a911);
+	phy_set_bb_reg(adapt, rIQK_AGC_Rsp, bMaskDWord, 0x0046a911);
 
 	/* One shot, path A LOK & IQK */
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("One shot, path A LOK & IQK!\n"));
-	PHY_SetBBReg(adapt, rIQK_AGC_Pts, bMaskDWord, 0xf9000000);
-	PHY_SetBBReg(adapt, rIQK_AGC_Pts, bMaskDWord, 0xf8000000);
+	phy_set_bb_reg(adapt, rIQK_AGC_Pts, bMaskDWord, 0xf9000000);
+	phy_set_bb_reg(adapt, rIQK_AGC_Pts, bMaskDWord, 0xf8000000);
 
 	/*  delay x ms */
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD,
@@ -582,36 +582,36 @@ phy_PathA_RxIQK(struct adapter *adapt, bool configPathB)
 		return result;
 
 	u4tmp = 0x80007C00 | (regE94&0x3FF0000)  | ((regE9C&0x3FF0000) >> 16);
-	PHY_SetBBReg(adapt, rTx_IQK, bMaskDWord, u4tmp);
+	phy_set_bb_reg(adapt, rTx_IQK, bMaskDWord, u4tmp);
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("0xe40 = 0x%x u4tmp = 0x%x\n", phy_query_bb_reg(adapt, rTx_IQK, bMaskDWord), u4tmp));
 
 	/* 1 RX IQK */
 	/* modify RXIQK mode table */
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("Path-A Rx IQK modify RXIQK mode table 2!\n"));
-	PHY_SetBBReg(adapt, rFPGA0_IQK, bMaskDWord, 0x00000000);
+	phy_set_bb_reg(adapt, rFPGA0_IQK, bMaskDWord, 0x00000000);
 	PHY_SetRFReg(adapt, RF_PATH_A, RF_WE_LUT, bRFRegOffsetMask, 0x800a0);
 	PHY_SetRFReg(adapt, RF_PATH_A, RF_RCK_OS, bRFRegOffsetMask, 0x30000);
 	PHY_SetRFReg(adapt, RF_PATH_A, RF_TXPA_G1, bRFRegOffsetMask, 0x0000f);
 	PHY_SetRFReg(adapt, RF_PATH_A, RF_TXPA_G2, bRFRegOffsetMask, 0xf7ffa);
-	PHY_SetBBReg(adapt, rFPGA0_IQK, bMaskDWord, 0x80800000);
+	phy_set_bb_reg(adapt, rFPGA0_IQK, bMaskDWord, 0x80800000);
 
 	/* IQK setting */
-	PHY_SetBBReg(adapt, rRx_IQK, bMaskDWord, 0x01004800);
+	phy_set_bb_reg(adapt, rRx_IQK, bMaskDWord, 0x01004800);
 
 	/* path-A IQK setting */
-	PHY_SetBBReg(adapt, rTx_IQK_Tone_A, bMaskDWord, 0x38008c1c);
-	PHY_SetBBReg(adapt, rRx_IQK_Tone_A, bMaskDWord, 0x18008c1c);
-	PHY_SetBBReg(adapt, rTx_IQK_PI_A, bMaskDWord, 0x82160c05);
-	PHY_SetBBReg(adapt, rRx_IQK_PI_A, bMaskDWord, 0x28160c1f);
+	phy_set_bb_reg(adapt, rTx_IQK_Tone_A, bMaskDWord, 0x38008c1c);
+	phy_set_bb_reg(adapt, rRx_IQK_Tone_A, bMaskDWord, 0x18008c1c);
+	phy_set_bb_reg(adapt, rTx_IQK_PI_A, bMaskDWord, 0x82160c05);
+	phy_set_bb_reg(adapt, rRx_IQK_PI_A, bMaskDWord, 0x28160c1f);
 
 	/* LO calibration setting */
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("LO calibration setting!\n"));
-	PHY_SetBBReg(adapt, rIQK_AGC_Rsp, bMaskDWord, 0x0046a911);
+	phy_set_bb_reg(adapt, rIQK_AGC_Rsp, bMaskDWord, 0x0046a911);
 
 	/* One shot, path A LOK & IQK */
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("One shot, path A LOK & IQK!\n"));
-	PHY_SetBBReg(adapt, rIQK_AGC_Pts, bMaskDWord, 0xf9000000);
-	PHY_SetBBReg(adapt, rIQK_AGC_Pts, bMaskDWord, 0xf8000000);
+	phy_set_bb_reg(adapt, rIQK_AGC_Pts, bMaskDWord, 0xf9000000);
+	phy_set_bb_reg(adapt, rIQK_AGC_Pts, bMaskDWord, 0xf8000000);
 
 	/*  delay x ms */
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("Delay %d ms for One shot, path A LOK & IQK.\n", IQK_DELAY_TIME_88E));
@@ -629,7 +629,7 @@ phy_PathA_RxIQK(struct adapter *adapt, bool configPathB)
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD,  ("0xea4 = 0x%x\n", regEA4));
 
 	/* reload RF 0xdf */
-	PHY_SetBBReg(adapt, rFPGA0_IQK, bMaskDWord, 0x00000000);
+	phy_set_bb_reg(adapt, rFPGA0_IQK, bMaskDWord, 0x00000000);
 	PHY_SetRFReg(adapt, RF_PATH_A, 0xdf, bRFRegOffsetMask, 0x180);
 
 	if (!(regeac & BIT27) &&		/* if Tx is OK, check whether Rx is OK */
@@ -653,8 +653,8 @@ phy_PathB_IQK_8188E(struct adapter *adapt)
 
 	/* One shot, path B LOK & IQK */
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("One shot, path A LOK & IQK!\n"));
-	PHY_SetBBReg(adapt, rIQK_AGC_Cont, bMaskDWord, 0x00000002);
-	PHY_SetBBReg(adapt, rIQK_AGC_Cont, bMaskDWord, 0x00000000);
+	phy_set_bb_reg(adapt, rIQK_AGC_Cont, bMaskDWord, 0x00000002);
+	phy_set_bb_reg(adapt, rIQK_AGC_Cont, bMaskDWord, 0x00000000);
 
 	/*  delay x ms */
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD,
@@ -717,9 +717,9 @@ static void patha_fill_iqk(struct adapter *adapt, bool iqkok, s32 result[][8], u
 		ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD,
 			     ("X = 0x%x, TX0_A = 0x%x, Oldval_0 0x%x\n",
 			     X, TX0_A, Oldval_0));
-		PHY_SetBBReg(adapt, rOFDM0_XATxIQImbalance, 0x3FF, TX0_A);
+		phy_set_bb_reg(adapt, rOFDM0_XATxIQImbalance, 0x3FF, TX0_A);
 
-		PHY_SetBBReg(adapt, rOFDM0_ECCAThreshold, BIT(31), ((X * Oldval_0>>7) & 0x1));
+		phy_set_bb_reg(adapt, rOFDM0_ECCAThreshold, BIT(31), ((X * Oldval_0>>7) & 0x1));
 
 		Y = result[final_candidate][1];
 		if ((Y & 0x00000200) != 0)
@@ -727,10 +727,10 @@ static void patha_fill_iqk(struct adapter *adapt, bool iqkok, s32 result[][8], u
 
 		TX0_C = (Y * Oldval_0) >> 8;
 		ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD,  ("Y = 0x%x, TX = 0x%x\n", Y, TX0_C));
-		PHY_SetBBReg(adapt, rOFDM0_XCTxAFE, 0xF0000000, ((TX0_C&0x3C0)>>6));
-		PHY_SetBBReg(adapt, rOFDM0_XATxIQImbalance, 0x003F0000, (TX0_C&0x3F));
+		phy_set_bb_reg(adapt, rOFDM0_XCTxAFE, 0xF0000000, ((TX0_C&0x3C0)>>6));
+		phy_set_bb_reg(adapt, rOFDM0_XATxIQImbalance, 0x003F0000, (TX0_C&0x3F));
 
-		PHY_SetBBReg(adapt, rOFDM0_ECCAThreshold, BIT(29), ((Y * Oldval_0>>7) & 0x1));
+		phy_set_bb_reg(adapt, rOFDM0_ECCAThreshold, BIT(29), ((Y * Oldval_0>>7) & 0x1));
 
 		if (txonly) {
 			ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD,  ("patha_fill_iqk only Tx OK\n"));
@@ -738,13 +738,13 @@ static void patha_fill_iqk(struct adapter *adapt, bool iqkok, s32 result[][8], u
 		}
 
 		reg = result[final_candidate][2];
-		PHY_SetBBReg(adapt, rOFDM0_XARxIQImbalance, 0x3FF, reg);
+		phy_set_bb_reg(adapt, rOFDM0_XARxIQImbalance, 0x3FF, reg);
 
 		reg = result[final_candidate][3] & 0x3F;
-		PHY_SetBBReg(adapt, rOFDM0_XARxIQImbalance, 0xFC00, reg);
+		phy_set_bb_reg(adapt, rOFDM0_XARxIQImbalance, 0xFC00, reg);
 
 		reg = (result[final_candidate][3] >> 6) & 0xF;
-		PHY_SetBBReg(adapt, rOFDM0_RxIQExtAnta, 0xF0000000, reg);
+		phy_set_bb_reg(adapt, rOFDM0_RxIQExtAnta, 0xF0000000, reg);
 	}
 }
 
@@ -768,9 +768,9 @@ static void pathb_fill_iqk(struct adapter *adapt, bool iqkok, s32 result[][8], u
 			X = X | 0xFFFFFC00;
 		TX1_A = (X * Oldval_1) >> 8;
 		ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("X = 0x%x, TX1_A = 0x%x\n", X, TX1_A));
-		PHY_SetBBReg(adapt, rOFDM0_XBTxIQImbalance, 0x3FF, TX1_A);
+		phy_set_bb_reg(adapt, rOFDM0_XBTxIQImbalance, 0x3FF, TX1_A);
 
-		PHY_SetBBReg(adapt, rOFDM0_ECCAThreshold, BIT(27), ((X * Oldval_1>>7) & 0x1));
+		phy_set_bb_reg(adapt, rOFDM0_ECCAThreshold, BIT(27), ((X * Oldval_1>>7) & 0x1));
 
 		Y = result[final_candidate][5];
 		if ((Y & 0x00000200) != 0)
@@ -778,22 +778,22 @@ static void pathb_fill_iqk(struct adapter *adapt, bool iqkok, s32 result[][8], u
 
 		TX1_C = (Y * Oldval_1) >> 8;
 		ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD,  ("Y = 0x%x, TX1_C = 0x%x\n", Y, TX1_C));
-		PHY_SetBBReg(adapt, rOFDM0_XDTxAFE, 0xF0000000, ((TX1_C&0x3C0)>>6));
-		PHY_SetBBReg(adapt, rOFDM0_XBTxIQImbalance, 0x003F0000, (TX1_C&0x3F));
+		phy_set_bb_reg(adapt, rOFDM0_XDTxAFE, 0xF0000000, ((TX1_C&0x3C0)>>6));
+		phy_set_bb_reg(adapt, rOFDM0_XBTxIQImbalance, 0x003F0000, (TX1_C&0x3F));
 
-		PHY_SetBBReg(adapt, rOFDM0_ECCAThreshold, BIT(25), ((Y * Oldval_1>>7) & 0x1));
+		phy_set_bb_reg(adapt, rOFDM0_ECCAThreshold, BIT(25), ((Y * Oldval_1>>7) & 0x1));
 
 		if (txonly)
 			return;
 
 		reg = result[final_candidate][6];
-		PHY_SetBBReg(adapt, rOFDM0_XBRxIQImbalance, 0x3FF, reg);
+		phy_set_bb_reg(adapt, rOFDM0_XBRxIQImbalance, 0x3FF, reg);
 
 		reg = result[final_candidate][7] & 0x3F;
-		PHY_SetBBReg(adapt, rOFDM0_XBRxIQImbalance, 0xFC00, reg);
+		phy_set_bb_reg(adapt, rOFDM0_XBRxIQImbalance, 0xFC00, reg);
 
 		reg = (result[final_candidate][7] >> 6) & 0xF;
-		PHY_SetBBReg(adapt, rOFDM0_AGCRSSITable, 0x0000F000, reg);
+		phy_set_bb_reg(adapt, rOFDM0_AGCRSSITable, 0x0000F000, reg);
 	}
 }
 
@@ -833,7 +833,7 @@ static void reload_adda_reg(struct adapter *adapt, u32 *ADDAReg, u32 *ADDABackup
 
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("Reload ADDA power saving parameters !\n"));
 	for (i = 0; i < RegiesterNum; i++)
-		PHY_SetBBReg(adapt, ADDAReg[i], bMaskDWord, ADDABackup[i]);
+		phy_set_bb_reg(adapt, ADDAReg[i], bMaskDWord, ADDABackup[i]);
 }
 
 static void
@@ -871,13 +871,13 @@ _PHY_PathADDAOn(
 	pathOn = isPathAOn ? 0x04db25a4 : 0x0b1b25a4;
 	if (!is2t) {
 		pathOn = 0x0bdb25a0;
-		PHY_SetBBReg(adapt, ADDAReg[0], bMaskDWord, 0x0b1b25a0);
+		phy_set_bb_reg(adapt, ADDAReg[0], bMaskDWord, 0x0b1b25a0);
 	} else {
-		PHY_SetBBReg(adapt, ADDAReg[0], bMaskDWord, pathOn);
+		phy_set_bb_reg(adapt, ADDAReg[0], bMaskDWord, pathOn);
 	}
 
 	for (i = 1; i < IQK_ADDA_REG_NUM; i++)
-		PHY_SetBBReg(adapt, ADDAReg[i], bMaskDWord, pathOn);
+		phy_set_bb_reg(adapt, ADDAReg[i], bMaskDWord, pathOn);
 }
 
 void
@@ -911,9 +911,9 @@ _PHY_PathAStandBy(
 
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD,  ("Path-A standby mode!\n"));
 
-	PHY_SetBBReg(adapt, rFPGA0_IQK, bMaskDWord, 0x0);
-	PHY_SetBBReg(adapt, 0x840, bMaskDWord, 0x00010000);
-	PHY_SetBBReg(adapt, rFPGA0_IQK, bMaskDWord, 0x80800000);
+	phy_set_bb_reg(adapt, rFPGA0_IQK, bMaskDWord, 0x0);
+	phy_set_bb_reg(adapt, 0x840, bMaskDWord, 0x00010000);
+	phy_set_bb_reg(adapt, rFPGA0_IQK, bMaskDWord, 0x80800000);
 }
 
 static void _PHY_PIModeSwitch(
@@ -928,8 +928,8 @@ static void _PHY_PIModeSwitch(
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("BB Switch to %s mode!\n", (PIMode ? "PI" : "SI")));
 
 	mode = PIMode ? 0x01000100 : 0x01000000;
-	PHY_SetBBReg(adapt, rFPGA0_XA_HSSIParameter1, bMaskDWord, mode);
-	PHY_SetBBReg(adapt, rFPGA0_XB_HSSIParameter1, bMaskDWord, mode);
+	phy_set_bb_reg(adapt, rFPGA0_XA_HSSIParameter1, bMaskDWord, mode);
+	phy_set_bb_reg(adapt, rFPGA0_XB_HSSIParameter1, bMaskDWord, mode);
 }
 
 static bool phy_SimularityCompare_8188E(
@@ -1086,19 +1086,19 @@ static void phy_IQCalibrate_8188E(struct adapter *adapt, s32 result[][8], u8 t,
 	}
 
 	/* BB setting */
-	PHY_SetBBReg(adapt, rFPGA0_RFMOD, BIT24, 0x00);
-	PHY_SetBBReg(adapt, rOFDM0_TRxPathEnable, bMaskDWord, 0x03a05600);
-	PHY_SetBBReg(adapt, rOFDM0_TRMuxPar, bMaskDWord, 0x000800e4);
-	PHY_SetBBReg(adapt, rFPGA0_XCD_RFInterfaceSW, bMaskDWord, 0x22204000);
+	phy_set_bb_reg(adapt, rFPGA0_RFMOD, BIT24, 0x00);
+	phy_set_bb_reg(adapt, rOFDM0_TRxPathEnable, bMaskDWord, 0x03a05600);
+	phy_set_bb_reg(adapt, rOFDM0_TRMuxPar, bMaskDWord, 0x000800e4);
+	phy_set_bb_reg(adapt, rFPGA0_XCD_RFInterfaceSW, bMaskDWord, 0x22204000);
 
-	PHY_SetBBReg(adapt, rFPGA0_XAB_RFInterfaceSW, BIT10, 0x01);
-	PHY_SetBBReg(adapt, rFPGA0_XAB_RFInterfaceSW, BIT26, 0x01);
-	PHY_SetBBReg(adapt, rFPGA0_XA_RFInterfaceOE, BIT10, 0x00);
-	PHY_SetBBReg(adapt, rFPGA0_XB_RFInterfaceOE, BIT10, 0x00);
+	phy_set_bb_reg(adapt, rFPGA0_XAB_RFInterfaceSW, BIT10, 0x01);
+	phy_set_bb_reg(adapt, rFPGA0_XAB_RFInterfaceSW, BIT26, 0x01);
+	phy_set_bb_reg(adapt, rFPGA0_XA_RFInterfaceOE, BIT10, 0x00);
+	phy_set_bb_reg(adapt, rFPGA0_XB_RFInterfaceOE, BIT10, 0x00);
 
 	if (is2t) {
-		PHY_SetBBReg(adapt, rFPGA0_XA_LSSIParameter, bMaskDWord, 0x00010000);
-		PHY_SetBBReg(adapt, rFPGA0_XB_LSSIParameter, bMaskDWord, 0x00010000);
+		phy_set_bb_reg(adapt, rFPGA0_XA_LSSIParameter, bMaskDWord, 0x00010000);
+		phy_set_bb_reg(adapt, rFPGA0_XB_LSSIParameter, bMaskDWord, 0x00010000);
 	}
 
 	/* MAC settings */
@@ -1106,16 +1106,16 @@ static void phy_IQCalibrate_8188E(struct adapter *adapt, s32 result[][8], u8 t,
 
 	/* Page B init */
 	/* AP or IQK */
-	PHY_SetBBReg(adapt, rConfig_AntA, bMaskDWord, 0x0f600000);
+	phy_set_bb_reg(adapt, rConfig_AntA, bMaskDWord, 0x0f600000);
 
 	if (is2t)
-		PHY_SetBBReg(adapt, rConfig_AntB, bMaskDWord, 0x0f600000);
+		phy_set_bb_reg(adapt, rConfig_AntB, bMaskDWord, 0x0f600000);
 
 	/*  IQ calibration setting */
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("IQK setting!\n"));
-	PHY_SetBBReg(adapt, rFPGA0_IQK, bMaskDWord, 0x80800000);
-	PHY_SetBBReg(adapt, rTx_IQK, bMaskDWord, 0x01007c00);
-	PHY_SetBBReg(adapt, rRx_IQK, bMaskDWord, 0x81004800);
+	phy_set_bb_reg(adapt, rFPGA0_IQK, bMaskDWord, 0x80800000);
+	phy_set_bb_reg(adapt, rTx_IQK, bMaskDWord, 0x01007c00);
+	phy_set_bb_reg(adapt, rRx_IQK, bMaskDWord, 0x81004800);
 
 	for (i = 0; i < retryCount; i++) {
 		PathAOK = phy_PathA_IQK_8188E(adapt, is2t);
@@ -1172,7 +1172,7 @@ static void phy_IQCalibrate_8188E(struct adapter *adapt, s32 result[][8], u8 t,
 
 	/* Back to BB mode, load original value */
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("IQK:Back to BB mode, load original value!\n"));
-	PHY_SetBBReg(adapt, rFPGA0_IQK, bMaskDWord, 0);
+	phy_set_bb_reg(adapt, rFPGA0_IQK, bMaskDWord, 0);
 
 	if (t != 0) {
 		if (!dm_odm->RFCalibrateInfo.bRfPiEnable) {
@@ -1189,13 +1189,13 @@ static void phy_IQCalibrate_8188E(struct adapter *adapt, s32 result[][8], u8 t,
 		reload_adda_reg(adapt, IQK_BB_REG_92C, dm_odm->RFCalibrateInfo.IQK_BB_backup, IQK_BB_REG_NUM);
 
 		/*  Restore RX initial gain */
-		PHY_SetBBReg(adapt, rFPGA0_XA_LSSIParameter, bMaskDWord, 0x00032ed3);
+		phy_set_bb_reg(adapt, rFPGA0_XA_LSSIParameter, bMaskDWord, 0x00032ed3);
 		if (is2t)
-			PHY_SetBBReg(adapt, rFPGA0_XB_LSSIParameter, bMaskDWord, 0x00032ed3);
+			phy_set_bb_reg(adapt, rFPGA0_XB_LSSIParameter, bMaskDWord, 0x00032ed3);
 
 		/* load 0xe30 IQC default value */
-		PHY_SetBBReg(adapt, rTx_IQK_Tone_A, bMaskDWord, 0x01008c00);
-		PHY_SetBBReg(adapt, rRx_IQK_Tone_A, bMaskDWord, 0x01008c00);
+		phy_set_bb_reg(adapt, rTx_IQK_Tone_A, bMaskDWord, 0x01008c00);
+		phy_set_bb_reg(adapt, rRx_IQK_Tone_A, bMaskDWord, 0x01008c00);
 	}
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("phy_IQCalibrate_8188E() <==\n"));
 }
@@ -1438,19 +1438,19 @@ static void phy_setrfpathswitch_8188e(struct adapter *adapt, bool main, bool is2
 		u8 u1btmp;
 		u1btmp = usb_read8(adapt, REG_LEDCFG2) | BIT7;
 		usb_write8(adapt, REG_LEDCFG2, u1btmp);
-		PHY_SetBBReg(adapt, rFPGA0_XAB_RFParameter, BIT13, 0x01);
+		phy_set_bb_reg(adapt, rFPGA0_XAB_RFParameter, BIT13, 0x01);
 	}
 
 	if (is2t) {	/* 92C */
 		if (main)
-			PHY_SetBBReg(adapt, rFPGA0_XB_RFInterfaceOE, BIT5|BIT6, 0x1);	/* 92C_Path_A */
+			phy_set_bb_reg(adapt, rFPGA0_XB_RFInterfaceOE, BIT5|BIT6, 0x1);	/* 92C_Path_A */
 		else
-			PHY_SetBBReg(adapt, rFPGA0_XB_RFInterfaceOE, BIT5|BIT6, 0x2);	/* BT */
+			phy_set_bb_reg(adapt, rFPGA0_XB_RFInterfaceOE, BIT5|BIT6, 0x2);	/* BT */
 	} else {			/* 88C */
 		if (main)
-			PHY_SetBBReg(adapt, rFPGA0_XA_RFInterfaceOE, BIT8|BIT9, 0x2);	/* Main */
+			phy_set_bb_reg(adapt, rFPGA0_XA_RFInterfaceOE, BIT8|BIT9, 0x2);	/* Main */
 		else
-			PHY_SetBBReg(adapt, rFPGA0_XA_RFInterfaceOE, BIT8|BIT9, 0x1);	/* Aux */
+			phy_set_bb_reg(adapt, rFPGA0_XA_RFInterfaceOE, BIT8|BIT9, 0x1);	/* Aux */
 	}
 }
 
diff --git a/drivers/staging/rtl8188eu/hal/odm.c b/drivers/staging/rtl8188eu/hal/odm.c
index 4dea303..db0a72e 100644
--- a/drivers/staging/rtl8188eu/hal/odm.c
+++ b/drivers/staging/rtl8188eu/hal/odm.c
@@ -512,7 +512,7 @@ void ODM_Write_DIG(struct odm_dm_struct *pDM_Odm, u8 CurrentIGI)
 	struct adapter *adapter = pDM_Odm->Adapter;
 
 	if (pDM_DigTable->CurIGValue != CurrentIGI) {
-		PHY_SetBBReg(adapter, ODM_REG_IGI_A_11N, ODM_BIT_IGI_11N, CurrentIGI);
+		phy_set_bb_reg(adapter, ODM_REG_IGI_A_11N, ODM_BIT_IGI_11N, CurrentIGI);
 		pDM_DigTable->CurIGValue = CurrentIGI;
 	}
 }
@@ -734,8 +734,8 @@ void odm_FalseAlarmCounterStatistics(struct odm_dm_struct *pDM_Odm)
 		return;
 
 	/* hold ofdm counter */
-	PHY_SetBBReg(adapter, ODM_REG_OFDM_FA_HOLDC_11N, BIT31, 1); /* hold page C counter */
-	PHY_SetBBReg(adapter, ODM_REG_OFDM_FA_RSTD_11N, BIT31, 1); /* hold page D counter */
+	phy_set_bb_reg(adapter, ODM_REG_OFDM_FA_HOLDC_11N, BIT31, 1); /* hold page C counter */
+	phy_set_bb_reg(adapter, ODM_REG_OFDM_FA_RSTD_11N, BIT31, 1); /* hold page D counter */
 
 	ret_value = phy_query_bb_reg(adapter, ODM_REG_OFDM_FA_TYPE1_11N, bMaskDWord);
 	FalseAlmCnt->Cnt_Fast_Fsync = (ret_value&0xffff);
@@ -758,8 +758,8 @@ void odm_FalseAlarmCounterStatistics(struct odm_dm_struct *pDM_Odm)
 	FalseAlmCnt->Cnt_BW_USC = ((ret_value&0xffff0000)>>16);
 
 	/* hold cck counter */
-	PHY_SetBBReg(adapter, ODM_REG_CCK_FA_RST_11N, BIT12, 1);
-	PHY_SetBBReg(adapter, ODM_REG_CCK_FA_RST_11N, BIT14, 1);
+	phy_set_bb_reg(adapter, ODM_REG_CCK_FA_RST_11N, BIT12, 1);
+	phy_set_bb_reg(adapter, ODM_REG_CCK_FA_RST_11N, BIT14, 1);
 
 	ret_value = phy_query_bb_reg(adapter, ODM_REG_CCK_FA_LSB_11N, bMaskByte0);
 	FalseAlmCnt->Cnt_Cck_fail = ret_value;
@@ -879,19 +879,19 @@ void ODM_RF_Saving(struct odm_dm_struct *pDM_Odm, u8 bForceInNormal)
 
 	if (pDM_PSTable->PreRFState != pDM_PSTable->CurRFState) {
 		if (pDM_PSTable->CurRFState == RF_Save) {
-			PHY_SetBBReg(adapter, 0x874  , 0x1C0000, 0x2); /* Reg874[20:18]=3'b010 */
-			PHY_SetBBReg(adapter, 0xc70, BIT3, 0); /* RegC70[3]=1'b0 */
-			PHY_SetBBReg(adapter, 0x85c, 0xFF000000, 0x63); /* Reg85C[31:24]=0x63 */
-			PHY_SetBBReg(adapter, 0x874, 0xC000, 0x2); /* Reg874[15:14]=2'b10 */
-			PHY_SetBBReg(adapter, 0xa74, 0xF000, 0x3); /* RegA75[7:4]=0x3 */
-			PHY_SetBBReg(adapter, 0x818, BIT28, 0x0); /* Reg818[28]=1'b0 */
-			PHY_SetBBReg(adapter, 0x818, BIT28, 0x1); /* Reg818[28]=1'b1 */
+			phy_set_bb_reg(adapter, 0x874  , 0x1C0000, 0x2); /* Reg874[20:18]=3'b010 */
+			phy_set_bb_reg(adapter, 0xc70, BIT3, 0); /* RegC70[3]=1'b0 */
+			phy_set_bb_reg(adapter, 0x85c, 0xFF000000, 0x63); /* Reg85C[31:24]=0x63 */
+			phy_set_bb_reg(adapter, 0x874, 0xC000, 0x2); /* Reg874[15:14]=2'b10 */
+			phy_set_bb_reg(adapter, 0xa74, 0xF000, 0x3); /* RegA75[7:4]=0x3 */
+			phy_set_bb_reg(adapter, 0x818, BIT28, 0x0); /* Reg818[28]=1'b0 */
+			phy_set_bb_reg(adapter, 0x818, BIT28, 0x1); /* Reg818[28]=1'b1 */
 		} else {
-			PHY_SetBBReg(adapter, 0x874  , 0x1CC000, pDM_PSTable->Reg874);
-			PHY_SetBBReg(adapter, 0xc70, BIT3, pDM_PSTable->RegC70);
-			PHY_SetBBReg(adapter, 0x85c, 0xFF000000, pDM_PSTable->Reg85C);
-			PHY_SetBBReg(adapter, 0xa74, 0xF000, pDM_PSTable->RegA74);
-			PHY_SetBBReg(adapter, 0x818, BIT28, 0x0);
+			phy_set_bb_reg(adapter, 0x874  , 0x1CC000, pDM_PSTable->Reg874);
+			phy_set_bb_reg(adapter, 0xc70, BIT3, pDM_PSTable->RegC70);
+			phy_set_bb_reg(adapter, 0x85c, 0xFF000000, pDM_PSTable->Reg85C);
+			phy_set_bb_reg(adapter, 0xa74, 0xF000, pDM_PSTable->RegA74);
+			phy_set_bb_reg(adapter, 0x818, BIT28, 0x0);
 		}
 		pDM_PSTable->PreRFState = pDM_PSTable->CurRFState;
 	}
diff --git a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
index 8111f93..095078d 100644
--- a/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
+++ b/drivers/staging/rtl8188eu/hal/odm_RTL8188E.c
@@ -28,27 +28,27 @@ static void odm_RX_HWAntDivInit(struct odm_dm_struct *dm_odm)
 
 	if (*(dm_odm->mp_mode) == 1) {
 		dm_odm->AntDivType = CGCS_RX_SW_ANTDIV;
-		PHY_SetBBReg(adapter, ODM_REG_IGI_A_11N, BIT7, 0); /*  disable HW AntDiv */
-		PHY_SetBBReg(adapter, ODM_REG_LNA_SWITCH_11N, BIT31, 1);  /*  1:CG, 0:CS */
+		phy_set_bb_reg(adapter, ODM_REG_IGI_A_11N, BIT7, 0); /*  disable HW AntDiv */
+		phy_set_bb_reg(adapter, ODM_REG_LNA_SWITCH_11N, BIT31, 1);  /*  1:CG, 0:CS */
 		return;
 	}
 	ODM_RT_TRACE(dm_odm, ODM_COMP_ANT_DIV, ODM_DBG_LOUD, ("odm_RX_HWAntDivInit()\n"));
 
 	/* MAC Setting */
 	value32 = phy_query_bb_reg(adapter, ODM_REG_ANTSEL_PIN_11N, bMaskDWord);
-	PHY_SetBBReg(adapter, ODM_REG_ANTSEL_PIN_11N, bMaskDWord, value32|(BIT23|BIT25)); /* Reg4C[25]=1, Reg4C[23]=1 for pin output */
+	phy_set_bb_reg(adapter, ODM_REG_ANTSEL_PIN_11N, bMaskDWord, value32|(BIT23|BIT25)); /* Reg4C[25]=1, Reg4C[23]=1 for pin output */
 	/* Pin Settings */
-	PHY_SetBBReg(adapter, ODM_REG_PIN_CTRL_11N, BIT9|BIT8, 0);/* Reg870[8]=1'b0, Reg870[9]=1'b0	antsel antselb by HW */
-	PHY_SetBBReg(adapter, ODM_REG_RX_ANT_CTRL_11N, BIT10, 0);	/* Reg864[10]=1'b0	antsel2 by HW */
-	PHY_SetBBReg(adapter, ODM_REG_LNA_SWITCH_11N, BIT22, 1);	/* Regb2c[22]=1'b0	disable CS/CG switch */
-	PHY_SetBBReg(adapter, ODM_REG_LNA_SWITCH_11N, BIT31, 1);	/* Regb2c[31]=1'b1	output at CG only */
+	phy_set_bb_reg(adapter, ODM_REG_PIN_CTRL_11N, BIT9|BIT8, 0);/* Reg870[8]=1'b0, Reg870[9]=1'b0	antsel antselb by HW */
+	phy_set_bb_reg(adapter, ODM_REG_RX_ANT_CTRL_11N, BIT10, 0);	/* Reg864[10]=1'b0	antsel2 by HW */
+	phy_set_bb_reg(adapter, ODM_REG_LNA_SWITCH_11N, BIT22, 1);	/* Regb2c[22]=1'b0	disable CS/CG switch */
+	phy_set_bb_reg(adapter, ODM_REG_LNA_SWITCH_11N, BIT31, 1);	/* Regb2c[31]=1'b1	output at CG only */
 	/* OFDM Settings */
-	PHY_SetBBReg(adapter, ODM_REG_ANTDIV_PARA1_11N, bMaskDWord, 0x000000a0);
+	phy_set_bb_reg(adapter, ODM_REG_ANTDIV_PARA1_11N, bMaskDWord, 0x000000a0);
 	/* CCK Settings */
-	PHY_SetBBReg(adapter, ODM_REG_BB_PWR_SAV4_11N, BIT7, 1); /* Fix CCK PHY status report issue */
-	PHY_SetBBReg(adapter, ODM_REG_CCK_ANTDIV_PARA2_11N, BIT4, 1); /* CCK complete HW AntDiv within 64 samples */
+	phy_set_bb_reg(adapter, ODM_REG_BB_PWR_SAV4_11N, BIT7, 1); /* Fix CCK PHY status report issue */
+	phy_set_bb_reg(adapter, ODM_REG_CCK_ANTDIV_PARA2_11N, BIT4, 1); /* CCK complete HW AntDiv within 64 samples */
 	ODM_UpdateRxIdleAnt_88E(dm_odm, MAIN_ANT);
-	PHY_SetBBReg(adapter, ODM_REG_ANT_MAPPING1_11N, 0xFFFF, 0x0201);	/* antenna mapping table */
+	phy_set_bb_reg(adapter, ODM_REG_ANT_MAPPING1_11N, 0xFFFF, 0x0201);	/* antenna mapping table */
 }
 
 static void odm_TRX_HWAntDivInit(struct odm_dm_struct *dm_odm)
@@ -58,35 +58,35 @@ static void odm_TRX_HWAntDivInit(struct odm_dm_struct *dm_odm)
 
 	if (*(dm_odm->mp_mode) == 1) {
 		dm_odm->AntDivType = CGCS_RX_SW_ANTDIV;
-		PHY_SetBBReg(adapter, ODM_REG_IGI_A_11N, BIT7, 0); /*  disable HW AntDiv */
-		PHY_SetBBReg(adapter, ODM_REG_RX_ANT_CTRL_11N, BIT5|BIT4|BIT3, 0); /* Default RX   (0/1) */
+		phy_set_bb_reg(adapter, ODM_REG_IGI_A_11N, BIT7, 0); /*  disable HW AntDiv */
+		phy_set_bb_reg(adapter, ODM_REG_RX_ANT_CTRL_11N, BIT5|BIT4|BIT3, 0); /* Default RX   (0/1) */
 		return;
 	}
 	ODM_RT_TRACE(dm_odm, ODM_COMP_ANT_DIV, ODM_DBG_LOUD, ("odm_TRX_HWAntDivInit()\n"));
 
 	/* MAC Setting */
 	value32 = phy_query_bb_reg(adapter, ODM_REG_ANTSEL_PIN_11N, bMaskDWord);
-	PHY_SetBBReg(adapter, ODM_REG_ANTSEL_PIN_11N, bMaskDWord, value32|(BIT23|BIT25)); /* Reg4C[25]=1, Reg4C[23]=1 for pin output */
+	phy_set_bb_reg(adapter, ODM_REG_ANTSEL_PIN_11N, bMaskDWord, value32|(BIT23|BIT25)); /* Reg4C[25]=1, Reg4C[23]=1 for pin output */
 	/* Pin Settings */
-	PHY_SetBBReg(adapter, ODM_REG_PIN_CTRL_11N, BIT9|BIT8, 0);/* Reg870[8]=1'b0, Reg870[9]=1'b0		antsel antselb by HW */
-	PHY_SetBBReg(adapter, ODM_REG_RX_ANT_CTRL_11N, BIT10, 0);	/* Reg864[10]=1'b0	antsel2 by HW */
-	PHY_SetBBReg(adapter, ODM_REG_LNA_SWITCH_11N, BIT22, 0);	/* Regb2c[22]=1'b0	disable CS/CG switch */
-	PHY_SetBBReg(adapter, ODM_REG_LNA_SWITCH_11N, BIT31, 1);	/* Regb2c[31]=1'b1	output at CG only */
+	phy_set_bb_reg(adapter, ODM_REG_PIN_CTRL_11N, BIT9|BIT8, 0);/* Reg870[8]=1'b0, Reg870[9]=1'b0		antsel antselb by HW */
+	phy_set_bb_reg(adapter, ODM_REG_RX_ANT_CTRL_11N, BIT10, 0);	/* Reg864[10]=1'b0	antsel2 by HW */
+	phy_set_bb_reg(adapter, ODM_REG_LNA_SWITCH_11N, BIT22, 0);	/* Regb2c[22]=1'b0	disable CS/CG switch */
+	phy_set_bb_reg(adapter, ODM_REG_LNA_SWITCH_11N, BIT31, 1);	/* Regb2c[31]=1'b1	output at CG only */
 	/* OFDM Settings */
-	PHY_SetBBReg(adapter, ODM_REG_ANTDIV_PARA1_11N, bMaskDWord, 0x000000a0);
+	phy_set_bb_reg(adapter, ODM_REG_ANTDIV_PARA1_11N, bMaskDWord, 0x000000a0);
 	/* CCK Settings */
-	PHY_SetBBReg(adapter, ODM_REG_BB_PWR_SAV4_11N, BIT7, 1); /* Fix CCK PHY status report issue */
-	PHY_SetBBReg(adapter, ODM_REG_CCK_ANTDIV_PARA2_11N, BIT4, 1); /* CCK complete HW AntDiv within 64 samples */
+	phy_set_bb_reg(adapter, ODM_REG_BB_PWR_SAV4_11N, BIT7, 1); /* Fix CCK PHY status report issue */
+	phy_set_bb_reg(adapter, ODM_REG_CCK_ANTDIV_PARA2_11N, BIT4, 1); /* CCK complete HW AntDiv within 64 samples */
 	/* Tx Settings */
-	PHY_SetBBReg(adapter, ODM_REG_TX_ANT_CTRL_11N, BIT21, 0); /* Reg80c[21]=1'b0		from TX Reg */
+	phy_set_bb_reg(adapter, ODM_REG_TX_ANT_CTRL_11N, BIT21, 0); /* Reg80c[21]=1'b0		from TX Reg */
 	ODM_UpdateRxIdleAnt_88E(dm_odm, MAIN_ANT);
 
 	/* antenna mapping table */
 	if (!dm_odm->bIsMPChip) { /* testchip */
-		PHY_SetBBReg(adapter, ODM_REG_RX_DEFUALT_A_11N, BIT10|BIT9|BIT8, 1);	/* Reg858[10:8]=3'b001 */
-		PHY_SetBBReg(adapter, ODM_REG_RX_DEFUALT_A_11N, BIT13|BIT12|BIT11, 2);	/* Reg858[13:11]=3'b010 */
+		phy_set_bb_reg(adapter, ODM_REG_RX_DEFUALT_A_11N, BIT10|BIT9|BIT8, 1);	/* Reg858[10:8]=3'b001 */
+		phy_set_bb_reg(adapter, ODM_REG_RX_DEFUALT_A_11N, BIT13|BIT12|BIT11, 2);	/* Reg858[13:11]=3'b010 */
 	} else { /* MPchip */
-		PHY_SetBBReg(adapter, ODM_REG_ANT_MAPPING1_11N, bMaskDWord, 0x0201);	/* Reg914=3'b010, Reg915=3'b001 */
+		phy_set_bb_reg(adapter, ODM_REG_ANT_MAPPING1_11N, bMaskDWord, 0x0201);	/* Reg914=3'b010, Reg915=3'b001 */
 	}
 }
 
@@ -115,60 +115,60 @@ static void odm_FastAntTrainingInit(struct odm_dm_struct *dm_odm)
 
 	/* MAC Setting */
 	value32 = phy_query_bb_reg(adapter, 0x4c, bMaskDWord);
-	PHY_SetBBReg(adapter, 0x4c, bMaskDWord, value32|(BIT23|BIT25)); /* Reg4C[25]=1, Reg4C[23]=1 for pin output */
+	phy_set_bb_reg(adapter, 0x4c, bMaskDWord, value32|(BIT23|BIT25)); /* Reg4C[25]=1, Reg4C[23]=1 for pin output */
 	value32 = phy_query_bb_reg(adapter,  0x7B4, bMaskDWord);
-	PHY_SetBBReg(adapter, 0x7b4, bMaskDWord, value32|(BIT16|BIT17)); /* Reg7B4[16]=1 enable antenna training, Reg7B4[17]=1 enable A2 match */
+	phy_set_bb_reg(adapter, 0x7b4, bMaskDWord, value32|(BIT16|BIT17)); /* Reg7B4[16]=1 enable antenna training, Reg7B4[17]=1 enable A2 match */
 
 	/* Match MAC ADDR */
-	PHY_SetBBReg(adapter, 0x7b4, 0xFFFF, 0);
-	PHY_SetBBReg(adapter, 0x7b0, bMaskDWord, 0);
+	phy_set_bb_reg(adapter, 0x7b4, 0xFFFF, 0);
+	phy_set_bb_reg(adapter, 0x7b0, bMaskDWord, 0);
 
-	PHY_SetBBReg(adapter, 0x870, BIT9|BIT8, 0);/* Reg870[8]=1'b0, Reg870[9]=1'b0		antsel antselb by HW */
-	PHY_SetBBReg(adapter, 0x864, BIT10, 0);	/* Reg864[10]=1'b0	antsel2 by HW */
-	PHY_SetBBReg(adapter, 0xb2c, BIT22, 0);	/* Regb2c[22]=1'b0	disable CS/CG switch */
-	PHY_SetBBReg(adapter, 0xb2c, BIT31, 1);	/* Regb2c[31]=1'b1	output at CG only */
-	PHY_SetBBReg(adapter, 0xca4, bMaskDWord, 0x000000a0);
+	phy_set_bb_reg(adapter, 0x870, BIT9|BIT8, 0);/* Reg870[8]=1'b0, Reg870[9]=1'b0		antsel antselb by HW */
+	phy_set_bb_reg(adapter, 0x864, BIT10, 0);	/* Reg864[10]=1'b0	antsel2 by HW */
+	phy_set_bb_reg(adapter, 0xb2c, BIT22, 0);	/* Regb2c[22]=1'b0	disable CS/CG switch */
+	phy_set_bb_reg(adapter, 0xb2c, BIT31, 1);	/* Regb2c[31]=1'b1	output at CG only */
+	phy_set_bb_reg(adapter, 0xca4, bMaskDWord, 0x000000a0);
 
 	/* antenna mapping table */
 	if (AntCombination == 2) {
 		if (!dm_odm->bIsMPChip) { /* testchip */
-			PHY_SetBBReg(adapter, 0x858, BIT10|BIT9|BIT8, 1);	/* Reg858[10:8]=3'b001 */
-			PHY_SetBBReg(adapter, 0x858, BIT13|BIT12|BIT11, 2);	/* Reg858[13:11]=3'b010 */
+			phy_set_bb_reg(adapter, 0x858, BIT10|BIT9|BIT8, 1);	/* Reg858[10:8]=3'b001 */
+			phy_set_bb_reg(adapter, 0x858, BIT13|BIT12|BIT11, 2);	/* Reg858[13:11]=3'b010 */
 		} else { /* MPchip */
-			PHY_SetBBReg(adapter, 0x914, bMaskByte0, 1);
-			PHY_SetBBReg(adapter, 0x914, bMaskByte1, 2);
+			phy_set_bb_reg(adapter, 0x914, bMaskByte0, 1);
+			phy_set_bb_reg(adapter, 0x914, bMaskByte1, 2);
 		}
 	} else if (AntCombination == 7) {
 		if (!dm_odm->bIsMPChip) { /* testchip */
-			PHY_SetBBReg(adapter, 0x858, BIT10|BIT9|BIT8, 0);	/* Reg858[10:8]=3'b000 */
-			PHY_SetBBReg(adapter, 0x858, BIT13|BIT12|BIT11, 1);	/* Reg858[13:11]=3'b001 */
-			PHY_SetBBReg(adapter, 0x878, BIT16, 0);
-			PHY_SetBBReg(adapter, 0x858, BIT15|BIT14, 2);	/* Reg878[0],Reg858[14:15])=3'b010 */
-			PHY_SetBBReg(adapter, 0x878, BIT19|BIT18|BIT17, 3);/* Reg878[3:1]=3b'011 */
-			PHY_SetBBReg(adapter, 0x878, BIT22|BIT21|BIT20, 4);/* Reg878[6:4]=3b'100 */
-			PHY_SetBBReg(adapter, 0x878, BIT25|BIT24|BIT23, 5);/* Reg878[9:7]=3b'101 */
-			PHY_SetBBReg(adapter, 0x878, BIT28|BIT27|BIT26, 6);/* Reg878[12:10]=3b'110 */
-			PHY_SetBBReg(adapter, 0x878, BIT31|BIT30|BIT29, 7);/* Reg878[15:13]=3b'111 */
+			phy_set_bb_reg(adapter, 0x858, BIT10|BIT9|BIT8, 0);	/* Reg858[10:8]=3'b000 */
+			phy_set_bb_reg(adapter, 0x858, BIT13|BIT12|BIT11, 1);	/* Reg858[13:11]=3'b001 */
+			phy_set_bb_reg(adapter, 0x878, BIT16, 0);
+			phy_set_bb_reg(adapter, 0x858, BIT15|BIT14, 2);	/* Reg878[0],Reg858[14:15])=3'b010 */
+			phy_set_bb_reg(adapter, 0x878, BIT19|BIT18|BIT17, 3);/* Reg878[3:1]=3b'011 */
+			phy_set_bb_reg(adapter, 0x878, BIT22|BIT21|BIT20, 4);/* Reg878[6:4]=3b'100 */
+			phy_set_bb_reg(adapter, 0x878, BIT25|BIT24|BIT23, 5);/* Reg878[9:7]=3b'101 */
+			phy_set_bb_reg(adapter, 0x878, BIT28|BIT27|BIT26, 6);/* Reg878[12:10]=3b'110 */
+			phy_set_bb_reg(adapter, 0x878, BIT31|BIT30|BIT29, 7);/* Reg878[15:13]=3b'111 */
 		} else { /* MPchip */
-			PHY_SetBBReg(adapter, 0x914, bMaskByte0, 0);
-			PHY_SetBBReg(adapter, 0x914, bMaskByte1, 1);
-			PHY_SetBBReg(adapter, 0x914, bMaskByte2, 2);
-			PHY_SetBBReg(adapter, 0x914, bMaskByte3, 3);
-			PHY_SetBBReg(adapter, 0x918, bMaskByte0, 4);
-			PHY_SetBBReg(adapter, 0x918, bMaskByte1, 5);
-			PHY_SetBBReg(adapter, 0x918, bMaskByte2, 6);
-			PHY_SetBBReg(adapter, 0x918, bMaskByte3, 7);
+			phy_set_bb_reg(adapter, 0x914, bMaskByte0, 0);
+			phy_set_bb_reg(adapter, 0x914, bMaskByte1, 1);
+			phy_set_bb_reg(adapter, 0x914, bMaskByte2, 2);
+			phy_set_bb_reg(adapter, 0x914, bMaskByte3, 3);
+			phy_set_bb_reg(adapter, 0x918, bMaskByte0, 4);
+			phy_set_bb_reg(adapter, 0x918, bMaskByte1, 5);
+			phy_set_bb_reg(adapter, 0x918, bMaskByte2, 6);
+			phy_set_bb_reg(adapter, 0x918, bMaskByte3, 7);
 		}
 	}
 
 	/* Default Ant Setting when no fast training */
-	PHY_SetBBReg(adapter, 0x80c, BIT21, 1); /* Reg80c[21]=1'b1		from TX Info */
-	PHY_SetBBReg(adapter, 0x864, BIT5|BIT4|BIT3, 0);	/* Default RX */
-	PHY_SetBBReg(adapter, 0x864, BIT8|BIT7|BIT6, 1);	/* Optional RX */
+	phy_set_bb_reg(adapter, 0x80c, BIT21, 1); /* Reg80c[21]=1'b1		from TX Info */
+	phy_set_bb_reg(adapter, 0x864, BIT5|BIT4|BIT3, 0);	/* Default RX */
+	phy_set_bb_reg(adapter, 0x864, BIT8|BIT7|BIT6, 1);	/* Optional RX */
 
 	/* Enter Traing state */
-	PHY_SetBBReg(adapter, 0x864, BIT2|BIT1|BIT0, (AntCombination-1));	/* Reg864[2:0]=3'd6	ant combination=reg864[2:0]+1 */
-	PHY_SetBBReg(adapter, 0xc50, BIT7, 1);	/* RegC50[7]=1'b1		enable HW AntDiv */
+	phy_set_bb_reg(adapter, 0x864, BIT2|BIT1|BIT0, (AntCombination-1));	/* Reg864[2:0]=3'd6	ant combination=reg864[2:0]+1 */
+	phy_set_bb_reg(adapter, 0xc50, BIT7, 1);	/* RegC50[7]=1'b1		enable HW AntDiv */
 }
 
 void ODM_AntennaDiversityInit_88E(struct odm_dm_struct *dm_odm)
@@ -201,13 +201,13 @@ void ODM_UpdateRxIdleAnt_88E(struct odm_dm_struct *dm_odm, u8 Ant)
 		}
 
 		if (dm_odm->AntDivType == CG_TRX_HW_ANTDIV) {
-			PHY_SetBBReg(adapter, ODM_REG_RX_ANT_CTRL_11N, BIT5|BIT4|BIT3, DefaultAnt);	/* Default RX */
-			PHY_SetBBReg(adapter, ODM_REG_RX_ANT_CTRL_11N, BIT8|BIT7|BIT6, OptionalAnt);		/* Optional RX */
-			PHY_SetBBReg(adapter, ODM_REG_ANTSEL_CTRL_11N, BIT14|BIT13|BIT12, DefaultAnt);	/* Default TX */
-			PHY_SetBBReg(adapter, ODM_REG_RESP_TX_11N, BIT6|BIT7, DefaultAnt);	/* Resp Tx */
+			phy_set_bb_reg(adapter, ODM_REG_RX_ANT_CTRL_11N, BIT5|BIT4|BIT3, DefaultAnt);	/* Default RX */
+			phy_set_bb_reg(adapter, ODM_REG_RX_ANT_CTRL_11N, BIT8|BIT7|BIT6, OptionalAnt);		/* Optional RX */
+			phy_set_bb_reg(adapter, ODM_REG_ANTSEL_CTRL_11N, BIT14|BIT13|BIT12, DefaultAnt);	/* Default TX */
+			phy_set_bb_reg(adapter, ODM_REG_RESP_TX_11N, BIT6|BIT7, DefaultAnt);	/* Resp Tx */
 		} else if (dm_odm->AntDivType == CGCS_RX_HW_ANTDIV) {
-			PHY_SetBBReg(adapter, ODM_REG_RX_ANT_CTRL_11N, BIT5|BIT4|BIT3, DefaultAnt);	/* Default RX */
-			PHY_SetBBReg(adapter, ODM_REG_RX_ANT_CTRL_11N, BIT8|BIT7|BIT6, OptionalAnt);		/* Optional RX */
+			phy_set_bb_reg(adapter, ODM_REG_RX_ANT_CTRL_11N, BIT5|BIT4|BIT3, DefaultAnt);	/* Default RX */
+			phy_set_bb_reg(adapter, ODM_REG_RX_ANT_CTRL_11N, BIT8|BIT7|BIT6, OptionalAnt);		/* Optional RX */
 		}
 	}
 	dm_fat_tbl->RxIdleAnt = Ant;
@@ -341,10 +341,10 @@ void ODM_AntennaDiversity_88E(struct odm_dm_struct *dm_odm)
 		ODM_RT_TRACE(dm_odm, ODM_COMP_ANT_DIV, ODM_DBG_LOUD, ("ODM_AntennaDiversity_88E(): No Link.\n"));
 		if (dm_fat_tbl->bBecomeLinked) {
 			ODM_RT_TRACE(dm_odm, ODM_COMP_ANT_DIV, ODM_DBG_LOUD, ("Need to Turn off HW AntDiv\n"));
-			PHY_SetBBReg(adapter, ODM_REG_IGI_A_11N, BIT7, 0);	/* RegC50[7]=1'b1		enable HW AntDiv */
-			PHY_SetBBReg(adapter, ODM_REG_CCK_ANTDIV_PARA1_11N, BIT15, 0); /* Enable CCK AntDiv */
+			phy_set_bb_reg(adapter, ODM_REG_IGI_A_11N, BIT7, 0);	/* RegC50[7]=1'b1		enable HW AntDiv */
+			phy_set_bb_reg(adapter, ODM_REG_CCK_ANTDIV_PARA1_11N, BIT15, 0); /* Enable CCK AntDiv */
 			if (dm_odm->AntDivType == CG_TRX_HW_ANTDIV)
-				PHY_SetBBReg(adapter, ODM_REG_TX_ANT_CTRL_11N, BIT21, 0); /* Reg80c[21]=1'b0		from TX Reg */
+				phy_set_bb_reg(adapter, ODM_REG_TX_ANT_CTRL_11N, BIT21, 0); /* Reg80c[21]=1'b0		from TX Reg */
 			dm_fat_tbl->bBecomeLinked = dm_odm->bLinked;
 		}
 		return;
@@ -352,10 +352,10 @@ void ODM_AntennaDiversity_88E(struct odm_dm_struct *dm_odm)
 		if (!dm_fat_tbl->bBecomeLinked) {
 			ODM_RT_TRACE(dm_odm, ODM_COMP_ANT_DIV, ODM_DBG_LOUD, ("Need to Turn on HW AntDiv\n"));
 			/* Because HW AntDiv is disabled before Link, we enable HW AntDiv after link */
-			PHY_SetBBReg(adapter, ODM_REG_IGI_A_11N, BIT7, 1);	/* RegC50[7]=1'b1		enable HW AntDiv */
-			PHY_SetBBReg(adapter, ODM_REG_CCK_ANTDIV_PARA1_11N, BIT15, 1); /* Enable CCK AntDiv */
+			phy_set_bb_reg(adapter, ODM_REG_IGI_A_11N, BIT7, 1);	/* RegC50[7]=1'b1		enable HW AntDiv */
+			phy_set_bb_reg(adapter, ODM_REG_CCK_ANTDIV_PARA1_11N, BIT15, 1); /* Enable CCK AntDiv */
 			if (dm_odm->AntDivType == CG_TRX_HW_ANTDIV)
-				PHY_SetBBReg(adapter, ODM_REG_TX_ANT_CTRL_11N, BIT21, 1); /* Reg80c[21]=1'b1		from TX Info */
+				phy_set_bb_reg(adapter, ODM_REG_TX_ANT_CTRL_11N, BIT21, 1); /* Reg80c[21]=1'b1		from TX Info */
 			dm_fat_tbl->bBecomeLinked = dm_odm->bLinked;
 		}
 	}
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
index 1e982c1..752ca42 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
@@ -51,38 +51,19 @@ u32 phy_query_bb_reg(struct adapter *adapt, u32 regaddr, u32 bitmask)
 	return return_value;
 }
 
-/**
-* Function:	PHY_SetBBReg
-*
-* OverView:	Write "Specific bits" to BB register (page 8~)
-*
-* Input:
-*			struct adapter *Adapter,
-*			u32			RegAddr,	The target address to be modified
-*			u32			BitMask		The target bit position in the target address
-*									to be modified
-*			u32			Data		The new register value in the target bit position
-*									of the target address
-*
-* Output:	None
-* Return:		None
-* Note:		This function is equal to "PutRegSetting" in PHY programming guide
-*/
-
-void rtl8188e_PHY_SetBBReg(struct adapter *Adapter, u32 RegAddr, u32 BitMask, u32 Data)
+void phy_set_bb_reg(struct adapter *adapt, u32 regaddr, u32 bitmask, u32 data)
 {
-	u32 OriginalValue, BitShift;
+	u32 original_value, bit_shift;
 
-	if (BitMask != bMaskDWord) { /* if not "double word" write */
-		OriginalValue = usb_read32(Adapter, RegAddr);
-		BitShift = cal_bit_shift(BitMask);
-		Data = ((OriginalValue & (~BitMask)) | (Data << BitShift));
+	if (bitmask != bMaskDWord) { /* if not "double word" write */
+		original_value = usb_read32(adapt, regaddr);
+		bit_shift = cal_bit_shift(bitmask);
+		data = ((original_value & (~bitmask)) | (data << bit_shift));
 	}
 
-	usb_write32(Adapter, RegAddr, Data);
+	usb_write32(adapt, regaddr, data);
 }
 
-
 /*  */
 /*  2. RF register R/W API */
 /*  */
@@ -139,10 +120,10 @@ phy_RFSerialRead(
 
 	tmplong2 = (tmplong2 & (~bLSSIReadAddress)) | (NewOffset<<23) | bLSSIReadEdge;	/* T65 RF */
 
-	PHY_SetBBReg(Adapter, rFPGA0_XA_HSSIParameter2, bMaskDWord, tmplong&(~bLSSIReadEdge));
+	phy_set_bb_reg(Adapter, rFPGA0_XA_HSSIParameter2, bMaskDWord, tmplong&(~bLSSIReadEdge));
 	udelay(10);/*  PlatformStallExecution(10); */
 
-	PHY_SetBBReg(Adapter, pPhyReg->rfHSSIPara2, bMaskDWord, tmplong2);
+	phy_set_bb_reg(Adapter, pPhyReg->rfHSSIPara2, bMaskDWord, tmplong2);
 	udelay(100);/* PlatformStallExecution(100); */
 
 	udelay(10);/* PlatformStallExecution(10); */
@@ -234,7 +215,7 @@ phy_RFSerialWrite(
 	/*  */
 	/*  Write Operation */
 	/*  */
-	PHY_SetBBReg(Adapter, pPhyReg->rf3wireOffset, bMaskDWord, DataAndAddr);
+	phy_set_bb_reg(Adapter, pPhyReg->rf3wireOffset, bMaskDWord, DataAndAddr);
 }
 
 /**
@@ -491,17 +472,17 @@ _PHY_SetBWMode92C(
 	switch (pHalData->CurrentChannelBW) {
 	/* 20 MHz channel*/
 	case HT_CHANNEL_WIDTH_20:
-		PHY_SetBBReg(Adapter, rFPGA0_RFMOD, bRFMOD, 0x0);
-		PHY_SetBBReg(Adapter, rFPGA1_RFMOD, bRFMOD, 0x0);
+		phy_set_bb_reg(Adapter, rFPGA0_RFMOD, bRFMOD, 0x0);
+		phy_set_bb_reg(Adapter, rFPGA1_RFMOD, bRFMOD, 0x0);
 		break;
 	/* 40 MHz channel*/
 	case HT_CHANNEL_WIDTH_40:
-		PHY_SetBBReg(Adapter, rFPGA0_RFMOD, bRFMOD, 0x1);
-		PHY_SetBBReg(Adapter, rFPGA1_RFMOD, bRFMOD, 0x1);
+		phy_set_bb_reg(Adapter, rFPGA0_RFMOD, bRFMOD, 0x1);
+		phy_set_bb_reg(Adapter, rFPGA1_RFMOD, bRFMOD, 0x1);
 		/*  Set Control channel to upper or lower. These settings are required only for 40MHz */
-		PHY_SetBBReg(Adapter, rCCK0_System, bCCKSideBand, (pHalData->nCur40MhzPrimeSC>>1));
-		PHY_SetBBReg(Adapter, rOFDM1_LSTF, 0xC00, pHalData->nCur40MhzPrimeSC);
-		PHY_SetBBReg(Adapter, 0x818, (BIT26 | BIT27),
+		phy_set_bb_reg(Adapter, rCCK0_System, bCCKSideBand, (pHalData->nCur40MhzPrimeSC>>1));
+		phy_set_bb_reg(Adapter, rOFDM1_LSTF, 0xC00, pHalData->nCur40MhzPrimeSC);
+		phy_set_bb_reg(Adapter, 0x818, (BIT26 | BIT27),
 			     (pHalData->nCur40MhzPrimeSC == HAL_PRIME_CHNL_OFFSET_LOWER) ? 2 : 1);
 		break;
 	default:
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c b/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
index 655d8e0..8efb367 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
@@ -43,7 +43,7 @@
 
 #include <osdep_service.h>
 #include <drv_types.h>
-
+#include <phy.h>
 #include <rtl8188e_hal.h>
 
 /*-----------------------------------------------------------------------------
@@ -182,15 +182,15 @@ i		 *  Currently, we cannot fully disable driver dynamic
 
 	/*  rf-A cck tx power */
 	tmpval = TxAGC[RF_PATH_A]&0xff;
-	PHY_SetBBReg(Adapter, rTxAGC_A_CCK1_Mcs32, bMaskByte1, tmpval);
+	phy_set_bb_reg(Adapter, rTxAGC_A_CCK1_Mcs32, bMaskByte1, tmpval);
 	tmpval = TxAGC[RF_PATH_A]>>8;
-	PHY_SetBBReg(Adapter, rTxAGC_B_CCK11_A_CCK2_11, 0xffffff00, tmpval);
+	phy_set_bb_reg(Adapter, rTxAGC_B_CCK11_A_CCK2_11, 0xffffff00, tmpval);
 
 	/*  rf-B cck tx power */
 	tmpval = TxAGC[RF_PATH_B]>>24;
-	PHY_SetBBReg(Adapter, rTxAGC_B_CCK11_A_CCK2_11, bMaskByte0, tmpval);
+	phy_set_bb_reg(Adapter, rTxAGC_B_CCK11_A_CCK2_11, bMaskByte0, tmpval);
 	tmpval = TxAGC[RF_PATH_B]&0x00ffffff;
-	PHY_SetBBReg(Adapter, rTxAGC_B_CCK1_55_Mcs32, 0xffffff00, tmpval);
+	phy_set_bb_reg(Adapter, rTxAGC_B_CCK1_55_Mcs32, 0xffffff00, tmpval);
 }	/* PHY_RF6052SetCckTxPower */
 
 /*  */
@@ -349,7 +349,7 @@ static void writeOFDMPowerReg88E(struct adapter *Adapter, u8 index, u32 *pValue)
 		else
 			regoffset = regoffset_b[index];
 
-		PHY_SetBBReg(Adapter, regoffset, bMaskDWord, writeVal);
+		phy_set_bb_reg(Adapter, regoffset, bMaskDWord, writeVal);
 
 		/*  201005115 Joseph: Set Tx Power diff for Tx power training mechanism. */
 		if (((pHalData->rf_type == RF_2T2R) &&
diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index 5dec8e6..7503a24 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -613,8 +613,8 @@ static void _BeaconFunctionEnable(struct adapter *Adapter,
 /*  Set CCK and OFDM Block "ON" */
 static void _BBTurnOnBlock(struct adapter *Adapter)
 {
-	PHY_SetBBReg(Adapter, rFPGA0_RFMOD, bCCKEn, 0x1);
-	PHY_SetBBReg(Adapter, rFPGA0_RFMOD, bOFDMEn, 0x1);
+	phy_set_bb_reg(Adapter, rFPGA0_RFMOD, bCCKEn, 0x1);
+	phy_set_bb_reg(Adapter, rFPGA0_RFMOD, bOFDMEn, 0x1);
 }
 
 enum {
@@ -631,7 +631,7 @@ static void _InitAntenna_Selection(struct adapter *Adapter)
 	DBG_88E("==>  %s ....\n", __func__);
 
 	usb_write32(Adapter, REG_LEDCFG0, usb_read32(Adapter, REG_LEDCFG0)|BIT23);
-	PHY_SetBBReg(Adapter, rFPGA0_XAB_RFParameter, BIT13, 0x01);
+	phy_set_bb_reg(Adapter, rFPGA0_XAB_RFParameter, BIT13, 0x01);
 
 	if (phy_query_bb_reg(Adapter, rFPGA0_XA_RFInterfaceOE, 0x300) == Antenna_A)
 		haldata->CurAntenna = Antenna_A;
diff --git a/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h b/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
index 3e2135e..cfd59d7 100644
--- a/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
+++ b/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
@@ -198,8 +198,6 @@ struct ant_sel_cck {
 /*  */
 /*  BB and RF register read/write */
 /*  */
-void rtl8188e_PHY_SetBBReg(struct adapter *Adapter, u32 RegAddr,
-			   u32 mask, u32 data);
 u32 rtl8188e_PHY_QueryRFReg(struct adapter *adapter, enum rf_radio_path rfpath,
 			    u32 regaddr, u32 mask);
 void rtl8188e_PHY_SetRFReg(struct adapter *adapter, enum rf_radio_path rfpath,
@@ -234,8 +232,6 @@ bool SetAntennaConfig92C(struct adapter *adapter, u8 defaultant);
 
 /*--------------------------Exported Function prototype---------------------*/
 
-#define PHY_SetBBReg(adapt, regaddr, bitmask, data)		\
-	 rtl8188e_PHY_SetBBReg((adapt), (regaddr), (bitmask), (data))
 #define PHY_QueryRFReg(adapt, rfpath, regaddr, bitmask)	\
 	rtl8188e_PHY_QueryRFReg((adapt), (rfpath), (regaddr), (bitmask))
 #define PHY_SetRFReg(adapt, rfpath, regaddr, bitmask, data)	\
diff --git a/drivers/staging/rtl8188eu/include/phy.h b/drivers/staging/rtl8188eu/include/phy.h
index cefcc74..2d3889b 100644
--- a/drivers/staging/rtl8188eu/include/phy.h
+++ b/drivers/staging/rtl8188eu/include/phy.h
@@ -3,3 +3,4 @@ bool rtl88eu_phy_rf_config(struct adapter *adapt);
 bool rtl88eu_phy_bb_config(struct adapter *adapt);
 
 u32 phy_query_bb_reg(struct adapter *adapt, u32 regaddr, u32 bitmask);
+void phy_set_bb_reg(struct adapter *adapt, u32 regaddr, u32 bitmask, u32 data);
-- 
1.7.10.4

