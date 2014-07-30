Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaG3IgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 04:36:23 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53534 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751381AbaG3IfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 04:35:06 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dmaengine@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 1/3] dmaengine: sun6i: Remove switch statement from buswidth convertion routine
Date: Wed, 30 Jul 2014 10:30:21 +0200
Message-Id: <1406709023-7650-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <1406709023-7650-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1406709023-7650-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the conversion routine is quite trivial, we don't need this switch, and
we can just use a simple calculation.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/sun6i-dma.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/dma/sun6i-dma.c b/drivers/dma/sun6i-dma.c
index c771d90b8ded..609c5d8cb947 100644
--- a/drivers/dma/sun6i-dma.c
+++ b/drivers/dma/sun6i-dma.c
@@ -248,20 +248,11 @@ static inline int convert_burst(u32 maxburst, u8 *burst)
 
 static inline int convert_buswidth(enum dma_slave_buswidth addr_width, u8 *width)
 {
-	switch (addr_width) {
-	case DMA_SLAVE_BUSWIDTH_1_BYTE:
-		*width = 0;
-		break;
-	case DMA_SLAVE_BUSWIDTH_2_BYTES:
-		*width = 1;
-		break;
-	case DMA_SLAVE_BUSWIDTH_4_BYTES:
-		*width = 2;
-		break;
-	default:
+	if ((addr_width < DMA_SLAVE_BUSWIDTH_1_BYTE) ||
+	    (addr_width > DMA_SLAVE_BUSWIDTH_4_BYTES))
 		return -EINVAL;
-	}
 
+	*width = addr_width >> 1;
 	return 0;
 }
 
-- 
2.0.2

