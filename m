Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775AbbA2JBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:01:46 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44748 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757586AbbA2JBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:01:43 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Simon Farnsworth <simon@farnz.org.uk>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 078/176] drm/i915: Invalidate media caches on gen7
Date: Wed, 28 Jan 2015 15:28:28 +0100
Message-Id: <41d3d4b130a2a3e709d19245cbf345f1b6abf02d.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/i915/i915_reg.h         | 1 +
 drivers/gpu/drm/i915/intel_ringbuffer.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 998f774b5fff..9d344da55056 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -309,6 +309,7 @@
 #define   PIPE_CONTROL_GLOBAL_GTT_IVB			(1<<24) /* gen7+ */
 #define   PIPE_CONTROL_CS_STALL				(1<<20)
 #define   PIPE_CONTROL_TLB_INVALIDATE			(1<<18)
+#define   PIPE_CONTROL_MEDIA_STATE_CLEAR		(1<<16)
 #define   PIPE_CONTROL_QW_WRITE				(1<<14)
 #define   PIPE_CONTROL_DEPTH_STALL			(1<<13)
 #define   PIPE_CONTROL_WRITE_FLUSH			(1<<12)
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 1ceb95a3bbe0..7465effbe2e4 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -322,6 +322,7 @@ gen7_render_ring_flush(struct intel_ring_buffer *ring,
 		flags |= PIPE_CONTROL_VF_CACHE_INVALIDATE;
 		flags |= PIPE_CONTROL_CONST_CACHE_INVALIDATE;
 		flags |= PIPE_CONTROL_STATE_CACHE_INVALIDATE;
+		flags |= PIPE_CONTROL_MEDIA_STATE_CLEAR;
 		/*
 		 * TLB invalidate requires a post-sync write.
 		 */
-- 
2.2.2

