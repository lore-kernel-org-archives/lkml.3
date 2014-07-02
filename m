Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbaGBN3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:29:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37297 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043AbaGBN3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:29:43 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>, <lars@metafoo.de>,
        <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, <joelf@ti.com>, <nsekhar@ti.com>
CC: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <dmaengine@vger.kernel.org>
Subject: [PATCH v2 1/5] dma: Support for 3 bytes word size
Date: Wed, 2 Jul 2014 16:29:19 +0300
Message-ID: <1404307763-30557-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404307763-30557-1-git-send-email-peter.ujfalusi@ti.com>
References: <1404307763-30557-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DMA_SLAVE_BUSWIDTH_3_BYTES to dma_slave_buswidth for engines and users
to select 3 bytes as bus width.
For example eDMA can be configured to use 3bytes mode and in audio we have
formats stored on 3bytes in memory (_XXX_3LE) where this new bus width can
be used.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 include/linux/dmaengine.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index d2c5cc7c583c..3d1c2aa51530 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -299,6 +299,7 @@ enum dma_slave_buswidth {
 	DMA_SLAVE_BUSWIDTH_UNDEFINED = 0,
 	DMA_SLAVE_BUSWIDTH_1_BYTE = 1,
 	DMA_SLAVE_BUSWIDTH_2_BYTES = 2,
+	DMA_SLAVE_BUSWIDTH_3_BYTES = 3,
 	DMA_SLAVE_BUSWIDTH_4_BYTES = 4,
 	DMA_SLAVE_BUSWIDTH_8_BYTES = 8,
 };
-- 
2.0.0

