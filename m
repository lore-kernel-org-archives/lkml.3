Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103Ab3LWFLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 00:11:20 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:41855 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757077Ab3LWFLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 00:11:18 -0500
Message-ID: <52B7C5D5.2040202@huawei.com>
Date: Mon, 23 Dec 2013 13:10:45 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        <bridge@lists.linux-foundation.org>, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/21] bridge: slight optimization of addr compare
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.199]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the recently added and possibly more efficient
ether_addr_equal_unaligned to instead of memcmp.

Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: David Miller <davem@davemloft.net>
Cc: bridge@lists.linux-foundation.org
Cc: netdev@vger.kernel.org
Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 net/bridge/br_stp_if.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_stp_if.c b/net/bridge/br_stp_if.c
index 656a6f3..04217d1 100644
--- a/net/bridge/br_stp_if.c
+++ b/net/bridge/br_stp_if.c
@@ -229,7 +229,7 @@ bool br_stp_recalculate_bridge_id(struct net_bridge *br)
 
 	list_for_each_entry(p, &br->port_list, list) {
 		if (addr == br_mac_zero ||
-		    memcmp(p->dev->dev_addr, addr, ETH_ALEN) < 0)
+		    !ether_addr_equal_unaligned(p->dev->dev_addr, addr) < 0)
 			addr = p->dev->dev_addr;
 
 	}
-- 
1.8.0


