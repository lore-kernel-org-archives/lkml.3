Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbaHVH4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 03:56:12 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:49659 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995AbaHVHxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 03:53:43 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-50-53f6f7059681
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
Subject: [PATCH 09/15] drm/exynos/ipp: replace work_struct casting with better
 constructs
Date: Fri, 22 Aug 2014 09:52:20 +0200
Message-id: <1408693946-15456-10-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
References: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKJMWRmVeSWpSXmKPExsVy+t/xq7qs378FG7x7pWBxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJWxa5lDQYd0xc5fjewNjFvFuxg5OSQETCQuztrDDmGLSVy4t56t
	i5GLQ0hgKaNE544PTBBOH5PEr3e7mUCq2AQ0Jf5uvskGYosIKEus2tfODlLELPCRSeLK0jfM
	IAlhgWiJrWu2MILYLAKqEs9nNwI1c3DwCrhITDyoALFNTuLkscmsIDYnUPjCwWlgrUICzhJd
	t6cxTWDkXcDIsIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJKi+7GBcfMzqEKMAB6MSD2/i
	76/BQqyJZcWVuYcYJTiYlUR4N837FizEm5JYWZValB9fVJqTWnyIkYmDU6qBUb+h0yrNbENS
	mPSXcvO7X9yVZ2UvX3Xv56+k0KSsQnNPH5f01gOJQUecuxXq3N0+MGyxazspxKe36nK2ZMrD
	rZsl5A/EPmO4+/Jz/0ufxs/nxI6v7Li5kX+ThU/EpKfsPx49Me2rN1+0X3L/1deiL2Ylsx+q
	18qdoHW+5Jr5lzD2l3emcl/3U2Ipzkg01GIuKk4EAEV2Kf0IAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Type casting should be avoided if possible. In case of
work_struct it can be simply replaced by reference to member field.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_fimc.c    | 2 +-
 drivers/gpu/drm/exynos/exynos_drm_gsc.c     | 3 +--
 drivers/gpu/drm/exynos/exynos_drm_ipp.c     | 6 +++---
 drivers/gpu/drm/exynos/exynos_drm_rotator.c | 3 +--
 4 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimc.c b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
index 35db665..3264ed3 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
@@ -1307,7 +1307,7 @@ static irqreturn_t fimc_irq_handler(int irq, void *dev_id)
 
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
index 6ab6190..c72d8d1 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -791,7 +791,7 @@ static void ipp_handle_cmd_work(struct device *dev,
 
 	cmd_work->ippdrv = ippdrv;
 	cmd_work->c_node = c_node;
-	queue_work(ctx->cmd_workq, (struct work_struct *)cmd_work);
+	queue_work(ctx->cmd_workq, &cmd_work->work);
 }
 
 static int ipp_queue_buf_with_run(struct device *dev,
@@ -1319,7 +1319,7 @@ err_clear:
 void ipp_sched_cmd(struct work_struct *work)
 {
 	struct drm_exynos_ipp_cmd_work *cmd_work =
-		(struct drm_exynos_ipp_cmd_work *)work;
+		container_of(work, struct drm_exynos_ipp_cmd_work, work);
 	struct exynos_drm_ippdrv *ippdrv;
 	struct drm_exynos_ipp_cmd_node *c_node;
 	struct drm_exynos_ipp_property *property;
@@ -1532,7 +1532,7 @@ err_event_unlock:
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

