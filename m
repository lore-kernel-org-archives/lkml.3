Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbaLGT2d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 14:28:33 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:3226 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753507AbaLGT0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 14:26:54 -0500
X-IronPort-AV: E=Sophos;i="5.07,534,1413237600"; 
   d="scan'208";a="111932942"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: kernel-janitors@vger.kernel.org, linux@rasmusvillemoes.dk, joe@perches.com,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 16/20] rtlwifi: rtl8821ae: fix misspelling of current function in string
Date: Sun,  7 Dec 2014 20:20:58 +0100
Message-Id: <1417980062-25151-17-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a misspelled function name by %s and then __func__.

8821 was written as 8812.

This was done using Coccinelle, including the use of Levenshtein distance,
as proposed by Rasmus Villemoes.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The semantic patch is difficult to summarize, but is available in the cover
letter of this patch series.

 drivers/net/wireless/rtlwifi/rtl8821ae/dm.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/dm.c b/drivers/net/wireless/rtlwifi/rtl8821ae/dm.c
index 9be1061..ba30b0d 100644
--- a/drivers/net/wireless/rtlwifi/rtl8821ae/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8821ae/dm.c
@@ -2078,8 +2078,7 @@ void rtl8821ae_dm_txpwr_track_set_pwr(struct ieee80211_hw *hw,
 	if (rtldm->tx_rate != 0xFF)
 		tx_rate = rtl8821ae_hw_rate_to_mrate(hw, rtldm->tx_rate);
 
-	RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
-		 "===>rtl8812ae_dm_txpwr_track_set_pwr\n");
+	RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD, "===>%s\n", __func__);
 
 	if (tx_rate != 0xFF) { /* Mimic Modify High Rate BBSwing Limit.*/
 		/*CCK*/
@@ -2128,7 +2127,7 @@ void rtl8821ae_dm_txpwr_track_set_pwr(struct ieee80211_hw *hw,
 
 	if (method == BBSWING) {
 		RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
-			 "===>rtl8812ae_dm_txpwr_track_set_pwr\n");
+			 "===>%s\n", __func__);
 		if (rf_path == RF90_PATH_A) {
 			final_swing_idx[RF90_PATH_A] =
 				(rtldm->ofdm_index[RF90_PATH_A] >
@@ -2260,7 +2259,8 @@ void rtl8821ae_dm_txpower_tracking_callback_thermalmeter(
 	rtldm->txpower_trackinginit = true;
 
 	RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
-		 "===>rtl8812ae_dm_txpower_tracking_callback_thermalmeter,\n pDM_Odm->BbSwingIdxCckBase: %d,pDM_Odm->BbSwingIdxOfdmBase[A]:%d, pDM_Odm->DefaultOfdmIndex: %d\n",
+		 "===>%s,\n pDM_Odm->BbSwingIdxCckBase: %d,pDM_Odm->BbSwingIdxOfdmBase[A]:%d, pDM_Odm->DefaultOfdmIndex: %d\n",
+		 __func__,
 		 rtldm->swing_idx_cck_base,
 		 rtldm->swing_idx_ofdm_base[RF90_PATH_A],
 		 rtldm->default_ofdm_index);
@@ -2539,8 +2539,7 @@ void rtl8821ae_dm_txpower_tracking_callback_thermalmeter(
 		}
 	}
 
-	RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
-		 "<===rtl8812ae_dm_txpower_tracking_callback_thermalmeter\n");
+	RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD, "<===%s\n", __func__);
 }
 
 void rtl8821ae_dm_check_txpower_tracking_thermalmeter(struct ieee80211_hw *hw)
