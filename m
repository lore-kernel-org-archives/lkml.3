Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab3L0Gtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 01:49:39 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:40340 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab3L0Gtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 01:49:36 -0500
Message-ID: <52BD22E6.3090101@huawei.com>
Date: Fri, 27 Dec 2013 14:49:10 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 17/20] net: ti: slight optimization of addr compare
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
 drivers/net/ethernet/ti/cpsw_ale.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index 7fa60d6..63e9819 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -163,7 +163,7 @@ int cpsw_ale_match_addr(struct cpsw_ale *ale, u8 *addr, u16 vid)
 		if (cpsw_ale_get_vlan_id(ale_entry) != vid)
 			continue;
 		cpsw_ale_get_addr(ale_entry, entry_addr);
-		if (memcmp(entry_addr, addr, 6) == 0)
+		if (ether_addr_equal(entry_addr, addr))
 			return idx;
 	}
 	return -ENOENT;
-- 
1.8.0


