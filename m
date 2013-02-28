Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437Ab3B1OyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:54:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42553 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933132Ab3B1OvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:51:15 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Li Wei <lw@cn.fujitsu.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 130/139] ipv4: fix a bug in ping_err().
Date: Thu, 28 Feb 2013 14:44:40 +0000
Message-Id: <1362062689-2567-131-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Wei <lw@cn.fujitsu.com>

commit b531ed61a2a2a77eeb2f7c88b49aa5ec7d9880d8 upstream.

We should get 'type' and 'code' from the outer ICMP header.

Signed-off-by: Li Wei <lw@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/ping.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 2c00e8b..79db4e5 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -328,8 +328,8 @@ void ping_err(struct sk_buff *skb, u32 info)
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
-- 
1.8.1.2

