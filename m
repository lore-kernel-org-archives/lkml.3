Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963Ab3CZRwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:52:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19020 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab3CZRgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:19 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=5BQ5H_lnPr0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=83X1YI8fPvgA:10 a=omOdbC7AAAAA:8 a=J1Y8HTJGAAAA:8 a=C2I0aYpTRcXZx2DB3F8A:9 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173606.672990629@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Li Wei <lw@cn.fujitsu.com>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 42/86] ipv4: fix a bug in ping_err().
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0042-ipv4-fix-a-bug-in-ping_err.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Li Wei <lw@cn.fujitsu.com>

[ Upstream commit b531ed61a2a2a77eeb2f7c88b49aa5ec7d9880d8 ]

We should get 'type' and 'code' from the outer ICMP header.

Signed-off-by: Li Wei <lw@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv4/ping.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 6232d47..920cb0b 100644
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
1.7.10.4


