Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab3J2SI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:08:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59450 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab3J2SIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:08:55 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 56/81] sit: allow to use rtnl ops on fb tunnel
Date: Tue, 29 Oct 2013 11:04:17 -0700
Message-Id: <1383069882-11437-57-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ Upstream commit 205983c43700ac3a81e7625273a3fa83cd2759b5 ]

rtnl ops where introduced by ba3e3f50a0e5 ("sit: advertise tunnel param via
rtnl"), but I forget to assign rtnl ops to fb tunnels.

Now that it is done, we must remove the explicit call to
unregister_netdevice_queue(), because  the fallback tunnel is added to the queue
in sit_destroy_tunnels() when checking rtnl_link_ops of all netdevices (this
is valid since commit 5e6700b3bf98 ("sit: add support of x-netns")).

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/sit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index cfba99b..b1c5654 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1517,6 +1517,7 @@ static int __net_init sit_init_net(struct net *net)
 		goto err_alloc_dev;
 	}
 	dev_net_set(sitn->fb_tunnel_dev, net);
+	sitn->fb_tunnel_dev->rtnl_link_ops = &sit_link_ops;
 
 	err = ipip6_fb_tunnel_init(sitn->fb_tunnel_dev);
 	if (err)
-- 
1.8.1.2

