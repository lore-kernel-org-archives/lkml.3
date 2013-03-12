Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab3CLFqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:46:43 -0400
Received: from smtp.outflux.net ([198.145.64.163]:52365 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504Ab3CLFqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:46:42 -0400
Date: Mon, 11 Mar 2013 22:46:31 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org
Subject: [PATCH] drm/i915: use do_div() as needed in debugfs code
Message-ID: <20130312054631.GA21167@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This replaces the open-coded divisions in the debugfs code by calls
to do_div().

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/i915_debugfs.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index d86c304..6f3cbf8 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -1814,9 +1814,9 @@ i915_max_freq_set(void *data, u64 val)
 	/*
 	 * Turbo will still be enabled, but won't go above the set value.
 	 */
-	dev_priv->rps.max_delay = val / GT_FREQUENCY_MULTIPLIER;
-
-	gen6_set_rps(dev, val / GT_FREQUENCY_MULTIPLIER);
+	do_div(val, GT_FREQUENCY_MULTIPLIER);
+	dev_priv->rps.max_delay = val;
+	gen6_set_rps(dev, val);
 	mutex_unlock(&dev_priv->rps.hw_lock);
 
 	return 0;
@@ -1865,9 +1865,9 @@ i915_min_freq_set(void *data, u64 val)
 	/*
 	 * Turbo will still be enabled, but won't go below the set value.
 	 */
-	dev_priv->rps.min_delay = val / GT_FREQUENCY_MULTIPLIER;
-
-	gen6_set_rps(dev, val / GT_FREQUENCY_MULTIPLIER);
+	do_div(val, GT_FREQUENCY_MULTIPLIER);
+	dev_priv->rps.min_delay = val;
+	gen6_set_rps(dev, val);
 	mutex_unlock(&dev_priv->rps.hw_lock);
 
 	return 0;
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
