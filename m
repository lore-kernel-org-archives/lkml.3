Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762998Ab3ECJSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 05:18:53 -0400
Received: from mout.gmx.net ([212.227.15.15]:50551 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518Ab3ECJSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 05:18:50 -0400
X-Authenticated: #7313500
X-Provags-ID: V01U2FsdGVkX19Kzfd97DNKVZNpURgWBYDZJUBVupY4dj+zGAOLum
	lvLVS+fdGtNxBw
From: dl9pf@gmx.de
To: dl9pf@gmx.de
Cc: pageexec@freemail.hu, daniel.vetter@ffwll.ch, airlied@linux.ie,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [TRIVIAL] Fix declaration of intel_gmbus_{is_forced_bit/is_port_falid} in i915 driver.
Date: Fri,  3 May 2013 11:17:42 +0200
Message-Id: <1367572662-18400-1-git-send-email-dl9pf@gmx.de>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Simon Möller <dl9pf@gmx.de>

Description:
intel_gmbus_is_forced_bit is no extern as its body is right below.
Likewise for intel_gmbus_is_port_valid.

This fixes a compilation issue with clang. An initial version of this patch
was developed by PaX Team <pageexec at freemail.hu>.
This is respin of this patch.

Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
CC: pageexec@freemail.hu
CC: daniel.vetter@ffwll.ch
CC: airlied@linux.ie
CC: intel-gfx@lists.freedesktop.org
CC: dri-devel@lists.freedesktop.org
CC: linux-kernel@vger.kernel.org
---
 drivers/gpu/drm/i915/i915_drv.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 3ac71db..3c9ebc1 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1806,7 +1806,7 @@ void i915_teardown_sysfs(struct drm_device *dev_priv);
 /* intel_i2c.c */
 extern int intel_setup_gmbus(struct drm_device *dev);
 extern void intel_teardown_gmbus(struct drm_device *dev);
-extern inline bool intel_gmbus_is_port_valid(unsigned port)
+static bool intel_gmbus_is_port_valid(unsigned port)
 {
 	return (port >= GMBUS_PORT_SSC && port <= GMBUS_PORT_DPD);
 }
@@ -1815,7 +1815,7 @@ extern struct i2c_adapter *intel_gmbus_get_adapter(
 		struct drm_i915_private *dev_priv, unsigned port);
 extern void intel_gmbus_set_speed(struct i2c_adapter *adapter, int speed);
 extern void intel_gmbus_force_bit(struct i2c_adapter *adapter, bool force_bit);
-extern inline bool intel_gmbus_is_forced_bit(struct i2c_adapter *adapter)
+static bool intel_gmbus_is_forced_bit(struct i2c_adapter *adapter)
 {
 	return container_of(adapter, struct intel_gmbus, adapter)->force_bit;
 }
-- 
1.8.1.4

