Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbaGJISy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 04:18:54 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:55583 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbaGJISu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 04:18:50 -0400
From: Tom Gundersen <teg@jklm.no>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        David Herrmann <dh.herrmann@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Tom Gundersen <teg@jklm.no>, Pravin Shelar <pshelar@nicira.com>,
        dev@openvswitch.org
Subject: [PATCH v7 23/33] net: openvswitch - set name assign type
Date: Thu, 10 Jul 2014 10:17:28 +0200
Message-Id: <1404980258-30853-24-git-send-email-teg@jklm.no>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404980258-30853-1-git-send-email-teg@jklm.no>
References: <1404980258-30853-1-git-send-email-teg@jklm.no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tom Gundersen <teg@jklm.no>
Cc: Pravin Shelar <pshelar@nicira.com>
Cc: dev@openvswitch.org
---
 net/openvswitch/datapath.c           | 1 +
 net/openvswitch/vport-internal_dev.c | 2 +-
 net/openvswitch/vport.h              | 2 ++
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 0d407bc..f216eca 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1370,6 +1370,7 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 
 	/* Set up our datapath device. */
 	parms.name = nla_data(a[OVS_DP_ATTR_NAME]);
+	parms.name_assign_type = NET_NAME_USER;
 	parms.type = OVS_VPORT_TYPE_INTERNAL;
 	parms.options = NULL;
 	parms.dp = dp;
diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index 0a5e077..ceb098c 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -159,7 +159,7 @@ static struct vport *internal_dev_create(const struct vport_parms *parms)
 	netdev_vport = netdev_vport_priv(vport);
 
 	netdev_vport->dev = alloc_netdev(sizeof(struct internal_dev),
-					 parms->name, NET_NAME_UNKNOWN,
+					 parms->name, parms->name_assign_type,
 					 do_setup);
 	if (!netdev_vport->dev) {
 		err = -ENOMEM;
diff --git a/net/openvswitch/vport.h b/net/openvswitch/vport.h
index 8d721e6..a9d7480 100644
--- a/net/openvswitch/vport.h
+++ b/net/openvswitch/vport.h
@@ -97,6 +97,7 @@ struct vport {
  * struct vport_parms - parameters for creating a new vport
  *
  * @name: New vport's name.
+ * @name_assign_type: New vport's name's origin.
  * @type: New vport's type.
  * @options: %OVS_VPORT_ATTR_OPTIONS attribute from Netlink message, %NULL if
  * none was supplied.
@@ -105,6 +106,7 @@ struct vport {
  */
 struct vport_parms {
 	const char *name;
+	unsigned char name_assign_type;
 	enum ovs_vport_type type;
 	struct nlattr *options;
 
-- 
1.9.3

