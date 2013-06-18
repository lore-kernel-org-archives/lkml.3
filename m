Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab3FRL5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:57:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56117 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932362Ab3FRLop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:45 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 51/93] drm/gma500: Increase max resolution for mode setting
Date: Tue, 18 Jun 2013 12:42:59 +0100
Message-Id: <1371555821-12820-52-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>

commit cbbd379aa43890f36da934f5af619d2fb8ec3d87 upstream.

By having a higher max resolution we can now set up a virtual
framebuffer that spans several monitors. 4096 should be ok since we're
gen 3 or higher and should be enough for most dual head setups.

Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/gma500/framebuffer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/gma500/framebuffer.c b/drivers/gpu/drm/gma500/framebuffer.c
index 5732b57..71a4b61 100644
--- a/drivers/gpu/drm/gma500/framebuffer.c
+++ b/drivers/gpu/drm/gma500/framebuffer.c
@@ -793,8 +793,8 @@ void psb_modeset_init(struct drm_device *dev)
 	for (i = 0; i < dev_priv->num_pipe; i++)
 		psb_intel_crtc_init(dev, i, mode_dev);
 
-	dev->mode_config.max_width = 2048;
-	dev->mode_config.max_height = 2048;
+	dev->mode_config.max_width = 4096;
+	dev->mode_config.max_height = 4096;
 
 	psb_setup_outputs(dev);
 
-- 
1.8.1.2

