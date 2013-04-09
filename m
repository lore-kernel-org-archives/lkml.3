Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934621Ab3DIGgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 02:36:18 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:60184 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab3DIGgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 02:36:17 -0400
Date: Tue, 9 Apr 2013 14:35:00 +0800 (CST)
From: Xiong Zhou <jencce.kernel@gmail.com>
X-X-Sender: zx@M2420
To: airlied@redhat.com, alan@linux.intel.com, dri-devel@lists.freedesktop.org
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/gpu/drm/gma500:fix build failure for 3.9-rc5
Message-ID: <alpine.DEB.2.02.1304091428270.24675@M2420>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiong Zhou <jencce.kernel@gmail.com>

This patch fixes build failure of v3.9-rc5.
When config ACPI_VIDEO as m, DRM_GMA500 as y, here comes the failure.
gma5/600 needs acpi_video just like nouveau.

Failure message:
drivers/built-in.o: In function `psb_driver_load':
kernel-3.9-rc5/drivers/gpu/drm/gma500/psb_drv.c:340: \
	undefined reference to `acpi_video_register'
make: *** [vmlinux] Error 1

Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>
---
drivers/gpu/drm/gma500/Kconfig |    1 +
1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/gma500/Kconfig b/drivers/gpu/drm/gma500/Kconfig
index 1188f0f..d64fc45 100644
--- a/drivers/gpu/drm/gma500/Kconfig
+++ b/drivers/gpu/drm/gma500/Kconfig
@@ -6,6 +6,7 @@ config DRM_GMA500
         select FB_CFB_IMAGEBLIT
         select DRM_KMS_HELPER
         select DRM_TTM
+        select ACPI_VIDEO if ACPI && X86 && BACKLIGHT_CLASS_DEVICE && VIDEO_OUTPUT_CONTROL && INPUT
 	help
 	  Say yes for an experimental 2D KMS framebuffer driver for the
 	  Intel GMA500 ('Poulsbo') and other Intel IMG based graphics
