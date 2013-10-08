Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab3JHKje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:39:34 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:43660 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab3JHKjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:39:32 -0400
From: Majunath Goudar <csmanjuvijay@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: nataraja.km@lge.com, Majunath Goudar <csmanjuvijay@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] SHMOBILE: DRM: Fix backlight_device register and unregister undefined errors.
Date: Tue,  8 Oct 2013 16:09:17 +0530
Message-Id: <1381228757-23144-1-git-send-email-csmanjuvijay@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a BACKLIGHT_CLASS_DEVICE dependency to configure the
DRM_SHMOBILE. Without this patch, build system can lead to build failure.
This was observed during randconfig testing, in which DRM_SHMOBILE was
enabled w/o BACKLIGHT_CLASS_DEVICE being enabled. Following was the error:

 Building modules, stage 2.
  MODPOST 516 modules
ERROR: "backlight_device_register" [drivers/gpu/drm/shmobile/shmob-drm.ko] undefined!
ERROR: "backlight_device_unregister" [drivers/gpu/drm/shmobile/shmob-drm.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Signed-off-by: Manjunath Goudar <csmanjuvijay@gmail.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/gpu/drm/shmobile/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/shmobile/Kconfig b/drivers/gpu/drm/shmobile/Kconfig
index ca498d1..eaf822e 100644
--- a/drivers/gpu/drm/shmobile/Kconfig
+++ b/drivers/gpu/drm/shmobile/Kconfig
@@ -1,6 +1,6 @@
 config DRM_SHMOBILE
 	tristate "DRM Support for SH Mobile"
-	depends on DRM && (ARM || SUPERH)
+	depends on DRM && (ARM || SUPERH) && BACKLIGHT_CLASS_DEVICE
 	select DRM_KMS_HELPER
 	select DRM_KMS_CMA_HELPER
 	select DRM_GEM_CMA_HELPER
-- 
1.7.9.5

