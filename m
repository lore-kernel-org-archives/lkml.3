Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab3DXMBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 08:01:38 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:61151 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab3DXMB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 08:01:27 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LMML <linux-media@vger.kernel.org>,
        LFBDEV <linux-fbdev@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 4/6] ARM: davinci: dm355: enable fbdev driver
Date: Wed, 24 Apr 2013 17:30:06 +0530
Message-Id: <1366804808-22720-5-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1366804808-22720-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1366804808-22720-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch enables fbdev driver by creating fbdev device and register it.
Alongside renames 'vpfe_capture_dma_mask' to 'dm355_video_dma_mask' for better
clarity since it was reused by capture and diplay aswell.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 arch/arm/mach-davinci/dm355.c |   24 +++++++++++++++++-------
 1 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index bf9a9d4..fe50814 100644
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@ -714,7 +714,7 @@ static struct resource vpfe_resources[] = {
 	},
 };
 
-static u64 vpfe_capture_dma_mask = DMA_BIT_MASK(32);
+static u64 dm355_video_dma_mask = DMA_BIT_MASK(32);
 static struct resource dm355_ccdc_resource[] = {
 	/* CCDC Base address */
 	{
@@ -729,7 +729,7 @@ static struct platform_device dm355_ccdc_dev = {
 	.num_resources  = ARRAY_SIZE(dm355_ccdc_resource),
 	.resource       = dm355_ccdc_resource,
 	.dev = {
-		.dma_mask               = &vpfe_capture_dma_mask,
+		.dma_mask               = &dm355_video_dma_mask,
 		.coherent_dma_mask      = DMA_BIT_MASK(32),
 		.platform_data		= dm355_ccdc_setup_pinmux,
 	},
@@ -741,7 +741,7 @@ static struct platform_device vpfe_capture_dev = {
 	.num_resources	= ARRAY_SIZE(vpfe_resources),
 	.resource	= vpfe_resources,
 	.dev = {
-		.dma_mask		= &vpfe_capture_dma_mask,
+		.dma_mask		= &dm355_video_dma_mask,
 		.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
 };
@@ -760,7 +760,7 @@ static struct platform_device dm355_osd_dev = {
 	.num_resources	= ARRAY_SIZE(dm355_osd_resources),
 	.resource	= dm355_osd_resources,
 	.dev		= {
-		.dma_mask		= &vpfe_capture_dma_mask,
+		.dma_mask		= &dm355_video_dma_mask,
 		.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
 };
@@ -855,7 +855,16 @@ static struct platform_device dm355_vpbe_display = {
 	.num_resources	= ARRAY_SIZE(dm355_v4l2_disp_resources),
 	.resource	= dm355_v4l2_disp_resources,
 	.dev		= {
-		.dma_mask		= &vpfe_capture_dma_mask,
+		.dma_mask		= &dm355_video_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+};
+
+static struct platform_device dm355_davincifb = {
+	.name		= "davinci-vpbe-fb",
+	.id		= -1,
+	.dev		= {
+		.dma_mask		= &dm355_video_dma_mask,
 		.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
 };
@@ -871,7 +880,7 @@ static struct platform_device dm355_venc_dev = {
 	.num_resources	= ARRAY_SIZE(dm355_venc_resources),
 	.resource	= dm355_venc_resources,
 	.dev		= {
-		.dma_mask		= &vpfe_capture_dma_mask,
+		.dma_mask		= &dm355_video_dma_mask,
 		.coherent_dma_mask	= DMA_BIT_MASK(32),
 		.platform_data		= (void *)&dm355_venc_pdata,
 	},
@@ -881,7 +890,7 @@ static struct platform_device dm355_vpbe_dev = {
 	.name		= "vpbe_controller",
 	.id		= -1,
 	.dev		= {
-		.dma_mask		= &vpfe_capture_dma_mask,
+		.dma_mask		= &dm355_video_dma_mask,
 		.coherent_dma_mask	= DMA_BIT_MASK(32),
 	},
 };
@@ -1023,6 +1032,7 @@ int __init dm355_init_video(struct vpfe_config *vpfe_cfg,
 		platform_device_register(&dm355_venc_dev);
 		platform_device_register(&dm355_vpbe_dev);
 		platform_device_register(&dm355_vpbe_display);
+		platform_device_register(&dm355_davincifb);
 	}
 
 	return 0;
-- 
1.7.4.1

