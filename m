Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaHWOU4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 10:20:56 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:61423 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbaHWOUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 10:20:53 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 14/20] staging: rtl8188eu: Rework function PHY_SetTxPowerLevel8188E()
Date: Sat, 23 Aug 2014 19:48:35 +0530
Message-Id: <1408803521-13715-14-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
References: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CamelCase variables and function name.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c     |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c    |   44 ++++++--------------
 drivers/staging/rtl8188eu/hal/usb_halinit.c        |    2 +-
 drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h |    1 -
 drivers/staging/rtl8188eu/include/phy.h            |    2 +
 5 files changed, 17 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
index f1a1e78..0e58597 100644
--- a/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
+++ b/drivers/staging/rtl8188eu/hal/HalPhyRf_8188e.c
@@ -114,7 +114,7 @@ static void odm_TxPwrTrackSetPwr88E(struct odm_dm_struct *dm_odm)
 {
 	if (dm_odm->BbSwingFlagOfdm || dm_odm->BbSwingFlagCck) {
 		ODM_RT_TRACE(dm_odm, ODM_COMP_TX_PWR_TRACK, ODM_DBG_LOUD, ("odm_TxPwrTrackSetPwr88E CH=%d\n", *(dm_odm->pChannel)));
-		PHY_SetTxPowerLevel8188E(dm_odm->Adapter, *(dm_odm->pChannel));
+		phy_set_tx_power_level(dm_odm->Adapter, *(dm_odm->pChannel));
 		dm_odm->BbSwingFlagOfdm = false;
 		dm_odm->BbSwingFlagCck	= false;
 	}
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
index 1aa5a56..85e05ae 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
@@ -223,40 +223,22 @@ static void phy_power_index_check(struct adapter *adapt, u8 channel,
 	hal_data->CurrentBW4024GTxPwrIdx = bw40_pwr[0];
 }
 
-/*-----------------------------------------------------------------------------
- * Function:    SetTxPowerLevel8190()
- *
- * Overview:    This function is export to "HalCommon" moudule
- *			We must consider RF path later!!!!!!!
- *
- * Input:       struct adapter *Adapter
- *			u8		channel
- *
- * Output:      NONE
- *
- * Return:      NONE
- *	2008/11/04	MHC		We remove EEPROM_93C56.
- *						We need to move CCX relative code to independet file.
- *	2009/01/21	MHC		Support new EEPROM format from SD3 requirement.
- *
- *---------------------------------------------------------------------------*/
-void
-PHY_SetTxPowerLevel8188E(
-		struct adapter *Adapter,
-		u8 channel
-	)
+void phy_set_tx_power_level(struct adapter *adapt, u8 channel)
 {
-	u8 cckPowerLevel[MAX_TX_COUNT] = {0};
-	u8 ofdmPowerLevel[MAX_TX_COUNT] = {0};/*  [0]:RF-A, [1]:RF-B */
-	u8 BW20PowerLevel[MAX_TX_COUNT] = {0};
-	u8 BW40PowerLevel[MAX_TX_COUNT] = {0};
+	u8 cck_pwr[MAX_TX_COUNT] = {0};
+	u8 ofdm_pwr[MAX_TX_COUNT] = {0};/*  [0]:RF-A, [1]:RF-B */
+	u8 bw20_pwr[MAX_TX_COUNT] = {0};
+	u8 bw40_pwr[MAX_TX_COUNT] = {0};
 
-	get_tx_power_index(Adapter, channel, &cckPowerLevel[0], &ofdmPowerLevel[0], &BW20PowerLevel[0], &BW40PowerLevel[0]);
+	get_tx_power_index(adapt, channel, &cck_pwr[0], &ofdm_pwr[0],
+			   &bw20_pwr[0], &bw40_pwr[0]);
 
-	phy_power_index_check(Adapter, channel, &cckPowerLevel[0], &ofdmPowerLevel[0], &BW20PowerLevel[0], &BW40PowerLevel[0]);
+	phy_power_index_check(adapt, channel, &cck_pwr[0], &ofdm_pwr[0],
+			      &bw20_pwr[0], &bw40_pwr[0]);
 
-	rtl8188e_PHY_RF6052SetCckTxPower(Adapter, &cckPowerLevel[0]);
-	rtl8188e_PHY_RF6052SetOFDMTxPower(Adapter, &ofdmPowerLevel[0], &BW20PowerLevel[0], &BW40PowerLevel[0], channel);
+	rtl8188e_PHY_RF6052SetCckTxPower(adapt, &cck_pwr[0]);
+	rtl8188e_PHY_RF6052SetOFDMTxPower(adapt, &ofdm_pwr[0], &bw20_pwr[0],
+					  &bw40_pwr[0], channel);
 }
 
 static void phy_set_bw_mode_callback(struct adapter *adapt)
@@ -376,7 +358,7 @@ static void phy_sw_chnl_callback(struct adapter *adapt, u8 channel)
 	if (adapt->bNotifyChannelChange)
 		DBG_88E("[%s] ch = %d\n", __func__, channel);
 
-	PHY_SetTxPowerLevel8188E(adapt, channel);
+	phy_set_tx_power_level(adapt, channel);
 
 	param1 = RF_CHNLBW;
 	param2 = channel;
diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/rtl8188eu/hal/usb_halinit.c
index 968707e..f56cbdf 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -829,7 +829,7 @@ HAL_INIT_PROFILE_TAG(HAL_INIT_STAGES_INIT_SECURITY);
 
 HAL_INIT_PROFILE_TAG(HAL_INIT_STAGES_MISC11);
 	/*  2010/12/17 MH We need to set TX power according to EFUSE content at first. */
-	PHY_SetTxPowerLevel8188E(Adapter, haldata->CurrentChannel);
+	phy_set_tx_power_level(Adapter, haldata->CurrentChannel);
 
 /*  Move by Neo for USB SS to below setp */
 /* _RfPowerSave(Adapter); */
diff --git a/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h b/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
index 94f9bf0..1835933 100644
--- a/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
+++ b/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
@@ -204,7 +204,6 @@ void rtl8192c_PHY_GetHWRegOriginalValue(struct adapter *adapter);
 
 /*  BB TX Power R/W */
 void PHY_GetTxPowerLevel8188E(struct adapter *adapter, u32 *powerlevel);
-void PHY_SetTxPowerLevel8188E(struct adapter *adapter, u8 channel);
 
 void PHY_ScanOperationBackup8188E(struct adapter *Adapter, u8 Operation);
 
diff --git a/drivers/staging/rtl8188eu/include/phy.h b/drivers/staging/rtl8188eu/include/phy.h
index 4905479..853d1e3 100644
--- a/drivers/staging/rtl8188eu/include/phy.h
+++ b/drivers/staging/rtl8188eu/include/phy.h
@@ -8,3 +8,5 @@ u32 phy_query_rf_reg(struct adapter *adapt, enum rf_radio_path rf_path,
 		     u32 reg_addr, u32 bit_mask);
 void phy_set_rf_reg(struct adapter *adapt, enum rf_radio_path rf_path,
 		    u32 reg_addr, u32 bit_mask, u32 data);
+
+void phy_set_tx_power_level(struct adapter *adapt, u8 channel);
-- 
1.7.10.4

