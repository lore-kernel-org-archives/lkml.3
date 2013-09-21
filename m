Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab3IURX3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 13:23:29 -0400
Received: from smtprelay0055.hostedemail.com ([216.40.44.55]:47840 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752557Ab3IURXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 13:23:07 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:3867:3868:3870:3871:4605:5007:6261:7903:9592:10004:10026:10848:11658:11914:12043:12296:12438:12484:12517:12519:12555:13161:13229:13311:13357:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: play97_1af7ab7315436
X-Filterd-Recvd-Size: 2789
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 06/12] mrp.h: Remove extern from function prototypes
Date: Sat, 21 Sep 2013 10:22:46 -0700
Message-Id: <98931149ac392bc49ecdf2125fa32d68fcfe67ce.1379783995.git.joe@perches.com>
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
 include/net/mrp.h | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/include/net/mrp.h b/include/net/mrp.h
index 4fbf02a..687c8fe 100644
--- a/include/net/mrp.h
+++ b/include/net/mrp.h
@@ -125,19 +125,17 @@ struct mrp_port {
 	struct rcu_head			rcu;
 };
 
-extern int	mrp_register_application(struct mrp_application *app);
-extern void	mrp_unregister_application(struct mrp_application *app);
-
-extern int	mrp_init_applicant(struct net_device *dev,
-				    struct mrp_application *app);
-extern void	mrp_uninit_applicant(struct net_device *dev,
-				      struct mrp_application *app);
-
-extern int	mrp_request_join(const struct net_device *dev,
-				  const struct mrp_application *app,
-				  const void *value, u8 len, u8 type);
-extern void	mrp_request_leave(const struct net_device *dev,
-				   const struct mrp_application *app,
-				   const void *value, u8 len, u8 type);
+int mrp_register_application(struct mrp_application *app);
+void mrp_unregister_application(struct mrp_application *app);
+
+int mrp_init_applicant(struct net_device *dev, struct mrp_application *app);
+void mrp_uninit_applicant(struct net_device *dev, struct mrp_application *app);
+
+int mrp_request_join(const struct net_device *dev,
+		     const struct mrp_application *app,
+		     const void *value, u8 len, u8 type);
+void mrp_request_leave(const struct net_device *dev,
+		       const struct mrp_application *app,
+		       const void *value, u8 len, u8 type);
 
 #endif /* _NET_MRP_H */
-- 
1.8.1.2.459.gbcd45b4.dirty

