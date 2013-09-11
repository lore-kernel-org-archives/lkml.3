Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab3IKLQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:16:56 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:39417 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab3IKLQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:16:54 -0400
MIME-Version: 1.0
Date: Wed, 11 Sep 2013 19:16:53 +0800
Message-ID: <CAPgLHd_NrAGkJ+Ufw1nbfSDc_nzq1qdX1VFtmrgrYR6=0hGK0w@mail.gmail.com>
Subject: [PATCH] drm/omap: fix error return code in omap_dmm_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: airlied@linux.ie, gregkh@linuxfoundation.org, andy.gross@ti.com,
        robdclark@gmail.com, joe@perches.com
Cc: yongjun_wei@trendmicro.com.cn, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENOMEM in the refill memory alloc error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/gpu/drm/omapdrm/omap_dmm_tiler.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/omapdrm/omap_dmm_tiler.c b/drivers/gpu/drm/omapdrm/omap_dmm_tiler.c
index 9b794c9..ab546c9 100644
--- a/drivers/gpu/drm/omapdrm/omap_dmm_tiler.c
+++ b/drivers/gpu/drm/omapdrm/omap_dmm_tiler.c
@@ -675,6 +675,7 @@ static int omap_dmm_probe(struct platform_device *dev)
 				&omap_dmm->refill_pa, GFP_KERNEL);
 	if (!omap_dmm->refill_va) {
 		dev_err(&dev->dev, "could not allocate refill memory\n");
+		ret = -ENOMEM;
 		goto fail;
 	}
 

