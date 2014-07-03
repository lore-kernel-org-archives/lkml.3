Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365AbaGCNLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:11:12 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:55347 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282AbaGCNLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:11:08 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-8e-53b5566a33cb
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
Subject: [PATCH 08/12] drm/exynos/ipp: remove useless registration checks
Date: Thu, 03 Jul 2014 15:10:33 +0200
Message-id: <1404393037-17299-9-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1404393037-17299-1-git-send-email-a.hajda@samsung.com>
References: <1404393037-17299-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xK7pZYVuDDaavkbW4te4cq8WVr+/Z
	LCbdn8Bi8eLeRRaLs01v2C0u75rDZjHj/D4mi7VH7rJbzJj8ks2B0+N+93Emj74tqxg9Pm+S
	C2CO4rJJSc3JLEst0rdL4Mq48v4aa8FdjoqG20eZGhhPsXcxcnJICJhI9J39zQxhi0lcuLee
	rYuRi0NIYCmjRPP578wQTh+TxJuv65lAqtgENCX+br7JBmKLCChLrNrXzg5SxCzwkUniytI3
	YKOEBTwlnne1gxWxCKhKXJj0CijOwcEr4Czx9oAWxDY5iZPHJrOC2JwCLhKHZi5lBLGFgErW
	LpnLNoGRdwEjwypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkLD6soNx8TGrQ4wCHIxKPLyN
	KzYEC7EmlhVX5h5ilOBgVhLhrQjeGizEm5JYWZValB9fVJqTWnyIkYmDU6qBsS0/6Ef8/Gva
	xvunRX053XY6h8X8uVq/de7D5S/k6/4xPnn9Qdn3eGNO4dRDP3n6iyeopYsmRD4Xbj7McH7Z
	lKyl3dI2u66E+WfzZV11f6uftHWx6oqK1DOH9sSo2qtd6DnEuDrOpyj6ccjTRwzv7eOmfuNj
	mOssWVSj8P73zIgNDLvXRek9UWIpzkg01GIuKk4EAHpJSc8JAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Argument checks are redundant, clients always check ippdrv before calling
these functions.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index b7ce14e..26c8a2c 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -129,9 +129,6 @@ void exynos_platform_device_ipp_unregister(void)
 
 int exynos_drm_ippdrv_register(struct exynos_drm_ippdrv *ippdrv)
 {
-	if (!ippdrv)
-		return -EINVAL;
-
 	mutex_lock(&exynos_drm_ippdrv_lock);
 	list_add_tail(&ippdrv->drv_list, &exynos_drm_ippdrv_list);
 	mutex_unlock(&exynos_drm_ippdrv_lock);
@@ -141,9 +138,6 @@ int exynos_drm_ippdrv_register(struct exynos_drm_ippdrv *ippdrv)
 
 int exynos_drm_ippdrv_unregister(struct exynos_drm_ippdrv *ippdrv)
 {
-	if (!ippdrv)
-		return -EINVAL;
-
 	mutex_lock(&exynos_drm_ippdrv_lock);
 	list_del(&ippdrv->drv_list);
 	mutex_unlock(&exynos_drm_ippdrv_lock);
-- 
1.9.1

