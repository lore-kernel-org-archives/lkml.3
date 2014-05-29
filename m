Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934594AbaE2Nwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:52:47 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59511 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933598AbaE2Ntd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:33 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Pravin B Shelar <pshelar@nicira.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 101/103] ip_tunnel: Initialize the fallback device properly
Date: Thu, 29 May 2014 15:49:26 +0200
Message-Id: <9b60fabbe9b3577f82c8b9519c3cb351763b7d89.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 78ff4be45a4c51d8fb21ad92e4fabb467c6c3eeb ]

We need to initialize the fallback device to have a correct mtu
set on this device. Otherwise the mtu is set to null and the device
is unusable.

Fixes: fd58156e456d ("IPIP: Use ip-tunneling code.")
Cc: Pravin B Shelar <pshelar@nicira.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv4/ip_tunnel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index d626d4059a42..d9dbe0f78612 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -855,6 +855,7 @@ int ip_tunnel_init_net(struct net *net, int ip_tnl_net_id,
 	 */
 	if (!IS_ERR(itn->fb_tunnel_dev)) {
 		itn->fb_tunnel_dev->features |= NETIF_F_NETNS_LOCAL;
+		itn->fb_tunnel_dev->mtu = ip_tunnel_bind_dev(itn->fb_tunnel_dev);
 		ip_tunnel_add(itn, netdev_priv(itn->fb_tunnel_dev));
 	}
 	rtnl_unlock();
-- 
1.9.3

