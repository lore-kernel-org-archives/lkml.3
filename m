Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbaGHBLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:11:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55249 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbaGGXxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:53:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 3.15 041/122] drm/i915: Disable FBC by default also on Haswell and later
Date: Mon,  7 Jul 2014 16:56:43 -0700
Message-Id: <20140707235735.477420990@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_pm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -511,8 +511,7 @@ void intel_update_fbc(struct drm_device
 	obj = intel_fb->obj;
 	adjusted_mode = &intel_crtc->config.adjusted_mode;
 
-	if (i915.enable_fbc < 0 &&
-	    INTEL_INFO(dev)->gen <= 7 && !IS_HASWELL(dev)) {
+	if (i915.enable_fbc < 0) {
 		if (set_no_fbc_reason(dev_priv, FBC_CHIP_DEFAULT))
 			DRM_DEBUG_KMS("disabled per chip default\n");
 		goto out_disable;


