Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab3LXN7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 08:59:22 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:54667 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab3LXN7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 08:59:18 -0500
Message-ID: <52B9907C.6090002@gmail.com>
Date: Tue, 24 Dec 2013 21:47:40 +0800
From: Ding Tianhong <dthxman@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Don Fry <pcnet32@frontier.com>, Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH RESEND v2 03/20] net: pcnet: slight optimization of addr compare
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use possibly more efficient ether_addr_equal
to instead of memcmp.

Cc: Don Fry <pcnet32@frontier.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 drivers/net/ethernet/amd/pcnet32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
index 38492e0..9339ccc 100644
--- a/drivers/net/ethernet/amd/pcnet32.c
+++ b/drivers/net/ethernet/amd/pcnet32.c
@@ -1668,7 +1668,7 @@ pcnet32_probe1(unsigned long ioaddr, int shared, struct pci_dev *pdev)
 	for (i = 0; i < ETH_ALEN; i++)
 		promaddr[i] = inb(ioaddr + i);
 
-	if (memcmp(promaddr, dev->dev_addr, ETH_ALEN) ||
+	if (!ether_addr_equal(promaddr, dev->dev_addr) ||
 	    !is_valid_ether_addr(dev->dev_addr)) {
 		if (is_valid_ether_addr(promaddr)) {
 			if (pcnet32_debug & NETIF_MSG_PROBE) {
-- 
1.8.0



--
To unsubscribe from this list: send the line "unsubscribe netdev" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
.

