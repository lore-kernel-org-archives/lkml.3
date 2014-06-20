Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030259AbaFTUml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:42:41 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:38321 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030238AbaFTUmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:42:37 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <trivial@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] drivers/staging/rtl8821ae/rtl8821ae: Remove dead code
Date: Fri, 20 Jun 2014 22:42:22 +0200
Message-Id: <1403296942-18717-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is all #if 0'ed out, and it contains some rather weird stuff
(post-increment of a bool, for example). Nuke it.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/staging/rtl8821ae/rtl8821ae/hal_btc.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/staging/rtl8821ae/rtl8821ae/hal_btc.c b/drivers/staging/rtl8821ae/rtl8821ae/hal_btc.c
index 7b1d113..25e751b 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/hal_btc.c
+++ b/drivers/staging/rtl8821ae/rtl8821ae/hal_btc.c
@@ -1706,20 +1706,6 @@ void rtl8821ae_dm_bt_inq_page_monitor(struct ieee80211_hw *hw)
 			rtlpcipriv->btcoexist.current_state &=~ BT_COEX_STATE_BT_INQ_PAGE;
 		}
 	}
-
-#if 0
-	if (hal_coex_8821ae.b_c2h_bt_inquiry_page) {
-		hal_coex_8821ae.b_c2h_bt_inquiry_page++;
-		// bt inquiry or page is started.
-	} if(hal_coex_8821ae.b_c2h_bt_inquiry_page) {
-		rtlpcipriv->btcoexist.current_state |= BT_COEX_STATE_BT_INQ_PAGE;
-		if(hal_coex_8821ae.bt_inquiry_page_cnt >= 4)
-			hal_coex_8821ae.bt_inquiry_page_cnt = 0;
-		hal_coex_8821ae.bt_inquiry_page_cnt++;
-	} else {
-		rtlpcipriv->btcoexist.current_state &=~ BT_COEX_STATE_BT_INQ_PAGE;
-	}
-#endif
 }
 
 void rtl8821ae_dm_bt_reset_action_profile_state(struct ieee80211_hw *hw)
-- 
1.9.2

