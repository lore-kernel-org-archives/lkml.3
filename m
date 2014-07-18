Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161179AbaGRNP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:15:58 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17854 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161147AbaGRNPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:15:53 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>,
        Christopher Friedt <chrisfriedt@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 087/170] drm/vmwgfx: Fix incorrect write to read-only register v2:
Date: Fri, 18 Jul 2014 14:11:32 +0200
Message-Id: <8d8baacc721386b54a23302d93e8122f0ea15c6f.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Hellstrom <thellstrom@vmware.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.0.0

