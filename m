Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933825Ab3GZVnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:43:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50719 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759696Ab3GZUsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Cong Wang <amwang@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Saurabh Mohan <saurabh.mohan@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 08/79] vti: remove duplicated code to fix a memory leak
Date: Fri, 26 Jul 2013 13:46:58 -0700
Message-Id: <20130726204722.844127280@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <amwang@redhat.com>

[ Upstream commit ab6c7a0a43c2eaafa57583822b619b22637b49c7 ]

vti module allocates dev->tstats twice: in vti_fb_tunnel_init()
and in vti_tunnel_init(), this lead to a memory leak of
dev->tstats.

Just remove the duplicated operations in vti_fb_tunnel_init().

(candidate for -stable)

Signed-off-by: Cong Wang <amwang@redhat.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: Saurabh Mohan <saurabh.mohan@vyatta.com>
Acked-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_vti.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -606,17 +606,10 @@ static int __net_init vti_fb_tunnel_init
 	struct iphdr *iph = &tunnel->parms.iph;
 	struct vti_net *ipn = net_generic(dev_net(dev), vti_net_id);
 
-	tunnel->dev = dev;
-	strcpy(tunnel->parms.name, dev->name);
-
 	iph->version		= 4;
 	iph->protocol		= IPPROTO_IPIP;
 	iph->ihl		= 5;
 
-	dev->tstats = alloc_percpu(struct pcpu_tstats);
-	if (!dev->tstats)
-		return -ENOMEM;
-
 	dev_hold(dev);
 	rcu_assign_pointer(ipn->tunnels_wc[0], tunnel);
 	return 0;


