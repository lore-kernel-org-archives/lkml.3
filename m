Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424Ab3DXMCO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 08:02:14 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:35898 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757096Ab3DXMBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 08:01:35 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LMML <linux-media@vger.kernel.org>,
        LFBDEV <linux-fbdev@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 5/6] ARM: davinci: dm365: enable fbdev driver
Date: Wed, 24 Apr 2013 17:30:07 +0530
Message-Id: <1366804808-22720-6-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1366804808-22720-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1366804808-22720-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch enables fbdev driver by creating fbdev device and register it.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 arch/arm/mach-davinci/dm365.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
index ff771ce..b06623c 100644
--- a/arch/arm/mach-davinci/dm365.c
+++ b/arch/arm/mach-davinci/dm365.c
@@ -1349,6 +1349,15 @@ static struct platform_device dm365_vpbe_display = {
 	},
 };
 
+static struct platform_device dm365_davincifb = {
+	.name           = "davinci-vpbe-fb",
+	.id             = -1,
+	.dev            = {
+		.dma_mask		= &dm365_video_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+};
+
 struct venc_platform_data dm365_venc_pdata = {
 	.setup_pinmux	= dm365_vpbe_setup_pinmux,
 	.setup_clock	= dm365_venc_setup_clock,
@@ -1392,6 +1401,7 @@ int __init dm365_init_video(struct vpfe_config *vpfe_cfg,
 		platform_device_register(&dm365_venc_dev);
 		platform_device_register(&dm365_vpbe_dev);
 		platform_device_register(&dm365_vpbe_display);
+		platform_device_register(&dm365_davincifb);
 	}
 
 	return 0;
-- 
1.7.4.1

