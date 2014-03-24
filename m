Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbaCXUSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 16:18:07 -0400
Received: from smtprelay0231.hostedemail.com ([216.40.44.231]:49801 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754065AbaCXUPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 16:15:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:966:968:973:982:988:989:1260:1345:1359:1437:1534:1540:1711:1714:1730:1747:1777:1792:2196:2199:2393:2559:2562:3138:3139:3140:3141:3142:3351:3865:3866:3867:3871:4321:4385:5007:6119:6261:10004:10026:10848:11026:11657:11658:11914:12043:12296:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: walk57_163bb03fad708
X-Filterd-Recvd-Size: 1669
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: Jay Cliburn <jcliburn@gmail.com>, Chris Snook <chris.snook@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/7] alx: Remove casts of pointer to same type
Date: Mon, 24 Mar 2014 13:15:35 -0700
Message-Id: <b8c7eec08a896af664e5ef18d1278504f450cfee.1395692043.git.joe@perches.com>
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
 drivers/net/ethernet/atheros/alx/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index 2e45f6e..6de1752 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -535,7 +535,7 @@ static int alx_alloc_descriptors(struct alx_priv *alx)
 	if (!alx->descmem.virt)
 		goto out_free;
 
-	alx->txq.tpd = (void *)alx->descmem.virt;
+	alx->txq.tpd = alx->descmem.virt;
 	alx->txq.tpd_dma = alx->descmem.dma;
 
 	/* alignment requirement for next block */
-- 
1.8.1.2.459.gbcd45b4.dirty

