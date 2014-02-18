Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbaBRRm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 12:42:59 -0500
Received: from smtprelay0054.hostedemail.com ([216.40.44.54]:59118 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754932AbaBRRm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 12:42:56 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:4321:5007:6261:9592:10004:10026:10848:11026:11658:11914:12043:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: apple60_36970ef75655e
X-Filterd-Recvd-Size: 2249
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: Jay Vosburgh <fubar@us.ibm.com>, Veaceslav Falico <vfalico@redhat.com>,
        Andy Gospodarek <andy@greyhouse.net>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/3] bonding: Invert test
Date: Tue, 18 Feb 2014 09:42:47 -0800
Message-Id: <63cf685f6be365b2eff54db6bc1c6a3939983bd7.1392745014.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1392745013.git.joe@perches.com>
References: <cover.1392745013.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the error case return early.
Make the normal return at the bottom of the function.
Reduces indent for readability.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/bonding/bond_3ad.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 7cb51f9..a0e12369 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -2381,17 +2381,16 @@ int __bond_3ad_get_active_agg_info(struct bonding *bond,
 		}
 	}
 
-	if (aggregator) {
-		ad_info->aggregator_id = aggregator->aggregator_identifier;
-		ad_info->ports = aggregator->num_of_ports;
-		ad_info->actor_key = aggregator->actor_oper_aggregator_key;
-		ad_info->partner_key = aggregator->partner_oper_aggregator_key;
-		ether_addr_copy(ad_info->partner_system,
-				aggregator->partner_system.mac_addr_value);
-		return 0;
-	}
-
-	return -1;
+	if (!aggregator)
+		return -1;
+
+	ad_info->aggregator_id = aggregator->aggregator_identifier;
+	ad_info->ports = aggregator->num_of_ports;
+	ad_info->actor_key = aggregator->actor_oper_aggregator_key;
+	ad_info->partner_key = aggregator->partner_oper_aggregator_key;
+	ether_addr_copy(ad_info->partner_system,
+			aggregator->partner_system.mac_addr_value);
+	return 0;
 }
 
 /* Wrapper used to hold bond->lock so no slave manipulation can occur */
-- 
1.8.1.2.459.gbcd45b4.dirty

