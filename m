Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbaEODoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 23:44:54 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:59799
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752962AbaEODov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 23:44:51 -0400
X-IronPort-AV: E=Sophos;i="4.97,1056,1389740400"; 
   d="scan'208";a="61911943"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: "David S. Miller" <davem@davemloft.net>
Cc: kernel-janitors@vger.kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] ip_tunnel: delete unneeded call to netdev_priv
Date: Thu, 15 May 2014 05:43:20 +0200
Message-Id: <1400125401-15512-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Netdev_priv is an accessor function, and has no purpose if its result is
not used.

A simplified version of the semantic match that fixes this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@ local idexpression x; @@
-x = netdev_priv(...);
... when != x
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 net/ipv4/ip_tunnel.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index b3f8597..059176d 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -395,11 +395,10 @@ static struct ip_tunnel *ip_tunnel_create(struct net *net,
 					  struct ip_tunnel_net *itn,
 					  struct ip_tunnel_parm *parms)
 {
-	struct ip_tunnel *nt, *fbt;
+	struct ip_tunnel *nt;
 	struct net_device *dev;
 
 	BUG_ON(!itn->fb_tunnel_dev);
-	fbt = netdev_priv(itn->fb_tunnel_dev);
 	dev = __ip_tunnel_create(net, itn->fb_tunnel_dev->rtnl_link_ops, parms);
 	if (IS_ERR(dev))
 		return ERR_CAST(dev);

