Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933854AbaCTT1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 15:27:53 -0400
Received: from lekensteyn.nl ([178.21.112.251]:37585 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759779AbaCTT1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 15:27:46 -0400
From: Peter Wu <peter@lekensteyn.nl>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        John W Linville <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chaoming_Li <chaoming_li@realsil.com.cn>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, lekensteyn@gmail.com
Subject: [PATCH v2 1/3] rtlwifi: remove unused allow_all_destaddr functions
Date: Thu, 20 Mar 2014 19:52:22 +0100
Message-Id: <1395341544-21464-2-git-send-email-peter@lekensteyn.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1395341544-21464-1-git-send-email-peter@lekensteyn.nl>
References: <1395341544-21464-1-git-send-email-peter@lekensteyn.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unused as configure_filter takes care of setting/clearing RCR_AAP.

In commit "rtlwifi: rtl8723be: rtl8723com: Remove unused
allow_all_destaddr functions", Larry Finger removed allow_all_destaddr
from the struct. This commit removes the related function too.

Signed-off-by: Peter Wu <peter@lekensteyn.nl>
---
 - v2: removed functions for rtl8723be too, fix merge conflict due to
       a rename in the context of rtl8723ae.
---
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c | 20 --------------------
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.h |  2 --
 drivers/net/wireless/rtlwifi/rtl8188ee/sw.c |  1 -
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c | 21 ---------------------
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.h |  2 --
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c |  1 -
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c | 20 --------------------
 drivers/net/wireless/rtlwifi/rtl8192se/hw.h |  2 --
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c |  1 -
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c | 21 ---------------------
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.h |  2 --
 drivers/net/wireless/rtlwifi/rtl8723ae/sw.c |  1 -
 drivers/net/wireless/rtlwifi/rtl8723be/hw.c | 20 --------------------
 drivers/net/wireless/rtlwifi/rtl8723be/hw.h |  2 --
 drivers/net/wireless/rtlwifi/wifi.h         |  2 --
 15 files changed, 118 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
index bd2a26b..e655c65 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
@@ -2521,23 +2521,3 @@ void rtl88ee_suspend(struct ieee80211_hw *hw)
 void rtl88ee_resume(struct ieee80211_hw *hw)
 {
 }
-
-/* Turn on AAP (RCR:bit 0) for promicuous mode. */
-void rtl88ee_allow_all_destaddr(struct ieee80211_hw *hw,
-				bool allow_all_da, bool write_into_reg)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-
-	if (allow_all_da) /* Set BIT0 */
-		rtlpci->receive_config |= RCR_AAP;
-	 else /* Clear BIT0 */
-		rtlpci->receive_config &= ~RCR_AAP;
-
-	if (write_into_reg)
-		rtl_write_dword(rtlpriv, REG_RCR, rtlpci->receive_config);
-
-	RT_TRACE(rtlpriv, COMP_TURBO | COMP_INIT, DBG_LOUD,
-		 "receive_config = 0x%08X, write_into_reg =%d\n",
-		 rtlpci->receive_config, write_into_reg);
-}
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.h b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.h
index b4460a4..1850fde 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.h
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.h
@@ -61,8 +61,6 @@ void rtl8188ee_bt_reg_init(struct ieee80211_hw *hw);
 void rtl8188ee_bt_hw_init(struct ieee80211_hw *hw);
 void rtl88ee_suspend(struct ieee80211_hw *hw);
 void rtl88ee_resume(struct ieee80211_hw *hw);
-void rtl88ee_allow_all_destaddr(struct ieee80211_hw *hw,
-				bool allow_all_da, bool write_into_reg);
 void rtl88ee_fw_clk_off_timer_callback(unsigned long data);
 
 #endif
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/sw.c b/drivers/net/wireless/rtlwifi/rtl8188ee/sw.c
index 347af1e..41de6f3 100644
--- a/drivers/net/wireless/rtlwifi/rtl8188ee/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8188ee/sw.c
@@ -254,7 +254,6 @@ static struct rtl_hal_ops rtl8188ee_hal_ops = {
 	.enable_hw_sec = rtl88ee_enable_hw_security_config,
 	.set_key = rtl88ee_set_key,
 	.init_sw_leds = rtl88ee_init_sw_leds,
-	.allow_all_destaddr = rtl88ee_allow_all_destaddr,
 	.get_bbreg = rtl88e_phy_query_bb_reg,
 	.set_bbreg = rtl88e_phy_set_bb_reg,
 	.get_rfreg = rtl88e_phy_query_rf_reg,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
index 4ae51d5..e2ba368 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -2423,24 +2423,3 @@ void rtl92ce_suspend(struct ieee80211_hw *hw)
 void rtl92ce_resume(struct ieee80211_hw *hw)
 {
 }
-
-/* Turn on AAP (RCR:bit 0) for promicuous mode. */
-void rtl92ce_allow_all_destaddr(struct ieee80211_hw *hw,
-	bool allow_all_da, bool write_into_reg)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-
-	if (allow_all_da) {/* Set BIT0 */
-		rtlpci->receive_config |= RCR_AAP;
-	} else {/* Clear BIT0 */
-		rtlpci->receive_config &= ~RCR_AAP;
-	}
-
-	if (write_into_reg)
-		rtl_write_dword(rtlpriv, REG_RCR, rtlpci->receive_config);
-
-	RT_TRACE(rtlpriv, COMP_TURBO | COMP_INIT, DBG_LOUD,
-		 "receive_config=0x%08X, write_into_reg=%d\n",
-		 rtlpci->receive_config, write_into_reg);
-}
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.h b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.h
index 2d063b0..5533070 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.h
@@ -76,7 +76,5 @@ void rtl8192ce_bt_reg_init(struct ieee80211_hw *hw);
 void rtl8192ce_bt_hw_init(struct ieee80211_hw *hw);
 void rtl92ce_suspend(struct ieee80211_hw *hw);
 void rtl92ce_resume(struct ieee80211_hw *hw);
-void rtl92ce_allow_all_destaddr(struct ieee80211_hw *hw,
-				bool allow_all_da, bool write_into_reg);
 
 #endif
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
index b790320..12f21f4 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -229,7 +229,6 @@ static struct rtl_hal_ops rtl8192ce_hal_ops = {
 	.enable_hw_sec = rtl92ce_enable_hw_security_config,
 	.set_key = rtl92ce_set_key,
 	.init_sw_leds = rtl92ce_init_sw_leds,
-	.allow_all_destaddr = rtl92ce_allow_all_destaddr,
 	.get_bbreg = rtl92c_phy_query_bb_reg,
 	.set_bbreg = rtl92c_phy_set_bb_reg,
 	.set_rfreg = rtl92ce_phy_set_rf_reg,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
index 3015af1..52a9230 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
@@ -2546,23 +2546,3 @@ void rtl92se_resume(struct ieee80211_hw *hw)
 		pci_write_config_dword(rtlpci->pdev, 0x40,
 			val & 0xffff00ff);
 }
-
-/* Turn on AAP (RCR:bit 0) for promicuous mode. */
-void rtl92se_allow_all_destaddr(struct ieee80211_hw *hw,
-				bool allow_all_da, bool write_into_reg)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-
-	if (allow_all_da) /* Set BIT0 */
-		rtlpci->receive_config |= RCR_AAP;
-	else /* Clear BIT0 */
-		rtlpci->receive_config &= ~RCR_AAP;
-
-	if (write_into_reg)
-		rtl_write_dword(rtlpriv, RCR, rtlpci->receive_config);
-
-	RT_TRACE(rtlpriv, COMP_TURBO | COMP_INIT, DBG_LOUD,
-		 "receive_config=0x%08X, write_into_reg=%d\n",
-		 rtlpci->receive_config, write_into_reg);
-}
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/hw.h b/drivers/net/wireless/rtlwifi/rtl8192se/hw.h
index da48aa8..4cacee1 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/hw.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/hw.h
@@ -74,7 +74,5 @@ void rtl92se_set_key(struct ieee80211_hw *hw,
 		     u8 enc_algo, bool is_wepkey, bool clear_all);
 void rtl92se_suspend(struct ieee80211_hw *hw);
 void rtl92se_resume(struct ieee80211_hw *hw);
-void rtl92se_allow_all_destaddr(struct ieee80211_hw *hw,
-				bool allow_all_da, bool write_into_reg);
 
 #endif
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
index 2e8e6f8..1bff2a0 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
@@ -290,7 +290,6 @@ static struct rtl_hal_ops rtl8192se_hal_ops = {
 	.enable_hw_sec = rtl92se_enable_hw_security_config,
 	.set_key = rtl92se_set_key,
 	.init_sw_leds = rtl92se_init_sw_leds,
-	.allow_all_destaddr = rtl92se_allow_all_destaddr,
 	.get_bbreg = rtl92s_phy_query_bb_reg,
 	.set_bbreg = rtl92s_phy_set_bb_reg,
 	.get_rfreg = rtl92s_phy_query_rf_reg,
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c b/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
index f4c9852..2e27ae3 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
@@ -2390,24 +2390,3 @@ void rtl8723ae_suspend(struct ieee80211_hw *hw)
 void rtl8723ae_resume(struct ieee80211_hw *hw)
 {
 }
-
-/* Turn on AAP (RCR:bit 0) for promicuous mode. */
-void rtl8723ae_allow_all_destaddr(struct ieee80211_hw *hw,
-	bool allow_all_da, bool write_into_reg)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-
-	if (allow_all_da) /* Set BIT0 */
-		rtlpci->receive_config |= RCR_AAP;
-	else /* Clear BIT0 */
-		rtlpci->receive_config &= ~RCR_AAP;
-
-	if (write_into_reg)
-		rtl_write_dword(rtlpriv, REG_RCR, rtlpci->receive_config);
-
-
-	RT_TRACE(rtlpriv, COMP_TURBO | COMP_INIT, DBG_LOUD,
-		 "receive_config=0x%08X, write_into_reg=%d\n",
-		 rtlpci->receive_config, write_into_reg);
-}
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/hw.h b/drivers/net/wireless/rtlwifi/rtl8723ae/hw.h
index 6fa24f7..d3bc39f 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/hw.h
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/hw.h
@@ -67,7 +67,5 @@ void rtl8723ae_bt_reg_init(struct ieee80211_hw *hw);
 void rtl8723ae_bt_hw_init(struct ieee80211_hw *hw);
 void rtl8723ae_suspend(struct ieee80211_hw *hw);
 void rtl8723ae_resume(struct ieee80211_hw *hw);
-void rtl8723ae_allow_all_destaddr(struct ieee80211_hw *hw,
-				  bool allow_all_da, bool write_into_reg);
 
 #endif
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/sw.c b/drivers/net/wireless/rtlwifi/rtl8723ae/sw.c
index 1087a3b..73cba1e 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/sw.c
@@ -238,7 +238,6 @@ static struct rtl_hal_ops rtl8723ae_hal_ops = {
 	.enable_hw_sec = rtl8723ae_enable_hw_security_config,
 	.set_key = rtl8723ae_set_key,
 	.init_sw_leds = rtl8723ae_init_sw_leds,
-	.allow_all_destaddr = rtl8723ae_allow_all_destaddr,
 	.get_bbreg = rtl8723_phy_query_bb_reg,
 	.set_bbreg = rtl8723_phy_set_bb_reg,
 	.get_rfreg = rtl8723ae_phy_query_rf_reg,
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
index 7e70c71..6d8fe50 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723be/hw.c
@@ -2505,23 +2505,3 @@ void rtl8723be_suspend(struct ieee80211_hw *hw)
 void rtl8723be_resume(struct ieee80211_hw *hw)
 {
 }
-
-/* Turn on AAP (RCR:bit 0) for promicuous mode. */
-void rtl8723be_allow_all_destaddr(struct ieee80211_hw *hw, bool allow_all_da,
-				  bool write_into_reg)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
-
-	if (allow_all_da) /* Set BIT0 */
-		rtlpci->receive_config |= RCR_AAP;
-	else /* Clear BIT0 */
-		rtlpci->receive_config &= ~RCR_AAP;
-
-	if (write_into_reg)
-		rtl_write_dword(rtlpriv, REG_RCR, rtlpci->receive_config);
-
-	RT_TRACE(rtlpriv, COMP_TURBO | COMP_INIT, DBG_LOUD,
-		 "receive_config = 0x%08X, write_into_reg =%d\n",
-		 rtlpci->receive_config, write_into_reg);
-}
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/hw.h b/drivers/net/wireless/rtlwifi/rtl8723be/hw.h
index b7449a9..64c7551 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723be/hw.h
+++ b/drivers/net/wireless/rtlwifi/rtl8723be/hw.h
@@ -59,6 +59,4 @@ void rtl8723be_bt_reg_init(struct ieee80211_hw *hw);
 void rtl8723be_bt_hw_init(struct ieee80211_hw *hw);
 void rtl8723be_suspend(struct ieee80211_hw *hw);
 void rtl8723be_resume(struct ieee80211_hw *hw);
-void rtl8723be_allow_all_destaddr(struct ieee80211_hw *hw, bool allow_all_da,
-				  bool write_into_reg);
 #endif
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index 6965afd..903874c 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -1960,8 +1960,6 @@ struct rtl_hal_ops {
 			  u32 regaddr, u32 bitmask);
 	void (*set_rfreg) (struct ieee80211_hw *hw, enum radio_path rfpath,
 			   u32 regaddr, u32 bitmask, u32 data);
-	void (*allow_all_destaddr)(struct ieee80211_hw *hw,
-		bool allow_all_da, bool write_into_reg);
 	void (*linked_set_reg) (struct ieee80211_hw *hw);
 	void (*chk_switch_dmdp) (struct ieee80211_hw *hw);
 	void (*dualmac_easy_concurrent) (struct ieee80211_hw *hw);
-- 
1.9.1

