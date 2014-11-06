Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbaKFWoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:44:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59185 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbaKFWok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:44:40 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 024/162] ip6_gre: fix flowi6_proto value in xmit path
Date: Thu,  6 Nov 2014 14:34:48 -0800
Message-Id: <1415313426-9622-25-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ Upstream commit 3be07244b7337760a3269d56b2f4a63e72218648 ]

In xmit path, we build a flowi6 which will be used for the output route lookup.
We are sending a GRE packet, neither IPv4 nor IPv6 encapsulated packet, thus the
protocol should be IPPROTO_GRE.

Fixes: c12b395a4664 ("gre: Support GRE over IPv6")
Reported-by: Matthieu Ternisien d'Ouville <matthieu.tdo@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/ip6_gre.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 01ee297..bbb5ccd 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -790,7 +790,7 @@ static inline int ip6gre_xmit_ipv4(struct sk_buff *skb, struct net_device *dev)
 		encap_limit = t->parms.encap_limit;
 
 	memcpy(&fl6, &t->fl.u.ip6, sizeof(fl6));
-	fl6.flowi6_proto = IPPROTO_IPIP;
+	fl6.flowi6_proto = IPPROTO_GRE;
 
 	dsfield = ipv4_get_dsfield(iph);
 
@@ -840,7 +840,7 @@ static inline int ip6gre_xmit_ipv6(struct sk_buff *skb, struct net_device *dev)
 		encap_limit = t->parms.encap_limit;
 
 	memcpy(&fl6, &t->fl.u.ip6, sizeof(fl6));
-	fl6.flowi6_proto = IPPROTO_IPV6;
+	fl6.flowi6_proto = IPPROTO_GRE;
 
 	dsfield = ipv6_get_dsfield(ipv6h);
 	if (t->parms.flags & IP6_TNL_F_USE_ORIG_TCLASS)
-- 
1.9.1

