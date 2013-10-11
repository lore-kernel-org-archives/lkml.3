Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933105Ab3JKUNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:13:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383Ab3JKTlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ding Zhi <zhi.ding@6wind.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 026/135] ip6_tunnels: raddr and laddr are inverted in nl msg
Date: Fri, 11 Oct 2013 12:38:27 -0700
Message-Id: <20131011193948.078933669@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ding Zhi <zhi.ding@6wind.com>

[ Upstream commit 0d2ede929f61783aebfb9228e4d32a0546ee4d23 ]

IFLA_IPTUN_LOCAL and IFLA_IPTUN_REMOTE were inverted.

Introduced by c075b13098b3 (ip6tnl: advertise tunnel param via rtnl).

Signed-off-by: Ding Zhi <zhi.ding@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_tunnel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1652,9 +1652,9 @@ static int ip6_tnl_fill_info(struct sk_b
 
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


