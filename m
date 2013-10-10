Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab3JJPox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:44:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52640 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621Ab3JJPou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:44:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 049/104] drm/i915: do not update cursor in crtc mode set
Date: Thu, 10 Oct 2013 08:41:37 -0700
Message-Id: <1381419752-29733-50-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit cc173961a68034c1171a421f0dbed39edfb60880 upstream.

The cursor is disabled before crtc mode set in crtc disable (and we
assert this is the case), and enabled afterwards in crtc enable. Do not
update it in crtc mode set.

On HSW enabling a plane on a disabled pipe may hang the entire system.
And there's no good reason for doing it ever, so just don't.

v2: Add note about HSW hangs - vsyrjala

Suggested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Tested-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ kamal: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 33015db..3e4e629 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4750,9 +4750,6 @@ static int i9xx_crtc_mode_set(struct drm_crtc *crtc,
 		return -EINVAL;
 	}
 
-	/* Ensure that the cursor is valid for the new mode before changing... */
-	intel_crtc_update_cursor(crtc, true);
-
 	if (is_lvds && dev_priv->lvds_downclock_avail) {
 		/*
 		 * Ensure we match the reduced clock's P to the target clock.
@@ -5639,9 +5636,6 @@ static int ironlake_crtc_mode_set(struct drm_crtc *crtc,
 		return -EINVAL;
 	}
 
-	/* Ensure that the cursor is valid for the new mode before changing... */
-	intel_crtc_update_cursor(crtc, true);
-
 	/* determine panel color depth */
 	dither = intel_choose_pipe_bpp_dither(crtc, fb, &intel_crtc->bpp,
 					      adjusted_mode);
@@ -5842,9 +5836,6 @@ static int haswell_crtc_mode_set(struct drm_crtc *crtc,
 		}
 	}
 
-	/* Ensure that the cursor is valid for the new mode before changing... */
-	intel_crtc_update_cursor(crtc, true);
-
 	/* determine panel color depth */
 	dither = intel_choose_pipe_bpp_dither(crtc, fb, &intel_crtc->bpp,
 					      adjusted_mode);
-- 
1.8.1.2

