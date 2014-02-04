Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934460AbaBDVLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:11:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934375AbaBDVLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:11:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.13 032/140] rtlwifi: rtl8192c: Add new definitions in the dm_common header
Date: Tue,  4 Feb 2014 13:10:19 -0800
Message-Id: <20140204211037.884178861@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit c908c74e005de780fddbe8cb6fcd44803f5d4b74 upstream.

Changes in the gain-control mechanism will require some changes in the header.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

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
@@ -167,5 +178,8 @@ void rtl92c_phy_lc_calibrate(struct ieee
 void rtl92c_phy_iq_calibrate(struct ieee80211_hw *hw, bool recovery);
 void rtl92c_dm_dynamic_txpower(struct ieee80211_hw *hw);
 void rtl92c_dm_bt_coexist(struct ieee80211_hw *hw);
+void dm_savepowerindex(struct ieee80211_hw *hw);
+void dm_writepowerindex(struct ieee80211_hw *hw, u8 value);
+void dm_restorepowerindex(struct ieee80211_hw *hw);
 
 #endif


