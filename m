Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbaHVHxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 03:53:32 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:49131 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945AbaHVHx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 03:53:29 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-96-53f6f6f6cf3a
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
Subject: [PATCH 02/15] drm/exynos/ipp: cancel works before command node clean
Date: Fri, 22 Aug 2014 09:52:13 +0200
Message-id: <1408693946-15456-3-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
References: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJMWRmVeSWpSXmKPExsVy+t/xq7rfvn0LNui5IWlxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJVx6sRitoLFbBUXX1xmbGDcxNrFyMkhIWAica1rFjuELSZx4d56
	ti5GLg4hgaWMEocXnmeBcPqYJC5s+MgGUsUmoCnxd/NNMFtEQFli1b52dpAiZoGPTBJXlr5h
	BkkIC/hKrNzzFKyIRUBVou3aZbAVvALOEvduXWSDWCcncfLYZLAzOAVcJC4cnAbWKwRU03V7
	GtMERt4FjAyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MUIC6+sOxqXHrA4xCnAwKvHwRn75
	GizEmlhWXJl7iFGCg1lJhHfTvG/BQrwpiZVVqUX58UWlOanFhxiZODilGhjdmJ9u6prw5+yq
	P4UvfN4ESjkyP+AVZvv/Z5un++Rb9d9Tupc6WdcaO8RayTbmmedY1H6x+LXlx/XJLaXK+ZvC
	/4fsz3676obk2Xc53/WX7rE6U/hZOPPciaeFCrOfTNVenFG8kT1cb9M862uH8u9c4/aPDe26
	u1xitpumedhpBYeprwz5BFWVWIozEg21mIuKEwF6TUuQCgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All pending works should be canceled prior to its removal.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
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

