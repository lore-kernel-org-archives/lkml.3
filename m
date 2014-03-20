Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759774AbaCTT1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 15:27:44 -0400
Received: from lekensteyn.nl ([178.21.112.251]:56198 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759755AbaCTT1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 15:27:40 -0400
X-Greylist: delayed 2096 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Mar 2014 15:27:40 EDT
From: Peter Wu <peter@lekensteyn.nl>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        John W Linville <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chaoming_Li <chaoming_li@realsil.com.cn>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, lekensteyn@gmail.com
Subject: [PATCH 3/3] staging/rtl8821ae: remove unused allow_all_destaddr function
Date: Thu, 20 Mar 2014 19:52:24 +0100
Message-Id: <1395341544-21464-4-git-send-email-peter@lekensteyn.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1395341544-21464-1-git-send-email-peter@lekensteyn.nl>
References: <1395341544-21464-1-git-send-email-peter@lekensteyn.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to commit "rtlwifi: remove unused allow_all_destaddr functions",
this patch removes an unused function.

Unused as configure_filter takes care of setting/clearing RCR_AAP.

Signed-off-by: Peter Wu <peter@lekensteyn.nl>
---
 drivers/staging/rtl8821ae/rtl8821ae/hw.c | 22 ----------------------
 drivers/staging/rtl8821ae/rtl8821ae/hw.h |  3 ---
 drivers/staging/rtl8821ae/rtl8821ae/sw.c |  1 -
 drivers/staging/rtl8821ae/wifi.h         |  2 --
 4 files changed, 28 deletions(-)

diff --git a/drivers/staging/rtl8821ae/rtl8821ae/hw.c b/drivers/staging/rtl8821ae/rtl8821ae/hw.c
index e4dbf05..8ae4fae 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/hw.c
+++ b/drivers/staging/rtl8821ae/rtl8821ae/hw.c
@@ -3323,25 +3323,3 @@ void rtl8821ae_suspend(struct ieee80211_hw *hw)
 void rtl8821ae_resume(struct ieee80211_hw *hw)
 {
 }
-
-/* Turn on AAP (RCR:bit 0) for promicuous mode. */
-void rtl8821ae_allow_all_destaddr(struct ieee80211_hw *hw,
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
-	if(write_into_reg)
-		rtl_write_dword(rtlpriv, REG_RCR, rtlpci->receive_config);
-
-
-	RT_TRACE(COMP_TURBO | COMP_INIT, DBG_LOUD,
-		("receive_config=0x%08X, write_into_reg=%d\n",
-		rtlpci->receive_config, write_into_reg ));
-}
-
diff --git a/drivers/staging/rtl8821ae/rtl8821ae/hw.h b/drivers/staging/rtl8821ae/rtl8821ae/hw.h
index 4fb6bf0..f1d2949 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/hw.h
+++ b/drivers/staging/rtl8821ae/rtl8821ae/hw.h
@@ -67,9 +67,6 @@ void rtl8821ae_bt_reg_init(struct ieee80211_hw* hw);
 void rtl8821ae_bt_hw_init(struct ieee80211_hw* hw);
 void rtl8821ae_suspend(struct ieee80211_hw *hw);
 void rtl8821ae_resume(struct ieee80211_hw *hw);
-void rtl8821ae_allow_all_destaddr(struct ieee80211_hw *hw,
-										  bool allow_all_da,
-										  bool write_into_reg);
 void _rtl8821ae_stop_tx_beacon(struct ieee80211_hw *hw);
 void _rtl8821ae_resume_tx_beacon(struct ieee80211_hw *hw);
 #endif
diff --git a/drivers/staging/rtl8821ae/rtl8821ae/sw.c b/drivers/staging/rtl8821ae/rtl8821ae/sw.c
index 85a3474..25a8114 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/sw.c
+++ b/drivers/staging/rtl8821ae/rtl8821ae/sw.c
@@ -298,7 +298,6 @@ struct rtl_hal_ops rtl8821ae_hal_ops = {
 	.enable_hw_sec = rtl8821ae_enable_hw_security_config,
 	.set_key = rtl8821ae_set_key,
 	.init_sw_leds = rtl8821ae_init_sw_leds,
-	.allow_all_destaddr = rtl8821ae_allow_all_destaddr,
 	.get_bbreg = rtl8821ae_phy_query_bb_reg,
 	.set_bbreg = rtl8821ae_phy_set_bb_reg,
 	.get_rfreg = rtl8821ae_phy_query_rf_reg,
diff --git a/drivers/staging/rtl8821ae/wifi.h b/drivers/staging/rtl8821ae/wifi.h
index cfe88a1..871ff51 100644
--- a/drivers/staging/rtl8821ae/wifi.h
+++ b/drivers/staging/rtl8821ae/wifi.h
@@ -1840,8 +1840,6 @@ struct rtl_hal_ops {
 			  u32 regaddr, u32 bitmask);
 	void (*set_rfreg) (struct ieee80211_hw * hw, enum radio_path rfpath,
 			   u32 regaddr, u32 bitmask, u32 data);
-	void (*allow_all_destaddr)(struct ieee80211_hw *hw,
-		bool allow_all_da, bool write_into_reg);
 	void (*linked_set_reg) (struct ieee80211_hw * hw);
 	void (*check_switch_to_dmdp) (struct ieee80211_hw * hw);
 	void (*dualmac_easy_concurrent) (struct ieee80211_hw *hw);
-- 
1.9.1

