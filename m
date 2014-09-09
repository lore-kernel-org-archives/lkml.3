Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbaIINT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 09:19:28 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:20756 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756395AbaIINRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 09:17:05 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-98-540efdce5fc9
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
Subject: [PATCH 3/9] drm/exynos/fbdev: fix fbdev gem object cleanup
Date: Tue, 09 Sep 2014 15:16:07 +0200
Message-id: <1410268573-2297-4-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410268573-2297-1-git-send-email-a.hajda@samsung.com>
References: <1410268573-2297-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xK7rn/vKFGFzdIWJxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJVxcPpq1oIO9oo3xxpYGhinsHUxcnJICJhIbJv7GsoWk7hwbz2Q
	zcUhJLCUUeLK1r1MEE4fk8Tju2uYQarYBDQl/m6+CdYhIqAssWpfOztIEbPARyaJK0vfgBUJ
	CzhLLFi1ghHEZhFQlXi69DQriM0r4CTxtW0JC8Q6OYmTxyYDxTk4OIHq3/4LAAkLAZUsePuN
	fQIj7wJGhlWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYIWH1ZQfj4mNWhxgFOBiVeHgbMvhC
	hFgTy4orcw8xSnAwK4nwWr8ACvGmJFZWpRblxxeV5qQWH2Jk4uCUamAsaZGyqHyufSrtXm3M
	3WajPZvrWC9PFdiyMS/vUpL9VfUbTd31AhJHWxu7l/KGlib1OT6VYFmVNOuqY9mOv2XXnvt8
	bJBU/fy4aHlq/vTdpbGZAeXa2ZMPPvwj6s+xqrduSUUgVwznvZjsTr8ns0XEJr2s79unoZId
	Os3/xvtFJzKWS5xOOaTEUpyRaKjFXFScCAD2CvL2CQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

exynos_gem_obj is used by exynos_drm_fbdev_destroy so it cannot be destroyed
before calling the latter. exynos_gem_obj will be destroyed anyway by
exynos_drm_fbdev_destroy->...->exynos_drm_fb_destroy.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fbdev.c b/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
index 32e63f6..586e40d 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fbdev.c
@@ -353,9 +353,6 @@ void exynos_drm_fbdev_fini(struct drm_device *dev)
 
 	fbdev = to_exynos_fbdev(private->fb_helper);
 
-	if (fbdev->exynos_gem_obj)
-		exynos_drm_gem_destroy(fbdev->exynos_gem_obj);
-
 	exynos_drm_fbdev_destroy(dev, private->fb_helper);
 	kfree(fbdev);
 	private->fb_helper = NULL;
-- 
1.9.1

