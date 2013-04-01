Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597Ab3DASMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 14:12:32 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63060 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774Ab3DASMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 14:12:31 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Mon, 01 Apr 2013 13:12:30 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Guenter Roeck <linux@roeck-us.net>, Rob Clark <robdclark@gmail.com>
Subject: [PATCH] drm/tilcdc: Disable building as module
Date: Mon,  1 Apr 2013 11:12:24 -0700
Message-Id: <1364839944-4863-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attempts to compile tilcdc as module results in:

drivers/gpu/drm/tilcdc/tilcdc_slave.o:(.data+0x54): multiple definition of
`__mod_of_device_table'
drivers/gpu/drm/tilcdc/tilcdc_tfp410.o:(.data+0x54): first defined here
drivers/gpu/drm/tilcdc/tilcdc_panel.o:(.data+0x54): multiple definition of
`__mod_of_device_table'
drivers/gpu/drm/tilcdc/tilcdc_tfp410.o:(.data+0x54): first defined here
drivers/gpu/drm/tilcdc/tilcdc_drv.o:(.data+0x184): multiple definition of
`__mod_of_device_table'
drivers/gpu/drm/tilcdc/tilcdc_tfp410.o:(.data+0x54): first defined here
make[5]: [drivers/gpu/drm/tilcdc/tilcdc.o] Error 1 (ignored)

It appears it was never even tried to build it as module, or the problem
would have been seen. So running this driver as module was never really
tested. Disable it. If really needed, the code wil require some structural
changes and in-depth testing, which can and should be done separately.

Cc: Rob Clark <robdclark@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/gpu/drm/tilcdc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tilcdc/Kconfig b/drivers/gpu/drm/tilcdc/Kconfig
index d24d040..6ddb729 100644
--- a/drivers/gpu/drm/tilcdc/Kconfig
+++ b/drivers/gpu/drm/tilcdc/Kconfig
@@ -1,5 +1,5 @@
 config DRM_TILCDC
-	tristate "DRM Support for TI LCDC Display Controller"
+	bool "DRM Support for TI LCDC Display Controller"
 	depends on DRM && OF && ARM
 	select DRM_KMS_HELPER
 	select DRM_KMS_CMA_HELPER
-- 
1.7.9.7

