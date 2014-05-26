Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaEZIUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 04:20:43 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45630 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaEZISa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 04:18:30 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-36-5382f8ccbc33
From: Andrzej Hajda <a.hajda@samsung.com>
To: dri-devel@lists.freedesktop.org
Cc: YoungJun Cho <yj44.cho@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 3/9] drm/exynos: ipp: rename cmd_lock to lock
Date: Mon, 26 May 2014 10:17:17 +0200
Message-id: <1401092243-25568-4-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401092243-25568-1-git-send-email-a.hajda@samsung.com>
References: <1401092243-25568-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKJMWRmVeSWpSXmKPExsVy+t/xa7pnfjQFG7w8rmFx5et7NotJ9yew
	WLy4d5HF4mzTG3aLy7vmsFnMOL+PyWLtkbvsFjMmv2Sz2LtzMqMDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJWx5+hatoItUhXPL3s2MK4S62Lk5JAQMJHY8aqBDcIWk7hwbz2Q
	zcUhJLCUUaLr0Boop49JovvWG2aQKjYBTYm/m2+CdYgIKEv8nbiKEaSIWeAjk0TL9w/sIAlh
	AVuJv2eegTWwCKhKdB7+B9bAK+AsMWvmThaIdXISJ49NZgWxOQVcJF5/XMnUxcgBtM1Z4vd3
	/gmMvAsYGVYxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihATVlx2Mi49ZHWIU4GBU4uE9EdQU
	LMSaWFZcmXuIUYKDWUmEt/kDUIg3JbGyKrUoP76oNCe1+BAjEwenVANjR0Wb4UO7lrl+/leV
	NET/xflHHt/8OzLIQvm92tT0Nal2h74EaVfXZz9521B+6ObmY6Gq4lG5nx/LF/Nuspgi/OW3
	1FS+5k1ZR683yKzsmDwvpGizhc38OUclznycUnKLr2+jdtLpaEufTcU93CueGau56xTHND9m
	9Yh4nRpc2daZy999t1KJpTgj0VCLuag4EQAyk1IHCAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: YoungJun Cho <yj44.cho@samsung.com>

The ippdrv->cmd_list requires cmd_lock.
So renames cmd_lock to lock for context.

Signed-off-by: YoungJun Cho <yj44.cho@samsung.com>
Acked-by: Seong-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Tested-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 12 ++++++------
 drivers/gpu/drm/exynos/exynos_drm_ipp.h |  4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index 0968777..0d85433 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -507,7 +507,7 @@ int exynos_drm_ipp_set_property(struct drm_device *drm_dev, void *data,
 		goto err_free_stop;
 	}
 
-	mutex_init(&c_node->cmd_lock);
+	mutex_init(&c_node->lock);
 	mutex_init(&c_node->mem_lock);
 	mutex_init(&c_node->event_lock);
 
@@ -542,7 +542,7 @@ static void ipp_clean_cmd_node(struct drm_exynos_ipp_cmd_node *c_node)
 	list_del(&c_node->list);
 
 	/* destroy mutex */
-	mutex_destroy(&c_node->cmd_lock);
+	mutex_destroy(&c_node->lock);
 	mutex_destroy(&c_node->mem_lock);
 	mutex_destroy(&c_node->event_lock);
 
@@ -979,7 +979,7 @@ int exynos_drm_ipp_queue_buf(struct drm_device *drm_dev, void *data,
 		}
 		break;
 	case IPP_BUF_DEQUEUE:
-		mutex_lock(&c_node->cmd_lock);
+		mutex_lock(&c_node->lock);
 
 		/* put event for destination buffer */
 		if (qbuf->ops_id == EXYNOS_DRM_OPS_DST)
@@ -987,7 +987,7 @@ int exynos_drm_ipp_queue_buf(struct drm_device *drm_dev, void *data,
 
 		ipp_clean_queue_buf(drm_dev, c_node, qbuf);
 
-		mutex_unlock(&c_node->cmd_lock);
+		mutex_unlock(&c_node->lock);
 		break;
 	default:
 		DRM_ERROR("invalid buffer control.\n");
@@ -1412,7 +1412,7 @@ void ipp_sched_cmd(struct work_struct *work)
 		return;
 	}
 
-	mutex_lock(&c_node->cmd_lock);
+	mutex_lock(&c_node->lock);
 
 	property = &c_node->property;
 
@@ -1460,7 +1460,7 @@ void ipp_sched_cmd(struct work_struct *work)
 	DRM_DEBUG_KMS("ctrl[%d] done.\n", cmd_work->ctrl);
 
 err_unlock:
-	mutex_unlock(&c_node->cmd_lock);
+	mutex_unlock(&c_node->lock);
 }
 
 static int ipp_send_event(struct exynos_drm_ippdrv *ippdrv,
diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.h b/drivers/gpu/drm/exynos/exynos_drm_ipp.h
index eea4db3..fbb80ac 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.h
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.h
@@ -52,7 +52,7 @@ struct drm_exynos_ipp_cmd_work {
  * @list: list head to command queue information.
  * @event_list: list head of event.
  * @mem_list: list head to source,destination memory queue information.
- * @cmd_lock: lock for synchronization of access to ioctl.
+ * @lock: lock for synchronization of access to ioctl.
  * @mem_lock: lock for synchronization of access to memory nodes.
  * @event_lock: lock for synchronization of access to scheduled event.
  * @start_complete: completion of start of command.
@@ -68,7 +68,7 @@ struct drm_exynos_ipp_cmd_node {
 	struct list_head	list;
 	struct list_head	event_list;
 	struct list_head	mem_list[EXYNOS_DRM_OPS_MAX];
-	struct mutex	cmd_lock;
+	struct mutex	lock;
 	struct mutex	mem_lock;
 	struct mutex	event_lock;
 	struct completion	start_complete;
-- 
1.9.1

