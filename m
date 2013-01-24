Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422660Ab3AXVYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:24:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:40919 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932119Ab3AXVQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:16:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Rodrigo Vivi <rodrigo.vivi@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Abdallah Chatila <abdallah.chatila@ericsson.com>
Subject: [ 19/22] drm/i915: Implement WaDisableHiZPlanesWhenMSAAEnabled
Date: Thu, 24 Jan 2013 13:15:40 -0800
Message-Id: <20130124211510.921387461@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211504.701368763@linuxfoundation.org>
References: <20130124211504.701368763@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 4283908ef7f11a72c3b80dd4cf026f1a86429f82 upstream.

Quoting from Bspec, 3D_CHICKEN1, bit 10

This bit needs to be set always to "1", Project: DevSNB "

Reviewed-by: Rodrigo Vivi <rodrigo.vivi@gmail.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Abdallah Chatila <abdallah.chatila@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_reg.h      |    3 +++
 drivers/gpu/drm/i915/intel_display.c |    4 ++++
 2 files changed, 7 insertions(+)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -27,6 +27,8 @@
 
 #define _PIPE(pipe, a, b) ((a) + (pipe)*((b)-(a)))
 
+#define _MASKED_BIT_ENABLE(a) (((a) << 16) | (a))
+
 /*
  * The Bridge device's PCI config space has information about the
  * fb aperture size and the amount of pre-reserved memory.
@@ -433,6 +435,7 @@
  * the enables for writing to the corresponding low bit.
  */
 #define _3D_CHICKEN	0x02084
+#define _3D_CHICKEN_HIZ_PLANE_DISABLE_MSAA_4X_SNB	(1 << 10)
 #define _3D_CHICKEN2	0x0208c
 /* Disables pipelining of read flushes past the SF-WIZ interface.
  * Required on all Ironlake steppings according to the B-Spec, but the
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8592,6 +8592,10 @@ static void gen6_init_clock_gating(struc
 		   I915_READ(ILK_DISPLAY_CHICKEN2) |
 		   ILK_ELPIN_409_SELECT);
 
+	/* WaDisableHiZPlanesWhenMSAAEnabled */
+	I915_WRITE(_3D_CHICKEN,
+		   _MASKED_BIT_ENABLE(_3D_CHICKEN_HIZ_PLANE_DISABLE_MSAA_4X_SNB));
+
 	I915_WRITE(WM3_LP_ILK, 0);
 	I915_WRITE(WM2_LP_ILK, 0);
 	I915_WRITE(WM1_LP_ILK, 0);


