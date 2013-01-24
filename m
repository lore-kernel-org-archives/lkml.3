Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108Ab3AXVb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:31:28 -0500
Received: from mail.kernel.org ([198.145.19.201]:40331 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756882Ab3AXVOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:14:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Rodrigo Vivi <rodrigo.vivi@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 34/46] drm/i915: Implement WaDisableHiZPlanesWhenMSAAEnabled
Date: Thu, 24 Jan 2013 13:13:12 -0800
Message-Id: <20130124211148.513577935@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211135.862755794@linuxfoundation.org>
References: <20130124211135.862755794@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 4283908ef7f11a72c3b80dd4cf026f1a86429f82 upstream.

Quoting from Bspec, 3D_CHICKEN1, bit 10

This bit needs to be set always to "1", Project: DevSNB "

Reviewed-by: Rodrigo Vivi <rodrigo.vivi@gmail.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_reg.h |    1 +
 drivers/gpu/drm/i915/intel_pm.c |    4 ++++
 2 files changed, 5 insertions(+)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -514,6 +514,7 @@
  * the enables for writing to the corresponding low bit.
  */
 #define _3D_CHICKEN	0x02084
+#define  _3D_CHICKEN_HIZ_PLANE_DISABLE_MSAA_4X_SNB	(1 << 10)
 #define _3D_CHICKEN2	0x0208c
 /* Disables pipelining of read flushes past the SF-WIZ interface.
  * Required on all Ironlake steppings according to the B-Spec, but the
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -3412,6 +3412,10 @@ static void gen6_init_clock_gating(struc
 		   I915_READ(ILK_DISPLAY_CHICKEN2) |
 		   ILK_ELPIN_409_SELECT);
 
+	/* WaDisableHiZPlanesWhenMSAAEnabled */
+	I915_WRITE(_3D_CHICKEN,
+		   _MASKED_BIT_ENABLE(_3D_CHICKEN_HIZ_PLANE_DISABLE_MSAA_4X_SNB));
+
 	I915_WRITE(WM3_LP_ILK, 0);
 	I915_WRITE(WM2_LP_ILK, 0);
 	I915_WRITE(WM1_LP_ILK, 0);


