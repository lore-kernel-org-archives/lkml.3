Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbbALSat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:30:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58342 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204AbbALSam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:42 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Simon Farnsworth <simon@farnz.org.uk>, Daniel Vetter <daniel@ffwll.ch>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
	<ville.syrjala@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 180/216] drm/i915: Force the CS stall for invalidate flushes
Date: Mon, 12 Jan 2015 18:29:18 +0000
Message-Id: <1421087394-2712-68-git-send-email-luis.henriques@canonical.com>
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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_ringbuffer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index e831be6bcbae..db8e92f27289 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -359,6 +359,8 @@ gen7_render_ring_flush(struct intel_engine_cs *ring,
 		flags |= PIPE_CONTROL_QW_WRITE;
 		flags |= PIPE_CONTROL_GLOBAL_GTT_IVB;
 
+		flags |= PIPE_CONTROL_STALL_AT_SCOREBOARD;
+
 		/* Workaround: we must issue a pipe_control with CS-stall bit
 		 * set before a pipe_control command that has the state cache
 		 * invalidate bit set. */
-- 
2.1.4

