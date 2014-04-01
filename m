Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbaDALQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:16:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42086 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaDALQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:16:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>, Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 005/144] mac80211: send control port protocol frames to the VO queue
Date: Tue,  1 Apr 2014 12:13:29 +0100
Message-Id: <1396350948-29910-6-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 1bf4bbb4024dcdab5e57634dd8ae1072d42a53ac upstream.

Improves reliability of wifi connections with WPA, since authentication
frames are prioritized over normal traffic and also typically exempt
from aggregation.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/mac80211/wme.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index afba19c..a282fdd 100644
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
1.9.1

