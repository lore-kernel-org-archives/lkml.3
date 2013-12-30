Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab3L3HlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 02:41:18 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:30035 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab3L3HlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 02:41:15 -0500
Message-ID: <52C1238E.5090608@huawei.com>
Date: Mon, 30 Dec 2013 15:41:02 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jon Mason <jdmason@kudzu.us>, "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v3 10/19] net: vxge: slight optimization of addr
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

Cc: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 drivers/net/ethernet/neterion/vxge/vxge-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 11b1c70..6eae216 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -1430,7 +1430,7 @@ vxge_search_mac_addr_in_da_table(struct vxge_vpath *vpath, struct macInfo *mac)
 		return status;
 	}
 
-	while (memcmp(mac->macaddr, macaddr, ETH_ALEN)) {
+	while (!ether_addr_equal(mac->macaddr, macaddr)) {
 		status = vxge_hw_vpath_mac_addr_get_next(vpath->handle,
 				macaddr, macmask);
 		if (status != VXGE_HW_OK)
-- 
1.8.0


