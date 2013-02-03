Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab3BCO5r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:57:47 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34508 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754780Ab3BCO5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:57:44 -0500
Message-Id: <20130203144651.884220891@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:12 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Eric Anholt <eric@anholt.net>,
        Kenneth Graunke <kenneth@whitecape.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 088/128] drm/i915: Remove the MI_FLUSH_ENABLE setting.
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Anholt <eric@anholt.net>

commit 8d79c3490aecfe6e51f0ba6f9780746fb1434954 upstream.

We have always been using the wrong bit -- it's bit 12.  However, the
bit also doesn't do anything -- hardware has always accepted the
MI_FLUSH command even when it was specced not to.

Given that there is only one MI_FLUSH emitted in all of the driver
stack on gen6+ (in i965_video.c of the 2d driver, and it should be
using other code to do its flush instead), just remove the MI_FLUSH
enable instead of trying to fix it.

Signed-off-by: Eric Anholt <eric@anholt.net>
Reviewed-by: Kenneth Graunke <kenneth@whitecape.org>
Reviewed-by: Ben Widawsky <ben@bwidawsk.net>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_ringbuffer.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 77e729d..b3da17a 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -399,8 +399,6 @@ static int init_render_ring(struct intel_ring_buffer *ring)
 
 	if (INTEL_INFO(dev)->gen > 3) {
 		int mode = VS_TIMER_DISPATCH << 16 | VS_TIMER_DISPATCH;
-		if (IS_GEN6(dev) || IS_GEN7(dev))
-			mode |= MI_FLUSH_ENABLE << 16 | MI_FLUSH_ENABLE;
 		I915_WRITE(MI_MODE, mode);
 		if (IS_GEN7(dev))
 			I915_WRITE(GFX_MODE_GEN7,


