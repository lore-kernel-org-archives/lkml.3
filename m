Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab3ITSXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 14:23:46 -0400
Received: from smtprelay0117.hostedemail.com ([216.40.44.117]:41457 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752114Ab3ITSXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 14:23:43 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1540:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3870:3871:5007:6261:7903:10004:10026:10848:11658:11914:12517:12519:12555:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bat94_3d6c109f4283a
X-Filterd-Recvd-Size: 1678
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 05/11] esp.h: Remove extern from function prototypes
Date: Fri, 20 Sep 2013 11:23:22 -0700
Message-Id: <8a4f63b62ceebd21866d23ee959be7e6e571b736.1379701322.git.joe@perches.com>
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
 include/net/esp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/esp.h b/include/net/esp.h
index d584513..1356dda 100644
--- a/include/net/esp.h
+++ b/include/net/esp.h
@@ -13,7 +13,7 @@ struct esp_data {
 	struct crypto_aead *aead;
 };
 
-extern void *pskb_put(struct sk_buff *skb, struct sk_buff *tail, int len);
+void *pskb_put(struct sk_buff *skb, struct sk_buff *tail, int len);
 
 struct ip_esp_hdr;
 
-- 
1.8.1.2.459.gbcd45b4.dirty

