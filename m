Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab3KALuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 07:50:39 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:42006
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752372Ab3KALsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 07:48:53 -0400
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
Subject: [PATCH][RESEND 4/8] [media] coda: use gen_pool_dma_alloc() to allocate iram buffer
Date: Fri, 1 Nov 2013 19:48:17 +0800
Message-ID: <a4cb5380b1eeb1c634cedfe05d2a7dee950742a4.1383306365.git.b42378@freescale.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1383306365.git.b42378@freescale.com>
References: <cover.1383306365.git.b42378@freescale.com>
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
 drivers/media/platform/coda.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index ed4998c..bd72fb9 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -3298,13 +3298,12 @@ static int coda_probe(struct platform_device *pdev)
 		dev->iram_size = CODA7_IRAM_SIZE;
 		break;
 	}
-	dev->iram_vaddr = gen_pool_alloc(dev->iram_pool, dev->iram_size);
+	dev->iram_vaddr = (unsigned long)gen_pool_dma_alloc(dev->iram_pool,
+			dev->iram_size, (dma_addr_t *)&dev->iram_paddr);
 	if (!dev->iram_vaddr) {
 		dev_err(&pdev->dev, "unable to alloc iram\n");
 		return -ENOMEM;
 	}
-	dev->iram_paddr = gen_pool_virt_to_phys(dev->iram_pool,
-						dev->iram_vaddr);
 
 	platform_set_drvdata(pdev, dev);
 
-- 
1.8.4


