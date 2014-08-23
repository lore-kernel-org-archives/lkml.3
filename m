Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbaHWOUM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 10:20:12 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:58894 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaHWOUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 10:20:08 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 08/20] staging: rtl8188eu: Rework function PHY_QueryRFReg()
Date: Sat, 23 Aug 2014 19:48:29 +0530
Message-Id: <1408803521-13715-8-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
References: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CamelCase variables and function name.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c     |   10 +++----
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c  |    4 +--
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c    |   31 +++++---------------
 drivers/staging/rtl8188eu/hal/usb_halinit.c        |    4 +--
 drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h |    4 ---
 drivers/staging/rtl8188eu/include/phy.h            |    2 ++
 6 files changed, 18 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
index f837c95..06c5536 100644
--- a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
+++ b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
@@ -169,7 +169,7 @@ odm_TXPowerTrackingCallback_ThermalMeter_8188E(
 		     ("===>dm_TXPowerTrackingCallback_ThermalMeter_8188E txpowercontrol %d\n",
 		     dm_odm->RFCalibrateInfo.TxPowerTrackControl));
 
-	ThermalValue = (u8)PHY_QueryRFReg(Adapter, RF_PATH_A, RF_T_METER_88E, 0xfc00);	/* 0x42: RF Reg[15:10] 88E */
+	ThermalValue = (u8)phy_query_rf_reg(Adapter, RF_PATH_A, RF_T_METER_88E, 0xfc00);	/* 0x42: RF Reg[15:10] 88E */
 
 	ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD,
 		     ("Readback Thermal Meter = 0x%x pre thermal meter 0x%x EEPROMthermalmeter 0x%x\n",
@@ -446,7 +446,7 @@ odm_TXPowerTrackingCallback_ThermalMeter_8188E(
 				ODM_RT_TRACE(dm_odm, ODM_COMP_CALIBRATION, ODM_DBG_LOUD,
 					     ("TxPwrTracking 0xc80 = 0x%x, 0xc94 = 0x%x RF 0x24 = 0x%x\n",
 					     phy_query_bb_reg(Adapter, 0xc80, bMaskDWord), phy_query_bb_reg(Adapter,
-					     0xc94, bMaskDWord), PHY_QueryRFReg(Adapter, RF_PATH_A, 0x24, bRFRegOffsetMask)));
+					     0xc94, bMaskDWord), phy_query_rf_reg(Adapter, RF_PATH_A, 0x24, bRFRegOffsetMask)));
 			}
 		}
 
@@ -1216,11 +1216,11 @@ static void phy_LCCalibrate_8188E(struct adapter *adapt, bool is2t)
 	if ((tmpreg&0x70) != 0) {
 		/* 1. Read original RF mode */
 		/* Path-A */
-		RF_Amode = PHY_QueryRFReg(adapt, RF_PATH_A, RF_AC, bMask12Bits);
+		RF_Amode = phy_query_rf_reg(adapt, RF_PATH_A, RF_AC, bMask12Bits);
 
 		/* Path-B */
 		if (is2t)
-			RF_Bmode = PHY_QueryRFReg(adapt, RF_PATH_B, RF_AC, bMask12Bits);
+			RF_Bmode = phy_query_rf_reg(adapt, RF_PATH_B, RF_AC, bMask12Bits);
 
 		/* 2. Set RF mode = standby mode */
 		/* Path-A */
@@ -1232,7 +1232,7 @@ static void phy_LCCalibrate_8188E(struct adapter *adapt, bool is2t)
 	}
 
 	/* 3. Read RF reg18 */
-	LC_Cal = PHY_QueryRFReg(adapt, RF_PATH_A, RF_CHNLBW, bMask12Bits);
+	LC_Cal = phy_query_rf_reg(adapt, RF_PATH_A, RF_CHNLBW, bMask12Bits);
 
 	/* 4. Set LC calibration begin	bit15 */
 	PHY_SetRFReg(adapt, RF_PATH_A, RF_CHNLBW, bMask12Bits, LC_Cal|0x08000);
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index ae7cb8d..a5064ae 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -23,7 +23,7 @@
 #include <linux/vmalloc.h>
 #include <drv_types.h>
 #include <rtw_efuse.h>
-
+#include <phy.h>
 #include <rtl8188e_hal.h>
 
 #include <rtw_iol.h>
@@ -230,7 +230,7 @@ void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc)
 
 	pHalFunc->AntDivBeforeLinkHandler = &AntDivBeforeLink8188E;
 	pHalFunc->AntDivCompareHandler = &AntDivCompare8188E;
-	pHalFunc->read_rfreg = &rtl8188e_PHY_QueryRFReg;
+	pHalFunc->read_rfreg = &phy_query_rf_reg;
 	pHalFunc->write_rfreg = &rtl8188e_PHY_SetRFReg;
 
 	pHalFunc->sreset_init_value = &sreset_init_value;
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
index 2cbaff5..506b287 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
@@ -124,32 +124,15 @@ static void rf_serial_write(struct adapter *adapt,
 	phy_set_bb_reg(adapt, phyreg->rf3wireOffset, bMaskDWord, data_and_addr);
 }
 
-/**
-* Function:	PHY_QueryRFReg
-*
-* OverView:	Query "Specific bits" to RF register (page 8~)
-*
-* Input:
-*			struct adapter *Adapter,
-*			enum rf_radio_path eRFPath,	Radio path of A/B/C/D
-*			u32			RegAddr,	The target address to be read
-*			u32			BitMask		The target bit position in the target address
-*									to be read
-*
-* Output:	None
-* Return:		u32			Readback value
-* Note:		This function is equal to "GetRFRegSetting" in PHY programming guide
-*/
-u32 rtl8188e_PHY_QueryRFReg(struct adapter *Adapter, enum rf_radio_path eRFPath,
-			    u32 RegAddr, u32 BitMask)
+u32 phy_query_rf_reg(struct adapter *adapt, enum rf_radio_path rf_path,
+		     u32 reg_addr, u32 bit_mask)
 {
-	u32 Original_Value, Readback_Value, BitShift;
-
-	Original_Value = rf_serial_read(Adapter, eRFPath, RegAddr);
+	u32 original_value, readback_value, bit_shift;
 
-	BitShift =  cal_bit_shift(BitMask);
-	Readback_Value = (Original_Value & BitMask) >> BitShift;
-	return Readback_Value;
+	original_value = rf_serial_read(adapt, rf_path, reg_addr);
+	bit_shift =  cal_bit_shift(bit_mask);
+	readback_value = (original_value & bit_mask) >> bit_shift;
+	return readback_value;
 }
 
 /**
diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index 7503a24..968707e 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -818,8 +818,8 @@ static u32 rtl8188eu_hal_init(struct adapter *Adapter)
 	usb_write16(Adapter, REG_PKT_BE_BK_LIFE_TIME, 0x0400);	/*  unit: 256us. 256ms */
 
 	/* Keep RfRegChnlVal for later use. */
-	haldata->RfRegChnlVal[0] = PHY_QueryRFReg(Adapter, (enum rf_radio_path)0, RF_CHNLBW, bRFRegOffsetMask);
-	haldata->RfRegChnlVal[1] = PHY_QueryRFReg(Adapter, (enum rf_radio_path)1, RF_CHNLBW, bRFRegOffsetMask);
+	haldata->RfRegChnlVal[0] = phy_query_rf_reg(Adapter, (enum rf_radio_path)0, RF_CHNLBW, bRFRegOffsetMask);
+	haldata->RfRegChnlVal[1] = phy_query_rf_reg(Adapter, (enum rf_radio_path)1, RF_CHNLBW, bRFRegOffsetMask);
 
 HAL_INIT_PROFILE_TAG(HAL_INIT_STAGES_TURN_ON_BLOCK);
 	_BBTurnOnBlock(Adapter);
diff --git a/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h b/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
index cfd59d7..d080586 100644
--- a/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
+++ b/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
@@ -198,8 +198,6 @@ struct ant_sel_cck {
 /*  */
 /*  BB and RF register read/write */
 /*  */
-u32 rtl8188e_PHY_QueryRFReg(struct adapter *adapter, enum rf_radio_path rfpath,
-			    u32 regaddr, u32 mask);
 void rtl8188e_PHY_SetRFReg(struct adapter *adapter, enum rf_radio_path rfpath,
 			   u32 regaddr, u32 mask, u32 data);
 
@@ -232,8 +230,6 @@ bool SetAntennaConfig92C(struct adapter *adapter, u8 defaultant);
 
 /*--------------------------Exported Function prototype---------------------*/
 
-#define PHY_QueryRFReg(adapt, rfpath, regaddr, bitmask)	\
-	rtl8188e_PHY_QueryRFReg((adapt), (rfpath), (regaddr), (bitmask))
 #define PHY_SetRFReg(adapt, rfpath, regaddr, bitmask, data)	\
 	rtl8188e_PHY_SetRFReg((adapt), (rfpath), (regaddr), (bitmask), (data))
 
diff --git a/drivers/staging/rtl8188eu/include/phy.h b/drivers/staging/rtl8188eu/include/phy.h
index 2d3889b..129b81a 100644
--- a/drivers/staging/rtl8188eu/include/phy.h
+++ b/drivers/staging/rtl8188eu/include/phy.h
@@ -4,3 +4,5 @@ bool rtl88eu_phy_bb_config(struct adapter *adapt);
 
 u32 phy_query_bb_reg(struct adapter *adapt, u32 regaddr, u32 bitmask);
 void phy_set_bb_reg(struct adapter *adapt, u32 regaddr, u32 bitmask, u32 data);
+u32 phy_query_rf_reg(struct adapter *adapt, enum rf_radio_path rf_path,
+		     u32 reg_addr, u32 bit_mask);
-- 
1.7.10.4

