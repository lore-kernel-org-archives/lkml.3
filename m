Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965871AbaH1JMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:12:34 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54124 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936274AbaH1JIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:08:16 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-9f-53fef17e6a76
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
Subject: [PATCH v2 02/17] drm/exynos/ipp: cancel works before command node clean
Date: Thu, 28 Aug 2014 11:07:26 +0200
Message-id: <1409216861-12452-3-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
References: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJMWRmVeSWpSXmKPExsVy+t/xy7p1H/8FG7QfUbW4te4cq8WVr+/Z
	LCbdn8Bi8eLeRRaLs01v2C0u75rDZjHj/D4mi7VH7rJbzJj8ks2B0+N+93Emj74tqxg9Pm+S
	C2CO4rJJSc3JLEst0rdL4MpYdXQjY8Ettopzh36xNTA+Ye1i5OSQEDCReLpjHwuELSZx4d56
	ti5GLg4hgaWMErsOTGSHcPqYJH68/ArWwSagKfF38002EFtEQFli1b52sCJmgY9MEleWvmEG
	SQgLBEjMmHEZrIFFQFXi1+dL7CA2r4CzxO1X76HWyUmcPDYZrIZTwEVi4/E3YDVCQDW7z39m
	msDIu4CRYRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZGSGB93cG49JjVIUYBDkYlHl6F03+C
	hVgTy4orcw8xSnAwK4nwHj3+L1iINyWxsiq1KD++qDQntfgQIxMHp1QDo9J/mWUvD66cdSKg
	vEbLIMNXj8PY+/3X6o557OnuD24fPnMhsut6KOODxqiTknO3T77VsuQmV6TY/XJnaVaLyRKs
	8tvX/i3V7f0afNXtLseE1w1RNRm9/ZyznyRyhr8vaPGOu7I/iXdBbMaO7n2+Ts99d8188r17
	EZtW8u70y2tYmR43Ms3/r8RSnJFoqMVcVJwIAF5zMkAKAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All pending works should be canceled prior to its removal.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Reviewed-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index da917ca..9770966 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -502,6 +502,11 @@ err_clear:
 static void ipp_clean_cmd_node(struct ipp_context *ctx,
 				struct drm_exynos_ipp_cmd_node *c_node)
 {
+	/* cancel works */
+	cancel_work_sync(&c_node->start_work->work);
+	cancel_work_sync(&c_node->stop_work->work);
+	cancel_work_sync(&c_node->event_work->work);
+
 	/* delete list */
 	list_del(&c_node->list);
 
-- 
1.9.1

