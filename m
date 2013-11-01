Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab3KALgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 07:36:53 -0400
Received: from mail-db8lp0188.outbound.messaging.microsoft.com ([213.199.154.188]:13232
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751792Ab3KALgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 07:36:50 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6h1082kz70kz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h1155h)
From: Nicolin Chen <b42378@freescale.com>
To: <akpm@linux-foundation.org>, <joe@perches.com>, <nsekhar@ti.com>,
        <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <dan.j.williams@intel.com>, <vinod.koul@intel.com>,
        <m.chehab@samsung.com>, <hjk@hansjkoch.de>,
        <gregkh@linuxfoundation.org>, <perex@perex.cz>, <tiwai@suse.de>,
        <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <rmk+kernel@arm.linux.org.uk>, <eric.y.miao@gmail.com>,
        <haojian.zhuang@gmail.com>
CC: <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <dmaengine@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <alsa-devel@alsa-project.org>
Subject: [PATCH 5/8] uio: uio_pruss: use gen_pool_dma_alloc() to allocate sram memory
Date: Fri, 1 Nov 2013 19:36:03 +0800
Message-ID: <f26a7fd466d22aaaeae9cf32d3c4c43c333e0b35.1383303752.git.b42378@freescale.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1383303752.git.b42378@freescale.com>
References: <cover.1383303752.git.b42378@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since gen_pool_dma_alloc() is introduced, we implement it to simplify code.

Signed-off-by: Nicolin Chen <b42378@freescale.com>
---
 drivers/uio/uio_pruss.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/uio/uio_pruss.c b/drivers/uio/uio_pruss.c
index f519da9..96c4a19 100644
--- a/drivers/uio/uio_pruss.c
+++ b/drivers/uio/uio_pruss.c
@@ -158,14 +158,12 @@ static int pruss_probe(struct platform_device *dev)
 	if (pdata->sram_pool) {
 		gdev->sram_pool = pdata->sram_pool;
 		gdev->sram_vaddr =
-			gen_pool_alloc(gdev->sram_pool, sram_pool_sz);
+			(unsigned long)gen_pool_dma_alloc(gdev->sram_pool,
+					sram_pool_sz, &gdev->sram_paddr);
 		if (!gdev->sram_vaddr) {
 			dev_err(&dev->dev, "Could not allocate SRAM pool\n");
 			goto out_free;
 		}
-		gdev->sram_paddr =
-			gen_pool_virt_to_phys(gdev->sram_pool,
-					      gdev->sram_vaddr);
 	}
 
 	gdev->ddr_vaddr = dma_alloc_coherent(&dev->dev, extram_pool_sz,
-- 
1.8.4


