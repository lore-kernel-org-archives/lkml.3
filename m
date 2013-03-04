Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab3CDEMn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:12:43 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60902 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755777Ab3CDDm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:58 -0500
Message-Id: <20130304033719.902945622@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:39:12 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Li Wei <lw@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 125/153] ipv4: fix a bug in ping_err().
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Wei <lw@cn.fujitsu.com>

[ Upstream commit b531ed61a2a2a77eeb2f7c88b49aa5ec7d9880d8 ]

We should get 'type' and 'code' from the outer ICMP header.

Signed-off-by: Li Wei <lw@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/ping.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 43d4c3b..294a380 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -321,8 +321,8 @@ void ping_err(struct sk_buff *skb, u32 info)
 	struct iphdr *iph = (struct iphdr *)skb->data;
 	struct icmphdr *icmph = (struct icmphdr *)(skb->data+(iph->ihl<<2));
 	struct inet_sock *inet_sock;
-	int type = icmph->type;
-	int code = icmph->code;
+	int type = icmp_hdr(skb)->type;
+	int code = icmp_hdr(skb)->code;
 	struct net *net = dev_net(skb->dev);
 	struct sock *sk;
 	int harderr;


