Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbaGHBJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:09:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbaGGXxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:53:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 3.15 047/122] drm/i95: Initialize active ring->pid to -1
Date: Mon,  7 Jul 2014 16:56:49 -0700
Message-Id: <20140707235735.696944468@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit eee73b46261325eb140d899b5371f49b02d88f63 upstream.

Otherwise we print out spurious processes on unused rings in the error
state.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gpu_error.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_gpu_error.c
+++ b/drivers/gpu/drm/i915/i915_gpu_error.c
@@ -894,6 +894,8 @@ static void i915_gem_record_rings(struct
 	for (i = 0; i < I915_NUM_RINGS; i++) {
 		struct intel_ring_buffer *ring = &dev_priv->ring[i];
 
+		error->ring[i].pid = -1;
+
 		if (ring->dev == NULL)
 			continue;
 
@@ -901,7 +903,6 @@ static void i915_gem_record_rings(struct
 
 		i915_record_ring_state(dev, ring, &error->ring[i]);
 
-		error->ring[i].pid = -1;
 		request = i915_gem_find_active_request(ring);
 		if (request) {
 			/* We need to copy these to an anonymous buffer


