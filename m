Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965840AbaH1JKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:10:54 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:56444 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965634AbaH1JIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:08:25 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-c8-53fef186cbc0
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
Subject: [PATCH v2 09/17] drm/exynos/ipp: replace work_struct casting with
 better constructs
Date: Thu, 28 Aug 2014 11:07:33 +0200
Message-id: <1409216861-12452-10-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
References: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJMWRmVeSWpSXmKPExsVy+t/xy7ptH/8FGyzos7G4te4cq8WVr+/Z
	LCbdn8Bi8eLeRRaLs01v2C0u75rDZjHj/D4mi7VH7rJbzJj8ks2B0+N+93Emj74tqxg9Pm+S
	C2CO4rJJSc3JLEst0rdL4MqYumkaY8F+6YrzszcxNTA+F+9i5OSQEDCROPLiBiOELSZx4d56
	ti5GLg4hgaWMEjt3NzBCOH1MEi0v3rGBVLEJaEr83XwTzBYRUJZYta+dHaSIWeAjk8SVpW+Y
	QRLCAnES+x7PZgKxWQRUJU4tXcEOYvMKuEhceLWXHWKdnMTJY5NZQWxOoPjG42/A4kICzhK7
	z39mmsDIu4CRYRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZGSGB93cG49JjVIUYBDkYlHl6F
	03+ChVgTy4orcw8xSnAwK4nwHj3+L1iINyWxsiq1KD++qDQntfgQIxMHp1QDY3SW5OlHCdHe
	f3s9vhm1aB++t4RTceamaG6F2rbZU49KzL5zasc0t+kzD0U9br55dsodmT2tydduHfzyIvDm
	jGtTPI2+nDrDILyH3Szm8N99jHGJjW9jLh1oXrL3HnOUl0Dc5cxH1W1/tt7VFZURqO84EX5w
	z5Y7Auwie1WTO/zi9P1f6/5c2qPEUpyRaKjFXFScCABJvgHRCgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Type casting should be avoided if possible. In case of
work_struct it can be simply replaced by reference to member field.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Reviewed-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_fimc.c    | 2 +-
 drivers/gpu/drm/exynos/exynos_drm_gsc.c     | 3 +--
 drivers/gpu/drm/exynos/exynos_drm_ipp.c     | 6 +++---
 drivers/gpu/drm/exynos/exynos_drm_rotator.c | 3 +--
 4 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimc.c b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
index 177e7bc..34367ff 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
@@ -1309,7 +1309,7 @@ static irqreturn_t fimc_irq_handler(int irq, void *dev_id)
 
 	event_work->ippdrv = ippdrv;
 	event_work->buf_id[EXYNOS_DRM_OPS_DST] = buf_id;
-	queue_work(ippdrv->event_workq, (struct work_struct *)event_work);
+	queue_work(ippdrv->event_workq, &event_work->work);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/gpu/drm/exynos/exynos_drm_gsc.c b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
index 9e3ff16..c6a013f 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_gsc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
@@ -1326,8 +1326,7 @@ static irqreturn_t gsc_irq_handler(int irq, void *dev_id)
 			buf_id[EXYNOS_DRM_OPS_SRC];
 		event_work->buf_id[EXYNOS_DRM_OPS_DST] =
 			buf_id[EXYNOS_DRM_OPS_DST];
-		queue_work(ippdrv->event_workq,
-			(struct work_struct *)event_work);
+		queue_work(ippdrv->event_workq, &event_work->work);
 	}
 
 	return IRQ_HANDLED;
diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index 857817c..fff3509 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -790,7 +790,7 @@ static void ipp_handle_cmd_work(struct device *dev,
 
 	cmd_work->ippdrv = ippdrv;
 	cmd_work->c_node = c_node;
-	queue_work(ctx->cmd_workq, (struct work_struct *)cmd_work);
+	queue_work(ctx->cmd_workq, &cmd_work->work);
 }
 
 static int ipp_queue_buf_with_run(struct device *dev,
@@ -1318,7 +1318,7 @@ err_clear:
 void ipp_sched_cmd(struct work_struct *work)
 {
 	struct drm_exynos_ipp_cmd_work *cmd_work =
-		(struct drm_exynos_ipp_cmd_work *)work;
+		container_of(work, struct drm_exynos_ipp_cmd_work, work);
 	struct exynos_drm_ippdrv *ippdrv;
 	struct drm_exynos_ipp_cmd_node *c_node;
 	struct drm_exynos_ipp_property *property;
@@ -1531,7 +1531,7 @@ err_event_unlock:
 void ipp_sched_event(struct work_struct *work)
 {
 	struct drm_exynos_ipp_event_work *event_work =
-		(struct drm_exynos_ipp_event_work *)work;
+		container_of(work, struct drm_exynos_ipp_event_work, work);
 	struct exynos_drm_ippdrv *ippdrv;
 	struct drm_exynos_ipp_cmd_node *c_node;
 	int ret;
diff --git a/drivers/gpu/drm/exynos/exynos_drm_rotator.c b/drivers/gpu/drm/exynos/exynos_drm_rotator.c
index 55af6b4..b6a37d4 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_rotator.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_rotator.c
@@ -156,8 +156,7 @@ static irqreturn_t rotator_irq_handler(int irq, void *arg)
 		event_work->ippdrv = ippdrv;
 		event_work->buf_id[EXYNOS_DRM_OPS_DST] =
 			rot->cur_buf_id[EXYNOS_DRM_OPS_DST];
-		queue_work(ippdrv->event_workq,
-			(struct work_struct *)event_work);
+		queue_work(ippdrv->event_workq, &event_work->work);
 	} else {
 		DRM_ERROR("the SFR is set illegally\n");
 	}
-- 
1.9.1

