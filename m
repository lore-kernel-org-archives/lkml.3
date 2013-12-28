Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab3L1GSQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 01:18:16 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:42706 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab3L1GSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 01:18:12 -0500
Message-ID: <52BE6D1C.5090101@huawei.com>
Date: Sat, 28 Dec 2013 14:18:04 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v2 15/20] net: seeq: slight optimization of addr
 compare
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


