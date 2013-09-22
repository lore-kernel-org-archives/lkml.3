Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab3IVRfd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 13:35:33 -0400
Received: from smtprelay0056.hostedemail.com ([216.40.44.56]:35171 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752583Ab3IVRcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 13:32:35 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:3867:3868:3870:3871:4321:5007:6261:7903:10004:10026:10848:11473:11658:11914:12043:12438:12517:12519:12555:13161:13229:13311:13357:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: level95_1656af66b593e
X-Filterd-Recvd-Size: 2609
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 04/12] raw/rawv6.h: Remove extern from function prototypes
Date: Sun, 22 Sep 2013 10:32:19 -0700
Message-Id: <86e11439d933f867af7d05d08233f3699112eed6.1379870986.git.joe@perches.com>
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
 include/net/raw.h   | 6 +++---
 include/net/rawv6.h | 3 +--
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/include/net/raw.h b/include/net/raw.h
index 42ce6fe..6a40c65 100644
--- a/include/net/raw.h
+++ b/include/net/raw.h
@@ -26,7 +26,7 @@ extern struct proto raw_prot;
 void raw_icmp_error(struct sk_buff *, int, u32);
 int raw_local_deliver(struct sk_buff *, int);
 
-extern int 	raw_rcv(struct sock *, struct sk_buff *);
+int raw_rcv(struct sock *, struct sk_buff *);
 
 #define RAW_HTABLE_SIZE	MAX_INET_PROTOS
 
@@ -36,8 +36,8 @@ struct raw_hashinfo {
 };
 
 #ifdef CONFIG_PROC_FS
-extern int  raw_proc_init(void);
-extern void raw_proc_exit(void);
+int raw_proc_init(void);
+void raw_proc_exit(void);
 
 struct raw_iter_state {
 	struct seq_net_private p;
diff --git a/include/net/rawv6.h b/include/net/rawv6.h
index e7ea660..87783de 100644
--- a/include/net/rawv6.h
+++ b/include/net/rawv6.h
@@ -7,8 +7,7 @@ void raw6_icmp_error(struct sk_buff *, int nexthdr,
 		u8 type, u8 code, int inner_offset, __be32);
 bool raw6_local_deliver(struct sk_buff *, int);
 
-extern int			rawv6_rcv(struct sock *sk,
-					  struct sk_buff *skb);
+int rawv6_rcv(struct sock *sk, struct sk_buff *skb);
 
 #if defined(CONFIG_IPV6_MIP6) || defined(CONFIG_IPV6_MIP6_MODULE)
 int rawv6_mh_filter_register(int (*filter)(struct sock *sock,
-- 
1.8.1.2.459.gbcd45b4.dirty

