Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbaHSP05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:26:57 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:41316 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbaHSP04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:26:56 -0400
From: Yannis Damigos <giannis.damigos@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Yannis Damigos <giannis.damigos@gmail.com>
Subject: [PATCH 1/1] staging: imx-drm: Lines over 80 characters fixed.
Date: Tue, 19 Aug 2014 18:26:46 +0300
Message-Id: <1408462006-15873-1-git-send-email-giannis.damigos@gmail.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140819150359.GF30401@n2100.arm.linux.org.uk>
References: <20140819150359.GF30401@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ipuv3-crtc.c file that fixes up two "lines
over 80 characters" warnings found by the checkpatch.pl tool,
keeping the alignment of the x/y/width/height parameters for
readability.

Signed-off-by: Yannis Damigos <giannis.damigos@gmail.com>
---
 drivers/staging/imx-drm/ipuv3-crtc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/imx-drm/ipuv3-crtc.c b/drivers/staging/imx-drm/ipuv3-crtc.c
index 720868b..11e84a2 100644
--- a/drivers/staging/imx-drm/ipuv3-crtc.c
+++ b/drivers/staging/imx-drm/ipuv3-crtc.c
@@ -201,7 +201,8 @@ static int ipu_crtc_mode_set(struct drm_crtc *crtc,
 		return ret;
 	}
 
-	return ipu_plane_mode_set(ipu_crtc->plane[0], crtc, mode, crtc->primary->fb,
+	return ipu_plane_mode_set(ipu_crtc->plane[0], crtc, mode,
+				  crtc->primary->fb,
 				  0, 0, mode->hdisplay, mode->vdisplay,
 				  x, y, mode->hdisplay, mode->vdisplay);
 }
@@ -226,9 +227,11 @@ static irqreturn_t ipu_irq_handler(int irq, void *dev_id)
 	imx_drm_handle_vblank(ipu_crtc->imx_crtc);
 
 	if (ipu_crtc->newfb) {
+		struct ipu_plane *plane = ipu_crtc->plane[0];
+
 		ipu_crtc->newfb = NULL;
-		ipu_plane_set_base(ipu_crtc->plane[0], ipu_crtc->base.primary->fb,
-				ipu_crtc->plane[0]->x, ipu_crtc->plane[0]->y);
+		ipu_plane_set_base(plane, ipu_crtc->base.primary->fb,
+				   plane->x, plane->y);
 		ipu_crtc_handle_pageflip(ipu_crtc);
 	}
 
-- 
2.0.4

