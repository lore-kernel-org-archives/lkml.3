Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab3GVPjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 11:39:43 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:56674 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220Ab3GVPjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 11:39:40 -0400
From: andi.shyti@gmail.com
To: plagnioj@jcrosoft.com, tomi.valkeinen@ti.com
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andi@etezian.org, andi.shyti@gmail.com
Subject: [PATCH] vga16fb: remove unused variable
Date: Mon, 22 Jul 2013 17:41:00 +0200
Message-Id: <1374507660-8142-1-git-send-email-andi.shyti@gmail.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Shyti <andi.shyti@gmail.com>

This patch gets rid of the following warning:

drivers/video/vga16fb.c: In function ‘vga16fb_destroy’:
drivers/video/vga16fb.c:1268:26: warning: unused variable ‘dev’ [-Wunused-variable]
  struct platform_device *dev = container_of(info->device, struct platform_device, dev);
                          ^

As described, the 'dev' variable is no longer used, therefore it
can be removed.

Signed-off-by: Andi Shyti <andi.shyti@gmail.com>
---
 drivers/video/vga16fb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/video/vga16fb.c b/drivers/video/vga16fb.c
index 830ded4..2827333 100644
--- a/drivers/video/vga16fb.c
+++ b/drivers/video/vga16fb.c
@@ -1265,7 +1265,6 @@ static void vga16fb_imageblit(struct fb_info *info, const struct fb_image *image
 
 static void vga16fb_destroy(struct fb_info *info)
 {
-	struct platform_device *dev = container_of(info->device, struct platform_device, dev);
 	iounmap(info->screen_base);
 	fb_dealloc_cmap(&info->cmap);
 	/* XXX unshare VGA regions */
-- 
1.8.3.2

