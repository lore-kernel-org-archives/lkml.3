Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbaCKNH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:07:28 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:37840 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaCKNFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:05:24 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Subject: [PATCH 1/5] cfg80211: Add attributes describing prohibited channel bandwidth
Date: Tue, 11 Mar 2014 14:05:10 +0100
Message-Id: <1394543114-6700-2-git-send-email-rostislav.lisovy@fel.cvut.cz>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1394543114-6700-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
References: <1394543114-6700-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since there are channels which have only 10 or 5 MHz bandwidth,
we have to keep track about this information (and be able to
report it via netlink to userspace).

Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
---
 include/net/cfg80211.h       | 6 ++++++
 include/uapi/linux/nl80211.h | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b1f84b0..f5ecd6c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -109,6 +109,10 @@ enum ieee80211_band {
  *	channel as the control or any of the secondary channels.
  *	This may be due to the driver or due to regulatory bandwidth
  *	restrictions.
+ * @IEEE80211_CHAN_NO_20MHZ: 20 MHz bandwidth is not permitted
+ *     on this channel.
+ * @IEEE80211_CHAN_NO_10MHZ: 10 MHz bandwidth is not permitted
+ *     on this channel.
  */
 enum ieee80211_channel_flags {
 	IEEE80211_CHAN_DISABLED		= 1<<0,
@@ -120,6 +124,8 @@ enum ieee80211_channel_flags {
 	IEEE80211_CHAN_NO_OFDM		= 1<<6,
 	IEEE80211_CHAN_NO_80MHZ		= 1<<7,
 	IEEE80211_CHAN_NO_160MHZ	= 1<<8,
+	IEEE80211_CHAN_NO_20MHZ		= 1<<9,
+	IEEE80211_CHAN_NO_10MHZ		= 1<<10,
 };
 
 #define IEEE80211_CHAN_NO_HT40 \
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 91054fd..0748026 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2304,6 +2304,10 @@ enum nl80211_band_attr {
  * @NL80211_FREQUENCY_ATTR_NO_160MHZ: any 160 MHz (but not 80+80) channel
  *	using this channel as the primary or any of the secondary channels
  *	isn't possible
+ * @NL80211_FREQUENCY_ATTR_NO_20MHZ: 20 MHz operation is not allowed
+ *     on this channel in current regulatory domain.
+ * @NL80211_FREQUENCY_ATTR_NO_10MHZ: 10 MHz operation is not allowed
+ *     on this channel in current regulatory domain.
  * @NL80211_FREQUENCY_ATTR_MAX: highest frequency attribute number
  *	currently defined
  * @__NL80211_FREQUENCY_ATTR_AFTER_LAST: internal use
@@ -2322,6 +2326,8 @@ enum nl80211_frequency_attr {
 	NL80211_FREQUENCY_ATTR_NO_HT40_PLUS,
 	NL80211_FREQUENCY_ATTR_NO_80MHZ,
 	NL80211_FREQUENCY_ATTR_NO_160MHZ,
+	NL80211_FREQUENCY_ATTR_NO_20MHZ,
+	NL80211_FREQUENCY_ATTR_NO_10MHZ,
 
 	/* keep last */
 	__NL80211_FREQUENCY_ATTR_AFTER_LAST,
-- 
1.8.5.1

