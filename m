Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbaHVHxo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 03:53:44 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:34664 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062AbaHVHxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 03:53:41 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-4b-53f6f703182a
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
Subject: [PATCH 08/15] drm/exynos/ipp: clean memory nodes on command node
 cleaning
Date: Fri, 22 Aug 2014 09:52:19 +0200
Message-id: <1408693946-15456-9-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
References: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKJMWRmVeSWpSXmKPExsVy+t/xq7rM378FG9w+YmFxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJUxbfcPloIt7BWnJu9nbWBcxdbFyMkhIWAicWvCNlYIW0ziwr31
	YHEhgaWMEg8nM0HYfUwS519Eg9hsApoSfzffBKsREVCWWLWvnb2LkYuDWeAjk8SVpW+YQRLC
	AiESM/rbwJpZBFQl7j3+BRbnFXCWuLT5EhPEMjmJk8cmgy3mFHCRuHBwGjPEMmeJrtvTmCYw
	8i5gZFjFKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERJUX3YwLj5mdYhRgINRiYc38ffXYCHW
	xLLiytxDjBIczEoivJvmfQsW4k1JrKxKLcqPLyrNSS0+xMjEwSnVwNi+sTpBtufHlw2x+VrP
	d59a8G6PXY1KsP7GUNlQz2/PvjZdZfO7kOvc9I+bz7+Wg7esJWZP580JGrcrtRM+W/tFrZ/V
	toJXJfl721rfhTe2q5p//LXLfVLs7fcn5e3/H5oTqBrtbW7O3NzKdeTJWsOWfV5Xjn/K5/c7
	wtSzlUWn0evhp5qsECWW4oxEQy3mouJEAH3S8IoIAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nodes should be removed before removing command node.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index 22bd551..6ab6190 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -604,11 +604,16 @@ static void ipp_clean_mem_nodes(struct drm_device *drm_dev,
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

