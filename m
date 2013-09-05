Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763528Ab3IEIVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 04:21:13 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:54950 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763202Ab3IEIVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 04:21:10 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Herrmann <dh.herrmann@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Inki Dae <inki.dae@samsung.com>, David Airlie <airlied@linux.ie>,
        Geoff Levand <geoff@infradead.org>, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] video/drm: Drop superfluous "select VT_HW_CONSOLE_BINDING"
Date: Thu,  5 Sep 2013 10:20:30 +0200
Message-Id: <1378369230-7786-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 765d5b9c2b72f5b99722cdfcf4bf8f88c556cf92 ("fbdev: fbcon: select
VT_HW_CONSOLE_BINDING") made FRAMEBUFFER_CONSOLE always select
VT_HW_CONSOLE_BINDING, but forgot to remove

	select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE

from the individual drivers' sections that already did this before.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/gpu/drm/exynos/Kconfig |    1 -
 drivers/video/Kconfig          |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/exynos/Kconfig b/drivers/gpu/drm/exynos/Kconfig
index 772c62a..1344d34 100644
--- a/drivers/gpu/drm/exynos/Kconfig
+++ b/drivers/gpu/drm/exynos/Kconfig
@@ -5,7 +5,6 @@ config DRM_EXYNOS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-	select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE
 	help
 	  Choose this option if you have a Samsung SoC EXYNOS chipset.
 	  If M is selected the module will be called exynosdrm.
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 9788340..f60e3fa 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -2174,7 +2174,6 @@ config FB_PS3
 	select FB_SYS_COPYAREA
 	select FB_SYS_IMAGEBLIT
 	select FB_SYS_FOPS
-	select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE
 	---help---
 	  Include support for the virtual frame buffer in the PS3 platform.
 
-- 
1.7.9.5

