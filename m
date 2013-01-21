Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab3AURU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:20:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:64587 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab3AURRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:17:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH 08/15] drm/exynos: fimd and ipp are broken on multiplatform
Date: Mon, 21 Jan 2013 17:16:01 +0000
Message-Id: <1358788568-11137-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358788568-11137-1-git-send-email-arnd@arndb.de>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:veDhCeoKxR7GmFKWpTiAVAb3lrOBgTuFZVQLmlQ9WBY
 U0lRR8zDCaVBc4WOEdEvRo9WXRFYJjgvMkEuItPXIwTav76tDQ
 Si7MG0lE8LcJ5yLZSq9aKGGCzbk4PDq49aGnBer+BHzi99s39m
 4uTb3DAELACjoYde6SA/AySlBedCdUu4lKPN7fyw8jWN9ENs5v
 Ync96SQuKsSE7rwjIbb2xkVafa8JW9BOyUhacinoisoZef3iI4
 w6S0XU7YBW2geQKH4AwzEiu4Ufg+Z0bhyBh4rOlebkD74lPdIJ
 ULzrgUv80ewoCzcUrwKpUV96SA7bcAENol9mx1+m67UkYle241
 1D1IRqBylxW8yhDyoa8A/OZcnuuQvf0vCPDcSfJ7H
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While the exynos DRM support in principle can work on
multiplatform, the FIMD and IPP sections of it both
include the plat/map-base.h header file, which is
not available on multiplatform. Rather than disabling
the entire driver, we can just conditionally build
these two parts.

Without this patch, building allyesconfig results in:

drivers/gpu/drm/exynos/exynos_drm_fimc.c:19:27: fatal error: plat/map-base.h: No such file or directory
drivers/gpu/drm/exynos/exynos_drm_ipp.c:20:27: fatal error: plat/map-base.h: No such file or directory

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/exynos/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/exynos/Kconfig b/drivers/gpu/drm/exynos/Kconfig
index 1d1f1e5..046bcda 100644
--- a/drivers/gpu/drm/exynos/Kconfig
+++ b/drivers/gpu/drm/exynos/Kconfig
@@ -24,7 +24,7 @@ config DRM_EXYNOS_DMABUF
 
 config DRM_EXYNOS_FIMD
 	bool "Exynos DRM FIMD"
-	depends on DRM_EXYNOS && !FB_S3C
+	depends on DRM_EXYNOS && !FB_S3C && !ARCH_MULTIPLATFORM
 	help
 	  Choose this option if you want to use Exynos FIMD for DRM.
 
@@ -48,7 +48,7 @@ config DRM_EXYNOS_G2D
 
 config DRM_EXYNOS_IPP
 	bool "Exynos DRM IPP"
-	depends on DRM_EXYNOS
+	depends on DRM_EXYNOS && !ARCH_MULTIPLATFORM
 	help
 	  Choose this option if you want to use IPP feature for DRM.
 
-- 
1.7.10.4

