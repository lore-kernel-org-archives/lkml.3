Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbaEZISv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 04:18:51 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:37360 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbaEZISs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 04:18:48 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-17-5382f8c99724
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
Subject: [PATCH 2/9] drm/exynos: ipp: remove duplicated setting
Date: Mon, 26 May 2014 10:17:16 +0200
Message-id: <1401092243-25568-3-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401092243-25568-1-git-send-email-a.hajda@samsung.com>
References: <1401092243-25568-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKJMWRmVeSWpSXmKPExsVy+t/xa7onfzQFG7Qu0be48vU9m8Wk+xNY
	LF7cu8hicbbpDbvF5V1z2CxmnN/HZLH2yF12ixmTX7JZ7N05mdGB0+N+93Emj74tqxg9Pm+S
	C2CO4rJJSc3JLEst0rdL4Mq4P+cBe8F5joqbJ4+zNzCuY+9i5OSQEDCReH5zMTOELSZx4d56
	ti5GLg4hgaWMEi8edbJAOH1MEof+n2QEqWIT0JT4u/kmG4gtIqAs8XfiKkaQImaBj0wSLd8/
	AI3l4BAWsJdY+K4CpIZFQFXix94LrCA2r4CzxN1Dl6C2yUmcPDYZLM4p4CLx+uNKJpBWIaCa
	39/5JzDyLmBkWMUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kRElRfdjAuPmZ1iFGAg1GJh/dE
	UFOwEGtiWXFl7iFGCQ5mJRHe5g9AId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYyLEgud5s2r3MR3
	/cG0bzrzJO0SmaxnS0dG+3zh605RPJiyqCvOKDuMY+0DD6t1WjuDI78YXvi20S/Q5+rBOy8Y
	3nen/O/KnPXHntluVvKPkqOTFXj5Lx37eMVj0cRtn8PtHES7NeoO1FrxLM/NNpIWuS21Lbwo
	dt2dbss5L02UFl7a6Pptx18lluKMREMt5qLiRADLfRrbCAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: YoungJun Cho <yj44.cho@samsung.com>

This patch removes duplicated setting.

Signed-off-by: YoungJun Cho <yj44.cho@samsung.com>
Acked-by: Seong-Woo Kim <sw0312.cho@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Tested-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index c8cfa24..0968777 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -1090,12 +1090,12 @@ int exynos_drm_ipp_cmd_ctrl(struct drm_device *drm_dev, void *data,
 	case IPP_CTRL_PLAY:
 		if (pm_runtime_suspended(ippdrv->dev))
 			pm_runtime_get_sync(ippdrv->dev);
+
 		c_node->state = IPP_STATE_START;
 
 		cmd_work = c_node->start_work;
 		cmd_work->ctrl = cmd_ctrl->ctrl;
 		ipp_handle_cmd_work(dev, ippdrv, cmd_work, c_node);
-		c_node->state = IPP_STATE_START;
 		break;
 	case IPP_CTRL_STOP:
 		cmd_work = c_node->stop_work;
-- 
1.9.1

