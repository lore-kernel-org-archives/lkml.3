Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab3FMN4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:56:24 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:39322 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010Ab3FMN4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:56:23 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH] ARM: ux500: set coherent_dma_mask for dma40
Date: Thu, 13 Jun 2013 15:56:03 +0200
Message-Id: <1371131763-6288-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set coherent_dma_mask to DMA_BIT_MASK(32) for dma40 platform_device, as
without this DMA allocations were failing with the error:

dma40 dma40.0: coherent DMA mask is unset

when booting without device-tree.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---

Hi Linus, Lee,

I found this while removing the last hack I was keeping in my ASoC tree.
I originally thought that I had to set this on the driver's pdata, but
it turns out it's needed on the DMA controller one instead.

When booting with device-tree enabled the mask seems to be set
automatically.

Would you consider applying this with the other dma40 patches?

Thanks,
Fabio

 arch/arm/mach-ux500/devices-db8500.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-ux500/devices-db8500.c b/arch/arm/mach-ux500/devices-db8500.c
index e21ffd8..fa8f7a5 100644
--- a/arch/arm/mach-ux500/devices-db8500.c
+++ b/arch/arm/mach-ux500/devices-db8500.c
@@ -49,6 +49,7 @@ struct stedma40_platform_data dma40_plat_data = {
 struct platform_device u8500_dma40_device = {
 	.dev = {
 		.platform_data = &dma40_plat_data,
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 	},
 	.name = "dma40",
 	.id = 0,
-- 
1.8.2

