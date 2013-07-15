Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab3GOGaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 02:30:05 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:43484 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab3GOGaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 02:30:04 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>, <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] video: remove unused variable "dev" in vga16fb_destroy()
Date: Mon, 15 Jul 2013 14:29:25 +0800
Message-ID: <1373869765-52572-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete unused variable "dev" to fix build warning in
drivers/video/vga16fb.c

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Jingoo Han <jg1.han@samsung.com>
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


