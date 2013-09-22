Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab3IVReF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 13:34:05 -0400
Received: from smtprelay0042.hostedemail.com ([216.40.44.42]:35177 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752728Ab3IVRcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 13:32:42 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1543:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2902:3138:3139:3140:3141:3142:3354:3865:3866:3867:3868:3870:3871:4321:4605:5007:6261:7875:7903:10004:10026:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:12683:13161:13229:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: nail53_1757d547c0c5e
X-Filterd-Recvd-Size: 4422
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 08/12] rtnetlink.h: Remove extern from function prototypes
Date: Sun, 22 Sep 2013 10:32:23 -0700
Message-Id: <940639b0a395925321149293dceec59fe91c724e.1379870986.git.joe@perches.com>
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
 include/net/rtnetlink.h | 40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index 7026648..bb13a18 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -8,14 +8,12 @@ typedef int (*rtnl_doit_func)(struct sk_buff *, struct nlmsghdr *);
 typedef int (*rtnl_dumpit_func)(struct sk_buff *, struct netlink_callback *);
 typedef u16 (*rtnl_calcit_func)(struct sk_buff *, struct nlmsghdr *);
 
-extern int	__rtnl_register(int protocol, int msgtype,
-				rtnl_doit_func, rtnl_dumpit_func,
-				rtnl_calcit_func);
-extern void	rtnl_register(int protocol, int msgtype,
-			      rtnl_doit_func, rtnl_dumpit_func,
-			      rtnl_calcit_func);
-extern int	rtnl_unregister(int protocol, int msgtype);
-extern void	rtnl_unregister_all(int protocol);
+int __rtnl_register(int protocol, int msgtype,
+		    rtnl_doit_func, rtnl_dumpit_func, rtnl_calcit_func);
+void rtnl_register(int protocol, int msgtype,
+		   rtnl_doit_func, rtnl_dumpit_func, rtnl_calcit_func);
+int rtnl_unregister(int protocol, int msgtype);
+void rtnl_unregister_all(int protocol);
 
 static inline int rtnl_msg_family(const struct nlmsghdr *nlh)
 {
@@ -83,11 +81,11 @@ struct rtnl_link_ops {
 	unsigned int		(*get_num_rx_queues)(void);
 };
 
-extern int	__rtnl_link_register(struct rtnl_link_ops *ops);
-extern void	__rtnl_link_unregister(struct rtnl_link_ops *ops);
+int __rtnl_link_register(struct rtnl_link_ops *ops);
+void __rtnl_link_unregister(struct rtnl_link_ops *ops);
 
-extern int	rtnl_link_register(struct rtnl_link_ops *ops);
-extern void	rtnl_link_unregister(struct rtnl_link_ops *ops);
+int rtnl_link_register(struct rtnl_link_ops *ops);
+void rtnl_link_unregister(struct rtnl_link_ops *ops);
 
 /**
  * 	struct rtnl_af_ops - rtnetlink address family operations
@@ -117,18 +115,18 @@ struct rtnl_af_ops {
 					       const struct nlattr *attr);
 };
 
-extern int	__rtnl_af_register(struct rtnl_af_ops *ops);
-extern void	__rtnl_af_unregister(struct rtnl_af_ops *ops);
+int __rtnl_af_register(struct rtnl_af_ops *ops);
+void __rtnl_af_unregister(struct rtnl_af_ops *ops);
 
-extern int	rtnl_af_register(struct rtnl_af_ops *ops);
-extern void	rtnl_af_unregister(struct rtnl_af_ops *ops);
+int rtnl_af_register(struct rtnl_af_ops *ops);
+void rtnl_af_unregister(struct rtnl_af_ops *ops);
 
+struct net *rtnl_link_get_net(struct net *src_net, struct nlattr *tb[]);
+struct net_device *rtnl_create_link(struct net *net, char *ifname,
+				    const struct rtnl_link_ops *ops,
+				    struct nlattr *tb[]);
+int rtnl_configure_link(struct net_device *dev, const struct ifinfomsg *ifm);
 
-extern struct net *rtnl_link_get_net(struct net *src_net, struct nlattr *tb[]);
-extern struct net_device *rtnl_create_link(struct net *net,
-	char *ifname, const struct rtnl_link_ops *ops, struct nlattr *tb[]);
-extern int rtnl_configure_link(struct net_device *dev,
-			       const struct ifinfomsg *ifm);
 extern const struct nla_policy ifla_policy[IFLA_MAX+1];
 
 #define MODULE_ALIAS_RTNL_LINK(kind) MODULE_ALIAS("rtnl-link-" kind)
-- 
1.8.1.2.459.gbcd45b4.dirty

