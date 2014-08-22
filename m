Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbaHVHxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 03:53:35 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:32996 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945AbaHVHxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 03:53:33 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-27-53f6f6fa973c
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
Subject: [PATCH 04/15] drm/exynos/ipp: remove only related commands on file
 close
Date: Fri, 22 Aug 2014 09:52:15 +0200
Message-id: <1408693946-15456-5-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
References: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJMWRmVeSWpSXmKPExsVy+t/xq7q/vn0LNni7XNPi1rpzrBZXvr5n
	s5h0fwKLxYt7F1kszja9Ybe4vGsOm8WM8/uYLNYeuctuMWPySzYHTo/73ceZPPq2rGL0+LxJ
	LoA5issmJTUnsyy1SN8ugSvj3PFpzAXnuCvef2tnbmC8w9nFyMkhIWAi8f/WRHYIW0ziwr31
	bF2MXBxCAksZJX5tfMEI4fQxSfzp/MwKUsUmoCnxd/NNNhBbREBZYtW+dnaQImaBj0wSV5a+
	YQZJCAsES5zd9A9sLIuAqsTOXSfA4rwCzhINDfNZIdbJSZw8NhnM5hRwkbhwcBpYjRBQTdft
	aUwTGHkXMDKsYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAgJrC87GBcfszrEKMDBqMTDm/j7
	a7AQa2JZcWXuIUYJDmYlEd5N874FC/GmJFZWpRblxxeV5qQWH2Jk4uCUamA0M35w4ni7uteF
	jawzffi3PdIznKuYPYv7Ud0tXqPYQw2P00PPq0pZO8n2SbhtTjtRFfh6zZ9D1z3dd7DXdfYr
	nliYcmdiW2P+dkV/q/jTE9cw13V9V5Hxc/Beb7rSQVzh3CULn39HFV2L44S6w/KSbgpHnTJa
	fKXN7ASvS+bEtoiCvMMT5yqxFGckGmoxFxUnAgAYtJ1xCgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On file close driver should remove only command nodes created
via this file.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index bbe9968..81f780e 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -1681,14 +1681,11 @@ static int ipp_subdrv_open(struct drm_device *drm_dev, struct device *dev,
 static void ipp_subdrv_close(struct drm_device *drm_dev, struct device *dev,
 		struct drm_file *file)
 {
-	struct drm_exynos_file_private *file_priv = file->driver_priv;
 	struct exynos_drm_ippdrv *ippdrv = NULL;
 	struct ipp_context *ctx = get_ipp_context(dev);
 	struct drm_exynos_ipp_cmd_node *c_node, *tc_node;
 	int count = 0;
 
-	DRM_DEBUG_KMS("for priv[0x%x]\n", (int)file_priv->ipp_dev);
-
 	list_for_each_entry(ippdrv, &exynos_drm_ippdrv_list, drv_list) {
 		mutex_lock(&ippdrv->cmd_lock);
 		list_for_each_entry_safe(c_node, tc_node,
@@ -1696,7 +1693,7 @@ static void ipp_subdrv_close(struct drm_device *drm_dev, struct device *dev,
 			DRM_DEBUG_KMS("count[%d]ippdrv[0x%x]\n",
 				count++, (int)ippdrv);
 
-			if (c_node->dev == file_priv->ipp_dev) {
+			if (c_node->filp == file) {
 				/*
 				 * userland goto unnormal state. process killed.
 				 * and close the file.
-- 
1.9.1

