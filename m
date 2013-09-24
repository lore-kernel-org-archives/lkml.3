Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab3IXVKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 17:10:43 -0400
Received: from smtprelay0236.hostedemail.com ([216.40.44.236]:56335 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754815Ab3IXVKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 17:10:40 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3870:3871:5007:6117:6261:7903:10004:10026:10848:11473:11657:11658:11914:12043:12517:12519:12555:13161:13229:13311:13357:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: drain87_5b28a1d6b12b
X-Filterd-Recvd-Size: 2261
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 07/10] ti: Remove extern from function prototypes
Date: Tue, 24 Sep 2013 14:10:01 -0700
Message-Id: <95f7f1519d5b1ad7c51b3ac561a0903462202d36.1380056108.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1380056108.git.joe@perches.com>
References: <cover.1380056108.git.joe@perches.com>
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
 drivers/net/ethernet/ti/cpts.h | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpts.h b/drivers/net/ethernet/ti/cpts.h
index fe993cd..1a581ef 100644
--- a/drivers/net/ethernet/ti/cpts.h
+++ b/drivers/net/ethernet/ti/cpts.h
@@ -127,8 +127,8 @@ struct cpts {
 };
 
 #ifdef CONFIG_TI_CPTS
-extern void cpts_rx_timestamp(struct cpts *cpts, struct sk_buff *skb);
-extern void cpts_tx_timestamp(struct cpts *cpts, struct sk_buff *skb);
+void cpts_rx_timestamp(struct cpts *cpts, struct sk_buff *skb);
+void cpts_tx_timestamp(struct cpts *cpts, struct sk_buff *skb);
 #else
 static inline void cpts_rx_timestamp(struct cpts *cpts, struct sk_buff *skb)
 {
@@ -138,8 +138,7 @@ static inline void cpts_tx_timestamp(struct cpts *cpts, struct sk_buff *skb)
 }
 #endif
 
-extern int cpts_register(struct device *dev, struct cpts *cpts,
-			 u32 mult, u32 shift);
-extern void cpts_unregister(struct cpts *cpts);
+int cpts_register(struct device *dev, struct cpts *cpts, u32 mult, u32 shift);
+void cpts_unregister(struct cpts *cpts);
 
 #endif
-- 
1.8.1.2.459.gbcd45b4.dirty

