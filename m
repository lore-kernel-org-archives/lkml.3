Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab3AOAb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 19:31:26 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:41578 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab3AOAbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 19:31:25 -0500
From: Cong Ding <dinggnu@gmail.com>
To: David Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>,
        Alan Cox <alan@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Zhao Yakui <yakui.zhao@intel.com>, Rob Clark <rob@ti.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] gpu: drm/gma500/mdfld_dsi_output.c: remove unnecessary null pointer check
Date: Tue, 15 Jan 2013 01:30:57 +0100
Message-Id: <1358209863-16570-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the variable sender is dereferenced in line 95, so it is no reason to check
null again in line 99.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/gpu/drm/gma500/mdfld_dsi_output.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/gpu/drm/gma500/mdfld_dsi_output.c b/drivers/gpu/drm/gma500/mdfld_dsi_output.c
index 2d4ab48..67e439a 100644
--- a/drivers/gpu/drm/gma500/mdfld_dsi_output.c
+++ b/drivers/gpu/drm/gma500/mdfld_dsi_output.c
@@ -96,11 +96,6 @@ void mdfld_dsi_brightness_init(struct mdfld_dsi_config *dsi_config, int pipe)
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	u32 gen_ctrl_val;
 
-	if (!sender) {
-		DRM_ERROR("No sender found\n");
-		return;
-	}
-
 	/* Set default display backlight value to 85% (0xd8)*/
 	mdfld_dsi_send_mcs_short(sender, write_display_brightness, 0xd8, 1,
 				true);
-- 
1.7.10.4

