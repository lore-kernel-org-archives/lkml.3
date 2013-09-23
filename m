Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab3IWWNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 18:13:51 -0400
Received: from smtprelay0253.hostedemail.com ([216.40.44.253]:48427 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752406Ab3IWWLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 18:11:48 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3870:3871:4321:5007:6261:7903:10004:10026:10848:11026:11473:11657:11658:11914:12043:12438:12517:12519:12555:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: face54_2ca6ddc1a0d56
X-Filterd-Recvd-Size: 2366
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 04/10] amd/7990: Remove extern from function prototypes
Date: Mon, 23 Sep 2013 15:11:31 -0700
Message-Id: <65ef2eba58fddc268ba0afb4de7757f073d3bb49.1379974101.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <5570169a078375fa8662adeb2a7f24c1ae718bfb.1379974101.git.joe@perches.com>
References: <5570169a078375fa8662adeb2a7f24c1ae718bfb.1379974101.git.joe@perches.com>
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
 drivers/net/ethernet/amd/7990.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/amd/7990.h b/drivers/net/ethernet/amd/7990.h
index 0a5837b..ae33a99 100644
--- a/drivers/net/ethernet/amd/7990.h
+++ b/drivers/net/ethernet/amd/7990.h
@@ -242,14 +242,13 @@ struct lance_private
 #define LANCE_ADDR(x) ((int)(x) & ~0xff000000)
 
 /* Now the prototypes we export */
-extern int lance_open(struct net_device *dev);
-extern int lance_close (struct net_device *dev);
-extern int lance_start_xmit (struct sk_buff *skb, struct net_device *dev);
-extern void lance_set_multicast (struct net_device *dev);
-extern void lance_tx_timeout(struct net_device *dev);
+int lance_open(struct net_device *dev);
+int lance_close(struct net_device *dev);
+int lance_start_xmit(struct sk_buff *skb, struct net_device *dev);
+void lance_set_multicast(struct net_device *dev);
+void lance_tx_timeout(struct net_device *dev);
 #ifdef CONFIG_NET_POLL_CONTROLLER
-extern void lance_poll(struct net_device *dev);
+void lance_poll(struct net_device *dev);
 #endif
 
 #endif /* ndef _7990_H */
-- 
1.8.1.2.459.gbcd45b4.dirty

