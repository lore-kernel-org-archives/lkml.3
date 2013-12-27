Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab3L0Gwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 01:52:36 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:52865 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab3L0Gta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 01:49:30 -0500
Message-ID: <52BD22DE.1010708@huawei.com>
Date: Fri, 27 Dec 2013 14:49:02 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 15/20] net: seeq: slight optimization of addr compare
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.199]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use possibly more efficient ether_addr_equal
to instead of memcmp.

Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 drivers/net/ethernet/seeq/sgiseeq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/seeq/sgiseeq.c b/drivers/net/ethernet/seeq/sgiseeq.c
index c765718..ced5b13 100644
--- a/drivers/net/ethernet/seeq/sgiseeq.c
+++ b/drivers/net/ethernet/seeq/sgiseeq.c
@@ -356,7 +356,7 @@ static inline void sgiseeq_rx(struct net_device *dev, struct sgiseeq_private *sp
 		if (pkt_status & SEEQ_RSTAT_FIG) {
 			/* Packet is OK. */
 			/* We don't want to receive our own packets */
-			if (memcmp(rd->skb->data + 6, dev->dev_addr, ETH_ALEN)) {
+			if (!ether_addr_equal(rd->skb->data + 6, dev->dev_addr)) {
 				if (len > rx_copybreak) {
 					skb = rd->skb;
 					newskb = netdev_alloc_skb(dev, PKT_BUF_SZ);
-- 
1.8.0


