Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965826AbaH1JJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:09:59 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54144 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965698AbaH1JI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:08:29 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-e2-53fef18b2cc7
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
Subject: [PATCH v2 13/17] drm/exynos/fimc: do not enable fimc twice
Date: Thu, 28 Aug 2014 11:07:37 +0200
Message-id: <1409216861-12452-14-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
References: <1409216861-12452-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCJMWRmVeSWpSXmKPExsVy+t/xy7rdH/8FG6zZL25xa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJWxt+U3c8FXtopVc38wNzB+Zu1i5OSQEDCRWN5xkRHCFpO4cG89
	WxcjF4eQwFJGiQsnv7GAJIQE+pgk1r72BLHZBDQl/m6+yQZiiwgoS6za184O0sAs8JFJ4srS
	N8wgCWEBZ4lr+3YygdgsAqoSz+acA9rGzsEr4CLxoBZil5zEyWOTwW7gBIpuPP6GHWKVs8Tu
	85+ZJjDyLmBkWMUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kRElJfdzAuPWZ1iFGAg1GJh1fh
	9J9gIdbEsuLK3EOMEhzMSiK8R4//CxbiTUmsrEotyo8vKs1JLT7EyMTBKdXAWMtof/6CXebn
	JRxHs8K/WchktTRPKFl4RtZjjqou/5yINaJTX627XmfWJ1LBJs93NvSUUfo0kf5OxZnqDXMv
	77nIe60hr+v7JXZx64ad224dZK19HMj4klHI6mnCjfRVe39s6o9silaJcp2/7l669fPUqTUF
	q3q52JfwXOft13X8f9eyRcNQiaU4I9FQi7moOBEAaUtr/gcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch removes redundant H/W activation.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Reviewed-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_fimc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimc.c b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
index 6dc9c41..62ba033 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
@@ -1598,12 +1598,9 @@ static int fimc_ippdrv_start(struct device *dev, enum drm_exynos_ipp_cmd cmd)
 
 	fimc_clear_bits(ctx, EXYNOS_CIOCTRL, EXYNOS_CIOCTRL_WEAVE_MASK);
 
-	if (cmd == IPP_CMD_M2M) {
+	if (cmd == IPP_CMD_M2M)
 		fimc_set_bits(ctx, EXYNOS_MSCTRL, EXYNOS_MSCTRL_ENVID);
 
-		fimc_set_bits(ctx, EXYNOS_MSCTRL, EXYNOS_MSCTRL_ENVID);
-	}
-
 	return 0;
 }
 
-- 
1.9.1

