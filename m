Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbaICBBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 21:01:05 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:34033 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaICBBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 21:01:01 -0400
From: An Ha <zero579911@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        An Ha <zero579911@gmail.com>
Subject: [PATCH 4/5] Staging: rtl8821ae: hal_bt_coexist: fix curly brace placement
Date: Tue,  2 Sep 2014 21:00:45 -0400
Message-Id: <1409706046-23616-4-git-send-email-zero579911@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409706046-23616-1-git-send-email-zero579911@gmail.com>
References: <1409706046-23616-1-git-send-email-zero579911@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style issue where the if statement unnecessarily uses curly
braces for one line statements and where the else conditional statement
should follow the closing curly brace '}'. Also, the open curly brace
'{' should be on the same line as the if statement.

Signed-off-by: An Ha <zero579911@gmail.com>
---
 .../staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c    | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c b/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
index 13cc5ba..d587072 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
+++ b/drivers/staging/rtl8821ae/rtl8821ae/hal_bt_coexist.c
@@ -78,17 +78,15 @@ struct rtl_phy *rtlphy = &(rtlpriv->phy);
 if (rtlpriv->link_info.b_busytraffic) {
 	rtlpcipriv->btcoexist.current_state &= ~BT_COEX_STATE_WIFI_IDLE;
 
-	if (rtlpriv->link_info.b_tx_busy_traffic) {
+	if (rtlpriv->link_info.b_tx_busy_traffic)
 		rtlpcipriv->btcoexist.current_state |= BT_COEX_STATE_WIFI_UPLINK;
-	} else {
+	else
 		rtlpcipriv->btcoexist.current_state &= ~BT_COEX_STATE_WIFI_UPLINK;
-	}
 
-	if (rtlpriv->link_info.b_rx_busy_traffic) {
+	if (rtlpriv->link_info.b_rx_busy_traffic)
 		rtlpcipriv->btcoexist.current_state |= BT_COEX_STATE_WIFI_DOWNLINK;
-	} else {
+	else
 		rtlpcipriv->btcoexist.current_state &= ~BT_COEX_STATE_WIFI_DOWNLINK;
-	}
 } else {
 	rtlpcipriv->btcoexist.current_state |= BT_COEX_STATE_WIFI_IDLE;
 	rtlpcipriv->btcoexist.current_state &= ~BT_COEX_STATE_WIFI_UPLINK;
@@ -111,12 +109,11 @@ if (rtlpriv->mac80211.mode == WIRELESS_MODE_G
 	}
 }
 
-if (bt_operation_on) {
+if (bt_operation_on)
 	rtlpcipriv->btcoexist.current_state |= BT_COEX_STATE_BT30;
-} else {
+else
 	rtlpcipriv->btcoexist.current_state &= ~BT_COEX_STATE_BT30;
 }
-}
 
 
 u8 rtl8821ae_dm_bt_check_coex_rssi_state1(struct ieee80211_hw *hw,
@@ -254,8 +251,7 @@ u8 rtl8821ae_dm_bt_check_coex_rssi_state(struct ieee80211_hw *hw,
 					("[DM][BT], RSSI state stay at High\n"));
 			}
 		}
-	}
-	else if (level_num == 3) {
+	} else if (level_num == 3) {
 		if (rssi_thresh > rssi_thresh1) {
 			RT_TRACE(COMP_BT_COEXIST, DBG_TRACE,
 				("[DM][BT], RSSI thresh error!!\n"));
@@ -292,8 +288,7 @@ u8 rtl8821ae_dm_bt_check_coex_rssi_state(struct ieee80211_hw *hw,
 					&= ~BT_COEX_STATE_WIFI_RSSI_MEDIUM;
 				RT_TRACE(COMP_BT_COEXIST, DBG_TRACE,
 					("[DM][BT], RSSI state switch to High\n"));
-			} else if (undecoratedsmoothed_pwdb < rssi_thresh)
-			{
+			} else if (undecoratedsmoothed_pwdb < rssi_thresh) {
 				bt_rssi_state = BT_RSSI_STATE_LOW;
 				rtlpcipriv->btcoexist.current_state
 					|= BT_COEX_STATE_WIFI_RSSI_LOW;
-- 
2.1.0

