Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759523Ab3FCWSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:18:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21010 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758758Ab3FCWMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:12:17 -0400
X-Authority-Analysis: v=2.0 cv=BcJaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=xCUrDgNEQlkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=SN_-A_peiFIA:10 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=owa15NvcG_ooZ1K4DF8A:9 a=UTB_XpHje0EA:10 a=9J5VuaLb3qoA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221157.381227249@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:10:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mike Galbraith <bitbucket@online.de>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [29/65] tcp: force a dst refcount when prequeue packet
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0029-tcp-force-a-dst-refcount-when-prequeue-packet.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 093162553c33e9479283e107b4431378271c735d ]

Before escaping RCU protected section and adding packet into
prequeue, make sure the dst is refcounted.

Reported-by: Mike Galbraith <bitbucket@online.de>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/net/tcp.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 1f000ff..9297897 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1015,6 +1015,7 @@ static inline bool tcp_prequeue(struct sock *sk, struct sk_buff *skb)
 	if (sysctl_tcp_low_latency || !tp->ucopy.task)
 		return false;
 
+	skb_dst_force(skb);
 	__skb_queue_tail(&tp->ucopy.prequeue, skb);
 	tp->ucopy.memory += skb->truesize;
 	if (tp->ucopy.memory > sk->sk_rcvbuf) {
-- 
1.7.10.4


