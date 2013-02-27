Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933555Ab3B0ATe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:19:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760377Ab3B0AJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:09:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 49/86] drm: Use C8 instead of RGB332 when determining the format from depth/bpp
Date: Tue, 26 Feb 2013 16:07:57 -0800
Message-Id: <20130226235917.992896998@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235912.881663118@linuxfoundation.org>
References: <20130226235912.881663118@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_crtc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -2023,7 +2023,7 @@ uint32_t drm_mode_legacy_fb_format(uint3
 
 	switch (bpp) {
 	case 8:
-		fmt = DRM_FORMAT_RGB332;
+		fmt = DRM_FORMAT_C8;
 		break;
 	case 16:
 		if (depth == 15)


