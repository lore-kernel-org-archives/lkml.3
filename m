Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbaBRRnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 12:43:32 -0500
Received: from smtprelay0179.hostedemail.com ([216.40.44.179]:59102 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754886AbaBRRmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 12:42:54 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1540:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3351:3868:3870:3872:5007:6261:10004:10026:10848:11026:11658:11914:12043:12296:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: card09_36403e5baba5a
X-Filterd-Recvd-Size: 1724
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: Jay Vosburgh <fubar@us.ibm.com>, Veaceslav Falico <vfalico@redhat.com>,
        Andy Gospodarek <andy@greyhouse.net>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/3] bonding: Remove unnecessary else
Date: Tue, 18 Feb 2014 09:42:46 -0800
Message-Id: <3df50662c3e4dab1f7e97f5f9ad985b5c116bc76.1392745014.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1392745013.git.joe@perches.com>
References: <cover.1392745013.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's unnecessary and less readable after a clause ending in a goto.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/bonding/bond_alb.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 97a43a20..aaeeacf 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1455,12 +1455,12 @@ int bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
 
 		bond_dev_queue_xmit(bond, skb, tx_slave->dev);
 		goto out;
-	} else {
-		if (tx_slave) {
-			_lock_tx_hashtbl(bond);
-			__tlb_clear_slave(bond, tx_slave, 0);
-			_unlock_tx_hashtbl(bond);
-		}
+	}
+
+	if (tx_slave) {
+		_lock_tx_hashtbl(bond);
+		__tlb_clear_slave(bond, tx_slave, 0);
+		_unlock_tx_hashtbl(bond);
 	}
 
 	/* no suitable interface, frame not sent */
-- 
1.8.1.2.459.gbcd45b4.dirty

