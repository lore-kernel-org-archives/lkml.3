Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab3KUPtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 10:49:55 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38439 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149Ab3KUPty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 10:49:54 -0500
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH] i915, debugfs: Fix uninitialized warning
Date: Thu, 21 Nov 2013 16:49:46 +0100
Message-Id: <1385048986-14478-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

gcc complains that:

drivers/gpu/drm/i915/i915_debugfs.c: In function ‘display_crc_ctl_write’:
drivers/gpu/drm/i915/i915_debugfs.c:2393:2: warning: ‘val’ may be used uninitialized in this function [-Wuninitialized]
drivers/gpu/drm/i915/i915_debugfs.c:2350:6: note: ‘val’ was declared here

but it can't see that we're going to use val only in the success case.
So shut it up.

Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: intel-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/gpu/drm/i915/i915_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index 6ed45a984230..1191aa47adc9 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -2347,7 +2347,7 @@ static int pipe_crc_set_source(struct drm_device *dev, enum pipe pipe,
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct intel_pipe_crc *pipe_crc = &dev_priv->pipe_crc[pipe];
-	u32 val;
+	u32 val = 0; /* shut up gcc */
 	int ret;
 
 	if (pipe_crc->source == source)
-- 
1.8.4

