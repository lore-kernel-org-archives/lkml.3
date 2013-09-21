Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab3IURXf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 13:23:35 -0400
Received: from smtprelay0226.hostedemail.com ([216.40.44.226]:47602 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752615Ab3IURXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 13:23:14 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1535:1544:1605:1711:1730:1747:1777:1792:2393:2559:2562:2910:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:4321:4605:5007:6119:6261:7903:8603:9592:10004:10026:10848:11658:11914:12043:12291:12296:12438:12517:12519:12555:12683:13161:13229:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: plate15_1bf1f41d4754c
X-Filterd-Recvd-Size: 5765
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 10/12] netevent/netlink.h: Remove extern from function prototypes
Date: Sat, 21 Sep 2013 10:22:50 -0700
Message-Id: <b167058642444fecd8fb53e18927e10a4b14ddef.1379783996.git.joe@perches.com>
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
 include/net/netevent.h |  6 ++---
 include/net/netlink.h  | 63 ++++++++++++++++++++------------------------------
 2 files changed, 28 insertions(+), 41 deletions(-)

diff --git a/include/net/netevent.h b/include/net/netevent.h
index fe630dd..d8bbb38 100644
--- a/include/net/netevent.h
+++ b/include/net/netevent.h
@@ -26,8 +26,8 @@ enum netevent_notif_type {
 	NETEVENT_REDIRECT,	   /* arg is struct netevent_redirect ptr */
 };
 
-extern int register_netevent_notifier(struct notifier_block *nb);
-extern int unregister_netevent_notifier(struct notifier_block *nb);
-extern int call_netevent_notifiers(unsigned long val, void *v);
+int register_netevent_notifier(struct notifier_block *nb);
+int unregister_netevent_notifier(struct notifier_block *nb);
+int call_netevent_notifiers(unsigned long val, void *v);
 
 #endif
diff --git a/include/net/netlink.h b/include/net/netlink.h
index 9690b0f..2b47eaa 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -225,44 +225,31 @@ struct nl_info {
 	u32			portid;
 };
 
-extern int		netlink_rcv_skb(struct sk_buff *skb,
-					int (*cb)(struct sk_buff *,
-						  struct nlmsghdr *));
-extern int		nlmsg_notify(struct sock *sk, struct sk_buff *skb,
-				     u32 portid, unsigned int group, int report,
-				     gfp_t flags);
-
-extern int		nla_validate(const struct nlattr *head,
-				     int len, int maxtype,
-				     const struct nla_policy *policy);
-extern int		nla_parse(struct nlattr **tb, int maxtype,
-				  const struct nlattr *head, int len,
-				  const struct nla_policy *policy);
-extern int		nla_policy_len(const struct nla_policy *, int);
-extern struct nlattr *	nla_find(const struct nlattr *head,
-				 int len, int attrtype);
-extern size_t		nla_strlcpy(char *dst, const struct nlattr *nla,
-				    size_t dstsize);
-extern int		nla_memcpy(void *dest, const struct nlattr *src, int count);
-extern int		nla_memcmp(const struct nlattr *nla, const void *data,
-				   size_t size);
-extern int		nla_strcmp(const struct nlattr *nla, const char *str);
-extern struct nlattr *	__nla_reserve(struct sk_buff *skb, int attrtype,
-				      int attrlen);
-extern void *		__nla_reserve_nohdr(struct sk_buff *skb, int attrlen);
-extern struct nlattr *	nla_reserve(struct sk_buff *skb, int attrtype,
-				    int attrlen);
-extern void *		nla_reserve_nohdr(struct sk_buff *skb, int attrlen);
-extern void		__nla_put(struct sk_buff *skb, int attrtype,
-				  int attrlen, const void *data);
-extern void		__nla_put_nohdr(struct sk_buff *skb, int attrlen,
-					const void *data);
-extern int		nla_put(struct sk_buff *skb, int attrtype,
-				int attrlen, const void *data);
-extern int		nla_put_nohdr(struct sk_buff *skb, int attrlen,
-				      const void *data);
-extern int		nla_append(struct sk_buff *skb, int attrlen,
-				   const void *data);
+int netlink_rcv_skb(struct sk_buff *skb,
+		    int (*cb)(struct sk_buff *, struct nlmsghdr *));
+int nlmsg_notify(struct sock *sk, struct sk_buff *skb, u32 portid,
+		 unsigned int group, int report, gfp_t flags);
+
+int nla_validate(const struct nlattr *head, int len, int maxtype,
+		 const struct nla_policy *policy);
+int nla_parse(struct nlattr **tb, int maxtype, const struct nlattr *head,
+	      int len, const struct nla_policy *policy);
+int nla_policy_len(const struct nla_policy *, int);
+struct nlattr *nla_find(const struct nlattr *head, int len, int attrtype);
+size_t nla_strlcpy(char *dst, const struct nlattr *nla, size_t dstsize);
+int nla_memcpy(void *dest, const struct nlattr *src, int count);
+int nla_memcmp(const struct nlattr *nla, const void *data, size_t size);
+int nla_strcmp(const struct nlattr *nla, const char *str);
+struct nlattr *__nla_reserve(struct sk_buff *skb, int attrtype, int attrlen);
+void *__nla_reserve_nohdr(struct sk_buff *skb, int attrlen);
+struct nlattr *nla_reserve(struct sk_buff *skb, int attrtype, int attrlen);
+void *nla_reserve_nohdr(struct sk_buff *skb, int attrlen);
+void __nla_put(struct sk_buff *skb, int attrtype, int attrlen,
+	       const void *data);
+void __nla_put_nohdr(struct sk_buff *skb, int attrlen, const void *data);
+int nla_put(struct sk_buff *skb, int attrtype, int attrlen, const void *data);
+int nla_put_nohdr(struct sk_buff *skb, int attrlen, const void *data);
+int nla_append(struct sk_buff *skb, int attrlen, const void *data);
 
 /**************************************************************************
  * Netlink Messages
-- 
1.8.1.2.459.gbcd45b4.dirty

