Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbaJPJFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:05:16 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36413 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751817AbaJPJFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:05:05 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 05/11] dmaengine: k3: Remove chancnt affectations
Date: Thu, 16 Oct 2014 11:00:57 +0200
Message-Id: <1413450063-23829-6-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413450063-23829-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413450063-23829-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

chanctnt is already filled by dma_async_device_register, which uses the channel
list to know how much channels there is.

Since it's already filled, we can safely remove it from the drivers' probe
function.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/k3dma.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/dma/k3dma.c b/drivers/dma/k3dma.c
index a1f911aaf220..58219aa649fd 100644
--- a/drivers/dma/k3dma.c
+++ b/drivers/dma/k3dma.c
@@ -722,7 +722,6 @@ static int k3_dma_probe(struct platform_device *op)
 	d->slave.device_issue_pending = k3_dma_issue_pending;
 	d->slave.device_control = k3_dma_control;
 	d->slave.copy_align = DMA_ALIGN;
-	d->slave.chancnt = d->dma_requests;
 
 	/* init virtual channel */
 	d->chans = devm_kzalloc(&op->dev,
-- 
2.1.1

