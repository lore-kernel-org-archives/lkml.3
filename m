Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964774Ab3CRVq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:46:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955Ab3CRVHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:07:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@intel.com>,
        Ilya Tumaykin <itumaykin@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 74/75] Revert "drm/i915: enable irqs earlier when resuming"
Date: Mon, 18 Mar 2013 14:07:37 -0700
Message-Id: <20130318210515.597927833@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210510.203500214@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 31f14f4219d2a74b7a6d86c7798f49141b5eccbe which was
commit 15239099d7a7a9ecdc1ccb5b187ae4cda5488ff9 upstream.

It caused problems in the 3.8-stable series, but 3.9-rc is just fine.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@intel.com>
Cc: Ilya Tumaykin <itumaykin@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>

---
 drivers/gpu/drm/i915/i915_drv.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -486,7 +486,6 @@ static int i915_drm_freeze(struct drm_de
 		intel_modeset_disable(dev);
 
 		drm_irq_uninstall(dev);
-		dev_priv->enable_hotplug_processing = false;
 	}
 
 	i915_save_state(dev);
@@ -563,19 +562,9 @@ static int __i915_drm_thaw(struct drm_de
 		error = i915_gem_init_hw(dev);
 		mutex_unlock(&dev->struct_mutex);
 
-		/* We need working interrupts for modeset enabling ... */
-		drm_irq_install(dev);
-
 		intel_modeset_init_hw(dev);
 		intel_modeset_setup_hw_state(dev, false);
-
-		/*
-		 * ... but also need to make sure that hotplug processing
-		 * doesn't cause havoc. Like in the driver load code we don't
-		 * bother with the tiny race here where we might loose hotplug
-		 * notifications.
-		 * */
-		dev_priv->enable_hotplug_processing = true;
+		drm_irq_install(dev);
 	}
 
 	intel_opregion_init(dev);


