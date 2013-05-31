Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab3EaWYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 18:24:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54945 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757651Ab3EaWXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 18:23:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: patches@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Rob Clark <robdclark@gmail.com>,
        dri-devel@lists.freedesktop.org, Dave Airlie <airlied@redhat.com>
Subject: [PATCH 10/15] drm/tilcd: select BACKLIGHT_LCD_SUPPORT
Date: Sat,  1 Jun 2013 00:22:47 +0200
Message-Id: <1370038972-2318779-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:/s71t2H4rNMDeWJ4+thmmbC0n8uvyBCmsJoz3XcN6Oj
 iIBn711S97inYN6DI3FZtp+9aArbBEtvJT8JltiR/ttzCsJuOZ
 7lkx3LoV7G8qlmkvQPBgnCT0Rshe9QHcKYCxnE7f1FdELOJe2B
 LC/JS9of4wEtUAJbmhE0h9U/S0NZbikiijhf6k1bAoJ+TMLEvF
 Kg3sei/72RoLUifrNnfPQaa9xI8x3gE6WRE8fAN34ExekcCn1b
 m6cyRsSwaFMv7ftW2uchHgmoO93XJV0SN9vAtz5WLXRJiM2Ve6
 +2hnzem0w+MdkJlkvPaSeXAVim6YWydBZLZEqCgv0vUDO6w5A8
 3St3qruiYuUM2xpfnZlARS8gVZf75ftWZH/N7zlV/
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

