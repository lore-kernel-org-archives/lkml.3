Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384Ab3JKUCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:02:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46254 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932562Ab3JKTld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 048/135] sit: allow to use rtnl ops on fb tunnel
Date: Fri, 11 Oct 2013 12:38:49 -0700
Message-Id: <20131011193950.500861993@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/sit.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1673,6 +1673,7 @@ static int __net_init sit_init_net(struc
 		goto err_alloc_dev;
 	}
 	dev_net_set(sitn->fb_tunnel_dev, net);
+	sitn->fb_tunnel_dev->rtnl_link_ops = &sit_link_ops;
 	/* FB netdevice is special: we have one, and only one per netns.
 	 * Allowing to move it to another netns is clearly unsafe.
 	 */


