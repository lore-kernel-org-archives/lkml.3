Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbaDAQYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:24:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44669 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbaDAQQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:16:05 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>, Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 23/86] mac80211: send control port protocol frames to the VO queue
Date: Tue,  1 Apr 2014 09:07:36 -0700
Message-Id: <1396368519-12728-24-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 1bf4bbb4024dcdab5e57634dd8ae1072d42a53ac upstream.

Improves reliability of wifi connections with WPA, since authentication
frames are prioritized over normal traffic and also typically exempt
from aggregation.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/wme.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 906f00c..8fa9cc6 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -153,6 +153,11 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 		return IEEE80211_AC_BE;
 	}
 
+	if (skb->protocol == sdata->control_port_protocol) {
+		skb->priority = 7;
+		return ieee80211_downgrade_queue(sdata, skb);
+	}
+
 	/* use the data classifier to determine what 802.1d tag the
 	 * data frame has */
 	skb->priority = cfg80211_classify8021d(skb);
-- 
1.8.3.2

