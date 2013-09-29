Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab3I2T3U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:29:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59691 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab3I2T3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:29:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 26/71] drm/i915: do not update cursor in crtc mode set
Date: Sun, 29 Sep 2013 12:27:38 -0700
Message-Id: <20130929192645.304715975@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4837,9 +4837,6 @@ static int i9xx_crtc_mode_set(struct drm
 		return -EINVAL;
 	}
 
-	/* Ensure that the cursor is valid for the new mode before changing... */
-	intel_crtc_update_cursor(crtc, true);
-
 	if (is_lvds && dev_priv->lvds_downclock_avail) {
 		/*
 		 * Ensure we match the reduced clock's P to the target clock.
@@ -5688,9 +5685,6 @@ static int ironlake_crtc_mode_set(struct
 		intel_crtc->config.dpll.p2 = clock.p2;
 	}
 
-	/* Ensure that the cursor is valid for the new mode before changing... */
-	intel_crtc_update_cursor(crtc, true);
-
 	/* CPU eDP is the only output that doesn't need a PCH PLL of its own. */
 	if (intel_crtc->config.has_pch_encoder) {
 		fp = i9xx_dpll_compute_fp(&intel_crtc->config.dpll);
@@ -5897,9 +5891,6 @@ static int haswell_crtc_mode_set(struct
 	if (!intel_ddi_pll_mode_set(crtc))
 		return -EINVAL;
 
-	/* Ensure that the cursor is valid for the new mode before changing... */
-	intel_crtc_update_cursor(crtc, true);
-
 	if (intel_crtc->config.has_dp_encoder)
 		intel_dp_set_m_n(intel_crtc);
 


