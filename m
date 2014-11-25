Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbaKYKnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:43:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59098 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbaKYKnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:24 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 218/254] gre6: Move the setting of dev->iflink into the ndo_init functions.
Date: Tue, 25 Nov 2014 10:39:28 +0000
Message-Id: <1416912004-5928-219-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Klassert <steffen.klassert@secunet.com>

commit f03eb128e3f4276f46442d14f3b8f864f3775821 upstream.

Otherwise it gets overwritten by register_netdev().

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/ip6_gre.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 43bc1fc24621..c3ba41cef1df 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -953,8 +953,6 @@ static void ip6gre_tnl_link_config(struct ip6_tnl *t, int set_mtu)
 	else
 		dev->flags &= ~IFF_POINTOPOINT;
 
-	dev->iflink = p->link;
-
 	/* Precalculate GRE options length */
 	if (t->parms.o_flags&(GRE_CSUM|GRE_KEY|GRE_SEQ)) {
 		if (t->parms.o_flags&GRE_CSUM)
@@ -1262,6 +1260,7 @@ static int ip6gre_tunnel_init(struct net_device *dev)
 		u64_stats_init(&ip6gre_tunnel_stats->syncp);
 	}
 
+	dev->iflink = tunnel->parms.link;
 
 	return 0;
 }
@@ -1470,6 +1469,8 @@ static int ip6gre_tap_init(struct net_device *dev)
 	if (!dev->tstats)
 		return -ENOMEM;
 
+	dev->iflink = tunnel->parms.link;
+
 	return 0;
 }
 
-- 
2.1.0

