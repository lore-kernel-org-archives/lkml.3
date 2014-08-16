Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729AbaHPTex (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 15:34:53 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:48141 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbaHPTew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 15:34:52 -0400
Date: Sat, 16 Aug 2014 22:34:42 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] rcu: Replace rcu_dereference() with rcu_access_pointer()
Message-ID: <20140816193442.GA6471@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This "rcu_dereference()" call is used directly in a condition.
Since its return value is never dereferenced it is recommended to use
"rcu_access_pointer()" instead of "rcu_dereference()".
Therefore, this patch makes this replacement.

The following Coccinelle semantic patch was used for solving it:
@@
@@

(
 if(
 (<+...
- rcu_dereference
+ rcu_access_pointer
  (...)
 ...+>)) {...}
|
 while(
 (<+...
- rcu_dereference
+ rcu_access_pointer
  (...)
  ...+>)) {...}
)

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
---
 drivers/net/bonding/bond_alb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 76c0dad..1319c5b 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1385,7 +1385,7 @@ static int bond_do_alb_xmit(struct sk_buff *skb, struct bonding *bond,
 	}
 
 	if (tx_slave && bond_slave_can_tx(tx_slave)) {
-		if (tx_slave != rcu_dereference(bond->curr_active_slave)) {
+		if (tx_slave != rcu_access_pointer(bond->curr_active_slave)) {
 			ether_addr_copy(eth_data->h_source,
 					tx_slave->dev->dev_addr);
 		}
-- 
1.9.1

