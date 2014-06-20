Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbaFTUVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:21:50 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:64472 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757159AbaFTUVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:21:49 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, Jiri Kosina <trivial@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: drivers/staging/rtl8821ae/rtl8821ae: Fix closing brace followed by if
Organization: D03
References: <1403294195-18209-1-git-send-email-linux@rasmusvillemoes.dk>
	<20140620200707.GA16329@kroah.com>
X-Hashcash: 1:20:140620:linux-kernel@vger.kernel.org::JADEu6dnbKAO6QCb:0000000000000000000000000000000000iaM
X-Hashcash: 1:20:140620:gregkh@linuxfoundation.org::NXWoTmab76efAqR7:000000000000000000000000000000000003nmx
X-Hashcash: 1:20:140620:devel@driverdev.osuosl.org::oMDzlCDp2rVqoqUd:0000000000000000000000000000000000057oE
X-Hashcash: 1:20:140620:trivial@kernel.org::9X01D9essZQaWr8I:0000000000000000000000000000000000000000000BUxd
Date: Fri, 20 Jun 2014 22:21:45 +0200
In-Reply-To: <20140620200707.GA16329@kroah.com> (Greg Kroah-Hartman's message
	of "Fri, 20 Jun 2014 13:07:07 -0700")
Message-ID: <87simz49ie.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Fri, Jun 20, 2014 at 09:56:35PM +0200, Rasmus Villemoes wrote:
>> All of the code is #if 0'd out, and the change just replaces a
>> space with a newline, so this obviously doesn't change anything.
>
> How about just deleting all the #if 0 code out entirely so no one has to
> worry about it anymore?

Fine by me. Like this?

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] drivers/staging/rtl8821ae/rtl8821ae: Remove dead code

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

