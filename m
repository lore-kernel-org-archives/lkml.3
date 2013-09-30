Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab3I3LaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 07:30:21 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:44496 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab3I3L2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 07:28:03 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the drm-intel tree
Date: Mon, 30 Sep 2013 13:26:06 +0200
Message-Id: <1380540373-25352-4-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380540373-25352-1-git-send-email-treding@nvidia.com>
References: <1380540373-25352-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the drm-intel tree got conflicts in

	drivers/gpu/drm/i915/intel_display.c

I fixed it up (see below). Please check if the resolution looks correct.

Thanks,
Thierry
---
diff --cc drivers/gpu/drm/i915/intel_display.c
index e5822e7,cbbdab6..76870f0
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@@ -4775,21 -4882,8 +4882,12 @@@ static void i9xx_set_pipeconf(struct in
  
  	pipeconf = 0;
  
 +	if (dev_priv->quirks & QUIRK_PIPEA_FORCE &&
 +	    I915_READ(PIPECONF(intel_crtc->pipe)) & PIPECONF_ENABLE)
 +		pipeconf |= PIPECONF_ENABLE;
 +
- 	if (intel_crtc->pipe == 0 && INTEL_INFO(dev)->gen < 4) {
- 		/* Enable pixel doubling when the dot clock is > 90% of the (display)
- 		 * core speed.
- 		 *
- 		 * XXX: No double-wide on 915GM pipe B. Is that the only reason for the
- 		 * pipe == 0 check?
- 		 */
- 		if (intel_crtc->config.requested_mode.clock >
- 		    dev_priv->display.get_display_clock_speed(dev) * 9 / 10)
- 			pipeconf |= PIPECONF_DOUBLE_WIDE;
- 	}
+ 	if (intel_crtc->config.double_wide)
+ 		pipeconf |= PIPECONF_DOUBLE_WIDE;
  
  	/* only g4x and later have fancy bpc/dither controls */
  	if (IS_G4X(dev) || IS_VALLEYVIEW(dev)) {
