Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966985Ab3DRJY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:24:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40264 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758812Ab3DRJSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:18:18 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ben Widawsky <ben@bwidawsk.net>, Matthew Garret <mjg@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 51/72] drm/i915: Use the correct size of the GTT for placing the per-process entries
Date: Thu, 18 Apr 2013 10:16:36 +0100
Message-Id: <1366276617-3553-52-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 9a0f938bde74bf9e50bd75c8de9e38c1787398cd upstream.

The current layout is to place the per-process tables at the end of the
GTT. However, this is currently using a hardcoded maximum size for the GTT
and not taking in account limitations imposed by the BIOS. Use the value
for the total number of entries allocated in the table as provided by
the configuration registers.

Reported-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Ben Widawsky <ben@bwidawsk.net>
Cc: Matthew Garret <mjg@redhat.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/i915_gem_gtt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_gtt.c b/drivers/gpu/drm/i915/i915_gem_gtt.c
index 9fd25a4..1e30d8f 100644
--- a/drivers/gpu/drm/i915/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
@@ -72,7 +72,7 @@ int i915_gem_init_aliasing_ppgtt(struct drm_device *dev)
 	/* ppgtt PDEs reside in the global gtt pagetable, which has 512*1024
 	 * entries. For aliasing ppgtt support we just steal them at the end for
 	 * now. */
-	first_pd_entry_in_global_pt = 512*1024 - I915_PPGTT_PD_ENTRIES;
+	first_pd_entry_in_global_pt = dev_priv->mm.gtt->gtt_total_entries - I915_PPGTT_PD_ENTRIES;
 
 	ppgtt = kzalloc(sizeof(*ppgtt), GFP_KERNEL);
 	if (!ppgtt)
-- 
1.8.1.2

