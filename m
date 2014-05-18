Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaERPWo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:22:44 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36206 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbaERPWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:22:43 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 10/28] staging:rtl8188eu: Remove unused function phy_DbmToTxPwrIdx()
Date: Sun, 18 May 2014 20:49:03 +0530
Message-Id: <1400426361-19596-11-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
References: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c |   44 -----------------------
 1 file changed, 44 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
index 7cc7f44..16f46c3 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
@@ -633,50 +633,6 @@ int PHY_RFConfig8188E(struct adapter *Adapter)
 
 /*  */
 /*	Description: */
-/*		Map dBm into Tx power index according to */
-/*		current HW model, for example, RF and PA, and */
-/*		current wireless mode. */
-/*	By Bruce, 2008-01-29. */
-/*  */
-static	u8 phy_DbmToTxPwrIdx(struct adapter *Adapter, enum wireless_mode WirelessMode, int PowerInDbm)
-{
-	u8 TxPwrIdx = 0;
-	int				Offset = 0;
-
-
-	/*  */
-	/*  Tested by MP, we found that CCK Index 0 equals to 8dbm, OFDM legacy equals to */
-	/*  3dbm, and OFDM HT equals to 0dbm respectively. */
-	/*  Note: */
-	/*	The mapping may be different by different NICs. Do not use this formula for what needs accurate result. */
-	/*  By Bruce, 2008-01-29. */
-	/*  */
-	switch (WirelessMode) {
-	case WIRELESS_MODE_B:
-		Offset = -7;
-		break;
-
-	case WIRELESS_MODE_G:
-	case WIRELESS_MODE_N_24G:
-	default:
-		Offset = -8;
-		break;
-	}
-
-	if ((PowerInDbm - Offset) > 0)
-		TxPwrIdx = (u8)((PowerInDbm - Offset) * 2);
-	else
-		TxPwrIdx = 0;
-
-	/*  Tx Power Index is too large. */
-	if (TxPwrIdx > MAX_TXPWR_IDX_NMODE_92S)
-		TxPwrIdx = MAX_TXPWR_IDX_NMODE_92S;
-
-	return TxPwrIdx;
-}
-
-/*  */
-/*	Description: */
 /*		Map Tx power index into dBm according to */
 /*		current HW model, for example, RF and PA, and */
 /*		current wireless mode. */
-- 
1.7.10.4

