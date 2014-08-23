Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbaHWOVE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 10:21:04 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:49062 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbaHWOVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 10:21:01 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 15/20] staging: rtl8188eu: Rework function PHY_SetBWMode8188E()
Date: Sat, 23 Aug 2014 19:48:36 +0530
Message-Id: <1408803521-13715-15-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
References: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CamelCase variables and function name.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c  |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c    |   33 ++++++--------------
 drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h |    4 ---
 drivers/staging/rtl8188eu/include/phy.h            |    3 ++
 4 files changed, 13 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
index cc2988c..f41e83d 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_hal_init.c
@@ -221,7 +221,7 @@ void rtl8188e_set_hal_ops(struct hal_ops *pHalFunc)
 
 	pHalFunc->read_chip_version = &rtl8188e_read_chip_version;
 
-	pHalFunc->set_bwmode_handler = &PHY_SetBWMode8188E;
+	pHalFunc->set_bwmode_handler = &phy_set_bw_mode;
 	pHalFunc->set_channel_handler = &PHY_SwChnl8188E;
 
 	pHalFunc->hal_dm_watchdog = &rtl8188e_HalDmWatchDog;
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
index 85e05ae..b1ff892 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
@@ -319,34 +319,19 @@ static void phy_set_bw_mode_callback(struct adapter *adapt)
 	}
 }
 
- /*-----------------------------------------------------------------------------
- * Function:   SetBWMode8190Pci()
- *
- * Overview:  This function is export to "HalCommon" moudule
- *
- * Input:		struct adapter *Adapter
- *			enum ht_channel_width Bandwidth	20M or 40M
- *
- * Output:      NONE
- *
- * Return:      NONE
- *
- * Note:		We do not take j mode into consideration now
- *---------------------------------------------------------------------------*/
-void PHY_SetBWMode8188E(struct adapter *Adapter, enum ht_channel_width Bandwidth,	/*  20M or 40M */
-			unsigned char	Offset)		/*  Upper, Lower, or Don't care */
+void phy_set_bw_mode(struct adapter *adapt, enum ht_channel_width bandwidth,
+		     unsigned char offset)
 {
-	struct hal_data_8188e	*pHalData = GET_HAL_DATA(Adapter);
-	enum ht_channel_width tmpBW = pHalData->CurrentChannelBW;
-
-	pHalData->CurrentChannelBW = Bandwidth;
+	struct hal_data_8188e	*hal_data = GET_HAL_DATA(adapt);
+	enum ht_channel_width tmp_bw = hal_data->CurrentChannelBW;
 
-	pHalData->nCur40MhzPrimeSC = Offset;
+	hal_data->CurrentChannelBW = bandwidth;
+	hal_data->nCur40MhzPrimeSC = offset;
 
-	if ((!Adapter->bDriverStopped) && (!Adapter->bSurpriseRemoved))
-		phy_set_bw_mode_callback(Adapter);
+	if ((!adapt->bDriverStopped) && (!adapt->bSurpriseRemoved))
+		phy_set_bw_mode_callback(adapt);
 	else
-		pHalData->CurrentChannelBW = tmpBW;
+		hal_data->CurrentChannelBW = tmp_bw;
 }
 
 static void phy_sw_chnl_callback(struct adapter *adapt, u8 channel)
diff --git a/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h b/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
index 1835933..f8bc63c 100644
--- a/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
+++ b/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
@@ -207,10 +207,6 @@ void PHY_GetTxPowerLevel8188E(struct adapter *adapter, u32 *powerlevel);
 
 void PHY_ScanOperationBackup8188E(struct adapter *Adapter, u8 Operation);
 
-/*  Switch bandwidth for 8192S */
-void PHY_SetBWMode8188E(struct adapter *adapter,
-			enum ht_channel_width chnlwidth, unsigned char offset);
-
 /*  channel switch related funciton */
 void PHY_SwChnl8188E(struct adapter *adapter, u8 channel);
 /*  Call after initialization */
diff --git a/drivers/staging/rtl8188eu/include/phy.h b/drivers/staging/rtl8188eu/include/phy.h
index 853d1e3..5b93987 100644
--- a/drivers/staging/rtl8188eu/include/phy.h
+++ b/drivers/staging/rtl8188eu/include/phy.h
@@ -10,3 +10,6 @@ void phy_set_rf_reg(struct adapter *adapt, enum rf_radio_path rf_path,
 		    u32 reg_addr, u32 bit_mask, u32 data);
 
 void phy_set_tx_power_level(struct adapter *adapt, u8 channel);
+
+void phy_set_bw_mode(struct adapter *adapt, enum ht_channel_width bandwidth,
+		     unsigned char offset);
-- 
1.7.10.4

