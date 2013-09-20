Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab3ITSYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 14:24:36 -0400
Received: from smtprelay0024.hostedemail.com ([216.40.44.24]:53904 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753682Ab3ITSX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 14:23:57 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3870:3871:5007:6261:7903:10004:10026:10848:11658:11914:12517:12519:12555:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: feast57_3f6e1c93b205a
X-Filterd-Recvd-Size: 2073
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 11/11] icmp.h: Remove extern from function prototypes
Date: Fri, 20 Sep 2013 11:23:28 -0700
Message-Id: <17d39f6b9a415d0c9d7a0235060f6061cffa451f.1379701322.git.joe@perches.com>
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
 include/net/icmp.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/icmp.h b/include/net/icmp.h
index 081439f..970028e 100644
--- a/include/net/icmp.h
+++ b/include/net/icmp.h
@@ -39,10 +39,10 @@ struct net_proto_family;
 struct sk_buff;
 struct net;
 
-extern void	icmp_send(struct sk_buff *skb_in,  int type, int code, __be32 info);
-extern int	icmp_rcv(struct sk_buff *skb);
-extern void	icmp_err(struct sk_buff *, u32 info);
-extern int	icmp_init(void);
-extern void	icmp_out_count(struct net *net, unsigned char type);
+void icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info);
+int icmp_rcv(struct sk_buff *skb);
+void icmp_err(struct sk_buff *skb, u32 info);
+int icmp_init(void);
+void icmp_out_count(struct net *net, unsigned char type);
 
 #endif	/* _ICMP_H */
-- 
1.8.1.2.459.gbcd45b4.dirty

