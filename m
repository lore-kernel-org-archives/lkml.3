Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751Ab3EBPSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:18:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58894 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932549Ab3EBPQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:16:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH, RFC 04/22] staging/drm: imx: add missing dependencies
Date: Thu,  2 May 2013 17:16:08 +0200
Message-Id: <1367507786-505303-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367507786-505303-1-git-send-email-arnd@arndb.de>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:bJeJTKCE7AuSCtbZiiqWqH7zMf8vF9EFnpF73KIMo2j
 21KX7tQSXV4TPDNYN7p1+n739lBXwugwM0ERM/cvb9KJ6+Fd4L
 bYwd95hw7jnjufR7yazpi8CYNS0mxDYFdhYo1RD1VVpcGAp29m
 YEekjulI9Wh04/M/18M0qPHPzDbm7DIJd0L0HnnX+/DS/j7FXU
 kDjEWSFpCCJ9rwqCXOnFhX/FsWo1b17dsmIRtMrUTsbNoCay92
 18q64sWhs2WKtsEP560ntrDK83PAUaEVgPj+tHuKNdr8a/pG8D
 qTHkpgOsExXo/mcpJQLYs44gWEqXA3Q+LHCZwbj/X91YPr/x5M
 S3ijkuhszFQgcallG3jLBj4MmeLokKPvPRfdCRKcJ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The imx DRM driver needs a couple of extra Kconfig dependencies
to avoid random build failures:

drivers/staging/imx-drm/ipuv3-crtc.c:448:
 undefined reference to `ipu_idmac_put'
 drivers/staging/imx-drm/ipuv3-crtc.c:450: undefined reference to
 `ipu_dmfc_put' drivers/staging/imx-drm/ipuv3-crtc.c:452:
 undefined reference to `ipu_dp_put'
 drivers/staging/imx-drm/ipuv3-crtc.c:454: undefined reference to
 `ipu_di_put'
drivers/built-in.o: In function `ipu_probe':
 :(.text+0x4b4174): undefined reference to `device_reset'
drivers/built-in.o: In function `imx_tve_probe':
 drivers/staging/imx-drm/imx-tve.c:648: undefined reference to
 `devm_regmap_init_mmio_clk'
drivers/built-in.o: In function
 `imx_pd_connector_get_modes':
 drivers/staging/imx-drm/parallel-display.c:78: undefined
 reference to `of_get_drm_display_mode'

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/imx-drm/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/imx-drm/Kconfig b/drivers/staging/imx-drm/Kconfig
index 8c9e403..35ccda5 100644
--- a/drivers/staging/imx-drm/Kconfig
+++ b/drivers/staging/imx-drm/Kconfig
@@ -1,6 +1,7 @@
 config DRM_IMX
 	tristate "DRM Support for Freescale i.MX"
 	select DRM_KMS_HELPER
+	select VIDEOMODE_HELPERS
 	select DRM_GEM_CMA_HELPER
 	select DRM_KMS_CMA_HELPER
 	depends on DRM && (ARCH_MXC || ARCH_MULTIPLATFORM)
@@ -23,6 +24,7 @@ config DRM_IMX_PARALLEL_DISPLAY
 config DRM_IMX_TVE
 	tristate "Support for TV and VGA displays"
 	depends on DRM_IMX
+	select REGMAP_MMIO
 	help
 	  Choose this to enable the internal Television Encoder (TVe)
 	  found on i.MX53 processors.
@@ -30,6 +32,7 @@ config DRM_IMX_TVE
 config DRM_IMX_IPUV3_CORE
 	tristate "IPUv3 core support"
 	depends on DRM_IMX
+	depends on RESET_CONTROLLER
 	help
 	  Choose this if you have a i.MX5/6 system and want
 	  to use the IPU. This option only enables IPU base
@@ -38,5 +41,6 @@ config DRM_IMX_IPUV3_CORE
 config DRM_IMX_IPUV3
 	tristate "DRM Support for i.MX IPUv3"
 	depends on DRM_IMX
+	depends on DRM_IMX_IPUV3_CORE
 	help
 	  Choose this if you have a i.MX5 or i.MX6 processor.
-- 
1.8.1.2

