Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab3HZHPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 03:15:40 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:36195 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab3HZHPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 03:15:39 -0400
MIME-Version: 1.0
Date: Mon, 26 Aug 2013 15:15:37 +0800
Message-ID: <CAPgLHd-6AP74UFPzxU0dz2y+JyPSL1w+x5zd_hXCVLOuws8AYQ@mail.gmail.com>
Subject: [PATCH] drm/vmwgfx: fix error return code in vmw_driver_load()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: airlied@linux.ie, airlied@redhat.com, thellstrom@vmware.com,
        brianp@vmware.com, dtor@vmware.com, daniel.vetter@ffwll.ch
Cc: yongjun_wei@trendmicro.com.cn, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENOMEM in the fence manager init error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index 78e2164..6dafefc 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -622,8 +622,10 @@ static int vmw_driver_load(struct drm_device *dev, unsigned long chipset)
 	}
 
 	dev_priv->fman = vmw_fence_manager_init(dev_priv);
-	if (unlikely(dev_priv->fman == NULL))
+	if (unlikely(dev_priv->fman == NULL)) {
+		ret = -ENOMEM;
 		goto out_no_fman;
+	}
 
 	vmw_kms_save_vga(dev_priv);
 

