Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab3KHC3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:29:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34822 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584Ab3KHCVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:21:23 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bruno Randolf <br1@einfach.org>, Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 41/91] cfg80211: fix warning when using WEXT for IBSS
Date: Thu,  7 Nov 2013 18:14:56 -0800
Message-Id: <1383876946-2396-42-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bruno Randolf <br1@einfach.org>

commit f478f33a93f9353dcd1fe55445343d76b1c3f84a upstream.

Fix kernel warning when using WEXT for configuring ad-hoc mode,
e.g.  "iwconfig wlan0 essid test channel 1"

WARNING: at net/wireless/chan.c:373 cfg80211_chandef_usable+0x50/0x21c [cfg80211]()

The warning is caused by an uninitialized variable center_freq1.

Signed-off-by: Bruno Randolf <br1@einfach.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/wireless/ibss.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 9b9551e..ceef854 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -269,6 +269,8 @@ int cfg80211_ibss_wext_join(struct cfg80211_registered_device *rdev,
 				if (chan->flags & IEEE80211_CHAN_DISABLED)
 					continue;
 				wdev->wext.ibss.chandef.chan = chan;
+				wdev->wext.ibss.chandef.center_freq1 =
+					chan->center_freq;
 				break;
 			}
 
@@ -353,6 +355,7 @@ int cfg80211_ibss_wext_siwfreq(struct net_device *dev,
 	if (chan) {
 		wdev->wext.ibss.chandef.chan = chan;
 		wdev->wext.ibss.chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
+		wdev->wext.ibss.chandef.center_freq1 = freq;
 		wdev->wext.ibss.channel_fixed = true;
 	} else {
 		/* cfg80211_ibss_wext_join will pick one if needed */
-- 
1.8.1.2

