Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbaHVHxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 03:53:51 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:34681 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102AbaHVHxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 03:53:48 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-64-53f6f70a6618
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
Subject: [PATCH 12/15] drm/exynos/fimc: avoid clearing overflow bits
Date: Fri, 22 Aug 2014 09:52:23 +0200
Message-id: <1408693946-15456-13-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
References: <1408693946-15456-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKJMWRmVeSWpSXmKPExsVy+t/xq7pc378FG6x7p2Rxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJXx4cs9toI7bBXnj89kb2B8wNrFyMEhIWAi8f+eeBcjJ5ApJnHh
	3nq2LkYuDiGBpYwSl28tZ4Jw+pgkfj3bzwxSxSagKfF38002EFtEQFli1b52dpAiZoGPTBJX
	lr4BKxIWcJG4fWIJWBGLgKrE1bOr2EC28QLFO55kQGyTkzh5bDIriM0JFL5wcBpYq5CAs0TX
	7WlMExh5FzAyrGIUTS1NLihOSs811CtOzC0uzUvXS87P3cQICaovOxgXH7M6xCjAwajEw5v4
	+2uwEGtiWXFl7iFGCQ5mJRHeTfO+BQvxpiRWVqUW5ccXleakFh9iZOLglGpgtF0z4/UdZ4Z5
	ZxqXzqv48H/2DzFupg0zPMJ8lu3h6RHVYBGM+tGvvSulJcHPzUAzcOLThAXHDqn1X7glyRtU
	EV29M0iubtOk5UqWgpo5kofz7DoeyC4Nyl7PfNBvnpGietDqGS7vXpvd2+f8QqxIp/98XqVL
	oGCFGeeVgwHqei8mMAT9W+qjxFKckWioxVxUnAgA58BKawgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Overflow bits shall be cleared by H/W.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_fimc.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimc.c b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
index 3264ed3..bbaf4f9 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimc.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimc.c
@@ -341,9 +341,6 @@ static bool fimc_check_ovf(struct fimc_context *ctx)
 		fimc_set_bits(ctx, EXYNOS_CIWDOFST,
 			EXYNOS_CIWDOFST_CLROVFIY | EXYNOS_CIWDOFST_CLROVFICB |
 			EXYNOS_CIWDOFST_CLROVFICR);
-		fimc_clear_bits(ctx, EXYNOS_CIWDOFST,
-			EXYNOS_CIWDOFST_CLROVFIY | EXYNOS_CIWDOFST_CLROVFICB |
-			EXYNOS_CIWDOFST_CLROVFICR);
 
 		dev_err(ippdrv->dev, "occurred overflow at %d, status 0x%x.\n",
 			ctx->id, status);
-- 
1.9.1

