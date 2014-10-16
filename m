Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaJPJFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:05:18 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36417 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751429AbaJPJFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:05:08 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 08/11] dmaengine: sa11x0: Remove chancnt affectations
Date: Thu, 16 Oct 2014 11:01:00 +0200
Message-Id: <1413450063-23829-9-git-send-email-maxime.ripard@free-electrons.com>
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
 drivers/dma/sa11x0-dma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma/sa11x0-dma.c b/drivers/dma/sa11x0-dma.c
index 4b0ef043729a..2329d295efb5 100644
--- a/drivers/dma/sa11x0-dma.c
+++ b/drivers/dma/sa11x0-dma.c
@@ -829,7 +829,6 @@ static int sa11x0_dma_init_dmadev(struct dma_device *dmadev,
 {
 	unsigned i;
 
-	dmadev->chancnt = ARRAY_SIZE(chan_desc);
 	INIT_LIST_HEAD(&dmadev->channels);
 	dmadev->dev = dev;
 	dmadev->device_alloc_chan_resources = sa11x0_dma_alloc_chan_resources;
@@ -838,7 +837,7 @@ static int sa11x0_dma_init_dmadev(struct dma_device *dmadev,
 	dmadev->device_tx_status = sa11x0_dma_tx_status;
 	dmadev->device_issue_pending = sa11x0_dma_issue_pending;
 
-	for (i = 0; i < dmadev->chancnt; i++) {
+	for (i = 0; i < ARRAY_SIZE(chan_desc); i++) {
 		struct sa11x0_dma_chan *c;
 
 		c = kzalloc(sizeof(*c), GFP_KERNEL);
-- 
2.1.1

