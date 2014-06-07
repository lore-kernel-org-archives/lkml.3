Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbaFGRjk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 13:39:40 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:6687 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbaFGRjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 13:39:39 -0400
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Cc: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH linux-next] staging: r8192ee: Adapt flush function prototype
Date: Sat,  7 Jun 2014 19:39:19 +0200
Message-Id: <1402162759-17074-1-git-send-email-vincent.stehle@laposte.net>
X-Mailer: git-send-email 2.0.0.rc2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 77be2c54c5bd 'mac80211: add vif to flush call' modifies the flush
operation prototype. Update r8192ee function accordingly.

This fixes the following compilation warnings:

  drivers/staging/rtl8192ee/core.c: At top level:
  drivers/staging/rtl8192ee/core.c:1599:2: warning: initialization from incompatible pointer type [enabled by default]
    .flush = rtl_op_flush,
    ^
  drivers/staging/rtl8192ee/core.c:1599:2: warning: (near initialization for ‘rtl92e_ops.flush’) [enabled by default]

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
---

Hi,

Linux next gives a "heads up" that the flush function of staging driver r8192ee
needs to be adapted soon.

This can be seen with e.g. linux next-20140606 and x86 allmodconfig.

Also, r8192ee would benefit from the following patch:
http://www.spinics.net/lists/linux-driver-devel/msg47690.html

Best regards,

V.

 drivers/staging/rtl8192ee/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8192ee/core.c b/drivers/staging/rtl8192ee/core.c
index 76ea356..7f6accd 100644
--- a/drivers/staging/rtl8192ee/core.c
+++ b/drivers/staging/rtl8192ee/core.c
@@ -322,7 +322,7 @@ static void _rtl_add_wowlan_patterns(struct ieee80211_hw *hw,
 	struct rtl_mac *mac = &(rtlpriv->mac80211);
 	struct cfg80211_pkt_pattern *patterns = wow->patterns;
 	struct rtl_wow_pattern rtl_pattern;
-	u8 *pattern_os, *mask_os;
+	const u8 *pattern_os, *mask_os;
 	u8 mask[MAX_WOL_BIT_MASK_SIZE] = {0};
 	u8 content[MAX_WOL_PATTERN_SIZE] = {0};
 	u8 broadcast_addr[6] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
@@ -1561,7 +1561,7 @@ static void rtl_op_rfkill_poll(struct ieee80211_hw *hw)
  * before switch channle or power save, or tx buffer packet
  * maybe send after offchannel or rf sleep, this may cause
  * dis-association by AP */
-static void rtl_op_flush(struct ieee80211_hw *hw,
+static void rtl_op_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			 u32 queues, bool drop)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-- 
2.0.0.rc2

