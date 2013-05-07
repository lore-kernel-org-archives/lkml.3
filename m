Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933508Ab3EGNnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:43:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42658 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933433Ab3EGNmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:42:37 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steve Conklin <sconklin@canonical.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Ben Widawsky <ben@bwidawsk.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 117/118] Revert "drm/i915: GFX_MODE Flush TLB Invalidate Mode must be '1' for scanline waits"
Date: Tue,  7 May 2013 14:39:23 +0100
Message-Id: <1367933964-1564-118-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Henriques <luis.henriques@canonical.com>

This reverts commit 899b5509abbdfee2eab408e7178e559346091ad3, which is commit
f05bb0c7b624252a5e768287e340e8e45df96e42 in Linus' tree.

This commit has been shown to cause GPU hangs on Sandy Bridge GPUs

BugLink: http://bugs.launchpad.net/bugs/1140716

Signed-off-by: Steve Conklin <sconklin@canonical.com>
Acked-by: Brad Figg <brad.figg@canonical.com>
Acked-by: Luis Henriques <luis.henriques@canonical.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Ben Widawsky <ben@bwidawsk.net>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_ringbuffer.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index e75d794..78486c7 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -421,11 +421,6 @@ static int init_render_ring(struct intel_ring_buffer *ring)
 	if (INTEL_INFO(dev)->gen >= 6)
 		I915_WRITE(MI_MODE, _MASKED_BIT_ENABLE(ASYNC_FLIP_PERF_DISABLE));
 
-	/* Required for the hardware to program scanline values for waiting */
-	if (INTEL_INFO(dev)->gen == 6)
-		I915_WRITE(GFX_MODE,
-			   _MASKED_BIT_ENABLE(GFX_TLB_INVALIDATE_ALWAYS));
-
 	if (IS_GEN7(dev))
 		I915_WRITE(GFX_MODE_GEN7,
 			   _MASKED_BIT_DISABLE(GFX_TLB_INVALIDATE_ALWAYS) |
-- 
1.8.1.2

