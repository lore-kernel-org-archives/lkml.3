Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbaCEPzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:55:25 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44553 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbaCEPzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 10:55:23 -0500
Date: Wed, 5 Mar 2014 23:54:18 +0800
From: Wang YanQing <udknight@gmail.com>
To: tomi.valkeinen@ti.com
Cc: plagnioj@jcrosoft.com, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: [PATCH] video: fbdev: uvesafb: Remove redundant NULL check in
 uvesafb_remove
Message-ID: <20140305155418.GA32106@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, tomi.valkeinen@ti.com,
	plagnioj@jcrosoft.com, linux-fbdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, fengguang.wu@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because uvesafb_par is allocated as part of fb_info in uvesafb_probe,
so we don't need to do NULL check for both fb_info and uvesafb_par in
uvesafb_remove.

[ This patch also fix a warning report by fengguang.wu@intel.com
  "drivers/video/fbdev/uvesafb.c:1815 uvesafb_remove()
   warn: variable dereferenced before check 'par'" ]

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/video/fbdev/uvesafb.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/video/fbdev/uvesafb.c b/drivers/video/fbdev/uvesafb.c
index 1f38445..18352b2 100644
--- a/drivers/video/fbdev/uvesafb.c
+++ b/drivers/video/fbdev/uvesafb.c
@@ -1812,11 +1812,9 @@ static int uvesafb_remove(struct platform_device *dev)
 		fb_destroy_modedb(info->monspecs.modedb);
 		fb_dealloc_cmap(&info->cmap);
 
-		if (par) {
-			kfree(par->vbe_modes);
-			kfree(par->vbe_state_orig);
-			kfree(par->vbe_state_saved);
-		}
+		kfree(par->vbe_modes);
+		kfree(par->vbe_state_orig);
+		kfree(par->vbe_state_saved);
 
 		framebuffer_release(info);
 	}
-- 
1.8.3.4.8.g69490f3.dirty
