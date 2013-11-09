Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052Ab3KIHSe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:18:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33246 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932648Ab3KIGvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:51:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bruno Randolf <br1@einfach.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.11 22/94] cfg80211: fix warning when using WEXT for IBSS
Date: Fri,  8 Nov 2013 22:51:28 -0800
Message-Id: <20131109065205.803433886@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bruno Randolf <br1@einfach.org>

commit f478f33a93f9353dcd1fe55445343d76b1c3f84a upstream.

Fix kernel warning when using WEXT for configuring ad-hoc mode,
e.g.  "iwconfig wlan0 essid test channel 1"

WARNING: at net/wireless/chan.c:373 cfg80211_chandef_usable+0x50/0x21c [cfg80211]()

The warning is caused by an uninitialized variable center_freq1.

Signed-off-by: Bruno Randolf <br1@einfach.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/ibss.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -263,6 +263,8 @@ int cfg80211_ibss_wext_join(struct cfg80
 				if (chan->flags & IEEE80211_CHAN_DISABLED)
 					continue;
 				wdev->wext.ibss.chandef.chan = chan;
+				wdev->wext.ibss.chandef.center_freq1 =
+					chan->center_freq;
 				break;
 			}
 
@@ -347,6 +349,7 @@ int cfg80211_ibss_wext_siwfreq(struct ne
 	if (chan) {
 		wdev->wext.ibss.chandef.chan = chan;
 		wdev->wext.ibss.chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
+		wdev->wext.ibss.chandef.center_freq1 = freq;
 		wdev->wext.ibss.channel_fixed = true;
 	} else {
 		/* cfg80211_ibss_wext_join will pick one if needed */


