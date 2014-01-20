Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbaATRxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 12:53:00 -0500
Received: from smtprelay0101.hostedemail.com ([216.40.44.101]:36064 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753568AbaATRwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 12:52:47 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,::::::,RULES_HIT:41:355:379:541:800:960:973:981:988:989:1260:1345:1359:1437:1534:1539:1567:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3866:3867:3868:4321:5007:6261:10004:10026:10848:11026:11658:11914:12043:12296:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: berry56_3523ff4a3c511
X-Filterd-Recvd-Size: 1387
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] dsa: Use ether_addr_copy
Date: Mon, 20 Jan 2014 09:52:20 -0800
Message-Id: <3c33df937d3cf83447bad0d6d219bdf66b629735.1390239869.git.joe@perches.com>
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
 net/dsa/slave.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 29d684e..02c0e17 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -156,7 +156,7 @@ static int dsa_slave_set_mac_address(struct net_device *dev, void *a)
 		dev_uc_del(master, dev->dev_addr);
 
 out:
-	memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
+	ether_addr_copy(dev->dev_addr, addr->sa_data);
 
 	return 0;
 }
-- 
1.8.1.2.459.gbcd45b4.dirty

