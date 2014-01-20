Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaATRwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 12:52:34 -0500
Received: from smtprelay0249.hostedemail.com ([216.40.44.249]:39179 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752156AbaATRw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 12:52:29 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,::::::::,RULES_HIT:41:355:379:541:800:960:973:981:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3866:3867:3868:4321:5007:6261:10004:10026:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: room17_3299ec1726055
X-Filterd-Recvd-Size: 2595
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] 8021q: Use ether_addr_copy
Date: Mon, 20 Jan 2014 09:52:14 -0800
Message-Id: <d925be29591181e70c54abb79d514c87ac8feb06.1390239869.git.joe@perches.com>
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
 net/8021q/vlan.c     | 2 +-
 net/8021q/vlan_dev.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index b3d17d1..ec99099 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -301,7 +301,7 @@ static void vlan_sync_address(struct net_device *dev,
 	    !ether_addr_equal(vlandev->dev_addr, dev->dev_addr))
 		dev_uc_add(dev, vlandev->dev_addr);
 
-	memcpy(vlan->real_dev_addr, dev->dev_addr, ETH_ALEN);
+	ether_addr_copy(vlan->real_dev_addr, dev->dev_addr);
 }
 
 static void vlan_transfer_features(struct net_device *dev,
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 47c908f..de51c48 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -61,7 +61,7 @@ static int vlan_dev_rebuild_header(struct sk_buff *skb)
 		pr_debug("%s: unable to resolve type %X addresses\n",
 			 dev->name, ntohs(veth->h_vlan_encapsulated_proto));
 
-		memcpy(veth->h_source, dev->dev_addr, ETH_ALEN);
+		ether_addr_copy(veth->h_source, dev->dev_addr);
 		break;
 	}
 
@@ -303,7 +303,7 @@ static int vlan_dev_open(struct net_device *dev)
 			goto clear_allmulti;
 	}
 
-	memcpy(vlan->real_dev_addr, real_dev->dev_addr, ETH_ALEN);
+	ether_addr_copy(vlan->real_dev_addr, real_dev->dev_addr);
 
 	if (vlan->flags & VLAN_FLAG_GVRP)
 		vlan_gvrp_request_join(dev);
@@ -367,7 +367,7 @@ static int vlan_dev_set_mac_address(struct net_device *dev, void *p)
 		dev_uc_del(real_dev, dev->dev_addr);
 
 out:
-	memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
+	ether_addr_copy(dev->dev_addr, addr->sa_data);
 	return 0;
 }
 
-- 
1.8.1.2.459.gbcd45b4.dirty

