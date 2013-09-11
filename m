Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab3IKEaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:30:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9580 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab3IKE3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:29:05 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=RbkAZLdamTAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=H8je0neeBswA:10 a=20KFwNOVAAAA:8 a=jZVsG21pAAAA:8 a=fh4mg5NFAAAA:8 a=J1Y8HTJGAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=jEp0ucaQiEUA:10 a=v-EnS7xDjQoA:10 a=Im-eZXwrtqoA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=sGeFNgwIPfhOWJim:21 a=0w91T4jW59p5yHLs:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042858.909213255@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:27:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        Saurabh Mohan <saurabh.mohan@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>, Cong Wang <amwang@redhat.com>
Subject: [040/251] vti: remove duplicated code to fix a memory leak
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0040-vti-remove-duplicated-code-to-fix-a-memory-leak.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Cong Wang <amwang@redhat.com>

[ Upstream commit ab6c7a0a43c2eaafa57583822b619b22637b49c7 ]

vti module allocates dev->tstats twice: in vti_fb_tunnel_init()
and in vti_tunnel_init(), this lead to a memory leak of
dev->tstats.

Just remove the duplicated operations in vti_fb_tunnel_init().

(candidate for -stable)

Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: Saurabh Mohan <saurabh.mohan@vyatta.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Cong Wang <amwang@redhat.com>
Acked-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/ipv4/ip_vti.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index bf89b21..ab37b31 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -664,17 +664,10 @@ static int __net_init vti_fb_tunnel_init(struct net_device *dev)
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
-- 
1.7.10.4


