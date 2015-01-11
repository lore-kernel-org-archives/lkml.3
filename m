Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbbAKWdo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:33:44 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:39939 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbbAKWdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:33:43 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jani Nikula <jani.nikula@intel.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm/nouveau/dispnv04/disp: Remove some unused functions
Date: Sun, 11 Jan 2015 23:36:47 +0100
Message-Id: <1421015807-25273-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
nv04_display_late_takedown() nv04_display_early_init()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/nouveau/dispnv04/disp.c |   18 ------------------
 drivers/gpu/drm/nouveau/dispnv04/disp.h |    2 --
 2 files changed, 20 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv04/disp.c b/drivers/gpu/drm/nouveau/dispnv04/disp.c
index 3d0afa1..bdf7cf4 100644
--- a/drivers/gpu/drm/nouveau/dispnv04/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv04/disp.c
@@ -32,24 +32,6 @@
 #include "nouveau_connector.h"
 
 int
-nv04_display_early_init(struct drm_device *dev)
-{
-	/* ensure vblank interrupts are off, they can't be enabled until
-	 * drm_vblank has been initialised
-	 */
-	NVWriteCRTC(dev, 0, NV_PCRTC_INTR_EN_0, 0);
-	if (nv_two_heads(dev))
-		NVWriteCRTC(dev, 1, NV_PCRTC_INTR_EN_0, 0);
-
-	return 0;
-}
-
-void
-nv04_display_late_takedown(struct drm_device *dev)
-{
-}
-
-int
 nv04_display_create(struct drm_device *dev)
 {
 	struct nouveau_drm *drm = nouveau_drm(dev);
diff --git a/drivers/gpu/drm/nouveau/dispnv04/disp.h b/drivers/gpu/drm/nouveau/dispnv04/disp.h
index 17b899d..3ad3ee8 100644
--- a/drivers/gpu/drm/nouveau/dispnv04/disp.h
+++ b/drivers/gpu/drm/nouveau/dispnv04/disp.h
@@ -90,8 +90,6 @@ nv04_display(struct drm_device *dev)
 }
 
 /* nv04_display.c */
-int nv04_display_early_init(struct drm_device *);
-void nv04_display_late_takedown(struct drm_device *);
 int nv04_display_create(struct drm_device *);
 void nv04_display_destroy(struct drm_device *);
 int nv04_display_init(struct drm_device *);
-- 
1.7.10.4

