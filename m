Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbaFWNno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:43:44 -0400
Received: from smtprelay0082.hostedemail.com ([216.40.44.82]:45142 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755405AbaFWNn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:43:28 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3867:4321:4419:5007:6119:6261:7875:9592:10004:10026:10848:11026:11473:11658:11914:12043:12114:12296:12438:12517:12519:12555,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: group98_4bb7e88251a
X-Filterd-Recvd-Size: 2879
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Martyn Welch <martyn.welch@ge.com>,
        Manohar Vanga <manohar.vanga@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 22/22] vme: bridges: Use pci_zalloc_consistent
Date: Mon, 23 Jun 2014 06:41:50 -0700
Message-Id: <19d9cd323d43bdb25425356d87e50de23855a1d4.1403530604.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1403530604.git.joe@perches.com>
References: <cover.1403530604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/vme/bridges/vme_ca91cx42.c | 6 ++----
 drivers/vme/bridges/vme_tsi148.c   | 6 ++----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/vme/bridges/vme_ca91cx42.c b/drivers/vme/bridges/vme_ca91cx42.c
index bfb2d3f..18078ec 100644
--- a/drivers/vme/bridges/vme_ca91cx42.c
+++ b/drivers/vme/bridges/vme_ca91cx42.c
@@ -1555,16 +1555,14 @@ static int ca91cx42_crcsr_init(struct vme_bridge *ca91cx42_bridge,
 	}
 
 	/* Allocate mem for CR/CSR image */
-	bridge->crcsr_kernel = pci_alloc_consistent(pdev, VME_CRCSR_BUF_SIZE,
-		&bridge->crcsr_bus);
+	bridge->crcsr_kernel = pci_zalloc_consistent(pdev, VME_CRCSR_BUF_SIZE,
+						     &bridge->crcsr_bus);
 	if (bridge->crcsr_kernel == NULL) {
 		dev_err(&pdev->dev, "Failed to allocate memory for CR/CSR "
 			"image\n");
 		return -ENOMEM;
 	}
 
-	memset(bridge->crcsr_kernel, 0, VME_CRCSR_BUF_SIZE);
-
 	crcsr_addr = slot * (512 * 1024);
 	iowrite32(bridge->crcsr_bus - crcsr_addr, bridge->base + VCSR_TO);
 
diff --git a/drivers/vme/bridges/vme_tsi148.c b/drivers/vme/bridges/vme_tsi148.c
index 61e706c..e07cfa8 100644
--- a/drivers/vme/bridges/vme_tsi148.c
+++ b/drivers/vme/bridges/vme_tsi148.c
@@ -2275,16 +2275,14 @@ static int tsi148_crcsr_init(struct vme_bridge *tsi148_bridge,
 	bridge = tsi148_bridge->driver_priv;
 
 	/* Allocate mem for CR/CSR image */
-	bridge->crcsr_kernel = pci_alloc_consistent(pdev, VME_CRCSR_BUF_SIZE,
-		&bridge->crcsr_bus);
+	bridge->crcsr_kernel = pci_zalloc_consistent(pdev, VME_CRCSR_BUF_SIZE,
+						     &bridge->crcsr_bus);
 	if (bridge->crcsr_kernel == NULL) {
 		dev_err(tsi148_bridge->parent, "Failed to allocate memory for "
 			"CR/CSR image\n");
 		return -ENOMEM;
 	}
 
-	memset(bridge->crcsr_kernel, 0, VME_CRCSR_BUF_SIZE);
-
 	reg_split(bridge->crcsr_bus, &crcsr_bus_high, &crcsr_bus_low);
 
 	iowrite32be(crcsr_bus_high, bridge->base + TSI148_LCSR_CROU);
-- 
1.8.1.2.459.gbcd45b4.dirty

