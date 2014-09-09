Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382AbaIINSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 09:18:52 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38633 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434AbaIINRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 09:17:05 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-a1-540efdd0cd1e
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
Subject: [PATCH 4/9] drm/exynos/fb: free exynos framebuffer on error
Date: Tue, 09 Sep 2014 15:16:08 +0200
Message-id: <1410268573-2297-5-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410268573-2297-1-git-send-email-a.hajda@samsung.com>
References: <1410268573-2297-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xK7oX/vKFGGz/zWdxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJVx+vxLpoLbrBWTbu5nbGD8wNLFyMkhIWAiMX3zBTYIW0ziwr31
	QDYXh5DAUkaJaYfaoJw+Jom9p5YzgVSxCWhK/N18E6xDREBZYtW+dnaQImaBj0wSV5a+YQZJ
	CAu4SMy+fx6sgUVAVaKr6x9YnFfASeLTm09Q6+QkTh6bzNrFyMHBKeAs8fZfAEhYCKhkwdtv
	7BMYeRcwMqxiFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECAmrLzsYFx+zOsQowMGoxMPbkMEX
	IsSaWFZcmXuIUYKDWUmE1/oFUIg3JbGyKrUoP76oNCe1+BAjEwenVANjhfuRY62aqQuE7lQ3
	JOt4uZ/6+bH0lD3brJ96q4QD75dmbD4lOLMqN3BD8x1z98QJ7HUbZjZ9PT7rgkKgk1jJ+ea1
	HzVLk+q0zXZvyNacdlmsNv+w4K+891v7Ew+cUn6mlPuwxnpSylV3hedTLA8dm7b6YUOx4YKd
	aRM/CJRN7RY/IfOD50qUEktxRqKhFnNRcSIAkc78rAkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case drm_framebuffer_init fails exynos_fb should be freed
before returning an error.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_fb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fb.c b/drivers/gpu/drm/exynos/exynos_drm_fb.c
index 65a22ca..d346d1e 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fb.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fb.c
@@ -165,6 +165,7 @@ exynos_drm_framebuffer_init(struct drm_device *dev,
 
 	ret = drm_framebuffer_init(dev, &exynos_fb->fb, &exynos_drm_fb_funcs);
 	if (ret) {
+		kfree(exynos_fb);
 		DRM_ERROR("failed to initialize framebuffer\n");
 		return ERR_PTR(ret);
 	}
-- 
1.9.1

