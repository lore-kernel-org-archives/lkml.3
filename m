Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054Ab3FDOXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:23:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46719 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628Ab3FDOH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:07:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 22/70] mac80211: fix AP-mode frame matching
Date: Tue,  4 Jun 2013 15:06:38 +0100
Message-Id: <1370354846-14213-23-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
References: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 2b9ccd4e4308272e5aec614b77c5385e7ec2ec90 upstream.

In AP mode, ignore frames with mis-matched BSSID that aren't
multicast or sent to the correct destination. This fixes
reporting public action frames to userspace multiple times
on multiple virtual AP interfaces.

Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/mac80211/rx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 064384c..1914a65 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2861,6 +2861,9 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 			 * and location updates. Note that mac80211
 			 * itself never looks at these frames.
 			 */
+			if (!multicast &&
+			    !ether_addr_equal(sdata->vif.addr, hdr->addr1))
+				return 0;
 			if (!(status->rx_flags & IEEE80211_RX_IN_SCAN) &&
 			    ieee80211_is_public_action(hdr, skb->len))
 				return 1;
-- 
1.8.1.2

