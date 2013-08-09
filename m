Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030360Ab3HICFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:05:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55864 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967740Ab3HIB72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pierre Assal <pierre.assal@verint.com>,
        "cancan,feng" <cancan.feng@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 080/102] drm/i915: make SDVO TV-out work for multifunction devices
Date: Thu,  8 Aug 2013 18:57:56 -0700
Message-Id: <20130809015029.083058664@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 09ede5414f0215461c933032630bf9c3a61a8ba3 upstream.

We need to track this correctly. While at it shovel the boolean
to track whether the sdvo is in tv mode or not into pipe_config.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=36997
Tested-by: Pierre Assal <pierre.assal@verint.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=63609
Tested-by: cancan,feng <cancan.feng@intel.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/gpu/drm/i915/intel_display.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4333,7 +4333,8 @@ static void vlv_update_pll(struct intel_
 
 static void i9xx_update_pll(struct intel_crtc *crtc,
 			    intel_clock_t *reduced_clock,
-			    int num_connectors)
+			    int num_connectors,
+			    bool needs_tv_clock)
 {
 	struct drm_device *dev = crtc->base.dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
@@ -4391,7 +4392,7 @@ static void i9xx_update_pll(struct intel
 	if (INTEL_INFO(dev)->gen >= 4)
 		dpll |= (6 << PLL_LOAD_PULSE_PHASE_SHIFT);
 
-	if (is_sdvo && intel_pipe_has_type(&crtc->base, INTEL_OUTPUT_TVOUT))
+	if (is_sdvo && needs_tv_clock)
 		dpll |= PLL_REF_INPUT_TVCLKINBC;
 	else if (intel_pipe_has_type(&crtc->base, INTEL_OUTPUT_TVOUT))
 		/* XXX: just matching BIOS for now */
@@ -4716,7 +4717,8 @@ static int i9xx_crtc_mode_set(struct drm
 	else
 		i9xx_update_pll(intel_crtc,
 				has_reduced_clock ? &reduced_clock : NULL,
-				num_connectors);
+				num_connectors,
+				is_sdvo && is_tv);
 
 	/* Set up the display plane register */
 	dspcntr = DISPPLANE_GAMMA_ENABLE;


