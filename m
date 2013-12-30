Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab3L3Hlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 02:41:35 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:30177 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab3L3Hlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 02:41:31 -0500
Message-ID: <52C123A4.3000803@huawei.com>
Date: Mon, 30 Dec 2013 15:41:24 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v3 16/19] net: sun: optimization of addr compare
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
 drivers/net/ethernet/sun/sunvnet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sun/sunvnet.c b/drivers/net/ethernet/sun/sunvnet.c
index 3df5684..1c24a8f 100644
--- a/drivers/net/ethernet/sun/sunvnet.c
+++ b/drivers/net/ethernet/sun/sunvnet.c
@@ -751,7 +751,7 @@ static struct vnet_mcast_entry *__vnet_mc_find(struct vnet *vp, u8 *addr)
 	struct vnet_mcast_entry *m;
 
 	for (m = vp->mcast_list; m; m = m->next) {
-		if (!memcmp(m->addr, addr, ETH_ALEN))
+		if (ether_addr_equal(m->addr, addr))
 			return m;
 	}
 	return NULL;
-- 
1.8.0


