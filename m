Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965888AbaH1JMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:12:48 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:11822 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936269AbaH1JIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:08:15 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-98-53fef17d88d7
From: Andrzej Hajda <a.hajda@samsung.com>
To: Inki Dae <inki.dae@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org (open list),
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...)
Subject: [PATCH v2 01/17] drm/exynos/ipp: remove fake pm callbacks
Date: Thu, 28 Aug 2014 11:07:25 +0200
Message-id: <1409216861-12452-2-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
References: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xy7q1H/8FG3T0sFjcWneO1eLK1/ds
	FpPuT2CxeHHvIovF2aY37BaXd81hs5hxfh+Txdojd9ktZkx+yebA6XG/+ziTR9+WVYwenzfJ
	BTBHcdmkpOZklqUW6dslcGUc2HmeveAXX8XlIy9YGhi38XQxcnJICJhITHjymQnCFpO4cG89
	WxcjF4eQwFJGiU+n5kE5fUwSW45fYgepYhPQlPi7+SYbiC0ioCyxal87O0gRs8BHJokrS98w
	gySEBZwklh6/AdbAIqAqcb7nNFADBwevgLPE4bvGENvkJE4em8wKYnMKuEhsPP4GrFwIqGT3
	+c9MExh5FzAyrGIUTS1NLihOSs810itOzC0uzUvXS87P3cQICauvOxiXHrM6xCjAwajEw6tw
	+k+wEGtiWXFl7iFGCQ5mJRHeo8f/BQvxpiRWVqUW5ccXleakFh9iZOLglGpg1D+9r6Be23e1
	UccWpUnfJPqrnQ6bxyRPYMx8e2hd0BXJopoNvz8aes5a/bM75Ler1/5Sb5HUZM1H6Q2N/KK3
	+y8Vfo/73rizvEjZ/Iyd0fPXH/Wz/nk/2i33qGmx4LNT552+lyy8qtH5bUbGvOY/n1xnP5ZM
	dNt6WC8578veJH79B0l8jlHTlFiKMxINtZiLihMB0lmdogkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PM callbacks in ipp core do nothing, so the patch removes it.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Reviewed-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 51 ---------------------------------
 1 file changed, 51 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index c411399..da917ca 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -1808,63 +1808,12 @@ static int ipp_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static int ipp_power_ctrl(struct ipp_context *ctx, bool enable)
-{
-	DRM_DEBUG_KMS("enable[%d]\n", enable);
-
-	return 0;
-}
-
-#ifdef CONFIG_PM_SLEEP
-static int ipp_suspend(struct device *dev)
-{
-	struct ipp_context *ctx = get_ipp_context(dev);
-
-	if (pm_runtime_suspended(dev))
-		return 0;
-
-	return ipp_power_ctrl(ctx, false);
-}
-
-static int ipp_resume(struct device *dev)
-{
-	struct ipp_context *ctx = get_ipp_context(dev);
-
-	if (!pm_runtime_suspended(dev))
-		return ipp_power_ctrl(ctx, true);
-
-	return 0;
-}
-#endif
-
-#ifdef CONFIG_PM_RUNTIME
-static int ipp_runtime_suspend(struct device *dev)
-{
-	struct ipp_context *ctx = get_ipp_context(dev);
-
-	return ipp_power_ctrl(ctx, false);
-}
-
-static int ipp_runtime_resume(struct device *dev)
-{
-	struct ipp_context *ctx = get_ipp_context(dev);
-
-	return ipp_power_ctrl(ctx, true);
-}
-#endif
-
-static const struct dev_pm_ops ipp_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(ipp_suspend, ipp_resume)
-	SET_RUNTIME_PM_OPS(ipp_runtime_suspend, ipp_runtime_resume, NULL)
-};
-
 struct platform_driver ipp_driver = {
 	.probe		= ipp_probe,
 	.remove		= ipp_remove,
 	.driver		= {
 		.name	= "exynos-drm-ipp",
 		.owner	= THIS_MODULE,
-		.pm	= &ipp_pm_ops,
 	},
 };
 
-- 
1.9.1

