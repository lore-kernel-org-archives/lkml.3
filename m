Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaAMKi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:38:56 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:60819 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaAMKiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:38:54 -0500
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, Marek Vasut <marex@denx.de>,
        Jiada Wang <jiada_wang@mentor.com>,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH] imx-drm: parallel-display: honor 'native-mode' property when selecting video mode from DT
Date: Mon, 13 Jan 2014 11:24:33 +0100
Message-Id: <1389608673-10565-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows to select a specific video mode from a list of modes
defined in DT by setting the 'native-mode' property appropriately.

Since all current users of this driver have only one mode defined in
their .dts files, the patch does not change the behaviour of this
driver on the affected platforms.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/staging/imx-drm/parallel-display.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/imx-drm/parallel-display.c b/drivers/staging/imx-drm/parallel-display.c
index 24aa9be..351d61d 100644
--- a/drivers/staging/imx-drm/parallel-display.c
+++ b/drivers/staging/imx-drm/parallel-display.c
@@ -23,6 +23,7 @@
 #include <drm/drm_fb_helper.h>
 #include <drm/drm_crtc_helper.h>
 #include <linux/videodev2.h>
+#include <video/of_display_timing.h>
 
 #include "imx-drm.h"
 
@@ -74,7 +75,7 @@ static int imx_pd_connector_get_modes(struct drm_connector *connector)
 
 	if (np) {
 		struct drm_display_mode *mode = drm_mode_create(connector->dev);
-		of_get_drm_display_mode(np, &imxpd->mode, 0);
+		of_get_drm_display_mode(np, &imxpd->mode, OF_USE_NATIVE_MODE);
 		drm_mode_copy(mode, &imxpd->mode);
 		mode->type |= DRM_MODE_TYPE_DRIVER | DRM_MODE_TYPE_PREFERRED,
 		drm_mode_probed_add(connector, mode);
-- 
1.7.2.5

