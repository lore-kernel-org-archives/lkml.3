Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab3KAWeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:34:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55015 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211Ab3KAWEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:04:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Julian Anastasov <ja@ssi.bg>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 38/54] netfilter: nf_conntrack: fix rt6i_gateway checks for H.323 helper
Date: Fri,  1 Nov 2013 15:04:06 -0700
Message-Id: <20131101220215.614972222@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220211.311926234@linuxfoundation.org>
References: <20131101220211.311926234@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit 56e42441ed54b092d6c7411138ce60d049e7c731 ]

Now when rt6_nexthop() can return nexthop address we can use it
for proper nexthop comparison of directly connected destinations.
For more information refer to commit bbb5823cf742a7
("netfilter: nf_conntrack: fix rt_gateway checks for H.323 helper").

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conntrack_h323_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -778,8 +778,8 @@ static int callforward_do_filter(const u
 				   flowi6_to_flowi(&fl1), false)) {
 			if (!afinfo->route(&init_net, (struct dst_entry **)&rt2,
 					   flowi6_to_flowi(&fl2), false)) {
-				if (!memcmp(&rt1->rt6i_gateway, &rt2->rt6i_gateway,
-					    sizeof(rt1->rt6i_gateway)) &&
+				if (ipv6_addr_equal(rt6_nexthop(rt1),
+						    rt6_nexthop(rt2)) &&
 				    rt1->dst.dev == rt2->dst.dev)
 					ret = 1;
 				dst_release(&rt2->dst);


