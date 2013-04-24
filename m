Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab3DXMBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 08:01:44 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:48698 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758098Ab3DXMBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 08:01:41 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LMML <linux-media@vger.kernel.org>,
        LFBDEV <linux-fbdev@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 6/6] ARM: davinci: dm644x: enable fbdev driver
Date: Wed, 24 Apr 2013 17:30:08 +0530
Message-Id: <1366804808-22720-7-git-send-email-prabhakar.csengg@gmail.com>
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
 arch/arm/mach-davinci/dm644x.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index c2a9273..a4fee07 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -745,6 +745,15 @@ static struct platform_device dm644x_vpbe_display = {
 	},
 };
 
+static struct platform_device dm644x_davincifb = {
+	.name           = "davinci-vpbe-fb",
+	.id             = -1,
+	.dev            = {
+		.dma_mask		= &dm644x_video_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+};
+
 static struct venc_platform_data dm644x_venc_pdata = {
 	.setup_clock	= dm644x_venc_setup_clock,
 };
@@ -909,6 +918,7 @@ int __init dm644x_init_video(struct vpfe_config *vpfe_cfg,
 		platform_device_register(&dm644x_venc_dev);
 		platform_device_register(&dm644x_vpbe_dev);
 		platform_device_register(&dm644x_vpbe_display);
+		platform_device_register(&dm644x_davincifb);
 	}
 
 	return 0;
-- 
1.7.4.1

