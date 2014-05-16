Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbaEPWRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 18:17:20 -0400
Received: from ns3094689.ip-91-121-202.eu ([91.121.202.112]:51812 "EHLO
	ns3094689.ip-91-121-202.eu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754207AbaEPWRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 18:17:17 -0400
From: Denis Pithon <denis.pithon@gmail.com>
To: gregkh@linuxfoundation.org, tklauser@distanz.ch
Cc: himangi774@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] staging/wlan-ng: rearrange comments
Date: Sat, 17 May 2014 00:14:52 +0200
Message-Id: <1400278492-1673-4-git-send-email-denis.pithon@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20140516072653.GA14932@distanz.ch>
References: <20140516072653.GA14932@distanz.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gathered together comments in front of multicast filtering block.

Signed-off-by: Denis Pithon <denis.pithon@gmail.com>
---
 drivers/staging/wlan-ng/p80211netdev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
index 63edc83..21ca17e 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -260,12 +260,12 @@ static int p80211_convert_to_ether(wlandevice_t *wlandev, struct sk_buff *skb)
 	if (p80211_rx_typedrop(wlandev, hdr->fc))
 		return CONV_TO_ETHER_SKIPPED;
 
-	/* perform mcast filtering */
+	/* perform mcast filtering: allow my local address through but reject
+	 * anything else that isn't multicast
+	 */
 	if (wlandev->netdev->flags & IFF_ALLMULTI) {
-		/* allow my local address through */
 		if (!ether_addr_equal_unaligned(wlandev->netdev->dev_addr,
 						hdr->a1)) {
-			/* but reject anything else that isn't multicast */
 			if (!is_multicast_ether_addr(hdr->a1))
 				return CONV_TO_ETHER_SKIPPED;
 		}
-- 
1.9.0

