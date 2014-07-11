Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbaGKP4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 11:56:32 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:35138 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbaGKP41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 11:56:27 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Mark Brown <broonie@kernel.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Cc: dmaengine@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2 1/2] dmaengine: Clarify device parameter for dma_sync_*_for_*()
Date: Fri, 11 Jul 2014 17:56:21 +0200
Message-Id: <1405094182-13962-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v2:
  - New
---
 Documentation/dmaengine.txt | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/dmaengine.txt b/Documentation/dmaengine.txt
index 879b6e31e2da..87d3f192e160 100644
--- a/Documentation/dmaengine.txt
+++ b/Documentation/dmaengine.txt
@@ -100,8 +100,10 @@ The slave DMA usage consists of following steps:
    The peripheral driver is expected to have mapped the scatterlist for
    the DMA operation prior to calling device_prep_slave_sg, and must
    keep the scatterlist mapped until the DMA operation has completed.
-   The scatterlist must be mapped using the DMA struct device.  So,
-   normal setup should look like this:
+   The scatterlist must be mapped using the DMA struct device.
+   If a mapping needs to be synchronized later, dma_sync_*_for_*() must be
+   called using the DMA struct device, too.
+   So, normal setup should look like this:
 
 	nr_sg = dma_map_sg(chan->device->dev, sgl, sg_len);
 	if (nr_sg == 0)
-- 
1.9.1

