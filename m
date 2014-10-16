Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaJPJIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:08:38 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36417 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751953AbaJPJFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:05:10 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 11/11] dmaengine: sun6i: Remove chancnt affectations
Date: Thu, 16 Oct 2014 11:01:03 +0200
Message-Id: <1413450063-23829-12-git-send-email-maxime.ripard@free-electrons.com>
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
 drivers/dma/sun6i-dma.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/dma/sun6i-dma.c b/drivers/dma/sun6i-dma.c
index 1f92a56fd2b6..61f22fc1c631 100644
--- a/drivers/dma/sun6i-dma.c
+++ b/drivers/dma/sun6i-dma.c
@@ -937,7 +937,6 @@ static int sun6i_dma_probe(struct platform_device *pdev)
 	sdc->slave.device_prep_slave_sg		= sun6i_dma_prep_slave_sg;
 	sdc->slave.device_prep_dma_memcpy	= sun6i_dma_prep_dma_memcpy;
 	sdc->slave.device_control		= sun6i_dma_control;
-	sdc->slave.chancnt			= NR_MAX_VCHANS;
 
 	sdc->slave.dev = &pdev->dev;
 
-- 
2.1.1

