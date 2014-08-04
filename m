Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaHDQz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:55:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56631 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752190AbaHDQt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jakob Bornecrantz" <jakob@vmware.com>,
        "Thomas Hellstrom" <thellstrom@vmware.com>,
        "Christopher Friedt" <chrisfriedt@gmail.com>
Date: Mon, 04 Aug 2014 17:48:31 +0100
Message-ID: <lsq.1407170911.752319308@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 23/94] drm/vmwgfx: Fix incorrect write to read-only
 register v2:
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c | 1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
@@ -179,7 +179,6 @@ static int vmw_fb_set_par(struct fb_info
 		vmw_write(vmw_priv, SVGA_REG_DISPLAY_POSITION_Y, info->var.yoffset);
 		vmw_write(vmw_priv, SVGA_REG_DISPLAY_WIDTH, info->var.xres);
 		vmw_write(vmw_priv, SVGA_REG_DISPLAY_HEIGHT, info->var.yres);
-		vmw_write(vmw_priv, SVGA_REG_BYTES_PER_LINE, info->fix.line_length);
 		vmw_write(vmw_priv, SVGA_REG_DISPLAY_ID, SVGA_ID_INVALID);
 	}
 

