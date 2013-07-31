Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389Ab3GaDVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 23:21:16 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:48389 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab3GaDVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 23:21:15 -0400
Message-ID: <51F8829E.4080605@huawei.com>
Date: Wed, 31 Jul 2013 11:21:02 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: <plagnioj@jcrosoft.com>, <tomi.valkeinen@ti.com>,
        <linux-fbdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] fbdev: fix build warning in vga16fb.c
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building v3.11-rc3, I get the following warning:
...
drivers/video/vga16fb.c: In function ‘vga16fb_destroy’:
drivers/video/vga16fb.c:1268: warning: unused variable ‘dev’
...

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 drivers/video/vga16fb.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

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
1.7.1

