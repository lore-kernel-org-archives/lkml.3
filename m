Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576AbaJ2Kib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:38:31 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:61511 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932168AbaJ2Ki3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:38:29 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhgOAOHCUFRXQzqR/2dsb2JhbABcgw6BLLo7BgEBAQEBBQF0mkeBGhcBAQEBAX2EMC8jgRo3iEUBtmyObiyGNYpUHYQ1BZ1oljiBRwGCMTwvgksBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] ipv6: remove inline on static in c file
Date: Wed, 29 Oct 2014 11:38:17 +0100
Message-Id: <1414579097-11659-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove __inline__ / inline and let compiler decide what to do
with static functions

Inspired-by: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/ipv6/reassembly.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 1a157ca..51ab096 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -69,7 +69,7 @@ struct ip6frag_skb_cb {
 
 #define FRAG6_CB(skb)	((struct ip6frag_skb_cb *)((skb)->cb))
 
-static inline u8 ip6_frag_ecn(const struct ipv6hdr *ipv6h)
+static u8 ip6_frag_ecn(const struct ipv6hdr *ipv6h)
 {
 	return 1 << (ipv6_get_dsfield(ipv6h) & INET_ECN_MASK);
 }
@@ -178,7 +178,7 @@ static void ip6_frag_expire(unsigned long data)
 	ip6_expire_frag_queue(net, fq, &ip6_frags);
 }
 
-static __inline__ struct frag_queue *
+static struct frag_queue *
 fq_find(struct net *net, __be32 id, const struct in6_addr *src,
 	const struct in6_addr *dst, u8 ecn)
 {
@@ -684,21 +684,21 @@ static void ip6_frags_sysctl_unregister(void)
 	unregister_net_sysctl_table(ip6_ctl_header);
 }
 #else
-static inline int ip6_frags_ns_sysctl_register(struct net *net)
+static int ip6_frags_ns_sysctl_register(struct net *net)
 {
 	return 0;
 }
 
-static inline void ip6_frags_ns_sysctl_unregister(struct net *net)
+static void ip6_frags_ns_sysctl_unregister(struct net *net)
 {
 }
 
-static inline int ip6_frags_sysctl_register(void)
+static int ip6_frags_sysctl_register(void)
 {
 	return 0;
 }
 
-static inline void ip6_frags_sysctl_unregister(void)
+static void ip6_frags_sysctl_unregister(void)
 {
 }
 #endif
-- 
1.9.3

