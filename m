Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab3LWFKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 00:10:21 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:41590 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab3LWFKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 00:10:14 -0500
Message-ID: <52B7C59E.8090106@huawei.com>
Date: Mon, 23 Dec 2013 13:09:50 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Don Fry <pcnet32@frontier.com>, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/21] net: pcnet: slight optimization of addr compare
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.199]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the recently added and possibly more efficient
ether_addr_equal_unaligned to instead of memcmp.

Cc: Don Fry <pcnet32@frontier.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 drivers/net/ethernet/amd/pcnet32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
index 38492e0..85d30dc 100644
--- a/drivers/net/ethernet/amd/pcnet32.c
+++ b/drivers/net/ethernet/amd/pcnet32.c
@@ -1668,7 +1668,7 @@ pcnet32_probe1(unsigned long ioaddr, int shared, struct pci_dev *pdev)
 	for (i = 0; i < ETH_ALEN; i++)
 		promaddr[i] = inb(ioaddr + i);
 
-	if (memcmp(promaddr, dev->dev_addr, ETH_ALEN) ||
+	if (!ether_addr_equal_unaligned(promaddr, dev->dev_addr) ||
 	    !is_valid_ether_addr(dev->dev_addr)) {
 		if (is_valid_ether_addr(promaddr)) {
 			if (pcnet32_debug & NETIF_MSG_PROBE) {
-- 
1.8.0


