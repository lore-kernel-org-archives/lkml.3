Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbaFIJJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:09:23 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58453 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754893AbaFIIvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 080/146] drm/i915/vlv: reset VLV media force wake request register
Date: Mon,  9 Jun 2014 10:50:15 +0200
Message-Id: <686690782794f889e08fbde2cabbd19321e2520b.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jani Nikula <jani.nikula@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/i915/intel_uncore.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_uncore.c b/drivers/gpu/drm/i915/intel_uncore.c
index ee7d6491f8cd..a9a015428b8b 100644
--- a/drivers/gpu/drm/i915/intel_uncore.c
+++ b/drivers/gpu/drm/i915/intel_uncore.c
@@ -166,6 +166,8 @@ static void vlv_force_wake_reset(struct drm_i915_private *dev_priv)
 {
 	__raw_i915_write32(dev_priv, FORCEWAKE_VLV,
 			   _MASKED_BIT_DISABLE(0xffff));
+	__raw_i915_write32(dev_priv, FORCEWAKE_MEDIA_VLV,
+			   _MASKED_BIT_DISABLE(0xffff));
 	/* something from same cacheline, but !FORCEWAKE_VLV */
 	__raw_posting_read(dev_priv, FORCEWAKE_ACK_VLV);
 }
-- 
1.9.3

