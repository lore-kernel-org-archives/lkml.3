Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738Ab3CJM3O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 08:29:14 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:48542 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab3CJM3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 08:29:13 -0400
From: Valentin Ilie <valentin.ilie@gmail.com>
To: socketcan@hartkopp.net, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Valentin Ilie <valentin.ilie@gmail.com>
Subject: [PATCH] net: can: af_can.c: Fix checkpatch warnings
Date: Sun, 10 Mar 2013 14:28:46 +0200
Message-Id: <1362918526-26730-1-git-send-email-valentin.ilie@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace printk(KERN_ERR with pr_err
Add space before {

Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
---
 net/can/af_can.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index c48e522..a14c0aa 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -525,7 +525,7 @@ void can_rx_unregister(struct net_device *dev, canid_t can_id, canid_t mask,
 
 	d = find_dev_rcv_lists(dev);
 	if (!d) {
-		printk(KERN_ERR "BUG: receive list not found for "
+		pr_err("BUG: receive list not found for "
 		       "dev %s, id %03X, mask %03X\n",
 		       DNAME(dev), can_id, mask);
 		goto out;
@@ -552,7 +552,7 @@ void can_rx_unregister(struct net_device *dev, canid_t can_id, canid_t mask,
 	 */
 
 	if (!r) {
-		printk(KERN_ERR "BUG: receive list entry not found for "
+		pr_err("BUG: receive list entry not found for "
 		       "dev %s, id %03X, mask %03X\n",
 		       DNAME(dev), can_id, mask);
 		r = NULL;
@@ -749,7 +749,7 @@ int can_proto_register(const struct can_proto *cp)
 	int err = 0;
 
 	if (proto < 0 || proto >= CAN_NPROTO) {
-		printk(KERN_ERR "can: protocol number %d out of range\n",
+		pr_err("can: protocol number %d out of range\n",
 		       proto);
 		return -EINVAL;
 	}
@@ -761,7 +761,7 @@ int can_proto_register(const struct can_proto *cp)
 	mutex_lock(&proto_tab_lock);
 
 	if (proto_tab[proto]) {
-		printk(KERN_ERR "can: protocol %d already registered\n",
+		pr_err("can: protocol %d already registered\n",
 		       proto);
 		err = -EBUSY;
 	} else
@@ -817,8 +817,7 @@ static int can_notifier(struct notifier_block *nb, unsigned long msg,
 		/* create new dev_rcv_lists for this device */
 		d = kzalloc(sizeof(*d), GFP_KERNEL);
 		if (!d) {
-			printk(KERN_ERR
-			       "can: allocation of receive list failed\n");
+			pr_err("can: allocation of receive list failed\n");
 			return NOTIFY_DONE;
 		}
 		BUG_ON(dev->ml_priv);
@@ -838,7 +837,7 @@ static int can_notifier(struct notifier_block *nb, unsigned long msg,
 				dev->ml_priv = NULL;
 			}
 		} else
-			printk(KERN_ERR "can: notifier: receive list not "
+			pr_err("can: notifier: receive list not "
 			       "found for dev %s\n", dev->name);
 
 		spin_unlock(&can_rcvlists_lock);
@@ -927,7 +926,7 @@ static __exit void can_exit(void)
 	/* remove created dev_rcv_lists from still registered CAN devices */
 	rcu_read_lock();
 	for_each_netdev_rcu(&init_net, dev) {
-		if (dev->type == ARPHRD_CAN && dev->ml_priv){
+		if (dev->type == ARPHRD_CAN && dev->ml_priv) {
 
 			struct dev_rcv_lists *d = dev->ml_priv;
 
-- 
1.8.1.2

