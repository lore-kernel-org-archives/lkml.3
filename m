Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925AbaBNVvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:51:20 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:39425 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbaBNVvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:51:19 -0500
From: Levente Kurusa <levex@linux.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>
Cc: Levente Kurusa <levex@linux.com>
Subject: [PATCH] [RFC] staging: rtl8821ae: fix invalid bit mask on MSR_AP check
Date: Fri, 14 Feb 2014 22:50:23 +0100
Message-Id: <1392414623-4369-1-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since MSR_AP is 0x3, ANDing it with 0xFC will never be true.
Add a NOT operation to 0xFC so that we will AND with the last
three bits which will result in a possibility that the condition
will succeed.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 Hi,

 This might not be the real solution since it is also possible that
 the particular condition never really happens. I seek comments
 so that I can post the proper patch.

 Thanks!
 
 drivers/staging/rtl8821ae/rtl8821ae/hw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8821ae/rtl8821ae/hw.c b/drivers/staging/rtl8821ae/rtl8821ae/hw.c
index 5ed7a11..f204b31 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/hw.c
+++ b/drivers/staging/rtl8821ae/rtl8821ae/hw.c
@@ -1622,7 +1622,7 @@ static int _rtl8821ae_set_media_status(struct ieee80211_hw *hw,
 
 	rtl_write_byte(rtlpriv, (MSR), bt_msr);
 	rtlpriv->cfg->ops->led_control(hw, ledaction);
-	if ((bt_msr & 0xfc) == MSR_AP)
+	if ((bt_msr & ~0xfc) == MSR_AP)
 		rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x00);
 	else
 		rtl_write_byte(rtlpriv, REG_BCNTCFG + 1, 0x66);
-- 
1.7.9.5

