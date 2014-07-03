Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbaGCNM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:12:58 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40887 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214AbaGCNLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:11:00 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-71-53b556630d2e
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
Subject: [PATCH 05/12] drm/exynos/ipp: remove temporary variable
Date: Thu, 03 Jul 2014 15:10:30 +0200
Message-id: <1404393037-17299-6-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1404393037-17299-1-git-send-email-a.hajda@samsung.com>
References: <1404393037-17299-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xK7rJYVuDDZ7+kbW4te4cq8WVr+/Z
	LCbdn8Bi8eLeRRaLs01v2C0u75rDZjHj/D4mi7VH7rJbzJj8ks2B0+N+93Emj74tqxg9Pm+S
	C2CO4rJJSc3JLEst0rdL4MrYM+8cU0ETb0XT6W9MDYxvuLoYOTkkBEwk5j1sY4OwxSQu3FsP
	ZgsJLGWU6PuR08XIBWT3MUmc/TwTLMEmoCnxd/NNMFtEQFli1b52dpAiZoGPTBJXlr5hBkkI
	CzhIrJi+EsxmEVCVaHr+GayBV8BZ4uWNPVDb5CROHpvMCmJzCrhIHJq5lBFis7PE2iVz2SYw
	8i5gZFjFKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERJWX3YwLj5mdYhRgINRiYe3ccWGYCHW
	xLLiytxDjBIczEoivBXBW4OFeFMSK6tSi/Lji0pzUosPMTJxcEo1MBqlu1sEOtrYbr68Ve3W
	6sJviy7fVdi20OOiS8+DtUJnD1YI/pQ/98PdKu50+OJXBvNvpLlz3no4p7lg6apCPhehqU/y
	jub89sgMkv1T1npK4tSXRUzRZ1/On33JMWbu3vVMt9Nm806w79gTK+fUpb7iqb45d/axGN9d
	0mJSh6oDvE2+nebkmqrEUpyRaKjFXFScCABZTK2gCQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason to allocate intermediate variable.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index f3d8b5c..f84ef8a 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -680,15 +680,14 @@ static struct drm_exynos_ipp_mem_node
 		struct drm_exynos_ipp_queue_buf *qbuf)
 {
 	struct drm_exynos_ipp_mem_node *m_node;
-	struct drm_exynos_ipp_buf_info buf_info;
+	struct drm_exynos_ipp_buf_info *buf_info;
 	int i;
 
 	m_node = kzalloc(sizeof(*m_node), GFP_KERNEL);
 	if (!m_node)
 		return ERR_PTR(-ENOMEM);
 
-	/* clear base address for error handling */
-	memset(&buf_info, 0x0, sizeof(buf_info));
+	buf_info = &m_node->buf_info;
 
 	/* operations, buffer id */
 	m_node->ops_id = qbuf->ops_id;
@@ -712,15 +711,14 @@ static struct drm_exynos_ipp_mem_node
 				goto err_clear;
 			}
 
-			buf_info.handles[i] = qbuf->handle[i];
-			buf_info.base[i] = *addr;
-			DRM_DEBUG_KMS("i[%d]base[0x%x]hd[0x%x]\n",
-				i, buf_info.base[i], (int)buf_info.handles[i]);
+			buf_info->handles[i] = qbuf->handle[i];
+			buf_info->base[i] = *addr;
+			DRM_DEBUG_KMS("i[%d]base[0x%x]hd[0x%lx]\n", i,
+				      buf_info->base[i], buf_info->handles[i]);
 		}
 	}
 
 	m_node->filp = file;
-	m_node->buf_info = buf_info;
 	mutex_lock(&c_node->mem_lock);
 	list_add_tail(&m_node->list, &c_node->mem_list[qbuf->ops_id]);
 	mutex_unlock(&c_node->mem_lock);
-- 
1.9.1

