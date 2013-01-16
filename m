Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269Ab3APQAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:00:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35819 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351Ab3APP75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:59:57 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 040/222] drm/i915: make the panel fitter work on pipes B and C on IVB
Date: Wed, 16 Jan 2013 13:54:00 -0200
Message-Id: <1358351822-7675-41-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Zanoni <paulo.r.zanoni@intel.com>

commit 13888d78c664a1f61d7b09d282f5916993827a40 upstream.

I actually found this problem on Haswell, but then discovered Ivy
Bridge also has it by reading the spec.

I don't have the hardware to test this.

Signed-off-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Reviewed-by: Damien Lespiau <damien.lespiau@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/i915/i915_reg.h      |    2 ++
 drivers/gpu/drm/i915/intel_display.c |    6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 84c04c8..19398df 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3182,6 +3182,8 @@
 #define _PFA_CTL_1               0x68080
 #define _PFB_CTL_1               0x68880
 #define  PF_ENABLE              (1<<31)
+#define  PF_PIPE_SEL_MASK_IVB	(3<<29)
+#define  PF_PIPE_SEL_IVB(pipe)	((pipe)<<29)
 #define  PF_FILTER_MASK		(3<<23)
 #define  PF_FILTER_PROGRAMMED	(0<<23)
 #define  PF_FILTER_MED_3x3	(1<<23)
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 552a229..f320aaf 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3054,7 +3054,11 @@ static void ironlake_crtc_enable(struct drm_crtc *crtc)
 		 * as some pre-programmed values are broken,
 		 * e.g. x201.
 		 */
-		I915_WRITE(PF_CTL(pipe), PF_ENABLE | PF_FILTER_MED_3x3);
+		if (IS_IVYBRIDGE(dev))
+			I915_WRITE(PF_CTL(pipe), PF_ENABLE | PF_FILTER_MED_3x3 |
+						 PF_PIPE_SEL_IVB(pipe));
+		else
+			I915_WRITE(PF_CTL(pipe), PF_ENABLE | PF_FILTER_MED_3x3);
 		I915_WRITE(PF_WIN_POS(pipe), dev_priv->pch_pf_pos);
 		I915_WRITE(PF_WIN_SZ(pipe), dev_priv->pch_pf_size);
 	}
-- 
1.7.9.5

