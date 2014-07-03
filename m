Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964825AbaGCNLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:11:07 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:55341 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282AbaGCNLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:11:03 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-67-53b556658a96
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
Subject: [PATCH 06/12] drm/exynos/ipp: remove incorrect checks of
 list_first_entry result
Date: Thu, 03 Jul 2014 15:10:31 +0200
Message-id: <1404393037-17299-7-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1404393037-17299-1-git-send-email-a.hajda@samsung.com>
References: <1404393037-17299-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCJMWRmVeSWpSXmKPExsVy+t/xK7qpYVuDDVbP1LK4te4cq8WVr+/Z
	LCbdn8Bi8eLeRRaLs01v2C0u75rDZjHj/D4mi7VH7rJbzJj8ks2B0+N+93Emj74tqxg9Pm+S
	C2CO4rJJSc3JLEst0rdL4Mq433GDveA4T8XU+/oNjJO4uhg5OCQETCSWNEl0MXICmWISF+6t
	Z+ti5OIQEljKKPGgfy8zhNPHJHHm/G9GkCo2AU2Jv5tvsoHYIgLKEqv2tbODFDELfGSSuLL0
	DTPIVGGBaInlvZIgNSwCqhJbP71hB7F5BZwlzh+5zwixTU7i5LHJrCA2p4CLxKGZS8HiQkA1
	a5fMZZvAyLuAkWEVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkhIfd3BuPSY1SFGAQ5GJR7e
	F/qbgoVYE8uKK3MPMUpwMCuJ8FYEbw0W4k1JrKxKLcqPLyrNSS0+xMjEwSnVwDhZ8MHV9jt2
	QmLHCmMmqF9KMUre1pH4qXXDWo7iWzleDZOe5vnrirDYtN46dddkh6pX5pugZGvDykLFNXaH
	XhVYcRg3nZfLtzm7OVn2xMdjebrHJkR6zVmpNWHnNDux0ksH0ozjFp0X+vlYcEGn/LvDzDk/
	rD+FVPy02bth7cG1m/3EXtkJeyqxFGckGmoxFxUnAgAQxj+DBwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

list_first_entry does not return NULL on empty list so this check
does not make sense. Moreover there is already code which prevents calling
list_first_entry on empty lists.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index f84ef8a..89ff7e3 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -1277,11 +1277,6 @@ static int ipp_start_property(struct exynos_drm_ippdrv *ippdrv,
 
 			m_node = list_first_entry(head,
 				struct drm_exynos_ipp_mem_node, list);
-			if (!m_node) {
-				DRM_ERROR("failed to get node.\n");
-				ret = -EFAULT;
-				goto err_unlock;
-			}
 
 			DRM_DEBUG_KMS("m_node[0x%x]\n", (int)m_node);
 
@@ -1539,11 +1534,6 @@ static int ipp_send_event(struct exynos_drm_ippdrv *ippdrv,
 
 			m_node = list_first_entry(head,
 				struct drm_exynos_ipp_mem_node, list);
-			if (!m_node) {
-				DRM_ERROR("empty memory node.\n");
-				ret = -ENOMEM;
-				goto err_mem_unlock;
-			}
 
 			tbuf_id[i] = m_node->buf_id;
 			DRM_DEBUG_KMS("%s buf_id[%d]\n",
@@ -1580,11 +1570,6 @@ static int ipp_send_event(struct exynos_drm_ippdrv *ippdrv,
 
 		m_node = list_first_entry(head,
 			struct drm_exynos_ipp_mem_node, list);
-		if (!m_node) {
-			DRM_ERROR("empty memory node.\n");
-			ret = -ENOMEM;
-			goto err_mem_unlock;
-		}
 
 		tbuf_id[EXYNOS_DRM_OPS_SRC] = m_node->buf_id;
 
-- 
1.9.1

