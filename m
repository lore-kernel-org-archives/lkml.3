Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab3IURXa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 13:23:30 -0400
Received: from smtprelay0218.hostedemail.com ([216.40.44.218]:34589 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752570Ab3IURXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 13:23:08 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1544:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3355:3865:3866:3867:3868:3870:3871:4321:4605:5007:6261:7903:10004:10026:10848:11026:11473:11658:11914:12043:12291:12438:12517:12519:12555:12683:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: help80_1b32c8de4f63a
X-Filterd-Recvd-Size: 4932
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 07/12] ndisc.h: Remove extern from function prototypes
Date: Sat, 21 Sep 2013 10:22:47 -0700
Message-Id: <51c24bca01d49a2080f5f06affeb8bb2862a54ee.1379783995.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <005f102eb1322058f9e797a7268ae8be01ecfaae.1379783995.git.joe@perches.com>
References: <005f102eb1322058f9e797a7268ae8be01ecfaae.1379783995.git.joe@perches.com>
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
 include/net/ndisc.h | 61 +++++++++++++++++++++++------------------------------
 1 file changed, 26 insertions(+), 35 deletions(-)

diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index ea0cc26..6bbda34 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -110,8 +110,8 @@ struct ndisc_options {
 
 #define NDISC_OPT_SPACE(len) (((len)+2+7)&~7)
 
-extern struct ndisc_options *ndisc_parse_options(u8 *opt, int opt_len,
-						 struct ndisc_options *ndopts);
+struct ndisc_options *ndisc_parse_options(u8 *opt, int opt_len,
+					  struct ndisc_options *ndopts);
 
 /*
  * Return the padding between the option length and the start of the
@@ -189,60 +189,51 @@ static inline struct neighbour *__ipv6_neigh_lookup(struct net_device *dev, cons
 	return n;
 }
 
-extern int			ndisc_init(void);
-extern int			ndisc_late_init(void);
+int ndisc_init(void);
+int ndisc_late_init(void);
 
-extern void			ndisc_late_cleanup(void);
-extern void			ndisc_cleanup(void);
+void ndisc_late_cleanup(void);
+void ndisc_cleanup(void);
 
-extern int			ndisc_rcv(struct sk_buff *skb);
+int ndisc_rcv(struct sk_buff *skb);
 
-extern void			ndisc_send_ns(struct net_device *dev,
-					      struct neighbour *neigh,
-					      const struct in6_addr *solicit,
-					      const struct in6_addr *daddr,
-					      const struct in6_addr *saddr);
+void ndisc_send_ns(struct net_device *dev, struct neighbour *neigh,
+		   const struct in6_addr *solicit,
+		   const struct in6_addr *daddr, const struct in6_addr *saddr);
 
-extern void			ndisc_send_rs(struct net_device *dev,
-					      const struct in6_addr *saddr,
-					      const struct in6_addr *daddr);
-extern void			ndisc_send_na(struct net_device *dev, struct neighbour *neigh,
-					      const struct in6_addr *daddr,
-					      const struct in6_addr *solicited_addr,
-					      bool router, bool solicited, bool override,
-					      bool inc_opt);
+void ndisc_send_rs(struct net_device *dev,
+		   const struct in6_addr *saddr, const struct in6_addr *daddr);
+void ndisc_send_na(struct net_device *dev, struct neighbour *neigh,
+		   const struct in6_addr *daddr,
+		   const struct in6_addr *solicited_addr,
+		   bool router, bool solicited, bool override, bool inc_opt);
 
-extern void			ndisc_send_redirect(struct sk_buff *skb,
-						    const struct in6_addr *target);
+void ndisc_send_redirect(struct sk_buff *skb, const struct in6_addr *target);
 
-extern int			ndisc_mc_map(const struct in6_addr *addr, char *buf,
-					     struct net_device *dev, int dir);
+int ndisc_mc_map(const struct in6_addr *addr, char *buf, struct net_device *dev,
+		 int dir);
 
 
 /*
  *	IGMP
  */
-extern int			igmp6_init(void);
+int igmp6_init(void);
 
-extern void			igmp6_cleanup(void);
+void igmp6_cleanup(void);
 
-extern int			igmp6_event_query(struct sk_buff *skb);
+int igmp6_event_query(struct sk_buff *skb);
 
-extern int			igmp6_event_report(struct sk_buff *skb);
+int igmp6_event_report(struct sk_buff *skb);
 
 
 #ifdef CONFIG_SYSCTL
-extern int 			ndisc_ifinfo_sysctl_change(struct ctl_table *ctl,
-							   int write,
-							   void __user *buffer,
-							   size_t *lenp,
-							   loff_t *ppos);
+int ndisc_ifinfo_sysctl_change(struct ctl_table *ctl, int write,
+			       void __user *buffer, size_t *lenp, loff_t *ppos);
 int ndisc_ifinfo_sysctl_strategy(struct ctl_table *ctl,
 				 void __user *oldval, size_t __user *oldlenp,
 				 void __user *newval, size_t newlen);
 #endif
 
-extern void 			inet6_ifinfo_notify(int event,
-						    struct inet6_dev *idev);
+void inet6_ifinfo_notify(int event, struct inet6_dev *idev);
 
 #endif
-- 
1.8.1.2.459.gbcd45b4.dirty

