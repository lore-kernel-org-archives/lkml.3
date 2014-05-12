Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369AbaELRvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 13:51:18 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:30250 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751368AbaELRvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 13:51:16 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: An8KABkJcVNbsHLF/2dsb2JhbABZgwasagkBBQGaG4EaF3SCUxMcIxiBAiQTiEUBz0aFVoh8hEcBA48liiIBiwSIA4M4Ow
Date: Mon, 12 May 2014 19:51:14 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] net/wireless/util.c: replace memcpy by ether_addr_copy
Message-Id: <20140512195114.5fca94e46368be5daaa9e56b@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/wireless/util.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index e5872ff..ab23b95 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -381,8 +381,8 @@ int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
 	 *   1     0   BSSID SA    DA    n/a
 	 *   1     1   RA    TA    DA    SA
 	 */
-	memcpy(dst, ieee80211_get_DA(hdr), ETH_ALEN);
-	memcpy(src, ieee80211_get_SA(hdr), ETH_ALEN);
+	ether_addr_copy(dst, ieee80211_get_DA(hdr));
+	ether_addr_copy(src, ieee80211_get_SA(hdr));
 
 	switch (hdr->frame_control &
 		cpu_to_le16(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
@@ -458,8 +458,8 @@ int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
 		/* remove RFC1042 or Bridge-Tunnel encapsulation and
 		 * replace EtherType */
 		skb_pull(skb, hdrlen + 6);
-		memcpy(skb_push(skb, ETH_ALEN), src, ETH_ALEN);
-		memcpy(skb_push(skb, ETH_ALEN), dst, ETH_ALEN);
+		ether_addr_copy(skb_push(skb, ETH_ALEN), src);
+		ether_addr_copy(skb_push(skb, ETH_ALEN), dst);
 	} else {
 		struct ethhdr *ehdr;
 		__be16 len;
@@ -467,8 +467,8 @@ int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
 		skb_pull(skb, hdrlen);
 		len = htons(skb->len);
 		ehdr = (struct ethhdr *) skb_push(skb, sizeof(struct ethhdr));
-		memcpy(ehdr->h_dest, dst, ETH_ALEN);
-		memcpy(ehdr->h_source, src, ETH_ALEN);
+		ether_addr_copy(ehdr->h_dest, dst);
+		ether_addr_copy(ehdr->h_source, src);
 		ehdr->h_proto = len;
 	}
 	return 0;
@@ -503,25 +503,25 @@ int ieee80211_data_from_8023(struct sk_buff *skb, const u8 *addr,
 	case NL80211_IFTYPE_P2P_GO:
 		fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS);
 		/* DA BSSID SA */
-		memcpy(hdr.addr1, skb->data, ETH_ALEN);
-		memcpy(hdr.addr2, addr, ETH_ALEN);
-		memcpy(hdr.addr3, skb->data + ETH_ALEN, ETH_ALEN);
+		ether_addr_copy(hdr.addr1, skb->data);
+		ether_addr_copy(hdr.addr2, addr);
+		ether_addr_copy(hdr.addr3, skb->data + ETH_ALEN);
 		hdrlen = 24;
 		break;
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_P2P_CLIENT:
 		fc |= cpu_to_le16(IEEE80211_FCTL_TODS);
 		/* BSSID SA DA */
-		memcpy(hdr.addr1, bssid, ETH_ALEN);
-		memcpy(hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
-		memcpy(hdr.addr3, skb->data, ETH_ALEN);
+		ether_addr_copy(hdr.addr1, bssid);
+		ether_addr_copy(hdr.addr2, skb->data + ETH_ALEN);
+		ether_addr_copy(hdr.addr3, skb->data);
 		hdrlen = 24;
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		/* DA SA BSSID */
-		memcpy(hdr.addr1, skb->data, ETH_ALEN);
-		memcpy(hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
-		memcpy(hdr.addr3, bssid, ETH_ALEN);
+		ether_addr_copy(hdr.addr1, skb->data);
+		ether_addr_copy(hdr.addr2, skb->data + ETH_ALEN);
+		ether_addr_copy(hdr.addr3, bssid);
 		hdrlen = 24;
 		break;
 	default:
@@ -622,8 +622,8 @@ void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 		unsigned int subframe_len = sizeof(struct ethhdr) + ntohs(len);
 
 		remaining = skb->len;
-		memcpy(dst, eth->h_dest, ETH_ALEN);
-		memcpy(src, eth->h_source, ETH_ALEN);
+		ether_addr_copy(dst, eth->h_dest);
+		ether_addr_copy(src, eth->h_source);
 
 		padding = (4 - subframe_len) & 0x3;
 		/* the last MSDU has no padding */
@@ -669,13 +669,13 @@ void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 			/* remove RFC1042 or Bridge-Tunnel
 			 * encapsulation and replace EtherType */
 			skb_pull(frame, 6);
-			memcpy(skb_push(frame, ETH_ALEN), src, ETH_ALEN);
-			memcpy(skb_push(frame, ETH_ALEN), dst, ETH_ALEN);
+			ether_addr_copy(skb_push(frame, ETH_ALEN), src);
+			ether_addr_copy(skb_push(frame, ETH_ALEN), dst);
 		} else {
 			memcpy(skb_push(frame, sizeof(__be16)), &len,
 				sizeof(__be16));
-			memcpy(skb_push(frame, ETH_ALEN), src, ETH_ALEN);
-			memcpy(skb_push(frame, ETH_ALEN), dst, ETH_ALEN);
+			ether_addr_copy(skb_push(frame, ETH_ALEN), src);
+			ether_addr_copy(skb_push(frame, ETH_ALEN), dst);
 		}
 		__skb_queue_tail(list, frame);
 	}
-- 
1.9.1
