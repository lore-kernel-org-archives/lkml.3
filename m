Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933519AbaLBTZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:25:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46812 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073AbaLBTZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:25:23 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 106/121] drm/i915: drop WaSetupGtModeTdRowDispatch:snb
Date: Tue,  2 Dec 2014 11:19:45 -0800
Message-Id: <1417548000-1794-107-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_pm.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index ba51112..95543ec 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -5195,11 +5195,6 @@ static void gen6_init_clock_gating(struct drm_device *dev)
 	I915_WRITE(_3D_CHICKEN,
 		   _MASKED_BIT_ENABLE(_3D_CHICKEN_HIZ_PLANE_DISABLE_MSAA_4X_SNB));
 
-	/* WaSetupGtModeTdRowDispatch:snb */
-	if (IS_SNB_GT1(dev))
-		I915_WRITE(GEN6_GT_MODE,
-			   _MASKED_BIT_ENABLE(GEN6_TD_FOUR_ROW_DISPATCH_DISABLE));
-
 	I915_WRITE(WM3_LP_ILK, 0);
 	I915_WRITE(WM2_LP_ILK, 0);
 	I915_WRITE(WM1_LP_ILK, 0);
-- 
1.9.1

