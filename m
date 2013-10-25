Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab3JYJHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 05:07:22 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:50811 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab3JYJHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 05:07:20 -0400
MIME-Version: 1.0
Date: Fri, 25 Oct 2013 17:07:18 +0800
Message-ID: <CAPgLHd8m+fq1WDdxkoVPRRDGBDD8ExVz8Nj9Z6W+DjQehp1YZA@mail.gmail.com>
Subject: [PATCH] staging: drm/imx: fix return value check in imx_drm_init()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org, s.hauer@pengutronix.de, airlied@redhat.com,
        daniel.vetter@ffwll.ch, p.zabel@pengutronix.de
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function platform_device_register_simple() returns
ERR_PTR() and never returns NULL. The NULL test in the return value check
should be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/imx-drm/imx-drm-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/imx-drm/imx-drm-core.c b/drivers/staging/imx-drm/imx-drm-core.c
index a2e52a0..835a1b1 100644
--- a/drivers/staging/imx-drm/imx-drm-core.c
+++ b/drivers/staging/imx-drm/imx-drm-core.c
@@ -837,8 +837,8 @@ static int __init imx_drm_init(void)
 	INIT_LIST_HEAD(&imx_drm_device->encoder_list);
 
 	imx_drm_pdev = platform_device_register_simple("imx-drm", -1, NULL, 0);
-	if (!imx_drm_pdev) {
-		ret = -EINVAL;
+	if (IS_ERR(imx_drm_pdev)) {
+		ret = PTR_ERR(imx_drm_pdev);
 		goto err_pdev;
 	}
 

