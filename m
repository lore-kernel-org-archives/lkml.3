Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbaHVHx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 03:53:29 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:49637 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbaHVHx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 03:53:26 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-0b-53f6f6f42816
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
Subject: [PATCH 01/15] drm/exynos/ipp: remove fake pm callbacks
Date: Fri, 22 Aug 2014 09:52:12 +0200
Message-id: <1408693946-15456-2-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
References: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xq7pfvn0LNljyktfi1rpzrBZXvr5n
	s5h0fwKLxYt7F1kszja9Ybe4vGsOm8WM8/uYLNYeuctuMWPySzYHTo/73ceZPPq2rGL0+LxJ
	LoA5issmJTUnsyy1SN8ugSuj7a5XwWG+itsX77I0MLbwdDFyckgImEhsedfMCGGLSVy4t56t
	i5GLQ0hgKaPE6XmdLBBOH5NE0/avYFVsApoSfzffZAOxRQSUJVbta2cHKWIW+MgkcWXpG2aQ
	hLCAvcSOb3PBGlgEVCWmHHwIFucVcJb4MPk2K8Q6OYmTxyaD2ZwCLhIXDk4DqxECqum6PY1p
	AiPvAkaGVYyiqaXJBcVJ6bmGesWJucWleel6yfm5mxghYfVlB+PiY1aHGAU4GJV4eBN/fw0W
	Yk0sK67MPcQowcGsJMK7ad63YCHelMTKqtSi/Pii0pzU4kOMTBycUg2MssXrV6h+kwiZ/Jnh
	dt9a06/31VRVIwJv7s+4OqP4zpcnD2vKl4Re6fsc3i7iYBi6KLXbRl1ocTP7BN295/kYgt9U
	s60LWM9o92TaVaWb1+RmMV2umHyOU+JsTjjH8Yn1/Gd5FvF3HJOwi31YZ7Er4DnvM/2v51Z1
	OVcyVm+v74xpmZQSkOyixFKckWioxVxUnAgAiKJIygkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PM callbacks in ipp core do nothing, so the patch removes it.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
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

