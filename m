Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934817AbaGXKFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:05:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54961 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757804AbaGXJsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:48:15 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christopher Friedt <chrisfriedt@gmail.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 077/128] drm/vmwgfx: Fix incorrect write to read-only register v2:
Date: Thu, 24 Jul 2014 10:45:26 +0100
Message-Id: <1406195177-8656-78-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit 4e578080ed3262ed2c3985868539bc66218d25c0 upstream.

Commit "drm/vmwgfx: correct fb_fix_screeninfo.line_length", while fixing a
vmwgfx fbdev bug, also writes the pitch to a supposedly read-only register:
SVGA_REG_BYTES_PER_LINE, while it should be (and also in fact is) written to
SVGA_REG_PITCHLOCK.

This patch is Cc'd stable because of the unknown effects writing to this
register might have, particularly on older device versions.

v2: Updated log message.

Cc: Christopher Friedt <chrisfriedt@gmail.com>
Tested-by: Christopher Friedt <chrisfriedt@gmail.com>
Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
index 021b5227e783..1b0f34bd3a03 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
@@ -179,7 +179,6 @@ static int vmw_fb_set_par(struct fb_info *info)
 		vmw_write(vmw_priv, SVGA_REG_DISPLAY_POSITION_Y, info->var.yoffset);
 		vmw_write(vmw_priv, SVGA_REG_DISPLAY_WIDTH, info->var.xres);
 		vmw_write(vmw_priv, SVGA_REG_DISPLAY_HEIGHT, info->var.yres);
-		vmw_write(vmw_priv, SVGA_REG_BYTES_PER_LINE, info->fix.line_length);
 		vmw_write(vmw_priv, SVGA_REG_DISPLAY_ID, SVGA_ID_INVALID);
 	}
 
-- 
1.9.1

