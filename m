Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaDAENn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 00:13:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53867 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbaDAENi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 00:13:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Todd Previte <tprevite@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.13 10/22] drm/i915: Undo gtt scratch pte unmapping again
Date: Mon, 31 Mar 2014 21:08:40 -0700
Message-Id: <20140401040705.540077828@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140401040703.045139933@linuxfoundation.org>
References: <20140401040703.045139933@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem_gtt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_gem_gtt.c
+++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
@@ -828,7 +828,7 @@ void i915_gem_suspend_gtt_mappings(struc
 	dev_priv->gtt.base.clear_range(&dev_priv->gtt.base,
 				       dev_priv->gtt.base.start / PAGE_SIZE,
 				       dev_priv->gtt.base.total / PAGE_SIZE,
-				       false);
+				       true);
 }
 
 void i915_gem_restore_gtt_mappings(struct drm_device *dev)


