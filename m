Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab3IKOJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 10:09:06 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:47555 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab3IKOJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 10:09:05 -0400
MIME-Version: 1.0
Date: Wed, 11 Sep 2013 22:09:02 +0800
Message-ID: <CAPgLHd8h4kV4U0g9orq_dLzB67UXTYXLQR_5dscyrBd=q6VERw@mail.gmail.com>
Subject: [PATCH] drm/msm: fix potential NULL pointer dereference
From: Wei Yongjun <weiyj.lk@gmail.com>
To: airlied@linux.ie, robdclark@gmail.com
Cc: yongjun_wei@trendmicro.com.cn, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference to 'pdata' should be moved below the NULL test.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/gpu/drm/msm/msm_gpu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_gpu.c b/drivers/gpu/drm/msm/msm_gpu.c
index e1e1ec9..6b50e6b 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -29,13 +29,14 @@
 static void bs_init(struct msm_gpu *gpu, struct platform_device *pdev)
 {
 	struct drm_device *dev = gpu->dev;
-	struct kgsl_device_platform_data *pdata = pdev->dev.platform_data;
+	struct kgsl_device_platform_data *pdata;
 
 	if (!pdev) {
 		dev_err(dev->dev, "could not find dtv pdata\n");
 		return;
 	}
 
+	pdata = pdev->dev.platform_data;
 	if (pdata->bus_scale_table) {
 		gpu->bsc = msm_bus_scale_register_client(pdata->bus_scale_table);
 		DBG("bus scale client: %08x", gpu->bsc);

