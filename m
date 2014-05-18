Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbaERPXQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:23:16 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:58085 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbaERPXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:23:12 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 12/28] staging: rtl8188eu: Remove unused funtion phy_TxPwrIdxToDbm()
Date: Sun, 18 May 2014 20:49:05 +0530
Message-Id: <1400426361-19596-13-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
References: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c |   34 -----------------------
 1 file changed, 34 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
index 099345f..a7872c8 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
@@ -631,40 +631,6 @@ int PHY_RFConfig8188E(struct adapter *Adapter)
 	return rtStatus;
 }
 
-/*  */
-/*	Description: */
-/*		Map Tx power index into dBm according to */
-/*		current HW model, for example, RF and PA, and */
-/*		current wireless mode. */
-/*	By Bruce, 2008-01-29. */
-/*  */
-static int phy_TxPwrIdxToDbm(struct adapter *Adapter, enum wireless_mode WirelessMode, u8 TxPwrIdx)
-{
-	int				Offset = 0;
-	int				PwrOutDbm = 0;
-
-	/*  */
-	/*  Tested by MP, we found that CCK Index 0 equals to -7dbm, OFDM legacy equals to -8dbm. */
-	/*  Note: */
-	/*	The mapping may be different by different NICs. Do not use this formula for what needs accurate result. */
-	/*  By Bruce, 2008-01-29. */
-	/*  */
-	switch (WirelessMode) {
-	case WIRELESS_MODE_B:
-		Offset = -7;
-		break;
-	case WIRELESS_MODE_G:
-	case WIRELESS_MODE_N_24G:
-	default:
-		Offset = -8;
-		break;
-	}
-
-	PwrOutDbm = TxPwrIdx / 2 + Offset; /*  Discard the decimal part. */
-
-	return PwrOutDbm;
-}
-
 static void getTxPowerIndex88E(struct adapter *Adapter, u8 channel, u8 *cckPowerLevel,
 			       u8 *ofdmPowerLevel, u8 *BW20PowerLevel,
 			       u8 *BW40PowerLevel)
-- 
1.7.10.4

