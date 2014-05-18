Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbaERUvk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 16:51:40 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:65142 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbaERUvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 16:51:13 -0400
From: Emil Goode <emilgoode@gmail.com>
To: Shawn Guo <shawn.guo@freescale.com>, Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH 1/2 v4] ARM: imx: fix error handling in ipu device registration
Date: Sun, 18 May 2014 22:50:59 +0200
Message-Id: <1400446261-27085-2-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400446261-27085-1-git-send-email-emilgoode@gmail.com>
References: <1400446261-27085-1-git-send-email-emilgoode@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we fail to allocate struct platform_device pdev we
dereference it after the goto label err.

This bug was found using coccinelle.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
v4: Simplified version that just fixes the bug.
    Also updated the changelog.
v3: Made subject line more specific.
v2: Changed to return -ENOMEM instead of ret where possible and
    updated the subject line.

 arch/arm/mach-imx/devices/platform-ipu-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/devices/platform-ipu-core.c b/arch/arm/mach-imx/devices/platform-ipu-core.c
index fc4dd7c..6bd7c3f 100644
--- a/arch/arm/mach-imx/devices/platform-ipu-core.c
+++ b/arch/arm/mach-imx/devices/platform-ipu-core.c
@@ -77,7 +77,7 @@ struct platform_device *__init imx_alloc_mx3_camera(
 
 	pdev = platform_device_alloc("mx3-camera", 0);
 	if (!pdev)
-		goto err;
+		return ERR_PTR(-ENOMEM);
 
 	pdev->dev.dma_mask = kmalloc(sizeof(*pdev->dev.dma_mask), GFP_KERNEL);
 	if (!pdev->dev.dma_mask)
-- 
1.7.10.4

