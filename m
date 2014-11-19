Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbaKSVfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:35:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933297AbaKSVOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:14:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 02/70] gre6: Move the setting of dev->iflink into the ndo_init functions.
Date: Wed, 19 Nov 2014 12:51:53 -0800
Message-Id: <20141119205210.995883250@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205210.913169042@linuxfoundation.org>
References: <20141119205210.913169042@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit f03eb128e3f4276f46442d14f3b8f864f3775821 ]

Otherwise it gets overwritten by register_netdev().

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_gre.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -962,8 +962,6 @@ static void ip6gre_tnl_link_config(struc
 	else
 		dev->flags &= ~IFF_POINTOPOINT;
 
-	dev->iflink = p->link;
-
 	/* Precalculate GRE options length */
 	if (t->parms.o_flags&(GRE_CSUM|GRE_KEY|GRE_SEQ)) {
 		if (t->parms.o_flags&GRE_CSUM)
@@ -1267,6 +1265,8 @@ static int ip6gre_tunnel_init(struct net
 	if (!dev->tstats)
 		return -ENOMEM;
 
+	dev->iflink = tunnel->parms.link;
+
 	return 0;
 }
 
@@ -1282,7 +1282,6 @@ static void ip6gre_fb_tunnel_init(struct
 	dev_hold(dev);
 }
 
-
 static struct inet6_protocol ip6gre_protocol __read_mostly = {
 	.handler     = ip6gre_rcv,
 	.err_handler = ip6gre_err,
@@ -1458,6 +1457,8 @@ static int ip6gre_tap_init(struct net_de
 	if (!dev->tstats)
 		return -ENOMEM;
 
+	dev->iflink = tunnel->parms.link;
+
 	return 0;
 }
 


