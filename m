Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab3ITSX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 14:23:58 -0400
Received: from smtprelay0254.hostedemail.com ([216.40.44.254]:48943 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753670Ab3ITSXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 14:23:55 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3354:3865:3866:3867:3868:3870:3871:4321:4605:5007:6261:7875:7903:10004:10026:10848:11026:11658:11914:12043:12296:12438:12517:12519:12555:13161:13229:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: lead21_3f1eacaa09d58
X-Filterd-Recvd-Size: 3767
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 10/11] genetlink.h: Remove extern from function prototypes
Date: Fri, 20 Sep 2013 11:23:27 -0700
Message-Id: <f52ca676284f5a6379c2c337f77bb1efee0f502f.1379701322.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <597c1b62607f823af60dc4a99d59373dddfb7837.1379701322.git.joe@perches.com>
References: <597c1b62607f823af60dc4a99d59373dddfb7837.1379701322.git.joe@perches.com>
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
 include/net/genetlink.h | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index 8e0b6c8..9b787b6 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -122,7 +122,7 @@ struct genl_ops {
 	struct list_head	ops_list;
 };
 
-extern int __genl_register_family(struct genl_family *family);
+int __genl_register_family(struct genl_family *family);
 
 static inline int genl_register_family(struct genl_family *family)
 {
@@ -130,8 +130,8 @@ static inline int genl_register_family(struct genl_family *family)
 	return __genl_register_family(family);
 }
 
-extern int __genl_register_family_with_ops(struct genl_family *family,
-	struct genl_ops *ops, size_t n_ops);
+int __genl_register_family_with_ops(struct genl_family *family,
+				    struct genl_ops *ops, size_t n_ops);
 
 static inline int genl_register_family_with_ops(struct genl_family *family,
 	struct genl_ops *ops, size_t n_ops)
@@ -140,18 +140,18 @@ static inline int genl_register_family_with_ops(struct genl_family *family,
 	return __genl_register_family_with_ops(family, ops, n_ops);
 }
 
-extern int genl_unregister_family(struct genl_family *family);
-extern int genl_register_ops(struct genl_family *, struct genl_ops *ops);
-extern int genl_unregister_ops(struct genl_family *, struct genl_ops *ops);
-extern int genl_register_mc_group(struct genl_family *family,
-				  struct genl_multicast_group *grp);
-extern void genl_unregister_mc_group(struct genl_family *family,
-				     struct genl_multicast_group *grp);
-extern void genl_notify(struct sk_buff *skb, struct net *net, u32 portid,
-			u32 group, struct nlmsghdr *nlh, gfp_t flags);
+int genl_unregister_family(struct genl_family *family);
+int genl_register_ops(struct genl_family *, struct genl_ops *ops);
+int genl_unregister_ops(struct genl_family *, struct genl_ops *ops);
+int genl_register_mc_group(struct genl_family *family,
+			   struct genl_multicast_group *grp);
+void genl_unregister_mc_group(struct genl_family *family,
+			      struct genl_multicast_group *grp);
+void genl_notify(struct sk_buff *skb, struct net *net, u32 portid,
+		 u32 group, struct nlmsghdr *nlh, gfp_t flags);
 
 void *genlmsg_put(struct sk_buff *skb, u32 portid, u32 seq,
-				struct genl_family *family, int flags, u8 cmd);
+		  struct genl_family *family, int flags, u8 cmd);
 
 /**
  * genlmsg_nlhdr - Obtain netlink header from user specified header
-- 
1.8.1.2.459.gbcd45b4.dirty

