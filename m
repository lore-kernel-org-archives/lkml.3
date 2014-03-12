Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbaCLREy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:04:54 -0400
Received: from smtprelay0017.hostedemail.com ([216.40.44.17]:42613 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755317AbaCLREw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:04:52 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2538:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:5007:6261:10004:10026:10848:11026:11658:11914:12043:12296:12517:12519:12555:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cave72_814963da1511b
X-Filterd-Recvd-Size: 2264
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/6] netfilter: Convert uses of __constant_<foo> to <foo>
Date: Wed, 12 Mar 2014 10:04:19 -0700
Message-Id: <d0259d9122d308e3297cac6f7bc47c9955c3597b.1394643455.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1394643455.git.joe@perches.com>
References: <cover.1394643455.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of __constant_<foo> has been unnecessary for quite awhile now.

Make these uses consistent with the rest of the kernel.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/netfilter/ipset/pfxlen.c | 4 ++--
 net/netfilter/xt_AUDIT.c     | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipset/pfxlen.c b/net/netfilter/ipset/pfxlen.c
index 4f29fa9..04d15fd 100644
--- a/net/netfilter/ipset/pfxlen.c
+++ b/net/netfilter/ipset/pfxlen.c
@@ -7,8 +7,8 @@
 
 #define E(a, b, c, d) \
 	{.ip6 = { \
-		__constant_htonl(a), __constant_htonl(b), \
-		__constant_htonl(c), __constant_htonl(d), \
+		htonl(a), htonl(b), \
+		htonl(c), htonl(d), \
 	} }
 
 /*
diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
index 3228d7f..4973cbd 100644
--- a/net/netfilter/xt_AUDIT.c
+++ b/net/netfilter/xt_AUDIT.c
@@ -146,11 +146,11 @@ audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
 
 		if (par->family == NFPROTO_BRIDGE) {
 			switch (eth_hdr(skb)->h_proto) {
-			case __constant_htons(ETH_P_IP):
+			case htons(ETH_P_IP):
 				audit_ip4(ab, skb);
 				break;
 
-			case __constant_htons(ETH_P_IPV6):
+			case htons(ETH_P_IPV6):
 				audit_ip6(ab, skb);
 				break;
 			}
-- 
1.8.1.2.459.gbcd45b4.dirty

