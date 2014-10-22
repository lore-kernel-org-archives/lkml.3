Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbaJVQKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:10:10 -0400
Received: from down.free-electrons.com ([37.187.137.238]:53950 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754259AbaJVPpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:45:13 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 09/59] dmaengine: Remove the need to declare device_control
Date: Wed, 22 Oct 2014 17:43:23 +0200
Message-Id: <1413992653-21963-10-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to migrate the drivers without triggering a BUG_ON for the converted
drivers, which would cause bisectability issues, we need to remove that check
before removing the device_control function entirely.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/dmaengine.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 9b2cd74b8f2e..98e9431f85ec 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -820,8 +820,6 @@ int dma_async_device_register(struct dma_device *device)
 		!device->device_prep_dma_sg);
 	BUG_ON(dma_has_cap(DMA_CYCLIC, device->cap_mask) &&
 		!device->device_prep_dma_cyclic);
-	BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
-		!device->device_control);
 	BUG_ON(dma_has_cap(DMA_INTERLEAVE, device->cap_mask) &&
 		!device->device_prep_interleaved_dma);
 
-- 
2.1.1

