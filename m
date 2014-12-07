Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbaLGV5h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 16:57:37 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:56034 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbaLGV5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 16:57:35 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: wireless: rtlwifi: rtl8192de: fw.c:  Remove unused function
Date: Sun,  7 Dec 2014 23:00:13 +0100
Message-Id: <1417989613-18300-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function rtl92d_set_fw_pwrmode_cmd() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/net/wireless/rtlwifi/rtl8192de/fw.c |   17 -----------------
 drivers/net/wireless/rtlwifi/rtl8192de/fw.h |    1 -
 2 files changed, 18 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/fw.c b/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
index 2317707..62ef820 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
@@ -540,23 +540,6 @@ void rtl92d_fill_h2c_cmd(struct ieee80211_hw *hw,
 	return;
 }
 
-void rtl92d_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u8 u1_h2c_set_pwrmode[3] = { 0 };
-	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
-
-	RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD, "FW LPS mode = %d\n", mode);
-	SET_H2CCMD_PWRMODE_PARM_MODE(u1_h2c_set_pwrmode, mode);
-	SET_H2CCMD_PWRMODE_PARM_SMART_PS(u1_h2c_set_pwrmode, 1);
-	SET_H2CCMD_PWRMODE_PARM_BCN_PASS_TIME(u1_h2c_set_pwrmode,
-					      ppsc->reg_max_lps_awakeintvl);
-	RT_PRINT_DATA(rtlpriv, COMP_CMD, DBG_DMESG,
-		      "rtl92d_set_fw_rsvdpagepkt(): u1_h2c_set_pwrmode",
-		      u1_h2c_set_pwrmode, 3);
-	rtl92d_fill_h2c_cmd(hw, H2C_SETPWRMODE, 3, u1_h2c_set_pwrmode);
-}
-
 static bool _rtl92d_cmd_send_packet(struct ieee80211_hw *hw,
 				    struct sk_buff *skb)
 {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/fw.h b/drivers/net/wireless/rtlwifi/rtl8192de/fw.h
index a55a803..1646e7c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/fw.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/fw.h
@@ -136,7 +136,6 @@ int rtl92d_download_fw(struct ieee80211_hw *hw);
 void rtl92d_fill_h2c_cmd(struct ieee80211_hw *hw, u8 element_id,
 			 u32 cmd_len, u8 *p_cmdbuffer);
 void rtl92d_firmware_selfreset(struct ieee80211_hw *hw);
-void rtl92d_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode);
 void rtl92d_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished);
 void rtl92d_set_fw_joinbss_report_cmd(struct ieee80211_hw *hw, u8 mstatus);
 
-- 
1.7.10.4

