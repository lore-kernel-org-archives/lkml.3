Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320AbaIFDUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 23:20:23 -0400
Received: from s87.loopia.se ([194.9.94.111]:11666 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbaIFDUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 23:20:20 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: linville@tuxdriver.com, larry.finger@lwfinger.net,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 1/1] rtlwifi: fix %d confusingly prefixed with 0x in format strings
Date: Fri,  5 Sep 2014 20:19:50 -0700
Message-Id: <1409973590-25352-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <20140825201255.GG1966@tuxdriver.com>
References: <20140825201255.GG1966@tuxdriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 drivers/net/wireless/rtlwifi/pci.c           | 6 +++---
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c | 8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 67d1ee6..74a8ba4 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -646,7 +646,7 @@ static void _rtl_pci_tx_isr(struct ieee80211_hw *hw, int prio)
 				== 2) {
 
 			RT_TRACE(rtlpriv, COMP_ERR, DBG_LOUD,
-				 "more desc left, wake skb_queue@%d, ring->idx = %d, skb_queue_len = 0x%d\n",
+				 "more desc left, wake skb_queue@%d, ring->idx = %d, skb_queue_len = 0x%x\n",
 				 prio, ring->idx,
 				 skb_queue_len(&ring->queue));
 
@@ -1469,7 +1469,7 @@ static int rtl_pci_tx(struct ieee80211_hw *hw,
 
 		if ((own == 1) && (hw_queue != BEACON_QUEUE)) {
 			RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
-				 "No more TX desc@%d, ring->idx = %d, idx = %d, skb_queue_len = 0x%d\n",
+				 "No more TX desc@%d, ring->idx = %d, idx = %d, skb_queue_len = 0x%x\n",
 				 hw_queue, ring->idx, idx,
 				 skb_queue_len(&ring->queue));
 
@@ -1511,7 +1511,7 @@ static int rtl_pci_tx(struct ieee80211_hw *hw,
 	if ((ring->entries - skb_queue_len(&ring->queue)) < 2 &&
 	    hw_queue != BEACON_QUEUE) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_LOUD,
-			 "less desc left, stop skb_queue@%d, ring->idx = %d, idx = %d, skb_queue_len = 0x%d\n",
+			 "less desc left, stop skb_queue@%d, ring->idx = %d, idx = %d, skb_queue_len = 0x%x\n",
 			 hw_queue, ring->idx, idx,
 			 skb_queue_len(&ring->queue));
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
index 592125a..1961b8e 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
@@ -677,7 +677,7 @@ static void _rtl92d_store_pwrindex_diffrate_offset(struct ieee80211_hw *hw,
 
 	rtlphy->mcs_offset[rtlphy->pwrgroup_cnt][index] = data;
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-		 "MCSTxPowerLevelOriginalOffset[%d][%d] = 0x%ulx\n",
+		 "MCSTxPowerLevelOriginalOffset[%d][%d] = 0x%x\n",
 		 rtlphy->pwrgroup_cnt, index,
 		 rtlphy->mcs_offset[rtlphy->pwrgroup_cnt][index]);
 	if (index == 13)
@@ -2531,7 +2531,7 @@ static void _rtl92d_phy_reload_lck_setting(struct ieee80211_hw *hw,
 	if (rtlpriv->rtlhal.current_bandtype == BAND_ON_5G) {/* Path-A for 5G */
 		u4tmp = curveindex_5g[channel-1];
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,
-			"ver 1 set RF-A, 5G,	0x28 = 0x%ulx !!\n", u4tmp);
+			"ver 1 set RF-A, 5G,	0x28 = 0x%x !!\n", u4tmp);
 		if (rtlpriv->rtlhal.macphymode == DUALMAC_DUALPHY &&
 			rtlpriv->rtlhal.interfaceindex == 1) {
 			bneed_powerdown_radio =
@@ -2550,7 +2550,7 @@ static void _rtl92d_phy_reload_lck_setting(struct ieee80211_hw *hw,
 	} else if (rtlpriv->rtlhal.current_bandtype == BAND_ON_2_4G) {
 		u4tmp = curveindex_2g[channel-1];
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,
-			"ver 3 set RF-B, 2G, 0x28 = 0x%ulx !!\n", u4tmp);
+			"ver 3 set RF-B, 2G, 0x28 = 0x%x !!\n", u4tmp);
 		if (rtlpriv->rtlhal.macphymode == DUALMAC_DUALPHY &&
 			rtlpriv->rtlhal.interfaceindex == 0) {
 			bneed_powerdown_radio =
@@ -2562,7 +2562,7 @@ static void _rtl92d_phy_reload_lck_setting(struct ieee80211_hw *hw,
 		}
 		rtl_set_rfreg(hw, erfpath, RF_SYN_G4, 0x3f800, u4tmp);
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,
-			"ver 3 set RF-B, 2G, 0x28 = 0x%ulx !!\n",
+			"ver 3 set RF-B, 2G, 0x28 = 0x%x !!\n",
 			rtl_get_rfreg(hw,  erfpath, RF_SYN_G4, 0x3f800));
 		if (bneed_powerdown_radio)
 			_rtl92d_phy_restore_rf_env(hw, erfpath, &u4regvalue);
-- 
2.1.0.rc2.206.gedb03e5

