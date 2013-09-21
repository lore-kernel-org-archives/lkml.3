Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab3IURXb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 13:23:31 -0400
Received: from smtprelay0052.hostedemail.com ([216.40.44.52]:34591 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752596Ab3IURXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 13:23:10 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1543:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3354:3865:3866:3867:3868:3870:3871:4321:5007:6261:7903:10004:10026:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:13161:13229:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cow34_1b724ce90123f
X-Filterd-Recvd-Size: 3903
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 08/12] net_namespace.h: Remove extern from function prototypes
Date: Sat, 21 Sep 2013 10:22:48 -0700
Message-Id: <06e3cfbaf8d24024d683f7ce0ddf94a52193a0b7.1379783996.git.joe@perches.com>
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
 include/net/net_namespace.h | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 1313456..38c2afb 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -136,8 +136,8 @@ struct net {
 extern struct net init_net;
 
 #ifdef CONFIG_NET_NS
-extern struct net *copy_net_ns(unsigned long flags,
-	struct user_namespace *user_ns, struct net *old_net);
+struct net *copy_net_ns(unsigned long flags, struct user_namespace *user_ns,
+			struct net *old_net);
 
 #else /* CONFIG_NET_NS */
 #include <linux/sched.h>
@@ -154,11 +154,11 @@ static inline struct net *copy_net_ns(unsigned long flags,
 
 extern struct list_head net_namespace_list;
 
-extern struct net *get_net_ns_by_pid(pid_t pid);
-extern struct net *get_net_ns_by_fd(int pid);
+struct net *get_net_ns_by_pid(pid_t pid);
+struct net *get_net_ns_by_fd(int pid);
 
 #ifdef CONFIG_NET_NS
-extern void __put_net(struct net *net);
+void __put_net(struct net *net);
 
 static inline struct net *get_net(struct net *net)
 {
@@ -190,7 +190,7 @@ int net_eq(const struct net *net1, const struct net *net2)
 	return net1 == net2;
 }
 
-extern void net_drop_ns(void *);
+void net_drop_ns(void *);
 
 #else
 
@@ -307,19 +307,19 @@ struct pernet_operations {
  * device which caused kernel oops, and panics during network
  * namespace cleanup.   So please don't get this wrong.
  */
-extern int register_pernet_subsys(struct pernet_operations *);
-extern void unregister_pernet_subsys(struct pernet_operations *);
-extern int register_pernet_device(struct pernet_operations *);
-extern void unregister_pernet_device(struct pernet_operations *);
+int register_pernet_subsys(struct pernet_operations *);
+void unregister_pernet_subsys(struct pernet_operations *);
+int register_pernet_device(struct pernet_operations *);
+void unregister_pernet_device(struct pernet_operations *);
 
 struct ctl_table;
 struct ctl_table_header;
 
 #ifdef CONFIG_SYSCTL
-extern int net_sysctl_init(void);
-extern struct ctl_table_header *register_net_sysctl(struct net *net,
-	const char *path, struct ctl_table *table);
-extern void unregister_net_sysctl_table(struct ctl_table_header *header);
+int net_sysctl_init(void);
+struct ctl_table_header *register_net_sysctl(struct net *net, const char *path,
+					     struct ctl_table *table);
+void unregister_net_sysctl_table(struct ctl_table_header *header);
 #else
 static inline int net_sysctl_init(void) { return 0; }
 static inline struct ctl_table_header *register_net_sysctl(struct net *net,
-- 
1.8.1.2.459.gbcd45b4.dirty

