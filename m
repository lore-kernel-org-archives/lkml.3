Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbaIINRG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 09:17:06 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16655 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaIINRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 09:17:00 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-7d-540efdc9d1fd
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
Subject: [PATCH 1/9] drm/exynos/ipp: traverse ipp drivers list safely
Date: Tue, 09 Sep 2014 15:16:05 +0200
Message-id: <1410268573-2297-2-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410268573-2297-1-git-send-email-a.hajda@samsung.com>
References: <1410268573-2297-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xK7on//KFGMy9L2Bxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJVx9e0DxoKNHBXbP25ib2CcxN7FyMkhIWAisf/6bUYIW0ziwr31
	bF2MXBxCAksZJaY+3MMO4fQxSZybNYENpIpNQFPi7+abYLaIgLLEqn3tYEXMAh+ZJK4sfcMM
	khAWcJVoe3sbbAWLgKpEx56/YA28Ak4Sp3ons0Ksk5M4eQzE5uDgFHCWePsvACQsBFSy4O03
	9gmMvAsYGVYxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihITVlx2Mi49ZHWIU4GBU4uFtyOAL
	EWJNLCuuzD3EKMHBrCTCa/0CKMSbklhZlVqUH19UmpNafIiRiYNTqoGxSVTysJ5Szrmy+23O
	B5+0Wmc+6djH/KaGneHr3Z0bfH8XeQrac/wztrmRLXd1KSu3mqnHvOiF1bozdv7mVuV+X3sn
	jDvppfqcm7IvagUkPT4eLHC5aLvWdfXjQ8yrrGPLN7Ezdgi3LZtnr3yJUZKJOfL2r0uZBVXH
	pAKaTnxL0jaftqBpyj8lluKMREMt5qLiRAAzO+dyCQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On ipp subsystem removal list of ipp drivers is traversed
and their members are deleted. To do it properly safe version
of list_for_each* should be used.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index 4f36a9d..00d74b1 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -1605,11 +1605,11 @@ err:
 
 static void ipp_subdrv_remove(struct drm_device *drm_dev, struct device *dev)
 {
-	struct exynos_drm_ippdrv *ippdrv;
+	struct exynos_drm_ippdrv *ippdrv, *t;
 	struct ipp_context *ctx = get_ipp_context(dev);
 
 	/* get ipp driver entry */
-	list_for_each_entry(ippdrv, &exynos_drm_ippdrv_list, drv_list) {
+	list_for_each_entry_safe(ippdrv, t, &exynos_drm_ippdrv_list, drv_list) {
 		if (is_drm_iommu_supported(drm_dev))
 			drm_iommu_detach_device(drm_dev, ippdrv->dev);
 
-- 
1.9.1

