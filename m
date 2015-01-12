Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbbALSl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:41:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58338 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197AbbALSal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Simon Farnsworth <simon@farnz.org.uk>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 179/216] drm/i915: Invalidate media caches on gen7
Date: Mon, 12 Jan 2015 18:29:17 +0000
Message-Id: <1421087394-2712-67-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 148b83d0815a3778c8949e6a97cb798cbaa0efb3 upstream.

In the gen7 pipe control there is an extra bit to flush the media
caches, so let's set it during cache invalidation flushes.

v2: Rename to MEDIA_STATE_CLEAR to be more inline with spec.

Cc: Simon Farnsworth <simon@farnz.org.uk>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/i915_reg.h         | 1 +
 drivers/gpu/drm/i915/intel_ringbuffer.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 6b9626567cfa..4fcff20cab98 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -352,6 +352,7 @@
 #define   PIPE_CONTROL_STORE_DATA_INDEX			(1<<21)
 #define   PIPE_CONTROL_CS_STALL				(1<<20)
 #define   PIPE_CONTROL_TLB_INVALIDATE			(1<<18)
+#define   PIPE_CONTROL_MEDIA_STATE_CLEAR		(1<<16)
 #define   PIPE_CONTROL_QW_WRITE				(1<<14)
 #define   PIPE_CONTROL_POST_SYNC_OP_MASK                (3<<14)
 #define   PIPE_CONTROL_DEPTH_STALL			(1<<13)
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 7add7eead21d..e831be6bcbae 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -352,6 +352,7 @@ gen7_render_ring_flush(struct intel_engine_cs *ring,
 		flags |= PIPE_CONTROL_VF_CACHE_INVALIDATE;
 		flags |= PIPE_CONTROL_CONST_CACHE_INVALIDATE;
 		flags |= PIPE_CONTROL_STATE_CACHE_INVALIDATE;
+		flags |= PIPE_CONTROL_MEDIA_STATE_CLEAR;
 		/*
 		 * TLB invalidate requires a post-sync write.
 		 */
-- 
2.1.4

