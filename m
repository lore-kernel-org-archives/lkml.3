Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab3L3Hlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 02:41:44 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:46368 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070Ab3L3Hlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 02:41:42 -0500
Message-ID: <52C123AD.9010908@huawei.com>
Date: Mon, 30 Dec 2013 15:41:33 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next v3 19/19] net: plip: slight optimization of addr
 compare
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.199]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use possibly more efficient ether_addr_equal_64bits
to instead of memcmp.

Cc: "David S. Miller" <davem@davemloft.net>
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 drivers/net/plip/plip.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/plip/plip.c b/drivers/net/plip/plip.c
index 7b4ff35..040b897 100644
--- a/drivers/net/plip/plip.c
+++ b/drivers/net/plip/plip.c
@@ -547,9 +547,9 @@ static __be16 plip_type_trans(struct sk_buff *skb, struct net_device *dev)
 	skb_pull(skb,dev->hard_header_len);
 	eth = eth_hdr(skb);
 
-	if(*eth->h_dest&1)
+	if(is_multicast_ether_addr(eth->h_dest))
 	{
-		if(memcmp(eth->h_dest,dev->broadcast, ETH_ALEN)==0)
+		if(ether_addr_equal_64bits(eth->h_dest, dev->broadcast))
 			skb->pkt_type=PACKET_BROADCAST;
 		else
 			skb->pkt_type=PACKET_MULTICAST;
-- 
1.6.0.2



