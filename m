Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbaBGNLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:11:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41643 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbaBGLst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:48:49 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 053/233] rtlwifi: rtl8192cu: Update the power index registers
Date: Fri,  7 Feb 2014 11:44:32 +0000
Message-Id: <1391773652-25214-54-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 9806eacf5de27ab01d680c5d75c92a3a89734e4f upstream.

This patch uses the newly introduced power index register routines.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/dm.c | 9 +++++++++
 drivers/net/wireless/rtlwifi/rtl8192cu/dm.h | 3 +++
 2 files changed, 12 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/dm.c b/drivers/net/wireless/rtlwifi/rtl8192cu/dm.c
index 16a0b9e..c16209a 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/dm.c
@@ -101,6 +101,15 @@ void rtl92cu_dm_dynamic_txpower(struct ieee80211_hw *hw)
 			 "PHY_SetTxPowerLevel8192S() Channel = %d\n",
 			 rtlphy->current_channel);
 		rtl92c_phy_set_txpower_level(hw, rtlphy->current_channel);
+		if (rtlpriv->dm.dynamic_txhighpower_lvl ==
+		    TXHIGHPWRLEVEL_NORMAL)
+			dm_restorepowerindex(hw);
+		else if (rtlpriv->dm.dynamic_txhighpower_lvl ==
+			 TXHIGHPWRLEVEL_LEVEL1)
+			dm_writepowerindex(hw, 0x14);
+		else if (rtlpriv->dm.dynamic_txhighpower_lvl ==
+			 TXHIGHPWRLEVEL_LEVEL2)
+			dm_writepowerindex(hw, 0x10);
 	}
 
 	rtlpriv->dm.last_dtp_lvl = rtlpriv->dm.dynamic_txhighpower_lvl;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/dm.h b/drivers/net/wireless/rtlwifi/rtl8192cu/dm.h
index d947e7d..fafa6ba 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/dm.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/dm.h
@@ -30,3 +30,6 @@
 #include "../rtl8192ce/dm.h"
 
 void rtl92cu_dm_dynamic_txpower(struct ieee80211_hw *hw);
+void dm_savepowerindex(struct ieee80211_hw *hw);
+void dm_writepowerindex(struct ieee80211_hw *hw, u8 value);
+void dm_restorepowerindex(struct ieee80211_hw *hw);
-- 
1.8.3.2

