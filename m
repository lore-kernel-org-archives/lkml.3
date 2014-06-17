Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967569AbaFQWl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:41:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53944 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965454AbaFQVsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:48:04 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jani Nikula <jani.nikula@intel.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 103/212] drm/i915/vlv: reset VLV media force wake request register
Date: Tue, 17 Jun 2014 14:43:17 -0700
Message-Id: <1403041506-13646-104-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 05adaf1f101f25f40f12c29403e6488f0e45f6b6 upstream.

Media force wake get hangs the machine when the system is booted without
displays attached. The assumption is that (at least some versions of)
the firmware has skipped some initialization in that case.

Empirical evidence suggests we need to reset the media force wake
request register in addition to the render one to avoid hangs.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=75895
Reported-by: Imre Deak <imre.deak@intel.com>
Reported-by: Darren Hart <dvhart@linux.intel.com>
Tested-by: Darren Hart <dvhart@linux.intel.com>
Reviewed-by: Mika Kuoppala <mika.kuoppala@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_uncore.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_uncore.c b/drivers/gpu/drm/i915/intel_uncore.c
index 25cbe07..8c9fb30 100644
--- a/drivers/gpu/drm/i915/intel_uncore.c
+++ b/drivers/gpu/drm/i915/intel_uncore.c
@@ -167,6 +167,8 @@ static void vlv_force_wake_reset(struct drm_i915_private *dev_priv)
 {
 	__raw_i915_write32(dev_priv, FORCEWAKE_VLV,
 			   _MASKED_BIT_DISABLE(0xffff));
+	__raw_i915_write32(dev_priv, FORCEWAKE_MEDIA_VLV,
+			   _MASKED_BIT_DISABLE(0xffff));
 	/* something from same cacheline, but !FORCEWAKE_VLV */
 	__raw_posting_read(dev_priv, FORCEWAKE_ACK_VLV);
 }
-- 
1.9.1

