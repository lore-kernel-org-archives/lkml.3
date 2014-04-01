Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaDAQQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:16:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44752 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbaDAQQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:16:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 32/86] mac80211: fix association to 20/40 MHz VHT networks
Date: Tue,  1 Apr 2014 09:07:45 -0700
Message-Id: <1396368519-12728-33-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit cb664981607a6b5b3d670ad57bbda893b2528d96 upstream.

When a VHT network uses 20 or 40 MHz as per the HT operation
information, the channel center frequency segment 0 field in
the VHT operation information is reserved, so ignore it.

This fixes association with such networks when the AP puts 0
into the field, previously we'd disconnect due to an invalid
channel with the message
wlan0: AP VHT information is invalid, disable VHT

Fixes: f2d9d270c15ae ("mac80211: support VHT association")
Reported-by: Tim Nelson <tim.l.nelson@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/mlme.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a67fe0f..e586c89 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3359,6 +3359,7 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 	switch (vht_oper->chan_width) {
 	case IEEE80211_VHT_CHANWIDTH_USE_HT:
 		vht_chandef.width = chandef->width;
+		vht_chandef.center_freq1 = chandef->center_freq1;
 		break;
 	case IEEE80211_VHT_CHANWIDTH_80MHZ:
 		vht_chandef.width = NL80211_CHAN_WIDTH_80;
-- 
1.8.3.2

