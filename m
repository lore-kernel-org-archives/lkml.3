Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab3GDMaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:30:18 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:51763 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441Ab3GDM0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:26:49 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH v2 13/14] drm/i915: use new drm_kick_out_firmware()
Date: Thu,  4 Jul 2013 14:25:13 +0200
Message-Id: <1372940714-12470-14-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
References: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new DRM infrastructure to kick out firmware DRM drivers before
loading i915.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/gpu/drm/i915/i915_dma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 3b315ba..d525b49 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1436,9 +1436,9 @@ static void i915_kick_out_firmware_fb(struct drm_i915_private *dev_priv)
 	primary =
 		pdev->resource[PCI_ROM_RESOURCE].flags & IORESOURCE_ROM_SHADOW;
 
-	remove_conflicting_framebuffers(ap, "inteldrmfb", primary);
-
-	kfree(ap);
+	drm_kick_out_firmware(ap, primary);
+	dev_priv->dev->apertures = ap;
+	dev_priv->dev->apert_boot = primary;
 }
 
 static void i915_dump_device_info(struct drm_i915_private *dev_priv)
-- 
1.8.3.2

