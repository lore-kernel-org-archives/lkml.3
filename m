Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab3FKUFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:05:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42080 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756811Ab3FKUEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:04:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [ 61/79] drm/gma500: Increase max resolution for mode setting
Date: Tue, 11 Jun 2013 13:03:27 -0700
Message-Id: <20130611195324.107826856@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>

commit cbbd379aa43890f36da934f5af619d2fb8ec3d87 upstream.

By having a higher max resolution we can now set up a virtual
framebuffer that spans several monitors. 4096 should be ok since we're
gen 3 or higher and should be enough for most dual head setups.

Bugzilla:
https://bugs.launchpad.net/ubuntu/+source/xserver-xorg-video-modesetting/+bug/1169147
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/gma500/framebuffer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/gma500/framebuffer.c
+++ b/drivers/gpu/drm/gma500/framebuffer.c
@@ -772,8 +772,8 @@ void psb_modeset_init(struct drm_device
 	for (i = 0; i < dev_priv->num_pipe; i++)
 		psb_intel_crtc_init(dev, i, mode_dev);
 
-	dev->mode_config.max_width = 2048;
-	dev->mode_config.max_height = 2048;
+	dev->mode_config.max_width = 4096;
+	dev->mode_config.max_height = 4096;
 
 	psb_setup_outputs(dev);
 


