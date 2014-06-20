Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966473AbaFTT4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:56:46 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:39142 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbaFTT4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:56:45 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Kosina <trivial@kernel.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] trivial: drivers/staging/rtl8821ae/rtl8821ae: Fix closing brace followed by if
Date: Fri, 20 Jun 2014 21:56:35 +0200
Message-Id: <1403294195-18209-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All of the code is #if 0'd out, and the change just replaces a
space with a newline, so this obviously doesn't change anything.

However, the code is highly suspect: The b_c2h_bt_inquiry_page member
has type bool, and applying the ++ operator to a bool is equivalent to
setting it true (using -- is equivalent to flipping it).

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/staging/rtl8821ae/rtl8821ae/hal_btc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8821ae/rtl8821ae/hal_btc.c b/drivers/staging/rtl8821ae/rtl8821ae/hal_btc.c
index 7b1d113..b4c68f0 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/hal_btc.c
+++ b/drivers/staging/rtl8821ae/rtl8821ae/hal_btc.c
@@ -1711,7 +1711,8 @@ void rtl8821ae_dm_bt_inq_page_monitor(struct ieee80211_hw *hw)
 	if (hal_coex_8821ae.b_c2h_bt_inquiry_page) {
 		hal_coex_8821ae.b_c2h_bt_inquiry_page++;
 		// bt inquiry or page is started.
-	} if(hal_coex_8821ae.b_c2h_bt_inquiry_page) {
+	}
+	if(hal_coex_8821ae.b_c2h_bt_inquiry_page) {
 		rtlpcipriv->btcoexist.current_state |= BT_COEX_STATE_BT_INQ_PAGE;
 		if(hal_coex_8821ae.bt_inquiry_page_cnt >= 4)
 			hal_coex_8821ae.bt_inquiry_page_cnt = 0;
-- 
1.9.2

