Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760810AbaCUB3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:29:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36454 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760238AbaCUADW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.13 023/149] mac80211: send control port protocol frames to the VO queue
Date: Thu, 20 Mar 2014 17:03:06 -0700
Message-Id: <20140321000437.755511688@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 1bf4bbb4024dcdab5e57634dd8ae1072d42a53ac upstream.

Improves reliability of wifi connections with WPA, since authentication
frames are prioritized over normal traffic and also typically exempt
from aggregation.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/wme.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -153,6 +153,11 @@ u16 ieee80211_select_queue(struct ieee80
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


