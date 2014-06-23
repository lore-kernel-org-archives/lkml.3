Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbaFWNmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:42:13 -0400
Received: from smtprelay0193.hostedemail.com ([216.40.44.193]:54163 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753998AbaFWNmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:42:09 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:966:968:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:1981:2194:2196:2199:2200:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3867:3868:4321:4385:4605:5007:6261:8603:10004:10026:10848:11026:11658:11914:12043:12114:12296:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wood23_86ee517146c53
X-Filterd-Recvd-Size: 1765
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
Subject: [PATCH 01/22] pci-dma-compat: Add pci_zalloc_consistent helper
Date: Mon, 23 Jun 2014 06:41:29 -0700
Message-Id: <2248b3ffe86cd8995a809bf7e2871f38039979c1.1403530604.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1403530604.git.joe@perches.com>
References: <cover.1403530604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add this helper for consistency with pci_zalloc_coherent
and the ability to remove unnecessary memset(,0,) uses.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-generic/pci-dma-compat.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/asm-generic/pci-dma-compat.h b/include/asm-generic/pci-dma-compat.h
index 1437b7d..c110843 100644
--- a/include/asm-generic/pci-dma-compat.h
+++ b/include/asm-generic/pci-dma-compat.h
@@ -19,6 +19,14 @@ pci_alloc_consistent(struct pci_dev *hwdev, size_t size,
 	return dma_alloc_coherent(hwdev == NULL ? NULL : &hwdev->dev, size, dma_handle, GFP_ATOMIC);
 }
 
+static inline void *
+pci_zalloc_consistent(struct pci_dev *hwdev, size_t size,
+		      dma_addr_t *dma_handle)
+{
+	return dma_zalloc_coherent(hwdev == NULL ? NULL : &hwdev->dev,
+				   size, dma_handle, GFP_ATOMIC);
+}
+
 static inline void
 pci_free_consistent(struct pci_dev *hwdev, size_t size,
 		    void *vaddr, dma_addr_t dma_handle)
-- 
1.8.1.2.459.gbcd45b4.dirty

