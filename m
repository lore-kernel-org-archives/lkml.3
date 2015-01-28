Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760172AbbA1B2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:28:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759752AbbA1B2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 3.18 13/61] drm/i915: Ban Haswell from using RCS flips
Date: Tue, 27 Jan 2015 17:26:25 -0800
Message-Id: <20150128012638.476143746@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012636.936333725@linuxfoundation.org>
References: <20150128012636.936333725@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 48bf5b2d00bfeb681f6500c626189c7cd2c964d2 upstream.

Like Ivybridge, we have reports that we get random hangs when flipping
with multiple pipes. Extend

commit 2a92d5bca1999b69c78f3c3e97b5484985b094b9
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Tue Jul 8 10:40:29 2014 +0100

    drm/i915: Disable RCS flips on Ivybridge

to also apply to Haswell.

Reported-and-tested-by: Scott Tsai <scottt.tw@gmail.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=87759
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -10019,7 +10019,7 @@ static int intel_crtc_page_flip(struct d
 		if (obj->tiling_mode != work->old_fb_obj->tiling_mode)
 			/* vlv: DISPLAY_FLIP fails to change tiling */
 			ring = NULL;
-	} else if (IS_IVYBRIDGE(dev)) {
+	} else if (IS_IVYBRIDGE(dev) || IS_HASWELL(dev)) {
 		ring = &dev_priv->ring[BCS];
 	} else if (INTEL_INFO(dev)->gen >= 7) {
 		ring = obj->ring;


