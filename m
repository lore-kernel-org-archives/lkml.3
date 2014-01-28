Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbaA1SuB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 13:50:01 -0500
Received: from smtprelay0047.hostedemail.com ([216.40.44.47]:48222 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754321AbaA1SuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 13:50:00 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1539:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3876:3877:5007:6114:6642:7652:10004:10400:10848:11026:11473:11658:11914:12043:12438:12517:12519:12555:13069:13161:13229:13311:13357:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: front88_913cf59f9de14
X-Filterd-Recvd-Size: 1471
Message-ID: <1390934997.11756.17.camel@joe-AO722>
Subject: [PATCH] omap: iommu: Fix decimal permissions
From: Joe Perches <joe@perches.com>
To: Joerg Roedel <joro@8bytes.org>, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Cc: iommu <iommu@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 28 Jan 2014 10:49:57 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These should have been octal

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/iommu/omap-iommu-debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/omap-iommu-debug.c b/drivers/iommu/omap-iommu-debug.c
index d97fbe4..80fffba 100644
--- a/drivers/iommu/omap-iommu-debug.c
+++ b/drivers/iommu/omap-iommu-debug.c
@@ -354,8 +354,8 @@ DEBUG_FOPS(mem);
 			return -ENOMEM;					\
 	}
 
-#define DEBUG_ADD_FILE(name) __DEBUG_ADD_FILE(name, 600)
-#define DEBUG_ADD_FILE_RO(name) __DEBUG_ADD_FILE(name, 400)
+#define DEBUG_ADD_FILE(name) __DEBUG_ADD_FILE(name, 0600)
+#define DEBUG_ADD_FILE_RO(name) __DEBUG_ADD_FILE(name, 0400)
 
 static int iommu_debug_register(struct device *dev, void *data)
 {


