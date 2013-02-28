Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797Ab3B1OuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:50:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42428 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720Ab3B1OuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:50:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 106/139] drm: Use C8 instead of RGB332 when determining the format from depth/bpp
Date: Thu, 28 Feb 2013 14:44:16 +0000
Message-Id: <1362062689-2567-107-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>

commit d84f031bd230fdf9c3b7734940c859bf28b90219 upstream.

Support for real RGB332 is a rarity, most hardware only really support
C8. So use C8 instead of RGB332 when determining the format based on
depth/bpp.

This fixes 8bpp fbcon on i915, since i915 will only accept C8 and not
RGB332.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=59572
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Acked-by: Dave Airlie <airlied@gmail.com>
Tested-by: mlsemon35@gmail.com
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/drm_crtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 2ca9737..3859f43 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -2023,7 +2023,7 @@ uint32_t drm_mode_legacy_fb_format(uint32_t bpp, uint32_t depth)
 
 	switch (bpp) {
 	case 8:
-		fmt = DRM_FORMAT_RGB332;
+		fmt = DRM_FORMAT_C8;
 		break;
 	case 16:
 		if (depth == 15)
-- 
1.8.1.2

