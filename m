Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbaATRw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 12:52:56 -0500
Received: from smtprelay0113.hostedemail.com ([216.40.44.113]:59576 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753487AbaATRwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 12:52:41 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,::::::,RULES_HIT:41:355:379:541:800:960:973:981:988:989:1260:1345:1359:1437:1534:1539:1568:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3866:3867:3868:5007:6261:10004:10026:10848:11026:11658:11914:12043:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rule84_3453943276b07
X-Filterd-Recvd-Size: 1535
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] netpoll: Use ether_addr_copy
Date: Mon, 20 Jan 2014 09:52:18 -0800
Message-Id: <3e26b62d1ec7cc3de34efc4ca7651baed7e7f1e3.1390239869.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1390239869.git.joe@perches.com>
References: <cover.1390239869.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ether_addr_copy instead of memcpy(a, b, ETH_ALEN) to
save some cycles on arm and powerpc.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/core/netpoll.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 19fe9c7..c03f3de 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -520,8 +520,8 @@ void netpoll_send_udp(struct netpoll *np, const char *msg, int len)
 		skb->protocol = eth->h_proto = htons(ETH_P_IP);
 	}
 
-	memcpy(eth->h_source, np->dev->dev_addr, ETH_ALEN);
-	memcpy(eth->h_dest, np->remote_mac, ETH_ALEN);
+	ether_addr_copy(eth->h_source, np->dev->dev_addr);
+	ether_addr_copy(eth->h_dest, np->remote_mac);
 
 	skb->dev = np->dev;
 
-- 
1.8.1.2.459.gbcd45b4.dirty

