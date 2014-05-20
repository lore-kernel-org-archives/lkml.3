Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbaETQfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:35:44 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:52088 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745AbaETQfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:35:43 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtEWAP+De1NbsnsG/2dsb2JhbABZgwarCAQBAQEBAQEFAYM6lm4CAoEcF3SCUxM/GIECJBOIRQHUGoVViHmERwEDjzyKKwGTIIF4gUI7
Date: Tue, 20 May 2014 18:35:41 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Brett Rudley <brudley@broadcom.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] drivers/net/wireless/brcm80211/brcmsmac/dma.c: replace
 shift loop by ilog2
Message-Id: <20140520183541.c6430e790225b202ede048c9@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't open code ilog2 -> remove dma_align_sizetobits

Cc: Brett Rudley <brudley@broadcom.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/wireless/brcm80211/brcmsmac/dma.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
index 4fb9635..7128c78 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
@@ -451,15 +451,6 @@ static void *dma_alloc_consistent(struct dma_info *di, uint size,
 	return dma_alloc_coherent(di->dmadev, size, pap, GFP_ATOMIC);
 }
 
-static
-u8 dma_align_sizetobits(uint size)
-{
-	u8 bitpos = 0;
-	while (size >>= 1)
-		bitpos++;
-	return bitpos;
-}
-
 /* This function ensures that the DMA descriptor ring will not get allocated
  * across Page boundary. If the allocation is done across the page boundary
  * at the first time, then it is freed and the allocation is done at
@@ -482,7 +473,7 @@ static void *dma_ringalloc(struct dma_info *di, u32 boundary, uint size,
 	desc_strtaddr = (u32) roundup((unsigned long)va, alignbytes);
 	if (((desc_strtaddr + size - 1) & boundary) != (desc_strtaddr
 							& boundary)) {
-		*alignbits = dma_align_sizetobits(size);
+		*alignbits = ilog2(size);
 		dma_free_coherent(di->dmadev, size, va, *descpa);
 		va = dma_alloc_consistent(di, size, *alignbits,
 			alloced, descpa);
-- 
1.8.4.5

