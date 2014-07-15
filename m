Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934040AbaGOVjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:39:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54990 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933995AbaGOVi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:38:57 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 142/198] drm/i915: Disable FBC by default also on Haswell and later
Date: Tue, 15 Jul 2014 14:30:12 -0700
Message-Id: <1405459868-15089-143-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 0368920e51ae0cded0eb518c340a4dd17764d461 upstream.

It causes black screen on bootup and is approximately 100x slower than
running with FBC disabled, so the GPU runs at a high frequency for much
longer - completely contrary to the power saving claims. It also still
has mutex deadlocks in multi-head scenarios, which can lead to a
system/X lockup. These bugs were known before FBC was enabled by default
on Haswell and still have not been fixed.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=79716
Reported-and-tested-by: Jon Kristensen <info@jonkri.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[Jani: update subject to reflect the actual change]
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
[ kamal: backport to 3.13-stable ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_pm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 4128d0e..1218c44 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -498,8 +498,7 @@ void intel_update_fbc(struct drm_device *dev)
 	obj = intel_fb->obj;
 	adjusted_mode = &intel_crtc->config.adjusted_mode;
 
-	if (i915_enable_fbc < 0 &&
-	    INTEL_INFO(dev)->gen <= 7 && !IS_HASWELL(dev)) {
+	if (i915_enable_fbc < 0) {
 		if (set_no_fbc_reason(dev_priv, FBC_CHIP_DEFAULT))
 			DRM_DEBUG_KMS("disabled per chip default\n");
 		goto out_disable;
-- 
1.9.1

