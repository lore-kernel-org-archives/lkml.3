Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483Ab3E1VZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:25:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59719 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932747Ab3E1VZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:25:10 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 78/78] drm/i915: don't intel_crt_init on any ULT machines
Date: Tue, 28 May 2013 14:20:27 -0700
Message-Id: <1369776027-17859-79-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Zanoni <paulo.r.zanoni@intel.com>

commit c40c0f5bd5b0f09e4386d2cf26c96c89c45ee539 upstream.

We may have DDI_BUF_CTL(PORT_A) configured with 2 lanes and still not
have CRT, so just check for !IS_ULT. This problem happened on a real
machine and resulted in a very ugly dmesg.

Signed-off-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_display.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index e05d0ba..b17d8a8 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8452,7 +8452,7 @@ static void intel_setup_outputs(struct drm_device *dev)
 		I915_WRITE(PFIT_CONTROL, 0);
 	}
 
-	if (!(HAS_DDI(dev) && (I915_READ(DDI_BUF_CTL(PORT_A)) & DDI_A_4_LANES)))
+	if (!IS_ULT(dev))
 		intel_crt_init(dev);
 
 	if (HAS_DDI(dev)) {
-- 
1.8.1.2

