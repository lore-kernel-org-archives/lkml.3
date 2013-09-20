Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab3ITSXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 14:23:47 -0400
Received: from smtprelay0094.hostedemail.com ([216.40.44.94]:41460 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753572Ab3ITSXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 14:23:46 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3870:3871:4321:5007:6261:7903:10004:10026:10848:11026:11233:11658:11914:12438:12517:12519:12555:13161:13229:13311:13357:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: beds20_3dc26619bb640
X-Filterd-Recvd-Size: 2497
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 06/11] fib_rules.h: Remove extern from function prototypes
Date: Fri, 20 Sep 2013 11:23:23 -0700
Message-Id: <10bbc6049fe0a1f2bb270e97cc4430226686dd39.1379701322.git.joe@perches.com>
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
 include/net/fib_rules.h | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/include/net/fib_rules.h b/include/net/fib_rules.h
index 4b2b557..e584de1 100644
--- a/include/net/fib_rules.h
+++ b/include/net/fib_rules.h
@@ -115,14 +115,13 @@ static inline u32 frh_get_table(struct fib_rule_hdr *frh, struct nlattr **nla)
 	return frh->table;
 }
 
-extern struct fib_rules_ops *fib_rules_register(const struct fib_rules_ops *, struct net *);
-extern void fib_rules_unregister(struct fib_rules_ops *);
+struct fib_rules_ops *fib_rules_register(const struct fib_rules_ops *,
+					 struct net *);
+void fib_rules_unregister(struct fib_rules_ops *);
 
-extern int			fib_rules_lookup(struct fib_rules_ops *,
-						 struct flowi *, int flags,
-						 struct fib_lookup_arg *);
-extern int			fib_default_rule_add(struct fib_rules_ops *,
-						     u32 pref, u32 table,
-						     u32 flags);
-extern u32			fib_default_rule_pref(struct fib_rules_ops *ops);
+int fib_rules_lookup(struct fib_rules_ops *, struct flowi *, int flags,
+		     struct fib_lookup_arg *);
+int fib_default_rule_add(struct fib_rules_ops *, u32 pref, u32 table,
+			 u32 flags);
+u32 fib_default_rule_pref(struct fib_rules_ops *ops);
 #endif
-- 
1.8.1.2.459.gbcd45b4.dirty

