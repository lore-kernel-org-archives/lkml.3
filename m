Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab3EBPQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:16:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50088 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760158Ab3EBPQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:16:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Rob Clark <robdclark@gmail.com>, dri-devel@lists.freedesktop.org,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH, RFC 07/22] drm/tilcd: select BACKLIGHT_LCD_SUPPORT
Date: Thu,  2 May 2013 17:16:11 +0200
Message-Id: <1367507786-505303-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367507786-505303-1-git-send-email-arnd@arndb.de>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:1q5Y9XJtZyF3XTTuOqo4FYAhl/hjHOcHSmW9khGahrn
 zzu9aF9eFxC6Izhh9GWhdLn5HS/O+dmYypdz19vedDiMwwsxs9
 XeChNBIyOtZD2nTO/+gVDAF0BtCv1komZmUY/+6xiWCZ4VksDI
 O7sJyx3WyAp7ZMp2WZZmumofruO60SsoKHPDBWyURDzTQbUVcp
 aEsDWfRkg8vKgQjXMft2OfkNGDxVsrR0QL8eRX97E9RvJ8ypwe
 o6PjaHU27DU8cnIlJKAzGtfgbRBcppxPKo1V4wOeXPVnfiJ5Gz
 LPTQnRc159XQhKZqiswbrkrOnzDDkxXvWSO9t0s6Pct8A+LTpm
 bA0069+AFH6YBtyOqKH1cBMM5FQ5bspziV3lfB2o2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dependecies for BACKLIGHT_CLASS_DEVICE are defined a bit
strange, but it seems one has to always select both BACKLIGHT_CLASS_DEVICE
and BACKLIGHT_LCD_SUPPORT to avoid this error:

drivers/gpu/drm/tilcdc/tilcdc_panel.c:396:
 undefined reference to `of_find_backlight_by_node'

Cc: Rob Clark <robdclark@gmail.com>
Cc: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@redhat.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/gpu/drm/tilcdc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/tilcdc/Kconfig b/drivers/gpu/drm/tilcdc/Kconfig
index e461e99..7a4d101 100644
--- a/drivers/gpu/drm/tilcdc/Kconfig
+++ b/drivers/gpu/drm/tilcdc/Kconfig
@@ -6,6 +6,7 @@ config DRM_TILCDC
 	select DRM_GEM_CMA_HELPER
 	select VIDEOMODE_HELPERS
 	select BACKLIGHT_CLASS_DEVICE
+	select BACKLIGHT_LCD_SUPPORT
 	help
 	  Choose this option if you have an TI SoC with LCDC display
 	  controller, for example AM33xx in beagle-bone, DA8xx, or
-- 
1.8.1.2

