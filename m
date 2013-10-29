Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab3J2SPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:15:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59545 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458Ab3J2SJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:09:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ding Zhi <zhi.ding@6wind.com>, Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 43/81] ip6_tunnels: raddr and laddr are inverted in nl msg
Date: Tue, 29 Oct 2013 11:04:04 -0700
Message-Id: <1383069882-11437-44-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ding Zhi <zhi.ding@6wind.com>

[ Upstream commit 0d2ede929f61783aebfb9228e4d32a0546ee4d23 ]

IFLA_IPTUN_LOCAL and IFLA_IPTUN_REMOTE were inverted.

Introduced by c075b13098b3 (ip6tnl: advertise tunnel param via rtnl).

Signed-off-by: Ding Zhi <zhi.ding@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/ip6_tunnel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index a14f28b..57458c8 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1660,9 +1660,9 @@ static int ip6_tnl_fill_info(struct sk_buff *skb, const struct net_device *dev)
 
 	if (nla_put_u32(skb, IFLA_IPTUN_LINK, parm->link) ||
 	    nla_put(skb, IFLA_IPTUN_LOCAL, sizeof(struct in6_addr),
-		    &parm->raddr) ||
-	    nla_put(skb, IFLA_IPTUN_REMOTE, sizeof(struct in6_addr),
 		    &parm->laddr) ||
+	    nla_put(skb, IFLA_IPTUN_REMOTE, sizeof(struct in6_addr),
+		    &parm->raddr) ||
 	    nla_put_u8(skb, IFLA_IPTUN_TTL, parm->hop_limit) ||
 	    nla_put_u8(skb, IFLA_IPTUN_ENCAP_LIMIT, parm->encap_limit) ||
 	    nla_put_be32(skb, IFLA_IPTUN_FLOWINFO, parm->flowinfo) ||
-- 
1.8.1.2

