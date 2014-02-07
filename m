Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbaBGNMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:12:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41623 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbaBGLsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:48:43 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 049/233] rtlwifi: rtl8192c: Add new definitions in the dm_common header
Date: Fri,  7 Feb 2014 11:44:28 +0000
Message-Id: <1391773652-25214-50-git-send-email-luis.henriques@canonical.com>
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

commit c908c74e005de780fddbe8cb6fcd44803f5d4b74 upstream.

Changes in the gain-control mechanism will require some changes in the header.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h
index 518e208..4f232a0 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h
@@ -91,6 +91,17 @@
 #define TX_POWER_NEAR_FIELD_THRESH_LVL2		74
 #define TX_POWER_NEAR_FIELD_THRESH_LVL1		67
 
+#define DYNAMIC_FUNC_DISABLE			0x0
+#define DYNAMIC_FUNC_DIG			BIT(0)
+#define DYNAMIC_FUNC_HP				BIT(1)
+#define DYNAMIC_FUNC_SS				BIT(2) /*Tx Power Tracking*/
+#define DYNAMIC_FUNC_BT				BIT(3)
+#define DYNAMIC_FUNC_ANT_DIV			BIT(4)
+
+#define	RSSI_CCK				0
+#define	RSSI_OFDM				1
+#define	RSSI_DEFAULT				2
+
 struct swat_t {
 	u8 failure_cnt;
 	u8 try_flag;
@@ -167,5 +178,8 @@ void rtl92c_phy_lc_calibrate(struct ieee80211_hw *hw);
 void rtl92c_phy_iq_calibrate(struct ieee80211_hw *hw, bool recovery);
 void rtl92c_dm_dynamic_txpower(struct ieee80211_hw *hw);
 void rtl92c_dm_bt_coexist(struct ieee80211_hw *hw);
+void dm_savepowerindex(struct ieee80211_hw *hw);
+void dm_writepowerindex(struct ieee80211_hw *hw, u8 value);
+void dm_restorepowerindex(struct ieee80211_hw *hw);
 
 #endif
-- 
1.8.3.2

