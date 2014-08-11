Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbaHKN5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:57:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:21615 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576AbaHKN5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:57:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,841,1400050800"; 
   d="scan'208";a="574988094"
From: Jani Nikula <jani.nikula@intel.com>
To: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Jon Mason <jon.mason@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, jani.nikula@intel.com
Subject: [PATCH 4/4] drm/i915: taint the kernel if unsafe module parameters are set
Date: Mon, 11 Aug 2014 16:52:22 +0300
Message-Id: <b273378175010aededf03993b81635c9707dadaf.1407764272.git.jani.nikula@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1407764272.git.jani.nikula@intel.com>
References: <cover.1407764272.git.jani.nikula@intel.com>
In-Reply-To: <cover.1407764272.git.jani.nikula@intel.com>
References: <cover.1407764272.git.jani.nikula@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Taint the kernel if the semaphores, enable_rc6, enable_fbc, or ppgtt
module parameters are modified. These module parameters are for
debugging and testing only, and should never be changed from their
platform specific default values by the users. We do not provide support
for people enabling all the experimental features. Make this clear by
tainting the kernel if the parameters are set.

Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 drivers/gpu/drm/i915/i915_params.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_params.c b/drivers/gpu/drm/i915/i915_params.c
index 62ee8308d682..bba4225ba575 100644
--- a/drivers/gpu/drm/i915/i915_params.c
+++ b/drivers/gpu/drm/i915/i915_params.c
@@ -66,12 +66,12 @@ module_param_named(powersave, i915.powersave, int, 0600);
 MODULE_PARM_DESC(powersave,
 	"Enable powersavings, fbc, downclocking, etc. (default: true)");
 
-module_param_named(semaphores, i915.semaphores, int, 0400);
+module_param_named_unsafe(semaphores, i915.semaphores, int, 0400);
 MODULE_PARM_DESC(semaphores,
 	"Use semaphores for inter-ring sync "
 	"(default: -1 (use per-chip defaults))");
 
-module_param_named(enable_rc6, i915.enable_rc6, int, 0400);
+module_param_named_unsafe(enable_rc6, i915.enable_rc6, int, 0400);
 MODULE_PARM_DESC(enable_rc6,
 	"Enable power-saving render C-state 6. "
 	"Different stages can be selected via bitmask values "
@@ -79,7 +79,7 @@ MODULE_PARM_DESC(enable_rc6,
 	"For example, 3 would enable rc6 and deep rc6, and 7 would enable everything. "
 	"default: -1 (use per-chip default)");
 
-module_param_named(enable_fbc, i915.enable_fbc, int, 0600);
+module_param_named_unsafe(enable_fbc, i915.enable_fbc, int, 0600);
 MODULE_PARM_DESC(enable_fbc,
 	"Enable frame buffer compression for power savings "
 	"(default: -1 (use per-chip default))");
@@ -113,7 +113,7 @@ MODULE_PARM_DESC(enable_hangcheck,
 	"WARNING: Disabling this can cause system wide hangs. "
 	"(default: true)");
 
-module_param_named(enable_ppgtt, i915.enable_ppgtt, int, 0400);
+module_param_named_unsafe(enable_ppgtt, i915.enable_ppgtt, int, 0400);
 MODULE_PARM_DESC(enable_ppgtt,
 	"Override PPGTT usage. "
 	"(-1=auto [default], 0=disabled, 1=aliasing, 2=full)");
-- 
1.9.1

