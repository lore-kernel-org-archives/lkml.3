Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbaLOPM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:12:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38287 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbaLOO10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:26 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 029/168] drm/i915: drop WaSetupGtModeTdRowDispatch:snb
Date: Mon, 15 Dec 2014 14:24:43 +0000
Message-Id: <1418653622-21105-30-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 2208d655a91f9879bd9a39ff9df05dd668b3512c upstream.

This reverts the regressing

commit 6547fbdbfff62c99e4f7b4f985ff8b3454f33b0f
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Fri Dec 14 23:38:29 2012 +0100

    drm/i915: Implement WaSetupGtModeTdRowDispatch

that causes GPU hangs immediately on boot.

Reported-by: Leo Wolf <jclw@ymail.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=79996
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
[Jani: amended the commit message slightly.]
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_pm.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index ee72807069e4..e6f131db18cc 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -4942,11 +4942,6 @@ static void gen6_init_clock_gating(struct drm_device *dev)
 	I915_WRITE(_3D_CHICKEN,
 		   _MASKED_BIT_ENABLE(_3D_CHICKEN_HIZ_PLANE_DISABLE_MSAA_4X_SNB));
 
-	/* WaSetupGtModeTdRowDispatch:snb */
-	if (IS_SNB_GT1(dev))
-		I915_WRITE(GEN6_GT_MODE,
-			   _MASKED_BIT_ENABLE(GEN6_TD_FOUR_ROW_DISPATCH_DISABLE));
-
 	/* WaDisable_RenderCache_OperationalFlush:snb */
 	I915_WRITE(CACHE_MODE_0, _MASKED_BIT_DISABLE(RC_OP_FLUSH_ENABLE));
 
-- 
2.1.3

