Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaKDToL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:44:11 -0500
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:21762 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752732AbaKDToI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:44:08 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgcOAFwrWVRbsl9p/2dsb2JhbABbgw6BLLp/BgEBAQEBBQF0miiBJBcBAQEBAX2EMC8jgRo3iEUBvm+PCCyGN4pZHYQ1BZ4Hlk+BRwGCMTwvgksBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] inet: frags: remove inline on static in c file
Date: Tue,  4 Nov 2014 20:44:04 +0100
Message-Id: <1415130244-15003-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove __inline__ / inline and let compiler decide what to do
with static functions

Inspired-by: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/ipv4/ip_fragment.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 2811cc1..4d964da 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -80,7 +80,7 @@ struct ipq {
 	struct inet_peer *peer;
 };
 
-static inline u8 ip4_frag_ecn(u8 tos)
+static u8 ip4_frag_ecn(u8 tos)
 {
 	return 1 << (tos & INET_ECN_MASK);
 }
@@ -148,7 +148,7 @@ static void ip4_frag_init(struct inet_frag_queue *q, const void *a)
 		inet_getpeer_v4(net->ipv4.peers, arg->iph->saddr, 1) : NULL;
 }
 
-static __inline__ void ip4_frag_free(struct inet_frag_queue *q)
+static void ip4_frag_free(struct inet_frag_queue *q)
 {
 	struct ipq *qp;
 
@@ -160,7 +160,7 @@ static __inline__ void ip4_frag_free(struct inet_frag_queue *q)
 
 /* Destruction primitives. */
 
-static __inline__ void ipq_put(struct ipq *ipq)
+static void ipq_put(struct ipq *ipq)
 {
 	inet_frag_put(&ipq->q, &ip4_frags);
 }
@@ -236,7 +236,7 @@ out:
 /* Find the correct entry in the "incomplete datagrams" queue for
  * this IP datagram, and create new one, if nothing is found.
  */
-static inline struct ipq *ip_find(struct net *net, struct iphdr *iph, u32 user)
+static struct ipq *ip_find(struct net *net, struct iphdr *iph, u32 user)
 {
 	struct inet_frag_queue *q;
 	struct ip4_create_arg arg;
@@ -256,7 +256,7 @@ static inline struct ipq *ip_find(struct net *net, struct iphdr *iph, u32 user)
 }
 
 /* Is the fragment too far ahead to be part of ipq? */
-static inline int ip_frag_too_far(struct ipq *qp)
+static int ip_frag_too_far(struct ipq *qp)
 {
 	struct inet_peer *peer = qp->peer;
 	unsigned int max = sysctl_ipfrag_max_dist;
@@ -795,16 +795,16 @@ static void __init ip4_frags_ctl_register(void)
 	register_net_sysctl(&init_net, "net/ipv4", ip4_frags_ctl_table);
 }
 #else
-static inline int ip4_frags_ns_ctl_register(struct net *net)
+static int ip4_frags_ns_ctl_register(struct net *net)
 {
 	return 0;
 }
 
-static inline void ip4_frags_ns_ctl_unregister(struct net *net)
+static void ip4_frags_ns_ctl_unregister(struct net *net)
 {
 }
 
-static inline void __init ip4_frags_ctl_register(void)
+static void __init ip4_frags_ctl_register(void)
 {
 }
 #endif
-- 
1.9.3

