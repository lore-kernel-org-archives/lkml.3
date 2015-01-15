Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbbAOVZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:25:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506AbbAOVZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:25:52 -0500
From: Gerd Hoffmann <kraxel@redhat.com>
To: airlied@gmail.com, dri-devel@lists.freedesktop.org
Cc: Gerd Hoffmann <kraxel@redhat.com>, David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RESEND PATCH] qxl: catch qxlfb_create_pinned_object failures
Date: Thu, 15 Jan 2015 22:25:43 +0100
Message-Id: <1421357143-6617-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/gpu/drm/qxl/qxl_fb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/qxl/qxl_fb.c b/drivers/gpu/drm/qxl/qxl_fb.c
index 3d7c1d0..18ef31a 100644
--- a/drivers/gpu/drm/qxl/qxl_fb.c
+++ b/drivers/gpu/drm/qxl/qxl_fb.c
@@ -521,6 +521,9 @@ static int qxlfb_create(struct qxl_fbdev *qfbdev,
 	mode_cmd.pixel_format = drm_mode_legacy_fb_format(bpp, depth);
 
 	ret = qxlfb_create_pinned_object(qfbdev, &mode_cmd, &gobj);
+	if (ret < 0)
+		return ret;
+
 	qbo = gem_to_qxl_bo(gobj);
 	QXL_INFO(qdev, "%s: %dx%d %d\n", __func__, mode_cmd.width,
 		 mode_cmd.height, mode_cmd.pitches[0]);
-- 
1.8.3.1

