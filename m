Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbaLCMAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:00:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54664 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbaLCL1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:08 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 004/101] gre6: Move the setting of dev->iflink into the ndo_init functions.
Date: Wed,  3 Dec 2014 12:25:26 +0100
Message-Id: <1efcf6b31e0d8fcef45693930735cd4a9a385356.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit f03eb128e3f4276f46442d14f3b8f864f3775821 ]

Otherwise it gets overwritten by register_netdev().

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv6/ip6_gre.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 99988b86f6af..88774ccb3dda 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -965,8 +965,6 @@ static void ip6gre_tnl_link_config(struct ip6_tnl *t, int set_mtu)
 	else
 		dev->flags &= ~IFF_POINTOPOINT;
 
-	dev->iflink = p->link;
-
 	/* Precalculate GRE options length */
 	if (t->parms.o_flags&(GRE_CSUM|GRE_KEY|GRE_SEQ)) {
 		if (t->parms.o_flags&GRE_CSUM)
@@ -1269,6 +1267,8 @@ static int ip6gre_tunnel_init(struct net_device *dev)
 	if (!dev->tstats)
 		return -ENOMEM;
 
+	dev->iflink = tunnel->parms.link;
+
 	return 0;
 }
 
@@ -1285,7 +1285,6 @@ static void ip6gre_fb_tunnel_init(struct net_device *dev)
 	dev_hold(dev);
 }
 
-
 static struct inet6_protocol ip6gre_protocol __read_mostly = {
 	.handler     = ip6gre_rcv,
 	.err_handler = ip6gre_err,
@@ -1462,6 +1461,8 @@ static int ip6gre_tap_init(struct net_device *dev)
 	if (!dev->tstats)
 		return -ENOMEM;
 
+	dev->iflink = tunnel->parms.link;
+
 	return 0;
 }
 
-- 
2.1.3

