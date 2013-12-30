Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab3L3Hwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 02:52:32 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:52651 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab3L3Hwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 02:52:30 -0500
Message-ID: <52C12378.7030801@huawei.com>
Date: Mon, 30 Dec 2013 15:40:40 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Christian Benvenuti <benve@cisco.com>, Sujith Sankar <ssujith@cisco.com>,
        Govindarajulu Varadarajan <govindarajulu90@gmail.com>,
        Neel Patel <neepatel@cisco.com>, Nishank Trivedi <nistrive@cisco.com>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v3 04/19] net: enic: slight optimization of addr
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

Cc: Christian Benvenuti <benve@cisco.com>
Cc: Sujith Sankar <ssujith@cisco.com>
Cc: Govindarajulu Varadarajan <govindarajulu90@gmail.com>
Cc: Neel Patel <neepatel@cisco.com>
Cc: Nishank Trivedi <nistrive@cisco.com>
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 drivers/net/ethernet/cisco/enic/enic_pp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cisco/enic/enic_pp.c b/drivers/net/ethernet/cisco/enic/enic_pp.c
index 43464f0..e6a8319 100644
--- a/drivers/net/ethernet/cisco/enic/enic_pp.c
+++ b/drivers/net/ethernet/cisco/enic/enic_pp.c
@@ -162,7 +162,7 @@ static int enic_are_pp_different(struct enic_port_profile *pp1,
 	return strcmp(pp1->name, pp2->name) | !!memcmp(pp1->instance_uuid,
 		pp2->instance_uuid, PORT_UUID_MAX) |
 		!!memcmp(pp1->host_uuid, pp2->host_uuid, PORT_UUID_MAX) |
-		!!memcmp(pp1->mac_addr, pp2->mac_addr, ETH_ALEN);
+		!ether_addr_equal(pp1->mac_addr, pp2->mac_addr);
 }
 
 static int enic_pp_preassociate(struct enic *enic, int vf,
-- 
1.8.0


