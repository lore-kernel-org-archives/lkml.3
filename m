Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290Ab3APAY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:24:58 -0500
Received: from mail.kernel.org ([198.145.19.201]:41888 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758169Ab3AOW3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:29:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Damien Lespiau <damien.lespiau@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 079/221] drm/i915: make the panel fitter work on pipes B and C on IVB
Date: Tue, 15 Jan 2013 10:50:06 -0800
Message-Id: <20130115185003.758534231@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Zanoni <paulo.r.zanoni@intel.com>

commit 13888d78c664a1f61d7b09d282f5916993827a40 upstream.

I actually found this problem on Haswell, but then discovered Ivy
Bridge also has it by reading the spec.

I don't have the hardware to test this.

Signed-off-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Reviewed-by: Damien Lespiau <damien.lespiau@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_reg.h      |    2 ++
 drivers/gpu/drm/i915/intel_display.c |    6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3315,6 +3315,8 @@
 #define _PFA_CTL_1               0x68080
 #define _PFB_CTL_1               0x68880
 #define  PF_ENABLE              (1<<31)
+#define  PF_PIPE_SEL_MASK_IVB	(3<<29)
+#define  PF_PIPE_SEL_IVB(pipe)	((pipe)<<29)
 #define  PF_FILTER_MASK		(3<<23)
 #define  PF_FILTER_PROGRAMMED	(0<<23)
 #define  PF_FILTER_MED_3x3	(1<<23)
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3225,7 +3225,11 @@ static void ironlake_crtc_enable(struct
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


