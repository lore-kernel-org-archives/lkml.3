Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbaERPW6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:22:58 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:58160 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbaERPW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:22:57 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 11/28] staging: rtl8188eu: Remove unused funtion PHY_GetTxPowerLevel8188E()
Date: Sun, 18 May 2014 20:49:04 +0530
Message-Id: <1400426361-19596-12-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
References: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c |   46 -----------------------
 1 file changed, 46 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
index 16f46c3..099345f 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
@@ -665,52 +665,6 @@ static int phy_TxPwrIdxToDbm(struct adapter *Adapter, enum wireless_mode Wireles
 	return PwrOutDbm;
 }
 
-
-/*-----------------------------------------------------------------------------
- * Function:    GetTxPowerLevel8190()
- *
- * Overview:    This function is export to "common" moudule
- *
- * Input:       struct adapter *Adapter
- *			psByte			Power Level
- *
- * Output:      NONE
- *
- * Return:      NONE
- *
- *---------------------------------------------------------------------------*/
-void PHY_GetTxPowerLevel8188E(struct adapter *Adapter, u32 *powerlevel)
-{
-	struct hal_data_8188e	*pHalData = GET_HAL_DATA(Adapter);
-	u8 TxPwrLevel = 0;
-	int			TxPwrDbm;
-
-	/*  */
-	/*  Because the Tx power indexes are different, we report the maximum of them to */
-	/*  meet the CCX TPC request. By Bruce, 2008-01-31. */
-	/*  */
-
-	/*  CCK */
-	TxPwrLevel = pHalData->CurrentCckTxPwrIdx;
-	TxPwrDbm = phy_TxPwrIdxToDbm(Adapter, WIRELESS_MODE_B, TxPwrLevel);
-
-	/*  Legacy OFDM */
-	TxPwrLevel = pHalData->CurrentOfdm24GTxPwrIdx + pHalData->LegacyHTTxPowerDiff;
-
-	/*  Compare with Legacy OFDM Tx power. */
-	if (phy_TxPwrIdxToDbm(Adapter, WIRELESS_MODE_G, TxPwrLevel) > TxPwrDbm)
-		TxPwrDbm = phy_TxPwrIdxToDbm(Adapter, WIRELESS_MODE_G, TxPwrLevel);
-
-	/*  HT OFDM */
-	TxPwrLevel = pHalData->CurrentOfdm24GTxPwrIdx;
-
-	/*  Compare with HT OFDM Tx power. */
-	if (phy_TxPwrIdxToDbm(Adapter, WIRELESS_MODE_N_24G, TxPwrLevel) > TxPwrDbm)
-		TxPwrDbm = phy_TxPwrIdxToDbm(Adapter, WIRELESS_MODE_N_24G, TxPwrLevel);
-
-	*powerlevel = TxPwrDbm;
-}
-
 static void getTxPowerIndex88E(struct adapter *Adapter, u8 channel, u8 *cckPowerLevel,
 			       u8 *ofdmPowerLevel, u8 *BW20PowerLevel,
 			       u8 *BW40PowerLevel)
-- 
1.7.10.4

