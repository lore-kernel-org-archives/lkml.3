Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab3ITSXu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 14:23:50 -0400
Received: from smtprelay0052.hostedemail.com ([216.40.44.52]:37082 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752114Ab3ITSXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 14:23:48 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:3867:3868:3870:3871:4321:4605:5007:6261:7903:10004:10026:10848:11026:11658:11914:12043:12438:12517:12519:12555:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: drop44_3e1dd3123f347
X-Filterd-Recvd-Size: 2628
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] flow.h/flow_keys.h: Remove extern from function prototypes
Date: Fri, 20 Sep 2013 11:23:24 -0700
Message-Id: <e353e88cf7202a9977a6caada9123dc57d968ee6.1379701322.git.joe@perches.com>
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
 include/net/flow.h      | 11 ++++++-----
 include/net/flow_keys.h |  2 +-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/net/flow.h b/include/net/flow.h
index 628e11b..65ce471 100644
--- a/include/net/flow.h
+++ b/include/net/flow.h
@@ -215,12 +215,13 @@ typedef struct flow_cache_object *(*flow_resolve_t)(
 		struct net *net, const struct flowi *key, u16 family,
 		u8 dir, struct flow_cache_object *oldobj, void *ctx);
 
-extern struct flow_cache_object *flow_cache_lookup(
-		struct net *net, const struct flowi *key, u16 family,
-		u8 dir, flow_resolve_t resolver, void *ctx);
+struct flow_cache_object *flow_cache_lookup(struct net *net,
+					    const struct flowi *key, u16 family,
+					    u8 dir, flow_resolve_t resolver,
+					    void *ctx);
 
-extern void flow_cache_flush(void);
-extern void flow_cache_flush_deferred(void);
+void flow_cache_flush(void);
+void flow_cache_flush_deferred(void);
 extern atomic_t flow_cache_genid;
 
 #endif
diff --git a/include/net/flow_keys.h b/include/net/flow_keys.h
index bb8271d..ac2439d 100644
--- a/include/net/flow_keys.h
+++ b/include/net/flow_keys.h
@@ -13,5 +13,5 @@ struct flow_keys {
 	u8 ip_proto;
 };
 
-extern bool skb_flow_dissect(const struct sk_buff *skb, struct flow_keys *flow);
+bool skb_flow_dissect(const struct sk_buff *skb, struct flow_keys *flow);
 #endif
-- 
1.8.1.2.459.gbcd45b4.dirty

