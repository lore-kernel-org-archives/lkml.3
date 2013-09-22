Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab3IVRcn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 13:32:43 -0400
Received: from smtprelay0021.hostedemail.com ([216.40.44.21]:41061 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752803Ab3IVRck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 13:32:40 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1535:1544:1605:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:4605:5007:6261:7903:9592:10004:10026:10848:11026:11658:11914:12043:12291:12438:12517:12519:12555:12683:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: leg64_1718ce307f259
X-Filterd-Recvd-Size: 5242
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 07/12] route.h: Remove extern from function prototypes
Date: Sun, 22 Sep 2013 10:32:22 -0700
Message-Id: <496f3eb3bb0e0439b50982260f4395c35d2a252e.1379870986.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <b692aba58032f629907ea2d462c99b87906645ca.1379870986.git.joe@perches.com>
References: <b692aba58032f629907ea2d462c99b87906645ca.1379870986.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a mix of function prototypes with and without extern
in the kernel sources.  Standardize on not using extern for
function prototypes.

Function prototypes don't need to be written with extern.
extern is assumed by the compiler.  Its use is as unnecessary as
using auto to declare automatic/local variables in a block.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/net/route.h | 53 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 28 insertions(+), 25 deletions(-)

diff --git a/include/net/route.h b/include/net/route.h
index afdeeb5..6f572ca 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -108,13 +108,15 @@ struct rt_cache_stat {
 extern struct ip_rt_acct __percpu *ip_rt_acct;
 
 struct in_device;
-extern int		ip_rt_init(void);
-extern void		rt_cache_flush(struct net *net);
-extern void		rt_flush_dev(struct net_device *dev);
-extern struct rtable *__ip_route_output_key(struct net *, struct flowi4 *flp);
-extern struct rtable *ip_route_output_flow(struct net *, struct flowi4 *flp,
-					   struct sock *sk);
-extern struct dst_entry *ipv4_blackhole_route(struct net *net, struct dst_entry *dst_orig);
+
+int ip_rt_init(void);
+void rt_cache_flush(struct net *net);
+void rt_flush_dev(struct net_device *dev);
+struct rtable *__ip_route_output_key(struct net *, struct flowi4 *flp);
+struct rtable *ip_route_output_flow(struct net *, struct flowi4 *flp,
+				    struct sock *sk);
+struct dst_entry *ipv4_blackhole_route(struct net *net,
+				       struct dst_entry *dst_orig);
 
 static inline struct rtable *ip_route_output_key(struct net *net, struct flowi4 *flp)
 {
@@ -162,8 +164,8 @@ static inline struct rtable *ip_route_output_gre(struct net *net, struct flowi4
 	return ip_route_output_key(net, fl4);
 }
 
-extern int ip_route_input_noref(struct sk_buff *skb, __be32 dst, __be32 src,
-				u8 tos, struct net_device *devin);
+int ip_route_input_noref(struct sk_buff *skb, __be32 dst, __be32 src,
+			 u8 tos, struct net_device *devin);
 
 static inline int ip_route_input(struct sk_buff *skb, __be32 dst, __be32 src,
 				 u8 tos, struct net_device *devin)
@@ -179,24 +181,25 @@ static inline int ip_route_input(struct sk_buff *skb, __be32 dst, __be32 src,
 	return err;
 }
 
-extern void ipv4_update_pmtu(struct sk_buff *skb, struct net *net, u32 mtu,
-			     int oif, u32 mark, u8 protocol, int flow_flags);
-extern void ipv4_sk_update_pmtu(struct sk_buff *skb, struct sock *sk, u32 mtu);
-extern void ipv4_redirect(struct sk_buff *skb, struct net *net,
-			  int oif, u32 mark, u8 protocol, int flow_flags);
-extern void ipv4_sk_redirect(struct sk_buff *skb, struct sock *sk);
-extern void ip_rt_send_redirect(struct sk_buff *skb);
-
-extern unsigned int		inet_addr_type(struct net *net, __be32 addr);
-extern unsigned int		inet_dev_addr_type(struct net *net, const struct net_device *dev, __be32 addr);
-extern void		ip_rt_multicast_event(struct in_device *);
-extern int		ip_rt_ioctl(struct net *, unsigned int cmd, void __user *arg);
-extern void		ip_rt_get_source(u8 *src, struct sk_buff *skb, struct rtable *rt);
-extern int		ip_rt_dump(struct sk_buff *skb,  struct netlink_callback *cb);
+void ipv4_update_pmtu(struct sk_buff *skb, struct net *net, u32 mtu, int oif,
+		      u32 mark, u8 protocol, int flow_flags);
+void ipv4_sk_update_pmtu(struct sk_buff *skb, struct sock *sk, u32 mtu);
+void ipv4_redirect(struct sk_buff *skb, struct net *net, int oif, u32 mark,
+		   u8 protocol, int flow_flags);
+void ipv4_sk_redirect(struct sk_buff *skb, struct sock *sk);
+void ip_rt_send_redirect(struct sk_buff *skb);
+
+unsigned int inet_addr_type(struct net *net, __be32 addr);
+unsigned int inet_dev_addr_type(struct net *net, const struct net_device *dev,
+				__be32 addr);
+void ip_rt_multicast_event(struct in_device *);
+int ip_rt_ioctl(struct net *, unsigned int cmd, void __user *arg);
+void ip_rt_get_source(u8 *src, struct sk_buff *skb, struct rtable *rt);
+int ip_rt_dump(struct sk_buff *skb,  struct netlink_callback *cb);
 
 struct in_ifaddr;
-extern void fib_add_ifaddr(struct in_ifaddr *);
-extern void fib_del_ifaddr(struct in_ifaddr *, struct in_ifaddr *);
+void fib_add_ifaddr(struct in_ifaddr *);
+void fib_del_ifaddr(struct in_ifaddr *, struct in_ifaddr *);
 
 static inline void ip_rt_put(struct rtable *rt)
 {
-- 
1.8.1.2.459.gbcd45b4.dirty

