Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934990AbaGPS0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 14:26:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934773AbaGPS0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 14:26:17 -0400
From: Amit Shah <amit.shah@redhat.com>
To: intel-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, Amit Shah <amit.shah@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, <stable@vger.kernel.org>
Subject: [PATCH 1/1] Revert "drm/i915: drop i915_ prefix from enable_rc6, enable_fbc, enable_ppgtt parameters"
Date: Wed, 16 Jul 2014 23:55:16 +0530
Message-Id: <93fec4e4ac212811364335e3343288d058dbf512.1405535116.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 3adee7a7976012a20f1d3b5a529a3c105e29fef1.

After upgrading to v3.15, my laptop's battery started draining quite
fast.  Powertop pointed to the deep RC6 states not being used.  The
kernel param I had put to enable them had stopped working the way it
used to; so I disagree with the 'not maintaing ABI' part of the param
name change.

However weird the names may be, they're in active use and changing them
only causes pain for users.  This also isn't advertised (marked
deprecated, big warning shown, etc.), so just reverting now.

CC: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: Jani Nikula <jani.nikula@linux.intel.com>
CC: David Airlie <airlied@linux.ie>
CC: <stable@vger.kernel.org> # v3.15+
Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/gpu/drm/i915/i915_params.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_params.c b/drivers/gpu/drm/i915/i915_params.c
index d05a2af..053981d 100644
--- a/drivers/gpu/drm/i915/i915_params.c
+++ b/drivers/gpu/drm/i915/i915_params.c
@@ -69,16 +69,16 @@ MODULE_PARM_DESC(semaphores,
 	"Use semaphores for inter-ring sync "
 	"(default: -1 (use per-chip defaults))");
 
-module_param_named(enable_rc6, i915.enable_rc6, int, 0400);
-MODULE_PARM_DESC(enable_rc6,
+module_param_named(i915_enable_rc6, i915.enable_rc6, int, 0400);
+MODULE_PARM_DESC(i915_enable_rc6,
 	"Enable power-saving render C-state 6. "
 	"Different stages can be selected via bitmask values "
 	"(0 = disable; 1 = enable rc6; 2 = enable deep rc6; 4 = enable deepest rc6). "
 	"For example, 3 would enable rc6 and deep rc6, and 7 would enable everything. "
 	"default: -1 (use per-chip default)");
 
-module_param_named(enable_fbc, i915.enable_fbc, int, 0600);
-MODULE_PARM_DESC(enable_fbc,
+module_param_named(i915_enable_fbc, i915.enable_fbc, int, 0600);
+MODULE_PARM_DESC(i915_enable_fbc,
 	"Enable frame buffer compression for power savings "
 	"(default: -1 (use per-chip default))");
 
@@ -111,8 +111,8 @@ MODULE_PARM_DESC(enable_hangcheck,
 	"WARNING: Disabling this can cause system wide hangs. "
 	"(default: true)");
 
-module_param_named(enable_ppgtt, i915.enable_ppgtt, int, 0400);
-MODULE_PARM_DESC(enable_ppgtt,
+module_param_named(i915_enable_ppgtt, i915.enable_ppgtt, int, 0400);
+MODULE_PARM_DESC(i915_enable_ppgtt,
 	"Override PPGTT usage. "
 	"(-1=auto [default], 0=disabled, 1=aliasing, 2=full)");
 
-- 
1.9.3

