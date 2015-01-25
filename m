Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758663AbbAYS5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:57:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbbAYSJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 3.18 043/183] drm/i915: resume MST after reading back hw state
Date: Sun, 25 Jan 2015 10:06:05 -0800
Message-Id: <20150125180812.041841391@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit e7d6f7d708290da1b7c92f533444b042c79412e0 upstream.

Otherwise the MST resume paths can hit DPMS paths
which hit state checker paths, which hit WARN_ON,
because the state checker is inconsistent with the
hw.

This fixes a bunch of WARN_ON's on resume after
undocking.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_drv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -692,11 +692,12 @@ static int __i915_drm_thaw(struct drm_de
 			spin_unlock_irqrestore(&dev_priv->irq_lock, irqflags);
 		}
 
-		intel_dp_mst_resume(dev);
 		drm_modeset_lock_all(dev);
 		intel_modeset_setup_hw_state(dev, true);
 		drm_modeset_unlock_all(dev);
 
+		intel_dp_mst_resume(dev);
+
 		/*
 		 * ... but also need to make sure that hotplug processing
 		 * doesn't cause havoc. Like in the driver load code we don't


