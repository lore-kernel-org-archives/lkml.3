Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbaLGS0k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 13:26:40 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34106 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbaLGS0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 13:26:38 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gpu: drm: i915: intel_display.c:  Remove unused function
Date: Sun,  7 Dec 2014 19:29:17 +0100
Message-Id: <1417976957-15049-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function intel_output_name() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/i915/intel_display.c |   22 ----------------------
 drivers/gpu/drm/i915/intel_drv.h     |    1 -
 2 files changed, 23 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index f0a1a56..14c47cf 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -12258,28 +12258,6 @@ static bool has_edp_a(struct drm_device *dev)
 	return true;
 }
 
-const char *intel_output_name(int output)
-{
-	static const char *names[] = {
-		[INTEL_OUTPUT_UNUSED] = "Unused",
-		[INTEL_OUTPUT_ANALOG] = "Analog",
-		[INTEL_OUTPUT_DVO] = "DVO",
-		[INTEL_OUTPUT_SDVO] = "SDVO",
-		[INTEL_OUTPUT_LVDS] = "LVDS",
-		[INTEL_OUTPUT_TVOUT] = "TV",
-		[INTEL_OUTPUT_HDMI] = "HDMI",
-		[INTEL_OUTPUT_DISPLAYPORT] = "DisplayPort",
-		[INTEL_OUTPUT_EDP] = "eDP",
-		[INTEL_OUTPUT_DSI] = "DSI",
-		[INTEL_OUTPUT_UNKNOWN] = "Unknown",
-	};
-
-	if (output < 0 || output >= ARRAY_SIZE(names) || !names[output])
-		return "Invalid";
-
-	return names[output];
-}
-
 static bool intel_crt_present(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index ba71522..7dde496 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -793,7 +793,6 @@ void intel_ddi_clock_get(struct intel_encoder *encoder,
 void intel_ddi_set_vc_payload_alloc(struct drm_crtc *crtc, bool state);
 
 /* intel_display.c */
-const char *intel_output_name(int output);
 bool intel_has_pending_fb_unpin(struct drm_device *dev);
 int intel_pch_rawclk(struct drm_device *dev);
 void intel_mark_busy(struct drm_device *dev);
-- 
1.7.10.4

