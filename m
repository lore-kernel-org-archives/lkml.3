Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab3IUR00 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 13:26:26 -0400
Received: from smtprelay0016.hostedemail.com ([216.40.44.16]:47869 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752628Ab3IURXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 13:23:18 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3870:3871:4321:5007:6261:7903:10004:10026:10848:11658:11914:12043:12438:12517:12519:12555:13161:13229:13311:13357:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: glove16_1c700bf349f53
X-Filterd-Recvd-Size: 2323
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 12/12] p8022.h: Remove extern from function prototypes
Date: Sat, 21 Sep 2013 10:22:52 -0700
Message-Id: <5640248f05394a4460179df8f9f8cb5a1959eb6b.1379783996.git.joe@perches.com>
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
 include/net/p8022.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/net/p8022.h b/include/net/p8022.h
index 42e9fac..05e4138 100644
--- a/include/net/p8022.h
+++ b/include/net/p8022.h
@@ -1,13 +1,13 @@
 #ifndef _NET_P8022_H
 #define _NET_P8022_H
-extern struct datalink_proto *
-	register_8022_client(unsigned char type,
-			     int (*func)(struct sk_buff *skb,
-					 struct net_device *dev,
-					 struct packet_type *pt,
-					 struct net_device *orig_dev));
-extern void unregister_8022_client(struct datalink_proto *proto);
+struct datalink_proto *
+register_8022_client(unsigned char type,
+		     int (*func)(struct sk_buff *skb,
+				 struct net_device *dev,
+				 struct packet_type *pt,
+				 struct net_device *orig_dev));
+void unregister_8022_client(struct datalink_proto *proto);
 
-extern struct datalink_proto *make_8023_client(void);
-extern void destroy_8023_client(struct datalink_proto *dl);
+struct datalink_proto *make_8023_client(void);
+void destroy_8023_client(struct datalink_proto *dl);
 #endif
-- 
1.8.1.2.459.gbcd45b4.dirty

