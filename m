Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaFAPSa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 11:18:30 -0400
Received: from v22013021537510585.yourvserver.net ([37.221.193.202]:36974 "EHLO
	finitebox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbaFAPS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 11:18:29 -0400
From: Marcus Farkas <marcus.farkas@finitebox.com>
To: gregkh@linuxfoundation.org
Cc: larry.finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linville@tuxdriver.com
Subject: [PATCH] staging: rtl8821ae: fix sparse warning for static declarations
Date: Sun,  1 Jun 2014 17:18:26 +0200
Message-Id: <1401635906-4634-1-git-send-email-marcus.farkas@finitebox.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes the following sparse warnings in ps.c:
  - 702: warning: symbol 'rtl_p2p_noa_ie' was not declared. Should it be static?
  - 802: warning: symbol 'rtl_p2p_action_ie' was not declared. Should it be static?

Signed-off-by: Marcus Farkas <marcus.farkas@finitebox.com>
---
 drivers/staging/rtl8821ae/ps.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8821ae/ps.c b/drivers/staging/rtl8821ae/ps.c
index 5a9bbf0..db9a02f 100644
--- a/drivers/staging/rtl8821ae/ps.c
+++ b/drivers/staging/rtl8821ae/ps.c
@@ -699,7 +699,8 @@ void rtl_swlps_wq_callback(void *data)
 }
 
 
-void rtl_p2p_noa_ie(struct ieee80211_hw *hw, void *data, unsigned int len)
+static void rtl_p2p_noa_ie(struct ieee80211_hw *hw, void *data,
+			   unsigned int len)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct ieee80211_mgmt *mgmt = (void *)data;
@@ -799,7 +800,8 @@ void rtl_p2p_noa_ie(struct ieee80211_hw *hw, void *data, unsigned int len)
 	}
 }
 
-void rtl_p2p_action_ie(struct ieee80211_hw *hw, void *data, unsigned int len)
+static void rtl_p2p_action_ie(struct ieee80211_hw *hw, void *data,
+			      unsigned int len)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct ieee80211_mgmt *mgmt = (void *)data;
-- 
1.9.3

