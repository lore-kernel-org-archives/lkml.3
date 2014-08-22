Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbaHVHyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 03:54:45 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:33021 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111AbaHVHxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 03:53:50 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-70-53f6f70ca783
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
Subject: [PATCH 13/15] drm/exynos/fimc: do not enable fimc twice
Date: Fri, 22 Aug 2014 09:52:24 +0200
Message-id: <1408693946-15456-14-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
References: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xq7o8378FG0x9Z2hxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJVx4NYZpoJ9bBWzlmU2MB5k7WLk5JAQMJHYu/4IM4QtJnHh3nq2
	LkYuDiGBpYwSy2c8ZYdw+pgk+n68AOtgE9CU+Lv5JhuILSKgLLFqXztYEbPARyaJK0vfgI0S
	FnCQ+PpiMjuIzSKgKrFy5jqwBl4BF4mHlxYyQqyTkzh5bDLYUE6g+IWD08B6hQScJbpuT2Oa
	wMi7gJFhFaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZIWH3Zwbj4mNUhRgEORiUe3sTfX4OF
	WBPLiitzDzFKcDArifBumvctWIg3JbGyKrUoP76oNCe1+BAjEwenVAPjnLj40vePHsiduGPu
	kSP1lyE9W0hnw9binb85j6zuFWo8JZm/3cPwz9b9axfc8162+dK+y7eVzHisrr8ptrxy/7VA
	ZvzL3DZle4Ff1hUf7k942Hhzo/QWbe8Av5MZgj/+eAQUPtjF+Ir1ixZL8IvTC7gKraaEXTI7
	2/bttdpcttLpu9cdLNu8TImlOCPRUIu5qDgRAEDQWpAJAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch removes redundant H/W activation.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_fimc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimc.c b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
index bbaf4f9..bd6628d 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
@@ -1596,12 +1596,9 @@ static int fimc_ippdrv_start(struct device *dev, enum drm_exynos_ipp_cmd cmd)
 
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

