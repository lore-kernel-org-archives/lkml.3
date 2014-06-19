Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934081AbaFSRHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 13:07:22 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34327 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932894AbaFSRHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:07:21 -0400
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: daniel.vetter@ffwll.ch
Cc: jani.nikula@linux.intel.com, airlied@linux.ie,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Konrad Zapalowicz <bergo.torino@gmail.com>
Subject: [PATCH v2] drivers/i915: Fix unnoticed failure of init_ring_common()
Date: Thu, 19 Jun 2014 19:07:15 +0200
Message-Id: <1403197635-14598-1-git-send-email-bergo.torino@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1403131134-9533-1-git-send-email-bergo.torino@gmail.com>
References: <1403131134-9533-1-git-send-email-bergo.torino@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit add check for return value of init_ring_common() in the
init_render_ring(). Now, when failure is detected the error code is
propagated to the caller instead of being ignored.

Signed-off-by: Konrad Zapalowicz <bergo.torino@gmail.com>
---
 
 v2:
   - remove from commit message references to the Oops.

 drivers/gpu/drm/i915/intel_ringbuffer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 279488a..d205b0d 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -604,6 +604,8 @@ static int init_render_ring(struct intel_engine_cs *ring)
 	struct drm_device *dev = ring->dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	int ret = init_ring_common(ring);
+	if (ret)
+		return ret;
 
 	/* WaTimedSingleVertexDispatch:cl,bw,ctg,elk,ilk,snb */
 	if (INTEL_INFO(dev)->gen >= 4 && INTEL_INFO(dev)->gen < 7)
-- 
1.8.1.2

