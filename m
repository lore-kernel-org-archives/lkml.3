Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbaLOTur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:50:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40622 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaLOT1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:27:12 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 16/96] gre6: Move the setting of dev->iflink into the ndo_init functions.
Date: Mon, 15 Dec 2014 11:25:36 -0800
Message-Id: <1418671616-25482-17-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit f03eb128e3f4276f46442d14f3b8f864f3775821 ]

Otherwise it gets overwritten by register_netdev().

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/ip6_gre.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index bbb5ccd..3355b76 100644
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
@@ -1276,6 +1274,7 @@ static int ip6gre_tunnel_init(struct net_device *dev)
 		u64_stats_init(&ip6gre_tunnel_stats->syncp);
 	}
 
+	dev->iflink = tunnel->parms.link;
 
 	return 0;
 }
@@ -1477,6 +1476,8 @@ static int ip6gre_tap_init(struct net_device *dev)
 		u64_stats_init(&ip6gre_tap_stats->syncp);
 	}
 
+	dev->iflink = tunnel->parms.link;
+
 	return 0;
 }
 
-- 
1.9.1

