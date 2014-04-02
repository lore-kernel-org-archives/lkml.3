Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987AbaDBUST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:18:19 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42852 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758917AbaDBUNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Takashi Iwai <tiwai@suse.de>, Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Todd Previte <tprevite@gmail.com>, Dave Airlie <airlied@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 34/40] drm/i915: Undo gtt scratch pte unmapping again
Date: Wed,  2 Apr 2014 22:13:20 +0200
Message-Id: <f90bec2a0b2107c1c841621d1deacc84bb6c92f3.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
References: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8ee661b505613ef2747b350ca2871a31b3781bee upstream.

It apparently blows up on some machines. This functionally reverts

commit 828c79087cec61eaf4c76bb32c222fbe35ac3930
Author: Ben Widawsky <benjamin.widawsky@intel.com>
Date:   Wed Oct 16 09:21:30 2013 -0700

    drm/i915: Disable GGTT PTEs on GEN6+ suspend

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=64841
Reported-and-Tested-by: Brad  Jackson <bjackson0971@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Paulo Zanoni <paulo.r.zanoni@intel.com>
Cc: Todd Previte <tprevite@gmail.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/i915/i915_gem_gtt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_gtt.c b/drivers/gpu/drm/i915/i915_gem_gtt.c
index 1f7b4caefb6e..c7fa2e420d49 100644
--- a/drivers/gpu/drm/i915/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
@@ -536,7 +536,7 @@ void i915_gem_suspend_gtt_mappings(struct drm_device *dev)
 	dev_priv->gtt.base.clear_range(&dev_priv->gtt.base,
 				       dev_priv->gtt.base.start / PAGE_SIZE,
 				       dev_priv->gtt.base.total / PAGE_SIZE,
-				       false);
+				       true);
 }
 
 void i915_gem_restore_gtt_mappings(struct drm_device *dev)
-- 
1.9.1

