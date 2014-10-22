Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200AbaJVPyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:54:15 -0400
Received: from down.free-electrons.com ([37.187.137.238]:54235 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753850AbaJVPqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:46:05 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 53/59] dmaengine: nbpfaxi: Declare slave capabilities for the generic code
Date: Wed, 22 Oct 2014 17:44:07 +0200
Message-Id: <1413992653-21963-54-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the generic slave caps code can make use of the device assigned
capabilities, instead of relying on a callback to be implemented.

Make use of this code.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/nbpfaxi.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/dma/nbpfaxi.c b/drivers/dma/nbpfaxi.c
index a07698fc798f..a3e138a0de10 100644
--- a/drivers/dma/nbpfaxi.c
+++ b/drivers/dma/nbpfaxi.c
@@ -1069,18 +1069,6 @@ static void nbpf_free_chan_resources(struct dma_chan *dchan)
 	}
 }
 
-static int nbpf_slave_caps(struct dma_chan *dchan,
-			   struct dma_slave_caps *caps)
-{
-	caps->src_addr_widths = NBPF_DMA_BUSWIDTHS;
-	caps->dst_addr_widths = NBPF_DMA_BUSWIDTHS;
-	caps->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
-	caps->cmd_pause = false;
-	caps->cmd_terminate = true;
-
-	return 0;
-}
-
 static struct dma_chan *nbpf_of_xlate(struct of_phandle_args *dma_spec,
 				      struct of_dma *ofdma)
 {
@@ -1411,7 +1399,6 @@ static int nbpf_probe(struct platform_device *pdev)
 	dma_dev->device_prep_dma_memcpy = nbpf_prep_memcpy;
 	dma_dev->device_tx_status = nbpf_tx_status;
 	dma_dev->device_issue_pending = nbpf_issue_pending;
-	dma_dev->device_slave_caps = nbpf_slave_caps;
 
 	/*
 	 * If we drop support for unaligned MEMCPY buffer addresses and / or
@@ -1427,6 +1414,11 @@ static int nbpf_probe(struct platform_device *pdev)
 	dma_dev->device_pause = nbpf_pause;
 	dma_dev->device_terminate_all = nbpf_terminate_all;
 
+	dma_dev->src_addr_widths = NBPF_DMA_BUSWIDTHS;
+	dma_dev->dst_addr_widths = NBPF_DMA_BUSWIDTHS;
+	dma_dev->directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
+	dma_dev->generic_slave_caps = true;
+
 	platform_set_drvdata(pdev, nbpf);
 
 	ret = clk_prepare_enable(nbpf->clk);
-- 
2.1.1

