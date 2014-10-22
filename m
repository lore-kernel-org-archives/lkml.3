Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbaJVPwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:52:33 -0400
Received: from down.free-electrons.com ([37.187.137.238]:54235 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755107AbaJVPqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:46:12 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 58/59] dmaengine: Add a warning for drivers not using the generic slave caps retrieval
Date: Wed, 22 Oct 2014 17:44:12 +0200
Message-Id: <1413992653-21963-59-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the slave caps retrieval to be really useful, most drivers need to
implement it.

Hence, we need to be slightly more aggressive, and trigger a warning at
registration time for drivers that don't fill their caps infos in order to
encourage them to implement it.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/dmaengine.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 98e9431f85ec..4e18981b16bd 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -827,6 +827,9 @@ int dma_async_device_register(struct dma_device *device)
 	BUG_ON(!device->device_issue_pending);
 	BUG_ON(!device->dev);
 
+	WARN(dma_has_cap(DMA_SLAVE, device->cap_mask) && !device->generic_slave_caps,
+	     "this driver doesn't support generic slave capabilities reporting\n");
+
 	/* note: this only matters in the
 	 * CONFIG_ASYNC_TX_ENABLE_CHANNEL_SWITCH=n case
 	 */
-- 
2.1.1

