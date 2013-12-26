Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab3LZLlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 06:41:31 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:4063 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab3LZLl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 06:41:29 -0500
Message-ID: <52BC15D1.1020104@huawei.com>
Date: Thu, 26 Dec 2013 19:41:05 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Karsten Keil <isdn@linux-pingi.de>, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3.5 12/19] isdn: slight optimization of addr compare
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.199]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use possibly more efficient ether_addr_equal
instead of memcmp.

Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 drivers/isdn/i4l/isdn_net.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_net.c b/drivers/isdn/i4l/isdn_net.c
index 8b98d53..d9aebbc 100644
--- a/drivers/isdn/i4l/isdn_net.c
+++ b/drivers/isdn/i4l/isdn_net.c
@@ -1371,7 +1371,7 @@ isdn_net_type_trans(struct sk_buff *skb, struct net_device *dev)
 	eth = eth_hdr(skb);
 
 	if (*eth->h_dest & 1) {
-		if (memcmp(eth->h_dest, dev->broadcast, ETH_ALEN) == 0)
+		if (ether_addr_equal(eth->h_dest, dev->broadcast))
 			skb->pkt_type = PACKET_BROADCAST;
 		else
 			skb->pkt_type = PACKET_MULTICAST;
@@ -1382,7 +1382,7 @@ isdn_net_type_trans(struct sk_buff *skb, struct net_device *dev)
 	 */
 
 	else if (dev->flags & (IFF_PROMISC /*| IFF_ALLMULTI*/)) {
-		if (memcmp(eth->h_dest, dev->dev_addr, ETH_ALEN))
+		if (!ether_addr_equal(eth->h_dest, dev->dev_addr))
 			skb->pkt_type = PACKET_OTHERHOST;
 	}
 	if (ntohs(eth->h_proto) >= ETH_P_802_3_MIN)
-- 
1.8.0


