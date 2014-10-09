Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072AbaJIV15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:27:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59399 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757611AbaJIVJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:09:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Thomas Richter <thor@math.tu-berlin.de>,
        Jani Nikula <jani.nikula@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 094/163] drm/i915: Fix SRC_COPY width on 830/845g
Date: Thu,  9 Oct 2014 14:01:59 -0700
Message-Id: <1412888588-26755-95-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 611a7a4fd8b5fb6b25ab1f8bdcde61800a7feacf upstream.

One small change I forgot to make in

commit c4d69da167fa967749aeb70bc0e94a457e5d00c1
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Mon Sep 8 14:25:41 2014 +0100

    drm/i915: Evict CS TLBs between batches

was to update the copy width for the compact BLT copy instruction.

Reported-by: Thomas Richter <thor@math.tu-berlin.de>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Thomas Richter <thor@math.tu-berlin.de>
Cc: Jani Nikula <jani.nikula@intel.com>
Tested-by: Thomas Richter <thor@math.tu-berlin.de>
Acked-by: Daniel Vetter <daniel@ffwll.ch>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_ringbuffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index a4ec035..82b58dd 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -1217,7 +1217,7 @@ i830_dispatch_execbuffer(struct intel_ring_buffer *ring,
 		 */
 		intel_ring_emit(ring, SRC_COPY_BLT_CMD | BLT_WRITE_RGBA);
 		intel_ring_emit(ring, BLT_DEPTH_32 | BLT_ROP_SRC_COPY | 4096);
-		intel_ring_emit(ring, DIV_ROUND_UP(len, 4096) << 16 | 1024);
+		intel_ring_emit(ring, DIV_ROUND_UP(len, 4096) << 16 | 4096);
 		intel_ring_emit(ring, cs_offset);
 		intel_ring_emit(ring, 4096);
 		intel_ring_emit(ring, offset);
-- 
1.9.1

