Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab3KEWNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 17:13:49 -0500
Received: from smtprelay0169.hostedemail.com ([216.40.44.169]:51838 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755048Ab3KEWNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 17:13:47 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3866:3874:4277:4321:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12517:12519:12555:13069:13138:13231:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rifle96_5b0ee5b3cb642
X-Filterd-Recvd-Size: 1742
Message-ID: <1383689627.28624.3.camel@joe-AO722>
Subject: [PATCH net-next trivial] udp: Remove unnecessary semicolon from
 do{}while (0) macro
From: Joe Perches <joe@perches.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 05 Nov 2013 14:13:47 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just an unnecessary semicolon that should be removed...

Whitespace neatening of macro too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/net/udp.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/net/udp.h b/include/net/udp.h
index fe4ba9f..a24f0f3 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -230,13 +230,13 @@ struct sock *__udp6_lib_lookup(struct net *net,
 } while(0)
 
 #if IS_ENABLED(CONFIG_IPV6)
-#define UDPX_INC_STATS_BH(sk, field) \
-	do { \
-		if ((sk)->sk_family == AF_INET) \
-			UDP_INC_STATS_BH(sock_net(sk), field, 0); \
-		else \
-			UDP6_INC_STATS_BH(sock_net(sk), field, 0); \
-	} while (0);
+#define UDPX_INC_STATS_BH(sk, field)					\
+do {									\
+	if ((sk)->sk_family == AF_INET)					\
+		UDP_INC_STATS_BH(sock_net(sk), field, 0);		\
+	else								\
+		UDP6_INC_STATS_BH(sock_net(sk), field, 0);		\
+} while (0)
 #else
 #define UDPX_INC_STATS_BH(sk, field) UDP_INC_STATS_BH(sock_net(sk), field, 0)
 #endif


