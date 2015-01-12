Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbbALUKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 15:10:21 -0500
Received: from laurent.telenet-ops.be ([195.130.137.89]:55414 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbbALUKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 15:10:16 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Airlie <airlied@linux.ie>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v2 1/2] drm: Drop superfluous "select VT_HW_CONSOLE_BINDING"
Date: Mon, 12 Jan 2015 21:10:12 +0100
Message-Id: <1421093413-26336-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 765d5b9c2b72f5b9 ("fbdev: fbcon: select VT_HW_CONSOLE_BINDING")
made FRAMEBUFFER_CONSOLE always select VT_HW_CONSOLE_BINDING, but forgot
to remove

	select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE

from the individual drivers' sections that already did this before.

Remove it, also from new drivers.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
v2:
  - Split in two (drm and video) patches,
  - Fix recently added rockchip.
---
 drivers/gpu/drm/exynos/Kconfig   | 1 -
 drivers/gpu/drm/rockchip/Kconfig | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/exynos/Kconfig b/drivers/gpu/drm/exynos/Kconfig
index 7f9f6f9e9b7e7992..c072999b7e0345c6 100644
--- a/drivers/gpu/drm/exynos/Kconfig
+++ b/drivers/gpu/drm/exynos/Kconfig
@@ -6,7 +6,6 @@ config DRM_EXYNOS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-	select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE
 	select VIDEOMODE_HELPERS
 	help
 	  Choose this option if you have a Samsung SoC EXYNOS chipset.
diff --git a/drivers/gpu/drm/rockchip/Kconfig b/drivers/gpu/drm/rockchip/Kconfig
index ca9f085efa922982..8652dad82009e3ce 100644
--- a/drivers/gpu/drm/rockchip/Kconfig
+++ b/drivers/gpu/drm/rockchip/Kconfig
@@ -7,7 +7,6 @@ config DRM_ROCKCHIP
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-	select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE
 	select VIDEOMODE_HELPERS
 	help
 	  Choose this option if you have a Rockchip soc chipset.
-- 
1.9.1

