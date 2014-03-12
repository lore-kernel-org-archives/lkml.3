Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbaCLREw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:04:52 -0400
Received: from smtprelay0034.hostedemail.com ([216.40.44.34]:35224 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755243AbaCLREr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:04:47 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:4321:5007:6261:10004:10026:10848:11026:11658:11914:12043:12296:12438:12517:12519:12555:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: flame31_80e6240612a12
X-Filterd-Recvd-Size: 2062
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-zigbee-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/6] ieee802154: Convert uses of __constant_<foo> to <foo>
Date: Wed, 12 Mar 2014 10:04:18 -0700
Message-Id: <5e8be8d647e70ad422eb686d315f93b3e265e9c6.1394643455.git.joe@perches.com>
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
 net/ieee802154/6lowpan_rtnl.c  | 2 +-
 net/ieee802154/af_ieee802154.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ieee802154/6lowpan_rtnl.c b/net/ieee802154/6lowpan_rtnl.c
index 1bbab89..48a8f52 100644
--- a/net/ieee802154/6lowpan_rtnl.c
+++ b/net/ieee802154/6lowpan_rtnl.c
@@ -613,7 +613,7 @@ static struct notifier_block lowpan_dev_notifier = {
 };
 
 static struct packet_type lowpan_packet_type = {
-	.type = __constant_htons(ETH_P_IEEE802154),
+	.type = htons(ETH_P_IEEE802154),
 	.func = lowpan_rcv,
 };
 
diff --git a/net/ieee802154/af_ieee802154.c b/net/ieee802154/af_ieee802154.c
index 40e606f..a56ab9c 100644
--- a/net/ieee802154/af_ieee802154.c
+++ b/net/ieee802154/af_ieee802154.c
@@ -326,7 +326,7 @@ drop:
 
 
 static struct packet_type ieee802154_packet_type = {
-	.type = __constant_htons(ETH_P_IEEE802154),
+	.type = htons(ETH_P_IEEE802154),
 	.func = ieee802154_rcv,
 };
 
-- 
1.8.1.2.459.gbcd45b4.dirty

