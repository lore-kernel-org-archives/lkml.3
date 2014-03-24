Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbaCXUP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 16:15:56 -0400
Received: from smtprelay0121.hostedemail.com ([216.40.44.121]:49795 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753671AbaCXUPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 16:15:52 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:968:973:982:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:3871:5007:6261:10004:10026:10848:11026:11657:11658:11914:12043:12296:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: can33_15e2c33ddce00
X-Filterd-Recvd-Size: 2104
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: nios2-dev@lists.rocketboards.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/7] altera: Remove casts of pointer to same type
Date: Mon, 24 Mar 2014 13:15:34 -0700
Message-Id: <b3437e88a3d02c3ee8b9378b5801471a38cf24c5.1395692043.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1395692043.git.joe@perches.com>
References: <cover.1395692043.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casting a pointer to a pointer of the same type is pointless,
so remove these unnecessary casts.

Done via coccinelle script:

$ cat typecast_2.cocci
@@
type T;
T *foo;
@@

-	(T *)foo
+	foo

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/altera/altera_tse_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 6006ef2..c70a29e 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -933,7 +933,7 @@ static int tse_change_mtu(struct net_device *dev, int new_mtu)
 static void altera_tse_set_mcfilter(struct net_device *dev)
 {
 	struct altera_tse_private *priv = netdev_priv(dev);
-	struct altera_tse_mac *mac = (struct altera_tse_mac *)priv->mac_dev;
+	struct altera_tse_mac *mac = priv->mac_dev;
 	int i;
 	struct netdev_hw_addr *ha;
 
@@ -963,7 +963,7 @@ static void altera_tse_set_mcfilter(struct net_device *dev)
 static void altera_tse_set_mcfilterall(struct net_device *dev)
 {
 	struct altera_tse_private *priv = netdev_priv(dev);
-	struct altera_tse_mac *mac = (struct altera_tse_mac *)priv->mac_dev;
+	struct altera_tse_mac *mac = priv->mac_dev;
 	int i;
 
 	/* set the hash filter */
-- 
1.8.1.2.459.gbcd45b4.dirty

