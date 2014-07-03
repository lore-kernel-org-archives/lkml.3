Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964895AbaGCNNW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:13:22 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40887 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbaGCNK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:10:59 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-6c-53b55661fa12
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
Subject: [PATCH 04/12] drm/exynos/ipp: correct address type
Date: Thu, 03 Jul 2014 15:10:29 +0200
Message-id: <1404393037-17299-5-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1404393037-17299-1-git-send-email-a.hajda@samsung.com>
References: <1404393037-17299-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJMWRmVeSWpSXmKPExsVy+t/xK7qJYVuDDabtU7a4te4cq8WVr+/Z
	LCbdn8Bi8eLeRRaLs01v2C0u75rDZjHj/D4mi7VH7rJbzJj8ks2B0+N+93Emj74tqxg9Pm+S
	C2CO4rJJSc3JLEst0rdL4Mr4MLeNqeA/Z8WDWx3MDYxzOLoYOTkkBEwkLmz6xgZhi0lcuLce
	yObiEBJYyigx9+AFRginj0liz/NnzCBVbAKaEn833wTrEBFQlli1r50dpIhZ4COTxJWlb8CK
	hAWsJfauf8MOYrMIqEpc+fySBcTmFXCWOPznBTPEOjmJk8cms4LYnAIuEodmLmUEsYWAatYu
	mcs2gZF3ASPDKkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYyQwPqyg3HxMatDjAIcjEo8vI0r
	NgQLsSaWFVfmHmKU4GBWEuGtCN4aLMSbklhZlVqUH19UmpNafIiRiYNTqoFxcfkHtWn3l0/I
	+Fi6p37Vm3cmS5o3+i0o42OV7F7GypOo9PKcBsPfyxvvB9YsPpQvvSLMRjeCX1bn0625z76+
	fni1n3neRs4sg0pbHRvz8xPO6V5I5J7pfasos0Xj9qeej+I1SkvXLolsf/fqsofxpVuqwRzL
	8wIjdee/ciiwyGX/Xq8eOdFeiaU4I9FQi7moOBEAZvxuLwoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

exynos_drm_gem_get_dma_addr returns dma_addr_t, type casting to void* and
back is not necessary.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index 34d185c..f3d8b5c 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -681,7 +681,6 @@ static struct drm_exynos_ipp_mem_node
 {
 	struct drm_exynos_ipp_mem_node *m_node;
 	struct drm_exynos_ipp_buf_info buf_info;
-	void *addr;
 	int i;
 
 	m_node = kzalloc(sizeof(*m_node), GFP_KERNEL);
@@ -704,6 +703,8 @@ static struct drm_exynos_ipp_mem_node
 
 		/* get dma address by handle */
 		if (qbuf->handle[i]) {
+			dma_addr_t *addr;
+
 			addr = exynos_drm_gem_get_dma_addr(drm_dev,
 					qbuf->handle[i], file);
 			if (IS_ERR(addr)) {
@@ -712,7 +713,7 @@ static struct drm_exynos_ipp_mem_node
 			}
 
 			buf_info.handles[i] = qbuf->handle[i];
-			buf_info.base[i] = *(dma_addr_t *) addr;
+			buf_info.base[i] = *addr;
 			DRM_DEBUG_KMS("i[%d]base[0x%x]hd[0x%x]\n",
 				i, buf_info.base[i], (int)buf_info.handles[i]);
 		}
-- 
1.9.1

