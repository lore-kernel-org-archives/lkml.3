Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab3LRVcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:32:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36419 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab3LRVNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.12 062/118] drm/i915: use the correct force_wake function at the PC8 code
Date: Wed, 18 Dec 2013 13:11:39 -0800
Message-Id: <20131218211221.215030917@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Zanoni <paulo.r.zanoni@intel.com>

commit a1216444283e81fd904593a4a77c90adfe5d14d1 upstream.

When I submitted the first patch adding these force wake functions,
Chris Wilson observed that I was using the wrong functions, so I sent
a second version of the patch to correct this problem. The problem is
that v1 was merged instead of v2.

I was able to notice the problem when running the
debugfs-forcewake-user subtest of pm_pc8 from intel-gpu-tools.

Signed-off-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@gmail.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -6062,7 +6062,7 @@ void hsw_restore_lcpll(struct drm_i915_p
 
 	/* Make sure we're not on PC8 state before disabling PC8, otherwise
 	 * we'll hang the machine! */
-	dev_priv->uncore.funcs.force_wake_get(dev_priv);
+	gen6_gt_force_wake_get(dev_priv);
 
 	if (val & LCPLL_POWER_DOWN_ALLOW) {
 		val &= ~LCPLL_POWER_DOWN_ALLOW;
@@ -6093,7 +6093,7 @@ void hsw_restore_lcpll(struct drm_i915_p
 			DRM_ERROR("Switching back to LCPLL failed\n");
 	}
 
-	dev_priv->uncore.funcs.force_wake_put(dev_priv);
+	gen6_gt_force_wake_put(dev_priv);
 }
 
 void hsw_enable_pc8_work(struct work_struct *__work)


