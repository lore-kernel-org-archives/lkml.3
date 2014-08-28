Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936481AbaH1JLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:11:33 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:56444 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965665AbaH1JIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:08:23 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-d8-53fef1854289
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
Subject: [PATCH v2 08/17] drm/exynos/ipp: clean memory nodes on command node
 cleaning
Date: Thu, 28 Aug 2014 11:07:32 +0200
Message-id: <1409216861-12452-9-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
References: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJMWRmVeSWpSXmKPExsVy+t/xy7qtH/8FG1xYa2Rxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJXR0dTEWvCaveL44ZXMDYx32LoYOTkkBEwkpsy+wwhhi0lcuLce
	KM7FISSwlFGice0sdginj0li//aj7CBVbAKaEn833wTrFhFQlli1rx2siFngI5PElaVvmEES
	wgLhEtOOLAArYhFQlfi/aDJYM6+As8TTG8dYIdbJSZw8NhnM5hRwkdh4/A1YjRBQze7zn5km
	MPIuYGRYxSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRESWF92MC4+ZnWIUYCDUYmHd0Ppv2Ah
	1sSy4srcQ4wSHMxKIrxHjwOFeFMSK6tSi/Lji0pzUosPMTJxcEo1MAY5NLldf6So0Djr6D+3
	GXY51+W2MJ7n19m4ufTNnyuGbuuZLllLnA1ITr27IKCMTc4siqPIz0Jn4U4P94iI5to7F+TD
	VNmiX/6YLe7YejaW9arlUqd5OxdUbnKVYzYXvpol9vXIomlfcydO/skbZOr5orf4f79KVNha
	hfjjFm81OUo9VyivV2Ipzkg01GIuKk4EALMWXvgKAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nodes should be removed before removing command node.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Reviewed-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index 05f103e..857817c 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -603,11 +603,16 @@ static void ipp_clean_mem_nodes(struct drm_device *drm_dev,
 static void ipp_clean_cmd_node(struct ipp_context *ctx,
 				struct drm_exynos_ipp_cmd_node *c_node)
 {
+	int i;
+
 	/* cancel works */
 	cancel_work_sync(&c_node->start_work->work);
 	cancel_work_sync(&c_node->stop_work->work);
 	cancel_work_sync(&c_node->event_work->work);
 
+	for_each_ipp_ops(i)
+		ipp_clean_mem_nodes(ctx->subdrv.drm_dev, c_node, i);
+
 	/* delete list */
 	list_del(&c_node->list);
 
-- 
1.9.1

