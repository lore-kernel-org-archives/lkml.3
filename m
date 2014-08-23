Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaHWOUW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 10:20:22 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:58868 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaHWOUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 10:20:16 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 09/20] staging: rtl8188eu: Rework function rtl8188e_PHY_SetRFReg()
Date: Sat, 23 Aug 2014 19:48:30 +0530
Message-Id: <1408803521-13715-9-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
References: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CamelCase variables and function name.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c   |    2 +-
 drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c     |   32 +++++++--------
 drivers/staging/rtl8188eu/hal/odm.c                |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c  |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c    |   42 +++++---------------
 drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c    |    4 +-
 drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h |    5 ---
 drivers/staging/rtl8188eu/include/phy.h            |    2 +
 8 files changed, 32 insertions(+), 59 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c b/drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c
index 670ded7..ddc2f55 100644
--- a/drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c
+++ b/drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c
@@ -179,7 +179,7 @@ static void rtl_rfreg_delay(struct adapter *adapt, enum rf_radio_path rfpath,u32
 	} else if (addr == 0xf9) {
 		udelay(1);
 	} else {
-		rtl8188e_PHY_SetRFReg(adapt, rfpath, addr, mask, data);
+		phy_set_rf_reg(adapt, rfpath, addr, mask, data);
 		udelay(1);
 	}
 }
diff --git a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
index 06c5536..f1a1e78 100644
--- a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
+++ b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
@@ -527,14 +527,14 @@ phy_PathA_RxIQK(struct adapter *adapt, bool configPathB)
 	/* modify RXIQK mode table */
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("Path-A Rx IQK modify RXIQK mode table!\n"));
 	phy_set_bb_reg(adapt, rFPGA0_IQK, bMaskDWord, 0x00000000);
-	PHY_SetRFReg(adapt, RF_PATH_A, RF_WE_LUT, bRFRegOffsetMask, 0x800a0);
-	PHY_SetRFReg(adapt, RF_PATH_A, RF_RCK_OS, bRFRegOffsetMask, 0x30000);
-	PHY_SetRFReg(adapt, RF_PATH_A, RF_TXPA_G1, bRFRegOffsetMask, 0x0000f);
-	PHY_SetRFReg(adapt, RF_PATH_A, RF_TXPA_G2, bRFRegOffsetMask, 0xf117B);
+	phy_set_rf_reg(adapt, RF_PATH_A, RF_WE_LUT, bRFRegOffsetMask, 0x800a0);
+	phy_set_rf_reg(adapt, RF_PATH_A, RF_RCK_OS, bRFRegOffsetMask, 0x30000);
+	phy_set_rf_reg(adapt, RF_PATH_A, RF_TXPA_G1, bRFRegOffsetMask, 0x0000f);
+	phy_set_rf_reg(adapt, RF_PATH_A, RF_TXPA_G2, bRFRegOffsetMask, 0xf117B);
 
 	/* PA,PAD off */
-	PHY_SetRFReg(adapt, RF_PATH_A, 0xdf, bRFRegOffsetMask, 0x980);
-	PHY_SetRFReg(adapt, RF_PATH_A, 0x56, bRFRegOffsetMask, 0x51000);
+	phy_set_rf_reg(adapt, RF_PATH_A, 0xdf, bRFRegOffsetMask, 0x980);
+	phy_set_rf_reg(adapt, RF_PATH_A, 0x56, bRFRegOffsetMask, 0x51000);
 
 	phy_set_bb_reg(adapt, rFPGA0_IQK, bMaskDWord, 0x80800000);
 
@@ -589,10 +589,10 @@ phy_PathA_RxIQK(struct adapter *adapt, bool configPathB)
 	/* modify RXIQK mode table */
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD, ("Path-A Rx IQK modify RXIQK mode table 2!\n"));
 	phy_set_bb_reg(adapt, rFPGA0_IQK, bMaskDWord, 0x00000000);
-	PHY_SetRFReg(adapt, RF_PATH_A, RF_WE_LUT, bRFRegOffsetMask, 0x800a0);
-	PHY_SetRFReg(adapt, RF_PATH_A, RF_RCK_OS, bRFRegOffsetMask, 0x30000);
-	PHY_SetRFReg(adapt, RF_PATH_A, RF_TXPA_G1, bRFRegOffsetMask, 0x0000f);
-	PHY_SetRFReg(adapt, RF_PATH_A, RF_TXPA_G2, bRFRegOffsetMask, 0xf7ffa);
+	phy_set_rf_reg(adapt, RF_PATH_A, RF_WE_LUT, bRFRegOffsetMask, 0x800a0);
+	phy_set_rf_reg(adapt, RF_PATH_A, RF_RCK_OS, bRFRegOffsetMask, 0x30000);
+	phy_set_rf_reg(adapt, RF_PATH_A, RF_TXPA_G1, bRFRegOffsetMask, 0x0000f);
+	phy_set_rf_reg(adapt, RF_PATH_A, RF_TXPA_G2, bRFRegOffsetMask, 0xf7ffa);
 	phy_set_bb_reg(adapt, rFPGA0_IQK, bMaskDWord, 0x80800000);
 
 	/* IQK setting */
@@ -630,7 +630,7 @@ phy_PathA_RxIQK(struct adapter *adapt, bool configPathB)
 
 	/* reload RF 0xdf */
 	phy_set_bb_reg(adapt, rFPGA0_IQK, bMaskDWord, 0x00000000);
-	PHY_SetRFReg(adapt, RF_PATH_A, 0xdf, bRFRegOffsetMask, 0x180);
+	phy_set_rf_reg(adapt, RF_PATH_A, 0xdf, bRFRegOffsetMask, 0x180);
 
 	if (!(regeac & BIT27) &&		/* if Tx is OK, check whether Rx is OK */
 	    (((regEA4 & 0x03FF0000)>>16) != 0x132) &&
@@ -1224,18 +1224,18 @@ static void phy_LCCalibrate_8188E(struct adapter *adapt, bool is2t)
 
 		/* 2. Set RF mode = standby mode */
 		/* Path-A */
-		PHY_SetRFReg(adapt, RF_PATH_A, RF_AC, bMask12Bits, (RF_Amode&0x8FFFF)|0x10000);
+		phy_set_rf_reg(adapt, RF_PATH_A, RF_AC, bMask12Bits, (RF_Amode&0x8FFFF)|0x10000);
 
 		/* Path-B */
 		if (is2t)
-			PHY_SetRFReg(adapt, RF_PATH_B, RF_AC, bMask12Bits, (RF_Bmode&0x8FFFF)|0x10000);
+			phy_set_rf_reg(adapt, RF_PATH_B, RF_AC, bMask12Bits, (RF_Bmode&0x8FFFF)|0x10000);
 	}
 
 	/* 3. Read RF reg18 */
 	LC_Cal = phy_query_rf_reg(adapt, RF_PATH_A, RF_CHNLBW, bMask12Bits);
 
 	/* 4. Set LC calibration begin	bit15 */
-	PHY_SetRFReg(adapt, RF_PATH_A, RF_CHNLBW, bMask12Bits, LC_Cal|0x08000);
+	phy_set_rf_reg(adapt, RF_PATH_A, RF_CHNLBW, bMask12Bits, LC_Cal|0x08000);
 
 	msleep(100);
 
@@ -1244,11 +1244,11 @@ static void phy_LCCalibrate_8188E(struct adapter *adapt, bool is2t)
 		/* Deal with continuous TX case */
 		/* Path-A */
 		usb_write8(adapt, 0xd03, tmpreg);
-		PHY_SetRFReg(adapt, RF_PATH_A, RF_AC, bMask12Bits, RF_Amode);
+		phy_set_rf_reg(adapt, RF_PATH_A, RF_AC, bMask12Bits, RF_Amode);
 
 		/* Path-B */
 		if (is2t)
-			PHY_SetRFReg(adapt, RF_PATH_B, RF_AC, bMask12Bits, RF_Bmode);
+			phy_set_rf_reg(adapt, RF_PATH_B, RF_AC, bMask12Bits, RF_Bmode);
 	} else {
 		/*  Deal with Packet TX case */
 		usb_write8(adapt, REG_TXPAUSE, 0x00);
diff --git a/drivers/staging/rtl8188eu/hal/odm.c b/drivers/staging/rtl8188eu/hal/odm.c
index db0a72e..6830500 100644
--- a/drivers/staging/rtl8188eu/hal/odm.c
+++ b/drivers/staging/rtl8188eu/hal/odm.c
@@ -1236,7 +1236,7 @@ void odm_TXPowerTrackingCheckCE(struct odm_dm_struct *pDM_Odm)
 		return;
 
 	if (!pDM_Odm->RFCalibrateInfo.TM_Trigger) {		/* at least delay 1 sec */
-		PHY_SetRFReg(Adapter, RF_PATH_A, RF_T_METER_88E, BIT17 | BIT16, 0x03);
+		phy_set_rf_reg(Adapter, RF_PATH_A, RF_T_METER_88E, BIT17 | BIT16, 0x03);
 
 		pDM_Odm->RFCalibrateInfo.TM_Trigger = 1;
 		return;
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index a5064ae..cc2988c 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -231,7 +231,7 @@ void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc)
 	pHalFunc->AntDivBeforeLinkHandler = &AntDivBeforeLink8188E;
 	pHalFunc->AntDivCompareHandler = &AntDivCompare8188E;
 	pHalFunc->read_rfreg = &phy_query_rf_reg;
-	pHalFunc->write_rfreg = &rtl8188e_PHY_SetRFReg;
+	pHalFunc->write_rfreg = &phy_set_rf_reg;
 
 	pHalFunc->sreset_init_value = &sreset_init_value;
 	pHalFunc->sreset_get_wifi_status  = &sreset_get_wifi_status;
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
index 506b287..83cd19d 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
@@ -135,43 +135,19 @@ u32 phy_query_rf_reg(struct adapter *adapt, enum rf_radio_path rf_path,
 	return readback_value;
 }
 
-/**
-* Function:	PHY_SetRFReg
-*
-* OverView:	Write "Specific bits" to RF register (page 8~)
-*
-* Input:
-*			struct adapter *Adapter,
-*			enum rf_radio_path eRFPath,	Radio path of A/B/C/D
-*			u32			RegAddr,	The target address to be modified
-*			u32			BitMask		The target bit position in the target address
-*									to be modified
-*			u32			Data		The new register Data in the target bit position
-*									of the target address
-*
-* Output:	None
-* Return:		None
-* Note:		This function is equal to "PutRFRegSetting" in PHY programming guide
-*/
-void
-rtl8188e_PHY_SetRFReg(
-		struct adapter *Adapter,
-		enum rf_radio_path eRFPath,
-		u32 RegAddr,
-		u32 BitMask,
-		u32 Data
-	)
+void phy_set_rf_reg(struct adapter *adapt, enum rf_radio_path rf_path,
+		     u32 reg_addr, u32 bit_mask, u32 data)
 {
-	u32 Original_Value, BitShift;
+	u32 original_value, bit_shift;
 
 	/*  RF data is 12 bits only */
-	if (BitMask != bRFRegOffsetMask) {
-		Original_Value = rf_serial_read(Adapter, eRFPath, RegAddr);
-		BitShift =  cal_bit_shift(BitMask);
-		Data = ((Original_Value & (~BitMask)) | (Data << BitShift));
+	if (bit_mask != bRFRegOffsetMask) {
+		original_value = rf_serial_read(adapt, rf_path, reg_addr);
+		bit_shift =  cal_bit_shift(bit_mask);
+		data = ((original_value & (~bit_mask)) | (data << bit_shift));
 	}
 
-	rf_serial_write(Adapter, eRFPath, RegAddr, Data);
+	rf_serial_write(adapt, rf_path, reg_addr, data);
 }
 
 static void getTxPowerIndex88E(struct adapter *Adapter, u8 channel, u8 *cckPowerLevel,
@@ -446,7 +422,7 @@ static void _PHY_SwChnl8192C(struct adapter *Adapter, u8 channel)
 	param2 = channel;
 	for (eRFPath = 0; eRFPath < pHalData->NumTotalRFPath; eRFPath++) {
 		pHalData->RfRegChnlVal[eRFPath] = ((pHalData->RfRegChnlVal[eRFPath] & 0xfffffc00) | param2);
-		PHY_SetRFReg(Adapter, (enum rf_radio_path)eRFPath, param1, bRFRegOffsetMask, pHalData->RfRegChnlVal[eRFPath]);
+		phy_set_rf_reg(Adapter, (enum rf_radio_path)eRFPath, param1, bRFRegOffsetMask, pHalData->RfRegChnlVal[eRFPath]);
 	}
 }
 
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c b/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
index 8efb367..bcee67a 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
@@ -68,11 +68,11 @@ void rtl8188e_PHY_RF6052SetBandwidth(struct adapter *Adapter,
 	switch (Bandwidth) {
 	case HT_CHANNEL_WIDTH_20:
 		pHalData->RfRegChnlVal[0] = ((pHalData->RfRegChnlVal[0] & 0xfffff3ff) | BIT(10) | BIT(11));
-		PHY_SetRFReg(Adapter, RF_PATH_A, RF_CHNLBW, bRFRegOffsetMask, pHalData->RfRegChnlVal[0]);
+		phy_set_rf_reg(Adapter, RF_PATH_A, RF_CHNLBW, bRFRegOffsetMask, pHalData->RfRegChnlVal[0]);
 		break;
 	case HT_CHANNEL_WIDTH_40:
 		pHalData->RfRegChnlVal[0] = ((pHalData->RfRegChnlVal[0] & 0xfffff3ff) | BIT(10));
-		PHY_SetRFReg(Adapter, RF_PATH_A, RF_CHNLBW, bRFRegOffsetMask, pHalData->RfRegChnlVal[0]);
+		phy_set_rf_reg(Adapter, RF_PATH_A, RF_CHNLBW, bRFRegOffsetMask, pHalData->RfRegChnlVal[0]);
 		break;
 	default:
 		break;
diff --git a/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h b/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
index d080586..94f9bf0 100644
--- a/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
+++ b/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
@@ -198,8 +198,6 @@ struct ant_sel_cck {
 /*  */
 /*  BB and RF register read/write */
 /*  */
-void rtl8188e_PHY_SetRFReg(struct adapter *adapter, enum rf_radio_path rfpath,
-			   u32 regaddr, u32 mask, u32 data);
 
 /* Read initi reg value for tx power setting. */
 void rtl8192c_PHY_GetHWRegOriginalValue(struct adapter *adapter);
@@ -230,9 +228,6 @@ bool SetAntennaConfig92C(struct adapter *adapter, u8 defaultant);
 
 /*--------------------------Exported Function prototype---------------------*/
 
-#define PHY_SetRFReg(adapt, rfpath, regaddr, bitmask, data)	\
-	rtl8188e_PHY_SetRFReg((adapt), (rfpath), (regaddr), (bitmask), (data))
-
 #define PHY_SetMacReg	PHY_SetBBReg
 
 #define	SIC_HW_SUPPORT			0
diff --git a/drivers/staging/rtl8188eu/include/phy.h b/drivers/staging/rtl8188eu/include/phy.h
index 129b81a..4905479 100644
--- a/drivers/staging/rtl8188eu/include/phy.h
+++ b/drivers/staging/rtl8188eu/include/phy.h
@@ -6,3 +6,5 @@ u32 phy_query_bb_reg(struct adapter *adapt, u32 regaddr, u32 bitmask);
 void phy_set_bb_reg(struct adapter *adapt, u32 regaddr, u32 bitmask, u32 data);
 u32 phy_query_rf_reg(struct adapter *adapt, enum rf_radio_path rf_path,
 		     u32 reg_addr, u32 bit_mask);
+void phy_set_rf_reg(struct adapter *adapt, enum rf_radio_path rf_path,
+		    u32 reg_addr, u32 bit_mask, u32 data);
-- 
1.7.10.4

