Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479Ab3JKUGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:06:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46195 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378Ab3JKTlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pravin Shelar <pshelar@nicira.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 047/135] ip_tunnel_core: Change __skb_push back to skb_push
Date: Fri, 11 Oct 2013 12:38:48 -0700
Message-Id: <20131011193950.390905208@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 78a3694d44a029242dd0830b34ab20ef1704be35 ]

Git commit 0e6fbc5b ("ip_tunnels: extend iptunnel_xmit()")
moved the IP header installation to iptunnel_xmit() and
changed skb_push() to __skb_push(). This makes possible
bugs hard to track down, so change it back to skb_push().

Cc: Pravin Shelar <pshelar@nicira.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_tunnel_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -63,7 +63,7 @@ int iptunnel_xmit(struct net *net, struc
 	memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
 
 	/* Push down and install the IP header. */
-	__skb_push(skb, sizeof(struct iphdr));
+	skb_push(skb, sizeof(struct iphdr));
 	skb_reset_network_header(skb);
 
 	iph = ip_hdr(skb);


