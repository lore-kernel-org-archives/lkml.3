Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab3F1Sz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:55:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41715 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab3F1SzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:55:22 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 033/105] drm/gma500: Increase max resolution for mode setting
Date: Fri, 28 Jun 2013 11:50:55 -0700
Message-Id: <1372445527-24414-34-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>

commit cbbd379aa43890f36da934f5af619d2fb8ec3d87 upstream.

By having a higher max resolution we can now set up a virtual
framebuffer that spans several monitors. 4096 should be ok since we're
gen 3 or higher and should be enough for most dual head setups.

Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/gma500/framebuffer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/gma500/framebuffer.c b/drivers/gpu/drm/gma500/framebuffer.c
index afded54..a3d26e2 100644
--- a/drivers/gpu/drm/gma500/framebuffer.c
+++ b/drivers/gpu/drm/gma500/framebuffer.c
@@ -799,8 +799,8 @@ void psb_modeset_init(struct drm_device *dev)
 	for (i = 0; i < dev_priv->num_pipe; i++)
 		psb_intel_crtc_init(dev, i, mode_dev);
 
-	dev->mode_config.max_width = 2048;
-	dev->mode_config.max_height = 2048;
+	dev->mode_config.max_width = 4096;
+	dev->mode_config.max_height = 4096;
 
 	psb_setup_outputs(dev);
 
-- 
1.8.1.2

