Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab3LZLlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 06:41:21 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:28494 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab3LZLlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 06:41:16 -0500
Message-ID: <52BC15C2.70402@huawei.com>
Date: Thu, 26 Dec 2013 19:40:50 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Faisal Latif <faisal.latif@intel.com>, <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: [PATCH v3.5 09/19] infiniband: slight optimization of addr compare
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.199]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the possibly more efficient ether_addr_equal
to instead of memcmp.

Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Faisal Latif <faisal.latif@intel.com>
Cc: linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 drivers/infiniband/hw/nes/nes_cm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 6b29249..9c9f2f5 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -1354,8 +1354,7 @@ static int nes_addr_resolve_neigh(struct nes_vnic *nesvnic, u32 dst_ip, int arpi
 				  neigh->ha, ntohl(rt->rt_gateway));
 
 			if (arpindex >= 0) {
-				if (!memcmp(nesadapter->arp_table[arpindex].mac_addr,
-					    neigh->ha, ETH_ALEN)) {
+				if (ether_addr_equal(nesadapter->arp_table[arpindex].mac_addr, neigh->ha)) {
 					/* Mac address same as in nes_arp_table */
 					goto out;
 				}
-- 
1.8.0


