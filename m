Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab3ITSYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 14:24:00 -0400
Received: from smtprelay0129.hostedemail.com ([216.40.44.129]:45951 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753653Ab3ITSXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 14:23:53 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1543:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3354:3865:3866:3867:3868:3870:3871:4605:5007:6261:7903:9592:10004:10026:10848:11026:11658:11914:12043:12291:12296:12438:12517:12519:12555:12683:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: title67_3ecb2aa95bb51
X-Filterd-Recvd-Size: 4216
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 09/11] gen_stats.h: Remove extern from function prototypes
Date: Fri, 20 Sep 2013 11:23:26 -0700
Message-Id: <de7ed4476339ad4dd67f56064fddc50bbeee410c.1379701322.git.joe@perches.com>
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
 include/net/gen_stats.h | 51 ++++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 26 deletions(-)

diff --git a/include/net/gen_stats.h b/include/net/gen_stats.h
index cf8439b..ea4271d 100644
--- a/include/net/gen_stats.h
+++ b/include/net/gen_stats.h
@@ -19,32 +19,31 @@ struct gnet_dump {
 	struct tc_stats   tc_stats;
 };
 
-extern int gnet_stats_start_copy(struct sk_buff *skb, int type,
+int gnet_stats_start_copy(struct sk_buff *skb, int type, spinlock_t *lock,
+			  struct gnet_dump *d);
+
+int gnet_stats_start_copy_compat(struct sk_buff *skb, int type,
+				 int tc_stats_type, int xstats_type,
 				 spinlock_t *lock, struct gnet_dump *d);
 
-extern int gnet_stats_start_copy_compat(struct sk_buff *skb, int type,
-					int tc_stats_type,int xstats_type,
-					spinlock_t *lock, struct gnet_dump *d);
-
-extern int gnet_stats_copy_basic(struct gnet_dump *d,
-				 struct gnet_stats_basic_packed *b);
-extern int gnet_stats_copy_rate_est(struct gnet_dump *d,
-				    const struct gnet_stats_basic_packed *b,
-				    struct gnet_stats_rate_est64 *r);
-extern int gnet_stats_copy_queue(struct gnet_dump *d,
-				 struct gnet_stats_queue *q);
-extern int gnet_stats_copy_app(struct gnet_dump *d, void *st, int len);
-
-extern int gnet_stats_finish_copy(struct gnet_dump *d);
-
-extern int gen_new_estimator(struct gnet_stats_basic_packed *bstats,
-			     struct gnet_stats_rate_est64 *rate_est,
-			     spinlock_t *stats_lock, struct nlattr *opt);
-extern void gen_kill_estimator(struct gnet_stats_basic_packed *bstats,
-			       struct gnet_stats_rate_est64 *rate_est);
-extern int gen_replace_estimator(struct gnet_stats_basic_packed *bstats,
-				 struct gnet_stats_rate_est64 *rate_est,
-				 spinlock_t *stats_lock, struct nlattr *opt);
-extern bool gen_estimator_active(const struct gnet_stats_basic_packed *bstats,
-				 const struct gnet_stats_rate_est64 *rate_est);
+int gnet_stats_copy_basic(struct gnet_dump *d,
+			  struct gnet_stats_basic_packed *b);
+int gnet_stats_copy_rate_est(struct gnet_dump *d,
+			     const struct gnet_stats_basic_packed *b,
+			     struct gnet_stats_rate_est64 *r);
+int gnet_stats_copy_queue(struct gnet_dump *d, struct gnet_stats_queue *q);
+int gnet_stats_copy_app(struct gnet_dump *d, void *st, int len);
+
+int gnet_stats_finish_copy(struct gnet_dump *d);
+
+int gen_new_estimator(struct gnet_stats_basic_packed *bstats,
+		      struct gnet_stats_rate_est64 *rate_est,
+		      spinlock_t *stats_lock, struct nlattr *opt);
+void gen_kill_estimator(struct gnet_stats_basic_packed *bstats,
+			struct gnet_stats_rate_est64 *rate_est);
+int gen_replace_estimator(struct gnet_stats_basic_packed *bstats,
+			  struct gnet_stats_rate_est64 *rate_est,
+			  spinlock_t *stats_lock, struct nlattr *opt);
+bool gen_estimator_active(const struct gnet_stats_basic_packed *bstats,
+			  const struct gnet_stats_rate_est64 *rate_est);
 #endif
-- 
1.8.1.2.459.gbcd45b4.dirty

