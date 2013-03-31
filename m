Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab3CaLyF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 07:54:05 -0400
Received: from fep19.mx.upcmail.net ([62.179.121.39]:39835 "EHLO
	fep19.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761Ab3CaLyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 07:54:03 -0400
X-Greylist: delayed 914 seconds by postgrey-1.27 at vger.kernel.org; Sun, 31 Mar 2013 07:54:03 EDT
X-SourceIP: 95.96.101.31
Date: Sun, 31 Mar 2013 13:38:44 +0200
From: Kero <kero@chello.nl>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gma500: Make VGA and HDMI connector hotpluggable
Message-ID: <20130331113844.GG16352@chmeee.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kero van Gelder <kero@chello.nl>

Both VGA and HDMI connectors are available on my Asus EeePC X101CH.
This patch will cause output to be shown on either when plugged in.
For both, it shows the leftmost 800x600, of the 1024x600 on LVDS.

Signed-off-by: Kero van Gelder <kero@chello.nl>
---
diff --git a/drivers/gpu/drm/gma500/cdv_intel_crt.c b/drivers/gpu/drm/gma500/cdv_intel_crt.c
index 8c17534..7b8386f 100644
--- a/drivers/gpu/drm/gma500/cdv_intel_crt.c
+++ b/drivers/gpu/drm/gma500/cdv_intel_crt.c
@@ -276,6 +276,7 @@ void cdv_intel_crt_init(struct drm_device *dev,
                goto failed_connector;
 
        connector = &psb_intel_connector->base;
+       connector->polled = DRM_CONNECTOR_POLL_HPD;
        drm_connector_init(dev, connector,
                &cdv_intel_crt_connector_funcs, DRM_MODE_CONNECTOR_VGA);
 
diff --git a/drivers/gpu/drm/gma500/cdv_intel_hdmi.c b/drivers/gpu/drm/gma500/cdv_intel_hdmi.c
index e223b50..464153d 100644
--- a/drivers/gpu/drm/gma500/cdv_intel_hdmi.c
+++ b/drivers/gpu/drm/gma500/cdv_intel_hdmi.c
@@ -319,6 +319,7 @@ void cdv_hdmi_init(struct drm_device *dev,
                goto err_priv;
 
        connector = &psb_intel_connector->base;
+       connector->polled = DRM_CONNECTOR_POLL_HPD;
        encoder = &psb_intel_encoder->base;
        drm_connector_init(dev, connector,
                           &cdv_hdmi_connector_funcs,
