Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab3J2SVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:21:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59434 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab3J2SIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:08:51 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 57/81] ip6tnl: allow to use rtnl ops on fb tunnel
Date: Tue, 29 Oct 2013 11:04:18 -0700
Message-Id: <1383069882-11437-58-git-send-email-kamal@canonical.com>
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

[ Upstream commit bb8140947a247b9aa15652cc24dc555ebb0b64b0 ]

rtnl ops where introduced by c075b13098b3 ("ip6tnl: advertise tunnel param via
rtnl"), but I forget to assign rtnl ops to fb tunnels.

Now that it is done, we must remove the explicit call to
unregister_netdevice_queue(), because  the fallback tunnel is added to the queue
in ip6_tnl_destroy_tunnels() when checking rtnl_link_ops of all netdevices (this
is valid since commit 0bd8762824e7 ("ip6tnl: add x-netns support")).

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/ip6_tunnel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 57458c8..a953bfb 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1746,6 +1746,7 @@ static int __net_init ip6_tnl_init_net(struct net *net)
 	if (!ip6n->fb_tnl_dev)
 		goto err_alloc_dev;
 	dev_net_set(ip6n->fb_tnl_dev, net);
+	ip6n->fb_tnl_dev->rtnl_link_ops = &ip6_link_ops;
 
 	err = ip6_fb_tnl_dev_init(ip6n->fb_tnl_dev);
 	if (err < 0)
-- 
1.8.1.2

