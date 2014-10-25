Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaJYSzQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:55:16 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:55196 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387AbaJYSzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:55:09 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag8OANbAS1RXQw14/2dsb2JhbABcgw6BLLlLCwUBdJpDgQYXAX2EXyOBGjeIRQG6II5TLIY0ilQdhDUFj2mNeIxqiUSBRwFsgUY7L4JLAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] xfrm: fix set but not used warning in xfrm_policy_queue_process()
Date: Sat, 25 Oct 2014 17:27:09 +0200
Message-Id: <1414250829-17908-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

err was set but unused.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/xfrm/xfrm_policy.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 4c4e457..dc65324 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1878,7 +1878,6 @@ xfrm_resolve_and_create_bundle(struct xfrm_policy **pols, int num_pols,
 
 static void xfrm_policy_queue_process(unsigned long arg)
 {
-	int err = 0;
 	struct sk_buff *skb;
 	struct sock *sk;
 	struct dst_entry *dst;
@@ -1941,7 +1940,7 @@ static void xfrm_policy_queue_process(unsigned long arg)
 		skb_dst_drop(skb);
 		skb_dst_set(skb, dst);
 
-		err = dst_output(skb);
+		dst_output(skb);
 	}
 
 out:
-- 
1.9.3

