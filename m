Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab3GYKJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 06:09:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61136 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755144Ab3GYKJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 06:09:45 -0400
X-IronPort-AV: E=Sophos;i="4.89,742,1367942400"; 
   d="scan'208";a="8020488"
Message-ID: <51F0F88D.8060903@cn.fujitsu.com>
Date: Thu, 25 Jul 2013 18:06:05 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: plagnioj@jcrosoft.com, tomi.valkeinen@ti.com
CC: linux-fbdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH V2] driver/vga16fb.c: remove the unused variable "dev" of
 function vga16fb_destroy()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/25 18:07:40,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/25 18:07:40,
	Serialize complete at 2013/07/25 18:07:40
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e21d2170f36602ae2708 ("video: remove unnecessary
platform_set_drvdata()") removed the unnecessary platform_set_drvdata(),
but left the variable "dev" unused, delete it.

v2:
   Following Geert's suggestion to make change log easier reading.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
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
1.7.7

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

