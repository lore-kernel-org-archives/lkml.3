Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab3L1GSM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 01:18:12 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:18151 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab3L1GSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 01:18:06 -0500
Message-ID: <52BE6D11.3060406@huawei.com>
Date: Sat, 28 Dec 2013 14:17:53 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Manish Chopra <manish.chopra@qlogic.com>,
        Sony Chacko <sony.chacko@qlogic.com>,
        Rajesh Borundia <rajesh.borundia@qlogic.com>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v2 12/20] net: netxen: slight optimization of addr
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

Cc: Manish Chopra <manish.chopra@qlogic.com>
Cc: Sony Chacko <sony.chacko@qlogic.com>
Cc: Rajesh Borundia <rajesh.borundia@qlogic.com>
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c
index b72b6be..db4280c 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c
@@ -661,7 +661,7 @@ static int nx_p3_nic_add_mac(struct netxen_adapter *adapter,
 	list_for_each(head, del_list) {
 		cur = list_entry(head, nx_mac_list_t, list);
 
-		if (memcmp(addr, cur->mac_addr, ETH_ALEN) == 0) {
+		if (ether_addr_equal(addr, cur->mac_addr)) {
 			list_move_tail(head, &adapter->mac_list);
 			return 0;
 		}
-- 
1.8.0


