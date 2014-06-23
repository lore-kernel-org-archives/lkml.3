Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbaFWNtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:49:49 -0400
Received: from smtprelay0109.hostedemail.com ([216.40.44.109]:59100 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754620AbaFWNmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:42:24 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:968:973:982:988:989:1260:1345:1359:1437:1534:1540:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3350:3865:3867:4321:4419:4605:5007:6261:10004:10026:10848:11026:11658:11914:12114:12296:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: owl60_8820df08d8903
X-Filterd-Recvd-Size: 1708
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Subject: [PATCH 04/22] crypto: Use pci_zalloc_consistent
Date: Mon, 23 Jun 2014 06:41:32 -0700
Message-Id: <774846b64fca6521637a4a4dec7161daa3df19fe.1403530604.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1403530604.git.joe@perches.com>
References: <cover.1403530604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/crypto/hifn_795x.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 12fea3e..8d2a772 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -2617,14 +2617,13 @@ static int hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		}
 	}
 
-	dev->desc_virt = pci_alloc_consistent(pdev, sizeof(struct hifn_dma),
-			&dev->desc_dma);
+	dev->desc_virt = pci_zalloc_consistent(pdev, sizeof(struct hifn_dma),
+					       &dev->desc_dma);
 	if (!dev->desc_virt) {
 		dprintk("Failed to allocate descriptor rings.\n");
 		err = -ENOMEM;
 		goto err_out_unmap_bars;
 	}
-	memset(dev->desc_virt, 0, sizeof(struct hifn_dma));
 
 	dev->pdev = pdev;
 	dev->irq = pdev->irq;
-- 
1.8.1.2.459.gbcd45b4.dirty

