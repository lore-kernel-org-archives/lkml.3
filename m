Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab3IJICs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 04:02:48 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:38132 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab3IJICl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 04:02:41 -0400
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Knut Petersen <Knut_Petersen@t-online.de>
Subject: [PATCH] drm/i915/sdvo: Fully translate sync flags in the dtd->mode conversion
Date: Tue, 10 Sep 2013 10:02:48 +0200
Message-Id: <1378800168-32277-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <522A5008.6060005@t-online.de>
References: <522A5008.6060005@t-online.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of just a flag bit for each of the positive/negative sync
modes drm actually uses a separate flag for each ... This upsets the
modeset checker since the adjusted mode filled out at modeset time
doesn't match the one reconstructed at check time (since the
->get_config callback already gets this right).

Reported-by: Knut Petersen <Knut_Petersen@t-online.de>
Cc: Knut Petersen <Knut_Petersen@t-online.de>
References: http://www.gossamer-threads.com/lists/linux/kernel/1778688?do=post_view_threaded
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/intel_sdvo.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index 85037b9..5033c74 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -866,8 +866,12 @@ static void intel_sdvo_get_mode_from_dtd(struct drm_display_mode * mode,
 		mode->flags |= DRM_MODE_FLAG_INTERLACE;
 	if (dtd->part2.dtd_flags & DTD_FLAG_HSYNC_POSITIVE)
 		mode->flags |= DRM_MODE_FLAG_PHSYNC;
+	else
+		mode->flags |= DRM_MODE_FLAG_NHSYNC;
 	if (dtd->part2.dtd_flags & DTD_FLAG_VSYNC_POSITIVE)
 		mode->flags |= DRM_MODE_FLAG_PVSYNC;
+	else
+		mode->flags |= DRM_MODE_FLAG_NVSYNC;
 }
 
 static bool intel_sdvo_check_supp_encode(struct intel_sdvo *intel_sdvo)
-- 
1.8.4.rc3

