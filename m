Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaERPWX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:22:23 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:49422 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbaERPWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:22:21 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 09/28] staging: rtl8188eu: Remove unused function PHY_UpdateTxPowerDbm8188E()
Date: Sun, 18 May 2014 20:49:02 +0530
Message-Id: <1400426361-19596-10-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
References: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c    |   37 --------------------
 drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h |    1 -
 2 files changed, 38 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
index 79f86db..7cc7f44 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
@@ -878,43 +878,6 @@ PHY_SetTxPowerLevel8188E(
 	rtl8188e_PHY_RF6052SetOFDMTxPower(Adapter, &ofdmPowerLevel[0], &BW20PowerLevel[0], &BW40PowerLevel[0], channel);
 }
 
-/*  */
-/*	Description: */
-/*		Update transmit power level of all channel supported. */
-/*  */
-/*	TODO: */
-/*		A mode. */
-/*	By Bruce, 2008-02-04. */
-/*  */
-bool
-PHY_UpdateTxPowerDbm8188E(
-		struct adapter *Adapter,
-		int		powerInDbm
-	)
-{
-	struct hal_data_8188e	*pHalData = GET_HAL_DATA(Adapter);
-	u8 idx;
-	u8 rf_path;
-
-	/*  TODO: A mode Tx power. */
-	u8 CckTxPwrIdx = phy_DbmToTxPwrIdx(Adapter, WIRELESS_MODE_B, powerInDbm);
-	u8 OfdmTxPwrIdx = phy_DbmToTxPwrIdx(Adapter, WIRELESS_MODE_N_24G, powerInDbm);
-
-	if (OfdmTxPwrIdx - pHalData->LegacyHTTxPowerDiff > 0)
-		OfdmTxPwrIdx -= pHalData->LegacyHTTxPowerDiff;
-	else
-		OfdmTxPwrIdx = 0;
-
-	for (idx = 0; idx < 14; idx++) {
-		for (rf_path = 0; rf_path < 2; rf_path++) {
-			pHalData->TxPwrLevelCck[rf_path][idx] = CckTxPwrIdx;
-			pHalData->TxPwrLevelHT40_1S[rf_path][idx] =
-			pHalData->TxPwrLevelHT40_2S[rf_path][idx] = OfdmTxPwrIdx;
-		}
-	}
-	return true;
-}
-
 void
 PHY_ScanOperationBackup8188E(
 		struct adapter *Adapter,
diff --git a/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h b/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
index 25cae81..260ea6b 100644
--- a/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
+++ b/drivers/staging/rtl8188eu/include/Hal8188EPhyCfg.h
@@ -224,7 +224,6 @@ void rtl8192c_PHY_GetHWRegOriginalValue(struct adapter *adapter);
 /*  BB TX Power R/W */
 void PHY_GetTxPowerLevel8188E(struct adapter *adapter, u32 *powerlevel);
 void PHY_SetTxPowerLevel8188E(struct adapter *adapter, u8 channel);
-bool PHY_UpdateTxPowerDbm8188E(struct adapter *adapter, int power);
 
 void PHY_ScanOperationBackup8188E(struct adapter *Adapter, u8 Operation);
 
-- 
1.7.10.4

