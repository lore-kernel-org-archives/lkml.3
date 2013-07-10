Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab3GJW5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 18:57:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38271 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab3GJW5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 18:57:04 -0400
Date: Wed, 10 Jul 2013 23:57:00 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-fbdev@vger.kernel.org
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] vga16fb: Remove unused variable
Message-ID: <20130710225659.GA14107@hercules>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build warning of unused variable:

drivers/video/vga16fb.c:1268:26: warning: unused variable ‘dev’ [-Wunused-variable]

Signed-off-by: Luis Henriques<luis.henriques@canonical.com>
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
1.8.1.2
