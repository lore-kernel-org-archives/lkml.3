Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbbALTT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:19:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57277 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbbALSFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:20 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jani Nikula <jani.nikula@intel.com>, Scot Doyle <lkml14@scotdoyle.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 001/216] drm/i915: don't warn if backlight unexpectedly enabled
Date: Mon, 12 Jan 2015 18:01:58 +0000
Message-Id: <1421085933-32536-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scot Doyle <lkml14@scotdoyle.com>

commit 813008cd3e93ea8a571b2b7d5b9360a3105b50f7 upstream.

BIOS or firmware can modify hardware state during suspend/resume,
for example on the Toshiba CB35 or Lenovo T400, so log a debug message
instead of a warning if the backlight is unexpectedly enabled.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=80930
Cc: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Scot Doyle <lkml14@scotdoyle.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_panel.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index 12b02fe1d0ae..59b294c5fe41 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -711,7 +711,7 @@ static void pch_enable_backlight(struct intel_connector *connector)
 
 	cpu_ctl2 = I915_READ(BLC_PWM_CPU_CTL2);
 	if (cpu_ctl2 & BLM_PWM_ENABLE) {
-		WARN(1, "cpu backlight already enabled\n");
+		DRM_DEBUG_KMS("cpu backlight already enabled\n");
 		cpu_ctl2 &= ~BLM_PWM_ENABLE;
 		I915_WRITE(BLC_PWM_CPU_CTL2, cpu_ctl2);
 	}
@@ -755,7 +755,7 @@ static void i9xx_enable_backlight(struct intel_connector *connector)
 
 	ctl = I915_READ(BLC_PWM_CTL);
 	if (ctl & BACKLIGHT_DUTY_CYCLE_MASK_PNV) {
-		WARN(1, "backlight already enabled\n");
+		DRM_DEBUG_KMS("backlight already enabled\n");
 		I915_WRITE(BLC_PWM_CTL, 0);
 	}
 
@@ -786,7 +786,7 @@ static void i965_enable_backlight(struct intel_connector *connector)
 
 	ctl2 = I915_READ(BLC_PWM_CTL2);
 	if (ctl2 & BLM_PWM_ENABLE) {
-		WARN(1, "backlight already enabled\n");
+		DRM_DEBUG_KMS("backlight already enabled\n");
 		ctl2 &= ~BLM_PWM_ENABLE;
 		I915_WRITE(BLC_PWM_CTL2, ctl2);
 	}
@@ -820,7 +820,7 @@ static void vlv_enable_backlight(struct intel_connector *connector)
 
 	ctl2 = I915_READ(VLV_BLC_PWM_CTL2(pipe));
 	if (ctl2 & BLM_PWM_ENABLE) {
-		WARN(1, "backlight already enabled\n");
+		DRM_DEBUG_KMS("backlight already enabled\n");
 		ctl2 &= ~BLM_PWM_ENABLE;
 		I915_WRITE(VLV_BLC_PWM_CTL2(pipe), ctl2);
 	}
-- 
2.1.4

