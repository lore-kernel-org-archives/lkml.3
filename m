Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab3JBL4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 07:56:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463Ab3JBL4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 07:56:00 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        devel@linuxdriverproject.org (open list:Hyper-V CORE AND...),
        linux-fbdev@vger.kernel.org (open list:FRAMEBUFFER LAYER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/2] hyperv-fb: add blanking support
Date: Wed,  2 Oct 2013 13:55:11 +0200
Message-Id: <1380714911-6254-2-git-send-email-kraxel@redhat.com>
In-Reply-To: <1380714911-6254-1-git-send-email-kraxel@redhat.com>
References: <1380714911-6254-1-git-send-email-kraxel@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 drivers/video/hyperv_fb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/video/hyperv_fb.c b/drivers/video/hyperv_fb.c
index 8d456dc..130708f 100644
--- a/drivers/video/hyperv_fb.c
+++ b/drivers/video/hyperv_fb.c
@@ -575,6 +575,10 @@ static int hvfb_setcolreg(unsigned regno, unsigned red, unsigned green,
 	return 0;
 }
 
+static int hvfb_blank(int blank, struct fb_info *info)
+{
+	return 1;	/* get fb_blank to set the colormap to all black */
+}
 
 static struct fb_ops hvfb_ops = {
 	.owner = THIS_MODULE,
@@ -584,6 +588,7 @@ static struct fb_ops hvfb_ops = {
 	.fb_fillrect = cfb_fillrect,
 	.fb_copyarea = cfb_copyarea,
 	.fb_imageblit = cfb_imageblit,
+	.fb_blank = hvfb_blank,
 };
 
 
-- 
1.8.3.1

