Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574AbbA2JHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:07:49 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44909 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932456AbbA2JHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:07:43 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Simon Farnsworth <simon@farnz.org.uk>, Daniel Vetter <daniel@ffwll.ch>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 079/176] drm/i915: Force the CS stall for invalidate flushes
Date: Wed, 28 Jan 2015 15:28:29 +0100
Message-Id: <dbe21f1df1b98409b2c8e3a7265625726e1a8a00.1422455352.git.jslaby@suse.cz>
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

commit add284a3a2481e759d6bec35f6444c32c8ddc383 upstream.

In order to act as a full command barrier by itself, we need to tell the
pipecontrol to actually stall the command streamer while the flush runs.
We require the full command barrier before operations like
MI_SET_CONTEXT, which currently rely on a prior invalidate flush.

References: https://bugs.freedesktop.org/show_bug.cgi?id=83677
Cc: Simon Farnsworth <simon@farnz.org.uk>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/i915/intel_ringbuffer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 7465effbe2e4..776ed3f7ef66 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -329,6 +329,8 @@ gen7_render_ring_flush(struct intel_ring_buffer *ring,
 		flags |= PIPE_CONTROL_QW_WRITE;
 		flags |= PIPE_CONTROL_GLOBAL_GTT_IVB;
 
+		flags |= PIPE_CONTROL_STALL_AT_SCOREBOARD;
+
 		/* Workaround: we must issue a pipe_control with CS-stall bit
 		 * set before a pipe_control command that has the state cache
 		 * invalidate bit set. */
-- 
2.2.2

