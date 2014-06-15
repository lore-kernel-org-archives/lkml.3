Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbaFOUlh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 16:41:37 -0400
Received: from smtprelay0025.hostedemail.com ([216.40.44.25]:47810 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752793AbaFOUjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 16:39:10 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:4321:5007:6261:10004:10026:10848:11026:11473:11658:11914:12043:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: size24_6ce98ad3b2120
X-Filterd-Recvd-Size: 2447
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: qla2xxx-upstream@qlogic.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH -next 22/26] qla2xxx: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:51 -0700
Message-Id: <5e845f43a014ad7dd4ab3a4fdcd95b879bc496ef.1402863905.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1402863904.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e218441..46990f4 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1526,8 +1526,8 @@ try_fce:
 			    FCE_SIZE, ha->fce, ha->fce_dma);
 
 		/* Allocate memory for Fibre Channel Event Buffer. */
-		tc = dma_alloc_coherent(&ha->pdev->dev, FCE_SIZE, &tc_dma,
-		    GFP_KERNEL);
+		tc = dma_zalloc_coherent(&ha->pdev->dev, FCE_SIZE, &tc_dma,
+					 GFP_KERNEL);
 		if (!tc) {
 			ql_log(ql_log_warn, vha, 0x00be,
 			    "Unable to allocate (%d KB) for FCE.\n",
@@ -1535,7 +1535,6 @@ try_fce:
 			goto try_eft;
 		}
 
-		memset(tc, 0, FCE_SIZE);
 		rval = qla2x00_enable_fce_trace(vha, tc_dma, FCE_NUM_BUFFERS,
 		    ha->fce_mb, &ha->fce_bufs);
 		if (rval) {
@@ -1560,8 +1559,8 @@ try_eft:
 			    EFT_SIZE, ha->eft, ha->eft_dma);
 
 		/* Allocate memory for Extended Trace Buffer. */
-		tc = dma_alloc_coherent(&ha->pdev->dev, EFT_SIZE, &tc_dma,
-		    GFP_KERNEL);
+		tc = dma_zalloc_coherent(&ha->pdev->dev, EFT_SIZE, &tc_dma,
+					 GFP_KERNEL);
 		if (!tc) {
 			ql_log(ql_log_warn, vha, 0x00c1,
 			    "Unable to allocate (%d KB) for EFT.\n",
@@ -1569,7 +1568,6 @@ try_eft:
 			goto cont_alloc;
 		}
 
-		memset(tc, 0, EFT_SIZE);
 		rval = qla2x00_enable_eft_trace(vha, tc_dma, EFT_NUM_BUFFERS);
 		if (rval) {
 			ql_log(ql_log_warn, vha, 0x00c2,
-- 
1.8.1.2.459.gbcd45b4.dirty

