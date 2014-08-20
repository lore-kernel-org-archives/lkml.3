Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbaHTIxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 04:53:39 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:60335 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaHTIxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 04:53:37 -0400
From: Hoang Tran <hoangtran.gwr@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Sachin Kamat <sachin.kamat@linaro.org>
Cc: Hoang Tran <hoangtran.gwr@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8821ae: fix sparse warning for static declarations in rtl8821ae/stats.c
Date: Wed, 20 Aug 2014 16:53:22 +0800
Message-Id: <1408524802-27441-1-git-send-email-hoangtran.gwr@gmail.com>
X-Mailer: git-send-email 2.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following sparse warnings in rtl8821ae/stats.c

drivers/staging/rtl8821ae/stats.c:62:6: warning: symbol 'rtl_translate_todbm' was not declared. Should it be static?
drivers/staging/rtl8821ae/stats.c:101:6: warning: symbol 'rtl_process_ui_rssi' was not declared. Should it be static?

Signed-off-by: Hoang Tran <hoangtran.gwr@gmail.com>
---
 drivers/staging/rtl8821ae/stats.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8821ae/stats.c b/drivers/staging/rtl8821ae/stats.c
index 4d383d1..fdbde43 100644
--- a/drivers/staging/rtl8821ae/stats.c
+++ b/drivers/staging/rtl8821ae/stats.c
@@ -59,7 +59,7 @@ u8 rtl_evm_db_to_percentage(char value)
 }
 //EXPORT_SYMBOL(rtl_evm_db_to_percentage);
 
-long rtl_translate_todbm(struct ieee80211_hw *hw,
+static long rtl_translate_todbm(struct ieee80211_hw *hw,
 			 u8 signal_strength_index)
 {
 	long signal_power;
@@ -98,7 +98,8 @@ long rtl_signal_scale_mapping(struct ieee80211_hw *hw, long currsig)
 }
 //EXPORT_SYMBOL(rtl_signal_scale_mapping);
 
-void rtl_process_ui_rssi(struct ieee80211_hw *hw, struct rtl_stats *pstatus)
+static void rtl_process_ui_rssi(struct ieee80211_hw *hw,
+				struct rtl_stats *pstatus)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
-- 
2.0.2

