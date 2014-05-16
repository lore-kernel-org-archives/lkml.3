Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbaEPWRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 18:17:21 -0400
Received: from ns3094689.ip-91-121-202.eu ([91.121.202.112]:51810 "EHLO
	ns3094689.ip-91-121-202.eu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755550AbaEPWRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 18:17:17 -0400
From: Denis Pithon <denis.pithon@gmail.com>
To: gregkh@linuxfoundation.org, tklauser@distanz.ch
Cc: himangi774@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] staging/wlan-ng: multicast address checking
Date: Sat, 17 May 2014 00:14:51 +0200
Message-Id: <1400278492-1673-3-git-send-email-denis.pithon@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20140516072653.GA14932@distanz.ch>
References: <20140516072653.GA14932@distanz.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used is_multicast_ether_addr() to perform the checking.

Signed-off-by: Denis Pithon <denis.pithon@gmail.com>
---
 drivers/staging/wlan-ng/p80211netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
index 13fe068..63edc83 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -266,7 +266,7 @@ static int p80211_convert_to_ether(wlandevice_t *wlandev, struct sk_buff *skb)
 		if (!ether_addr_equal_unaligned(wlandev->netdev->dev_addr,
 						hdr->a1)) {
 			/* but reject anything else that isn't multicast */
-			if (!(hdr->a1[0] & 0x01))
+			if (!is_multicast_ether_addr(hdr->a1))
 				return CONV_TO_ETHER_SKIPPED;
 		}
 	}
-- 
1.9.0

