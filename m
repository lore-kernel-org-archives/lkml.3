Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbaKQNr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:47:29 -0500
Received: from down.free-electrons.com ([37.187.137.238]:49222 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753435AbaKQNp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:45:58 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v5 59/61] dmaengine: Add a warning for drivers not using the generic slave caps retrieval
Date: Mon, 17 Nov 2014 14:42:53 +0100
Message-Id: <1416231775-31252-60-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the slave caps retrieval to be really useful, most drivers need to
implement it.

Hence, we need to be slightly more aggressive, and trigger a warning at
registration time for drivers that don't fill their caps infos in order to
encourage them to implement it.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/dma/dmaengine.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 98e9431f85ec..300c8cd2786c 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -827,6 +827,9 @@ int dma_async_device_register(struct dma_device *device)
 	BUG_ON(!device->device_issue_pending);
 	BUG_ON(!device->dev);
 
+	WARN(dma_has_cap(DMA_SLAVE, device->cap_mask) && !device->directions,
+	     "this driver doesn't support generic slave capabilities reporting\n");
+
 	/* note: this only matters in the
 	 * CONFIG_ASYNC_TX_ENABLE_CHANNEL_SWITCH=n case
 	 */
-- 
2.1.1

