Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaJCIYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 04:24:42 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:62943 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaJCIYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 04:24:36 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-60-542e5d4274b3
From: Andrzej Hajda <a.hajda@samsung.com>
To: dri-devel@lists.freedesktop.org (open list:DRM DRIVERS)
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        David Airlie <airlied@linux.ie>, Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS),
        linux-kernel@vger.kernel.org (open list),
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
        intel-gfx@lists.freedesktop.org (open list:INTEL DRM DRIVERS...)
Subject: [PATCH RFC 3/4] drm/exynos: remove master component PM callbacks
Date: Fri, 03 Oct 2014 10:24:12 +0200
Message-id: <1412324653-30677-4-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1412324653-30677-1-git-send-email-a.hajda@samsung.com>
References: <1412324653-30677-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFLMWRmVeSWpSXmKPExsVy+t/xq7pOsXohBp1XTC1urTvHatF77iST
	xfIz65gtrnx9z2Yx6f4EFovZEzYDxS6vZ7R4ce8ii0XvgqtsFmeb3rBbXN41h81ixvl9TBZr
	j9xlt5gx+SWbA5/H4j0vmTy2f3vA6jHvZKDH/e7jTB59W1YxenzeJBfAFsVlk5Kak1mWWqRv
	l8CVsXb6DtaCrzwVq45tZmtgfMPVxcjBISFgIjFxuUAXIyeQKSZx4d56NhBbSGApo8T37U4Q
	dh+TxIcTCiA2m4CmxN/NN9lAWkUErCWuTZLtYuTiYBboZZX4dqWZGaRGWMBTYs37XjCbRUBV
	onHbI1YQm1fAWWL2mw1MELvkJE4emwwW5xRwkXjeM40VYpezxM0Hv9kmMPIuYGRYxSiaWppc
	UJyUnmukV5yYW1yal66XnJ+7iRESnl93MC49ZnWIUYCDUYmH98MN3RAh1sSy4srcQ4wSHMxK
	IryTo/RChHhTEiurUovy44tKc1KLDzEycXBKNTBq925saz0VMP9NYvSitoV+0f1yt4w/NR73
	LvJPTOSL67kf2Xb7nZWcyLZNu0pO2ojM/OQYGDnxCpPivqnrTTPtJa/9rboRePybuXjLcs+f
	JjveL338eMVHr7RNC3V+Hln6ttlx15VDrTcXbml6P0l3b1pwQN8pPrfA/LSzDRv9uLa5c31v
	rTuixFKckWioxVxUnAgA15ILdy0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch removes master PM callbacks as their functionality
is already duplicated by suspend/resume drm callbacks.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_drv.c | 29 -----------------------------
 1 file changed, 29 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
index cf19e60..dca20b15 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
@@ -342,34 +342,6 @@ static struct drm_driver exynos_drm_driver = {
 	.minor	= DRIVER_MINOR,
 };
 
-#ifdef CONFIG_PM_SLEEP
-static int exynos_drm_sys_suspend(struct device *dev)
-{
-	struct drm_device *drm_dev = dev_get_drvdata(dev);
-	pm_message_t message;
-
-	if (pm_runtime_suspended(dev) || !drm_dev)
-		return 0;
-
-	message.event = PM_EVENT_SUSPEND;
-	return exynos_drm_suspend(drm_dev, message);
-}
-
-static int exynos_drm_sys_resume(struct device *dev)
-{
-	struct drm_device *drm_dev = dev_get_drvdata(dev);
-
-	if (pm_runtime_suspended(dev) || !drm_dev)
-		return 0;
-
-	return exynos_drm_resume(drm_dev);
-}
-#endif
-
-static const struct dev_pm_ops exynos_drm_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(exynos_drm_sys_suspend, exynos_drm_sys_resume)
-};
-
 int exynos_drm_component_add(struct device *dev,
 				enum exynos_drm_device_type dev_type,
 				enum exynos_drm_output_type out_type)
@@ -634,7 +606,6 @@ static struct platform_driver exynos_drm_platform_driver = {
 	.driver	= {
 		.owner	= THIS_MODULE,
 		.name	= "exynos-drm",
-		.pm	= &exynos_drm_pm_ops,
 	},
 };
 
-- 
1.9.1

