Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759459Ab3JKUFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:05:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46204 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540Ab3JKTl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 049/135] ip6tnl: allow to use rtnl ops on fb tunnel
Date: Fri, 11 Oct 2013 12:38:50 -0700
Message-Id: <20131011193950.607163888@linuxfoundation.org>
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

[ Upstream commit bb8140947a247b9aa15652cc24dc555ebb0b64b0 ]

rtnl ops where introduced by c075b13098b3 ("ip6tnl: advertise tunnel param via
rtnl"), but I forget to assign rtnl ops to fb tunnels.

Now that it is done, we must remove the explicit call to
unregister_netdevice_queue(), because  the fallback tunnel is added to the queue
in ip6_tnl_destroy_tunnels() when checking rtnl_link_ops of all netdevices (this
is valid since commit 0bd8762824e7 ("ip6tnl: add x-netns support")).

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_tunnel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1738,6 +1738,7 @@ static int __net_init ip6_tnl_init_net(s
 	if (!ip6n->fb_tnl_dev)
 		goto err_alloc_dev;
 	dev_net_set(ip6n->fb_tnl_dev, net);
+	ip6n->fb_tnl_dev->rtnl_link_ops = &ip6_link_ops;
 
 	err = ip6_fb_tnl_dev_init(ip6n->fb_tnl_dev);
 	if (err < 0)


