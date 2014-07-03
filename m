Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206AbaGCNK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:10:58 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:55334 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbaGCNKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:10:55 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-5d-53b5565ce864
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
Subject: [PATCH 01/12] drm/exynos/ipp: remove type casting
Date: Thu, 03 Jul 2014 15:10:26 +0200
Message-id: <1404393037-17299-2-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1404393037-17299-1-git-send-email-a.hajda@samsung.com>
References: <1404393037-17299-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKJMWRmVeSWpSXmKPExsVy+t/xK7oxYVuDDQ4c5LW4te4cq8WVr+/Z
	LCbdn8Bi8eLeRRaLs01v2C0u75rDZjHj/D4mi7VH7rJbzJj8ks2B0+N+93Emj74tqxg9Pm+S
	C2CO4rJJSc3JLEst0rdL4MpY+m0vU8Fd1orDT+IbGH+wdDFyckgImEjs/XqHCcIWk7hwbz0b
	iC0ksJRRYvtH9S5GLiC7j0ni3Nx/YEVsApoSfzffBCsSEVCWWLWvnR2kiFngI5PElaVvmEES
	wgJWEi9ebwfbwCKgKtH/dC8jiM0r4CyxY+o1VohtchInj00GszkFXCQOzVzKCLHZWWLtkrls
	Exh5FzAyrGIUTS1NLihOSs811CtOzC0uzUvXS87P3cQICaovOxgXH7M6xCjAwajEw9u4YkOw
	EGtiWXFl7iFGCQ5mJRHeiuCtwUK8KYmVValF+fFFpTmpxYcYmTg4pRoY4zMXWIrozZnp1vBy
	v9NER54y8yOW3fsOek687JfTW3M9PvELh5FQV1+mIMu/RPOnP1nyNCWuRu9XtDKeN3XX54l7
	5wV25Zv+lzFoZhN/OOXpXck9W1N+Ch1uSvykYPXU3OnJuydZkdf/yuXM386ucMh/1fwmlrkL
	Ti9ZHCTIVm8esuBSqmWTEktxRqKhFnNRcSIAMCJnnAgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch replaces type casting with proper pointer.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_ipp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_ipp.c b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
index a1888e1..f3f114c 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_ipp.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_ipp.c
@@ -432,7 +432,7 @@ static struct drm_exynos_ipp_event_work *ipp_create_event_work(void)
 	if (!event_work)
 		return ERR_PTR(-ENOMEM);
 
-	INIT_WORK((struct work_struct *)event_work, ipp_sched_event);
+	INIT_WORK(&event_work->work, ipp_sched_event);
 
 	return event_work;
 }
-- 
1.9.1

