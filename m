Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab3ITSXx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 14:23:53 -0400
Received: from smtprelay0054.hostedemail.com ([216.40.44.54]:41468 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753635Ab3ITSXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 14:23:51 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:3867:3868:3870:3871:4605:5007:6261:7903:9592:10004:10026:10848:11658:11914:12043:12296:12438:12484:12517:12519:12555:13161:13229:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cause42_3e6b737a6c54c
X-Filterd-Recvd-Size: 2816
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 08/11] garp.h: Remove extern from function prototypes
Date: Fri, 20 Sep 2013 11:23:25 -0700
Message-Id: <ac245c0f23dd6f797457718cfcb602a9efd43728.1379701322.git.joe@perches.com>
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
 include/net/garp.h | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/include/net/garp.h b/include/net/garp.h
index 834d8ad..abf33bb 100644
--- a/include/net/garp.h
+++ b/include/net/garp.h
@@ -112,19 +112,18 @@ struct garp_port {
 	struct rcu_head			rcu;
 };
 
-extern int	garp_register_application(struct garp_application *app);
-extern void	garp_unregister_application(struct garp_application *app);
-
-extern int	garp_init_applicant(struct net_device *dev,
-				    struct garp_application *app);
-extern void	garp_uninit_applicant(struct net_device *dev,
-				      struct garp_application *app);
-
-extern int	garp_request_join(const struct net_device *dev,
-				  const struct garp_application *app,
-				  const void *data, u8 len, u8 type);
-extern void	garp_request_leave(const struct net_device *dev,
-				   const struct garp_application *app,
-				   const void *data, u8 len, u8 type);
+int garp_register_application(struct garp_application *app);
+void garp_unregister_application(struct garp_application *app);
+
+int garp_init_applicant(struct net_device *dev, struct garp_application *app);
+void garp_uninit_applicant(struct net_device *dev,
+			   struct garp_application *app);
+
+int garp_request_join(const struct net_device *dev,
+		      const struct garp_application *app, const void *data,
+		      u8 len, u8 type);
+void garp_request_leave(const struct net_device *dev,
+			const struct garp_application *app,
+			const void *data, u8 len, u8 type);
 
 #endif /* _NET_GARP_H */
-- 
1.8.1.2.459.gbcd45b4.dirty

