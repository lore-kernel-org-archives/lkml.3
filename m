Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934975AbaBDVuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:50:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934382AbaBDVLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:11:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.13 035/140] rtlwifi: rtl8192cu: Update the power index registers
Date: Tue,  4 Feb 2014 13:10:22 -0800
Message-Id: <20140204211037.965303858@linuxfoundation.org>
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

commit 9806eacf5de27ab01d680c5d75c92a3a89734e4f upstream.

This patch uses the newly introduced power index register routines.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/rtl8192cu/dm.c |    9 +++++++++
 drivers/net/wireless/rtlwifi/rtl8192cu/dm.h |    3 +++
 2 files changed, 12 insertions(+)

--- a/drivers/net/wireless/rtlwifi/rtl8192cu/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/dm.c
@@ -101,6 +101,15 @@ void rtl92cu_dm_dynamic_txpower(struct i
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
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/dm.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/dm.h
@@ -30,3 +30,6 @@
 #include "../rtl8192ce/dm.h"
 
 void rtl92cu_dm_dynamic_txpower(struct ieee80211_hw *hw);
+void dm_savepowerindex(struct ieee80211_hw *hw);
+void dm_writepowerindex(struct ieee80211_hw *hw, u8 value);
+void dm_restorepowerindex(struct ieee80211_hw *hw);


