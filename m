Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbaDBIYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 04:24:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:54237 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758116AbaDBIYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 04:24:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,778,1389772800"; 
   d="scan'208";a="512647635"
From: Jani Nikula <jani.nikula@intel.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>, jani.nikula@intel.com
Subject: [PATCH] drm/i915: fix command parser debug print format mismatches
Date: Wed,  2 Apr 2014 11:24:20 +0300
Message-Id: <1396427060-12539-1-git-send-email-jani.nikula@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <533B106B.8090408@infradead.org>
References: <533B106B.8090408@infradead.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop the cast from the pointer diff to fix:

drivers/gpu/drm/i915/i915_cmd_parser.c:405:4: warning: format '%td' expects
argument of type 'ptrdiff_t', but argument 5 has type 'long unsigned int'
[-Wformat]

While at it, use %u for u32.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

---

Randy, try as I might, I wasn't able to coerce gcc to spit out that
warning. Please enlighten me! (Does this fix the warn?)

Thanks for the report.
---
 drivers/gpu/drm/i915/i915_cmd_parser.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_cmd_parser.c b/drivers/gpu/drm/i915/i915_cmd_parser.c
index 71ac3b4eaa0d..e5c4e99a22fb 100644
--- a/drivers/gpu/drm/i915/i915_cmd_parser.c
+++ b/drivers/gpu/drm/i915/i915_cmd_parser.c
@@ -811,10 +811,10 @@ int i915_parse_cmds(struct intel_ring_buffer *ring,
 			length = ((*cmd & desc->length.mask) + LENGTH_BIAS);
 
 		if ((batch_end - cmd) < length) {
-			DRM_DEBUG_DRIVER("CMD: Command length exceeds batch length: 0x%08X length=%d batchlen=%td\n",
+			DRM_DEBUG_DRIVER("CMD: Command length exceeds batch length: 0x%08X length=%u batchlen=%td\n",
 					 *cmd,
 					 length,
-					 (unsigned long)(batch_end - cmd));
+					 batch_end - cmd);
 			ret = -EINVAL;
 			break;
 		}
-- 
1.7.9.5

