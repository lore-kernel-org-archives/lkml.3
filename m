Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab3BEWP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:15:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48254 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757951Ab3BEWMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:12:52 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 83/93] drm/i915: Implement WaDisableHiZPlanesWhenMSAAEnabled
Date: Tue,  5 Feb 2013 20:07:12 -0200
Message-Id: <1360102042-10732-84-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 4283908ef7f11a72c3b80dd4cf026f1a86429f82 upstream.

Quoting from Bspec, 3D_CHICKEN1, bit 10

This bit needs to be set always to "1", Project: DevSNB "

Reviewed-by: Rodrigo Vivi <rodrigo.vivi@gmail.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/i915/i915_reg.h |    1 +
 drivers/gpu/drm/i915/intel_pm.c |    4 ++++
 2 files changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 623224c..44feabe 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -501,6 +501,7 @@
  * the enables for writing to the corresponding low bit.
  */
 #define _3D_CHICKEN	0x02084
+#define  _3D_CHICKEN_HIZ_PLANE_DISABLE_MSAA_4X_SNB	(1 << 10)
 #define _3D_CHICKEN2	0x0208c
 /* Disables pipelining of read flushes past the SF-WIZ interface.
  * Required on all Ironlake steppings according to the B-Spec, but the
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index f8e332d..b40ce63 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -3307,6 +3307,10 @@ static void gen6_init_clock_gating(struct drm_device *dev)
 		   I915_READ(ILK_DISPLAY_CHICKEN2) |
 		   ILK_ELPIN_409_SELECT);
 
+	/* WaDisableHiZPlanesWhenMSAAEnabled */
+	I915_WRITE(_3D_CHICKEN,
+		   _MASKED_BIT_ENABLE(_3D_CHICKEN_HIZ_PLANE_DISABLE_MSAA_4X_SNB));
+
 	I915_WRITE(WM3_LP_ILK, 0);
 	I915_WRITE(WM2_LP_ILK, 0);
 	I915_WRITE(WM1_LP_ILK, 0);
-- 
1.7.9.5

