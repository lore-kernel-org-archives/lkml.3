Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab3FDQ7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 12:59:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48283 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756744Ab3FDQ5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:57:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 17/75] mac80211: fix AP-mode frame matching
Date: Tue,  4 Jun 2013 09:55:01 -0700
Message-Id: <1370364959-9475-18-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 2b9ccd4e4308272e5aec614b77c5385e7ec2ec90 upstream.

In AP mode, ignore frames with mis-matched BSSID that aren't
multicast or sent to the correct destination. This fixes
reporting public action frames to userspace multiple times
on multiple virtual AP interfaces.

Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/rx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 580704e..bed1b09 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2950,6 +2950,9 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 			 * and location updates. Note that mac80211
 			 * itself never looks at these frames.
 			 */
+			if (!multicast &&
+			    !ether_addr_equal(sdata->vif.addr, hdr->addr1))
+				return 0;
 			if (ieee80211_is_public_action(hdr, skb->len))
 				return 1;
 			if (!ieee80211_is_beacon(hdr->frame_control))
-- 
1.8.1.2

