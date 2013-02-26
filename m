Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933138Ab3B0Ao0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:44:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42249 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933024Ab3BZX63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Li Wei <lw@cn.fujitsu.com>, "David S. Miller" <davem@davemloft.net>
Subject: [ 129/150] ipv4: fix a bug in ping_err().
Date: Tue, 26 Feb 2013 15:56:26 -0800
Message-Id: <20130226235537.566283508@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Li Wei <lw@cn.fujitsu.com>

[ Upstream commit b531ed61a2a2a77eeb2f7c88b49aa5ec7d9880d8 ]

We should get 'type' and 'code' from the outer ICMP header.

Signed-off-by: Li Wei <lw@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ping.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -322,8 +322,8 @@ void ping_err(struct sk_buff *skb, u32 i
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


