Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab3BCPDd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:03:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34573 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754933Ab3BCO6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:58:10 -0500
Message-Id: <20130203144654.273299109@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:40 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Rodrigo Vivi <rodrigo.vivi@gmail.com>,
        Abdallah Chatila <abdallah.chatila@ericsson.com>
Subject: [ 116/128] drm/i915: Implement WaDisableHiZPlanesWhenMSAAEnabled
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 4283908ef7f11a72c3b80dd4cf026f1a86429f82 upstream.

Quoting from Bspec, 3D_CHICKEN1, bit 10

This bit needs to be set always to "1", Project: DevSNB "

Reviewed-by: Rodrigo Vivi <rodrigo.vivi@gmail.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Abdallah Chatila <abdallah.chatila@ericsson.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_reg.h      |    3 +++
 drivers/gpu/drm/i915/intel_display.c |    4 ++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 8fa4f7b..5dc3b6d 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -27,6 +27,8 @@
 
 #define _PIPE(pipe, a, b) ((a) + (pipe)*((b)-(a)))
 
+#define _MASKED_BIT_ENABLE(a) (((a) << 16) | (a))
+
 /*
  * The Bridge device's PCI config space has information about the
  * fb aperture size and the amount of pre-reserved memory.
@@ -354,6 +356,7 @@
  * the enables for writing to the corresponding low bit.
  */
 #define _3D_CHICKEN	0x02084
+#define _3D_CHICKEN_HIZ_PLANE_DISABLE_MSAA_4X_SNB	(1 << 10)
 #define _3D_CHICKEN2	0x0208c
 /* Disables pipelining of read flushes past the SF-WIZ interface.
  * Required on all Ironlake steppings according to the B-Spec, but the
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index d1dca92..b4f4d12 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7412,6 +7412,10 @@ static void gen6_init_clock_gating(struct drm_device *dev)
 		   I915_READ(ILK_DISPLAY_CHICKEN2) |
 		   ILK_ELPIN_409_SELECT);
 
+	/* WaDisableHiZPlanesWhenMSAAEnabled */
+	I915_WRITE(_3D_CHICKEN,
+		   _MASKED_BIT_ENABLE(_3D_CHICKEN_HIZ_PLANE_DISABLE_MSAA_4X_SNB));
+
 	I915_WRITE(WM3_LP_ILK, 0);
 	I915_WRITE(WM2_LP_ILK, 0);
 	I915_WRITE(WM1_LP_ILK, 0);


