Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbaCLRFB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:05:01 -0400
Received: from smtprelay0017.hostedemail.com ([216.40.44.17]:34291 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755317AbaCLRE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:04:57 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1539:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3350:3865:3866:5007:6261:10004:10026:10848:11026:11658:11914:12296:12438:12517:12519:12555:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cakes19_81de91d350a24
X-Filterd-Recvd-Size: 1569
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: Jon Maloy <jon.maloy@ericsson.com>,
        Allan Stephens <allan.stephens@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        tipc-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/6] tipc: Convert uses of __constant_<foo> to <foo>
Date: Wed, 12 Mar 2014 10:04:20 -0700
Message-Id: <3f2447bc68b2fce7aa854eca0f6a1e263ec3669a.1394643455.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1394643455.git.joe@perches.com>
References: <cover.1394643455.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of __constant_<foo> has been unnecessary for quite awhile now.

Make these uses consistent with the rest of the kernel.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/tipc/bearer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index 89c4c2d..7f1f95c 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -575,7 +575,7 @@ static int tipc_l2_device_event(struct notifier_block *nb, unsigned long evt,
 }
 
 static struct packet_type tipc_packet_type __read_mostly = {
-	.type = __constant_htons(ETH_P_TIPC),
+	.type = htons(ETH_P_TIPC),
 	.func = tipc_l2_rcv_msg,
 };
 
-- 
1.8.1.2.459.gbcd45b4.dirty

