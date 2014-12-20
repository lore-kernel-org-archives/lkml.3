Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbaLTROq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 12:14:46 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:56318 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbaLTROp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 12:14:45 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: David Airlie <airlied@linux.ie>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Rob Clark <robdclark@gmail.com>, Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gpu: drm: sti: sti_drm_crtc.c:  Remove unused function
Date: Sat, 20 Dec 2014 18:17:30 +0100
Message-Id: <1419095850-10436-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function sti_drm_crtc_is_main() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/sti/sti_drm_crtc.c |   10 ----------
 drivers/gpu/drm/sti/sti_drm_crtc.h |    1 -
 2 files changed, 11 deletions(-)

diff --git a/drivers/gpu/drm/sti/sti_drm_crtc.c b/drivers/gpu/drm/sti/sti_drm_crtc.c
index d2ae0c0..be53e35 100644
--- a/drivers/gpu/drm/sti/sti_drm_crtc.c
+++ b/drivers/gpu/drm/sti/sti_drm_crtc.c
@@ -389,16 +389,6 @@ static struct drm_crtc_funcs sti_crtc_funcs = {
 	.set_property = sti_drm_crtc_set_property,
 };
 
-bool sti_drm_crtc_is_main(struct drm_crtc *crtc)
-{
-	struct sti_mixer *mixer = to_sti_mixer(crtc);
-
-	if (mixer->id == STI_MIXER_MAIN)
-		return true;
-
-	return false;
-}
-
 int sti_drm_crtc_init(struct drm_device *drm_dev, struct sti_mixer *mixer,
 		struct drm_plane *primary, struct drm_plane *cursor)
 {
diff --git a/drivers/gpu/drm/sti/sti_drm_crtc.h b/drivers/gpu/drm/sti/sti_drm_crtc.h
index caca8b1..ddae8fe 100644
--- a/drivers/gpu/drm/sti/sti_drm_crtc.h
+++ b/drivers/gpu/drm/sti/sti_drm_crtc.h
@@ -17,6 +17,5 @@ int sti_drm_crtc_enable_vblank(struct drm_device *dev, int crtc);
 void sti_drm_crtc_disable_vblank(struct drm_device *dev, int crtc);
 int sti_drm_crtc_vblank_cb(struct notifier_block *nb,
 		unsigned long event, void *data);
-bool sti_drm_crtc_is_main(struct drm_crtc *drm_crtc);
 
 #endif
-- 
1.7.10.4

