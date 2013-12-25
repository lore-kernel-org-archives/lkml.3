Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab3LYD2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 22:28:52 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:44008 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab3LYD2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 22:28:49 -0500
Message-ID: <52BA50CD.7010601@huawei.com>
Date: Wed, 25 Dec 2013 11:28:13 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jay Cliburn <jcliburn@gmail.com>, Chris Snook <chris.snook@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 03/19] net: atl1: slight optimization of addr compare
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.199]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the recently added and possibly more efficient
ether_addr_equal_unaligned to instead of memcmp.

Cc: Jay Cliburn <jcliburn@gmail.com>
Cc: Chris Snook <chris.snook@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Weilong Chen <chenweilong@huawei.com>
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 drivers/net/ethernet/atheros/atlx/atl1.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/ethernet/atheros/atlx/atl1.c
index 538211d..55d86ec 100644
--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -3122,7 +3122,8 @@ static void atl1_remove(struct pci_dev *pdev)
 	 * from the BIOS during POST.  If we've been messing with the MAC
 	 * address, we need to save the permanent one.
 	 */
-	if (memcmp(adapter->hw.mac_addr, adapter->hw.perm_mac_addr, ETH_ALEN)) {
+	if (!ether_addr_equal_unaligned(adapter->hw.mac_addr,
+					adapter->hw.perm_mac_addr)) {
 		memcpy(adapter->hw.mac_addr, adapter->hw.perm_mac_addr,
 			ETH_ALEN);
 		atl1_set_mac_addr(&adapter->hw);
-- 
1.8.0


