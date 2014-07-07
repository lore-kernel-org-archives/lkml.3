Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313AbaGHBH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:07:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbaGGXx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:53:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christopher Friedt <chrisfriedt@gmail.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jakob Bornecrantz <jakob@vmware.com>
Subject: [PATCH 3.15 051/122] drm/vmwgfx: Fix incorrect write to read-only register v2:
Date: Mon,  7 Jul 2014 16:56:53 -0700
Message-Id: <20140707235735.811756506@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c |    1 -
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
 


