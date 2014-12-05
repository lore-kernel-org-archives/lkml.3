Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbaLEXCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:02:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54631 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbaLEXB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 18:01:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Leo Wolf <jclw@ymail.com>, Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 3.17 109/122] drm/i915: drop WaSetupGtModeTdRowDispatch:snb
Date: Fri,  5 Dec 2014 14:44:43 -0800
Message-Id: <20141205223322.528891619@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_pm.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -5247,11 +5247,6 @@ static void gen6_init_clock_gating(struc
 	I915_WRITE(_3D_CHICKEN,
 		   _MASKED_BIT_ENABLE(_3D_CHICKEN_HIZ_PLANE_DISABLE_MSAA_4X_SNB));
 
-	/* WaSetupGtModeTdRowDispatch:snb */
-	if (IS_SNB_GT1(dev))
-		I915_WRITE(GEN6_GT_MODE,
-			   _MASKED_BIT_ENABLE(GEN6_TD_FOUR_ROW_DISPATCH_DISABLE));
-
 	/* WaDisable_RenderCache_OperationalFlush:snb */
 	I915_WRITE(CACHE_MODE_0, _MASKED_BIT_DISABLE(RC_OP_FLUSH_ENABLE));
 


