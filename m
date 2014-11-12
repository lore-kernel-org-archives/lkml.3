Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965694AbaKLDAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:00:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60114 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933502AbaKLBkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:40:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>, Scot Doyle <lkml14@scotdoyle.com>
Subject: [PATCH 3.14 069/203] drm/i915: dont warn if backlight unexpectedly enabled
Date: Wed, 12 Nov 2014 10:15:39 +0900
Message-Id: <20141112011545.867755777@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_panel.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -645,7 +645,7 @@ static void pch_enable_backlight(struct
 
 	cpu_ctl2 = I915_READ(BLC_PWM_CPU_CTL2);
 	if (cpu_ctl2 & BLM_PWM_ENABLE) {
-		WARN(1, "cpu backlight already enabled\n");
+		DRM_DEBUG_KMS("cpu backlight already enabled\n");
 		cpu_ctl2 &= ~BLM_PWM_ENABLE;
 		I915_WRITE(BLC_PWM_CPU_CTL2, cpu_ctl2);
 	}
@@ -693,7 +693,7 @@ static void i9xx_enable_backlight(struct
 
 	ctl = I915_READ(BLC_PWM_CTL);
 	if (ctl & BACKLIGHT_DUTY_CYCLE_MASK_PNV) {
-		WARN(1, "backlight already enabled\n");
+		DRM_DEBUG_KMS("backlight already enabled\n");
 		I915_WRITE(BLC_PWM_CTL, 0);
 	}
 
@@ -724,7 +724,7 @@ static void i965_enable_backlight(struct
 
 	ctl2 = I915_READ(BLC_PWM_CTL2);
 	if (ctl2 & BLM_PWM_ENABLE) {
-		WARN(1, "backlight already enabled\n");
+		DRM_DEBUG_KMS("backlight already enabled\n");
 		ctl2 &= ~BLM_PWM_ENABLE;
 		I915_WRITE(BLC_PWM_CTL2, ctl2);
 	}
@@ -758,7 +758,7 @@ static void vlv_enable_backlight(struct
 
 	ctl2 = I915_READ(VLV_BLC_PWM_CTL2(pipe));
 	if (ctl2 & BLM_PWM_ENABLE) {
-		WARN(1, "backlight already enabled\n");
+		DRM_DEBUG_KMS("backlight already enabled\n");
 		ctl2 &= ~BLM_PWM_ENABLE;
 		I915_WRITE(VLV_BLC_PWM_CTL2(pipe), ctl2);
 	}


