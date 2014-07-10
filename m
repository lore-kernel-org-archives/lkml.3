Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaGJIVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 04:21:44 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:57957 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbaGJITB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 04:19:01 -0400
From: Tom Gundersen <teg@jklm.no>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        David Herrmann <dh.herrmann@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Tom Gundersen <teg@jklm.no>, Fabian Godehardt <fg@emlix.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v7 28/33] net: dsa - set name assign type
Date: Thu, 10 Jul 2014 10:17:33 +0200
Message-Id: <1404980258-30853-29-git-send-email-teg@jklm.no>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404980258-30853-1-git-send-email-teg@jklm.no>
References: <1404980258-30853-1-git-send-email-teg@jklm.no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The name is given by the firmware, so we assume it is predictable.

Signed-off-by: Tom Gundersen <teg@jklm.no>
Cc: Fabian Godehardt <fg@emlix.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/dsa.c      | 3 ++-
 net/dsa/dsa_priv.h | 3 ++-
 net/dsa/slave.c    | 6 +++---
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 5db37ce..f3cd203 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -185,7 +185,8 @@ dsa_switch_setup(struct dsa_switch_tree *dst, int index,
 		if (!(ds->phys_port_mask & (1 << i)))
 			continue;
 
-		slave_dev = dsa_slave_create(ds, parent, i, pd->port_names[i]);
+		slave_dev = dsa_slave_create(ds, parent, i, pd->port_names[i],
+					     NET_NAME_PREDICTABLE);
 		if (slave_dev == NULL) {
 			printk(KERN_ERR "%s[%d]: can't create dsa "
 			       "slave device for port %d(%s)\n",
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index d4cf5cc..458881f 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -42,7 +42,8 @@ extern char dsa_driver_version[];
 void dsa_slave_mii_bus_init(struct dsa_switch *ds);
 struct net_device *dsa_slave_create(struct dsa_switch *ds,
 				    struct device *parent,
-				    int port, char *name);
+				    int port, char *name,
+				    unsigned char name_assign_type);
 
 /* tag_dsa.c */
 netdev_tx_t dsa_xmit(struct sk_buff *skb, struct net_device *dev);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 45a1e34..d29b0be 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -333,15 +333,15 @@ static const struct net_device_ops trailer_netdev_ops = {
 /* slave device setup *******************************************************/
 struct net_device *
 dsa_slave_create(struct dsa_switch *ds, struct device *parent,
-		 int port, char *name)
+		 int port, char *name, unsigned char name_assign_type)
 {
 	struct net_device *master = ds->dst->master_netdev;
 	struct net_device *slave_dev;
 	struct dsa_slave_priv *p;
 	int ret;
 
-	slave_dev = alloc_netdev(sizeof(struct dsa_slave_priv), name,
-				 NET_NAME_UNKNOWN, ether_setup);
+	slave_dev = alloc_netdev(sizeof(struct dsa_slave_priv),
+				 name, name_assign_type, ether_setup);
 	if (slave_dev == NULL)
 		return slave_dev;
 
-- 
1.9.3

