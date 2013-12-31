Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab3LaJsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 04:48:18 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:51847 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab3LaJsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 04:48:14 -0500
Message-ID: <52C292C6.3050504@huawei.com>
Date: Tue, 31 Dec 2013 17:47:50 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jay Vosburgh <fubar@us.ibm.com>, Veaceslav Falico <vfalico@redhat.com>,
        Joe Perches <joe@perches.com>, Julia Lawall <julia.lawall@lip6.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 7/7] bonding: use ether_addr_equal_64bits to instead
 of ether_addr_equal
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.199]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The net_device.dev_addr have more than 2 bytes of additional data after
the mac addr, so it is safe to use the ether_addr_equal_64bits().

Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
---
 drivers/net/bonding/bond_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index e4d5018..94d07d2 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1632,7 +1632,7 @@ err_free:
 err_undo_flags:
 	/* Enslave of first slave has failed and we need to fix master's mac */
 	if (!bond_has_slaves(bond) &&
-	    ether_addr_equal(bond_dev->dev_addr, slave_dev->dev_addr))
+	    ether_addr_equal_64bits(bond_dev->dev_addr, slave_dev->dev_addr))
 		eth_hw_addr_random(bond_dev);
 
 	return res;
@@ -1705,7 +1705,7 @@ static int __bond_release_one(struct net_device *bond_dev,
 	bond->current_arp_slave = NULL;
 
 	if (!all && !bond->params.fail_over_mac) {
-		if (ether_addr_equal(bond_dev->dev_addr, slave->perm_hwaddr) &&
+		if (ether_addr_equal_64bits(bond_dev->dev_addr, slave->perm_hwaddr) &&
 		    bond_has_slaves(bond))
 			pr_warn("%s: Warning: the permanent HWaddr of %s - %pM - is still in use by %s. Set the HWaddr of %s to a different address to avoid conflicts.\n",
 				   bond_dev->name, slave_dev->name,
-- 
1.8.0


