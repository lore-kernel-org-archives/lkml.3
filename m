Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaHDTHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:07:14 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:60504 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaHDTHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:07:12 -0400
Date: Mon, 4 Aug 2014 21:07:07 +0200
From: Quentin Lambert <lambert.quentin@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] staging: imx-drm: fix a blank line coding style issue
Message-ID: <20140804190707.GA4594@greed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing blank lines after declaration.

Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
---
 drivers/staging/imx-drm/imx-drm-core.c     | 2 ++
 drivers/staging/imx-drm/imx-tve.c          | 2 ++
 drivers/staging/imx-drm/parallel-display.c | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/drivers/staging/imx-drm/imx-drm-core.c b/drivers/staging/imx-drm/imx-drm-core.c
index 47ee6c7..345f7ac 100644
--- a/drivers/staging/imx-drm/imx-drm-core.c
+++ b/drivers/staging/imx-drm/imx-drm-core.c
@@ -427,6 +427,7 @@ static uint32_t imx_drm_find_crtc_mask(struct imx_drm_device *imxdrm,
 
 	for (i = 0; i < MAX_CRTC; i++) {
 		struct imx_drm_crtc *imx_drm_crtc = imxdrm->crtc[i];
+
 		if (imx_drm_crtc && imx_drm_crtc->port == port)
 			return drm_crtc_mask(imx_drm_crtc->crtc);
 	}
@@ -438,6 +439,7 @@ static struct device_node *imx_drm_of_get_next_endpoint(
 		const struct device_node *parent, struct device_node *prev)
 {
 	struct device_node *node = of_graph_get_next_endpoint(parent, prev);
+
 	of_node_put(prev);
 	return node;
 }
diff --git a/drivers/staging/imx-drm/imx-tve.c b/drivers/staging/imx-drm/imx-tve.c
index c628fcd..31fe7cf 100644
--- a/drivers/staging/imx-drm/imx-tve.c
+++ b/drivers/staging/imx-drm/imx-tve.c
@@ -133,6 +133,7 @@ static void tve_lock(void *__tve)
 __acquires(&tve->lock)
 {
 	struct imx_tve *tve = __tve;
+
 	spin_lock(&tve->lock);
 }
 
@@ -140,6 +141,7 @@ static void tve_unlock(void *__tve)
 __releases(&tve->lock)
 {
 	struct imx_tve *tve = __tve;
+
 	spin_unlock(&tve->lock);
 }
 
diff --git a/drivers/staging/imx-drm/parallel-display.c b/drivers/staging/imx-drm/parallel-display.c
index 4ca61af..1998846 100644
--- a/drivers/staging/imx-drm/parallel-display.c
+++ b/drivers/staging/imx-drm/parallel-display.c
@@ -70,6 +70,7 @@ static int imx_pd_connector_get_modes(struct drm_connector *connector)
 
 	if (imxpd->mode_valid) {
 		struct drm_display_mode *mode = drm_mode_create(connector->dev);
+
 		if (!mode)
 			return -EINVAL;
 		drm_mode_copy(mode, &imxpd->mode);
@@ -80,6 +81,7 @@ static int imx_pd_connector_get_modes(struct drm_connector *connector)
 
 	if (np) {
 		struct drm_display_mode *mode = drm_mode_create(connector->dev);
+
 		if (!mode)
 			return -EINVAL;
 		of_get_drm_display_mode(np, &imxpd->mode, OF_USE_NATIVE_MODE);
-- 
1.9.1

