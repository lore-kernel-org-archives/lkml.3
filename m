Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbaAHCxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 21:53:51 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:56609 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826AbaAHCx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 21:53:27 -0500
Message-ID: <52CCBDA3.8090302@huawei.com>
Date: Wed, 8 Jan 2014 10:53:23 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Joerg Reuter <jreuter@yaina.de>, <linux-hams@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3.6 04/19] hamradio: slight optimization of addr compare
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.246]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use possibly more efficient ether_addr_equal
to instead of memcmp.

Cc: Joerg Reuter <jreuter@yaina.de>
Cc: linux-hams@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 drivers/net/hamradio/bpqether.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index f91bf0d..d50b23c 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -208,7 +208,7 @@ static int bpq_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_ty
 	eth = eth_hdr(skb);
 
 	if (!(bpq->acpt_addr[0] & 0x01) &&
-	    memcmp(eth->h_source, bpq->acpt_addr, ETH_ALEN))
+	    !ether_addr_equal(eth->h_source, bpq->acpt_addr))
 		goto drop_unlock;
 
 	if (skb_cow(skb, sizeof(struct ethhdr)))
-- 
1.8.0


