Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaI0I4p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 04:56:45 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38664 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751892AbaI0I4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 04:56:42 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 2/9] dmaengine: Make channel allocation callbacks optional
Date: Sat, 27 Sep 2014 10:54:38 +0200
Message-Id: <1411808085-27792-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411808085-27792-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1411808085-27792-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nowadays, some drivers don't have anything in there channel allocation
callbacks anymore.

Remove the BUG_ON if those callbacks aren't implemented, in order to allow
drivers to not implement them.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/dmaengine.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index d5d30ed863ce..cfcb181b1184 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -817,8 +817,6 @@ int dma_async_device_register(struct dma_device *device)
 	BUG_ON(dma_has_cap(DMA_INTERLEAVE, device->cap_mask) &&
 		!device->device_prep_interleaved_dma);
 
-	BUG_ON(!device->device_alloc_chan_resources);
-	BUG_ON(!device->device_free_chan_resources);
 	BUG_ON(!device->device_tx_status);
 	BUG_ON(!device->device_issue_pending);
 	BUG_ON(!device->dev);
-- 
2.1.0

