Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbaEPWRS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 18:17:18 -0400
Received: from ns3094689.ip-91-121-202.eu ([91.121.202.112]:51809 "EHLO
	ns3094689.ip-91-121-202.eu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753151AbaEPWRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 18:17:17 -0400
From: Denis Pithon <denis.pithon@gmail.com>
To: gregkh@linuxfoundation.org, tklauser@distanz.ch
Cc: himangi774@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] staging/wlan-ng: compare using ether_addr_equal_unaligned
Date: Sat, 17 May 2014 00:14:50 +0200
Message-Id: <1400278492-1673-2-git-send-email-denis.pithon@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20140516072653.GA14932@distanz.ch>
References: <20140516072653.GA14932@distanz.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced generic memcmp() with dedicated ether_addr_equal_unaligned()
call. I did not find any clue of u16 alignment for both addresses.

Signed-off-by: Denis Pithon <denis.pithon@gmail.com>
---
 drivers/staging/wlan-ng/p80211netdev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
index 64dd935..13fe068 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -263,7 +263,8 @@ static int p80211_convert_to_ether(wlandevice_t *wlandev, struct sk_buff *skb)
 	/* perform mcast filtering */
 	if (wlandev->netdev->flags & IFF_ALLMULTI) {
 		/* allow my local address through */
-		if (memcmp(hdr->a1, wlandev->netdev->dev_addr, ETH_ALEN) != 0) {
+		if (!ether_addr_equal_unaligned(wlandev->netdev->dev_addr,
+						hdr->a1)) {
 			/* but reject anything else that isn't multicast */
 			if (!(hdr->a1[0] & 0x01))
 				return CONV_TO_ETHER_SKIPPED;
-- 
1.9.0

