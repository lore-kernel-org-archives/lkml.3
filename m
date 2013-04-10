Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936550Ab3DJMie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 08:38:34 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:42675 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936171Ab3DJMic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 08:38:32 -0400
Date: Wed, 10 Apr 2013 20:37:52 +0800 (CST)
From: Xiong Zhou <jencce.kernel@gmail.com>
X-X-Sender: zx@M2420
To: airlied@redhat.com, alan@linux.intel.com, dri-devel@lists.freedesktop.org,
        patrik.r.jakobsson@gmail.com
cc: linux-kernel@vger.kernel.org, jencce.kernel@gmail.com
Subject: [PATCH v2] gma500:fix build failure for 3.9-rc5
Message-ID: <alpine.DEB.2.02.1304102035250.15970@M2420>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiong Zhou <jencce.kernel@gmail.com>

Last version of this patch is not clear enough and X86 duplicated.

This patch fixes build failure of v3.9-rc5 and rc6.
When config ACPI_VIDEO as m, DRM_GMA500 as y, here comes the failure.
GMA5/600 needs acpi_video just like nouveau.
And some tab type fix by the way.

Failure message:
drivers/built-in.o: In function `psb_driver_load':
kernel-3.9-rc5/drivers/gpu/drm/gma500/psb_drv.c:340: \
	undefined reference to `acpi_video_register'
make: *** [vmlinux] Error 1

Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>
---
drivers/gpu/drm/gma500/Kconfig |   13 +++++++++----
1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/gma500/Kconfig b/drivers/gpu/drm/gma500/Kconfig
index 1188f0f..1f6e2df 100644
--- a/drivers/gpu/drm/gma500/Kconfig
+++ b/drivers/gpu/drm/gma500/Kconfig
@@ -2,10 +2,15 @@ config DRM_GMA500
 	tristate "Intel GMA5/600 KMS Framebuffer"
 	depends on DRM && PCI && X86
 	select FB_CFB_COPYAREA
-        select FB_CFB_FILLRECT
-        select FB_CFB_IMAGEBLIT
-        select DRM_KMS_HELPER
-        select DRM_TTM
+	select FB_CFB_FILLRECT
+	select FB_CFB_IMAGEBLIT
+	select DRM_KMS_HELPER
+	select DRM_TTM
+	# GMA500 depends on ACPI_VIDEO when ACPI is enabled, just like i915
+	select ACPI_VIDEO if ACPI
+	select BACKLIGHT_CLASS_DEVICE if ACPI
+	select VIDEO_OUTPUT_CONTROL if ACPI
+	select INPUT if ACPI
 	help
 	  Say yes for an experimental 2D KMS framebuffer driver for the
 	  Intel GMA500 ('Poulsbo') and other Intel IMG based graphics
