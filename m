Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbaIINRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 09:17:15 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:20770 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244AbaIINRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 09:17:11 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-29-540efdd5155e
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
Subject: [PATCH 7/9] drm/exynos/dpi: unregister connector and panel on removal
Date: Tue, 09 Sep 2014 15:16:11 +0200
Message-id: <1410268573-2297-8-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410268573-2297-1-git-send-email-a.hajda@samsung.com>
References: <1410268573-2297-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKJMWRmVeSWpSXmKPExsVy+t/xK7pX//KFGEyaYW1xa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJWx4/1EtoL57BV3V3xjbWBcztbFyMkhIWAisathJZQtJnHh3now
	W0hgKaPEt4VaXYxcQHYfk8SBXc3sIAk2AU2Jv5tvghWJCChLrNrXzg5SxCzwkUniytI3zCAJ
	YQE/iVdHp7OC2CwCqhKXFu1jArF5BZwkDs6dzgKxTU7i5LHJQDUcHJwCzhJv/wVALHaSWPD2
	G/sERt4FjAyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MUKC6usOxqXHrA4xCnAwKvHwTizj
	CxFiTSwrrsw9xCjBwawkwmv9AijEm5JYWZValB9fVJqTWnyIkYmDU6qBceaGOUeOt5fkuNrs
	Mkp0tFwwvVEroPv/Ej+1p5YSO1f4neG478SSJSGyRWjLyhPLe77OXFmmb/ltW03Pw0+Bt12T
	l2rl32Re8rb28UJ2o4KA9YcVnjv2Pu6UW8jT+H+aY0nHimDd49Xap/IcrC8VFczYIiUeueIF
	j0nkWbuf3r58s3dqFiv+UmIpzkg01GIuKk4EAD7FMJYIAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During component removal it should unregister connector
and optionally detach the panel.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_dpi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_dpi.c b/drivers/gpu/drm/exynos/exynos_drm_dpi.c
index fa08f05..96c87db 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dpi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dpi.c
@@ -342,8 +342,12 @@ int exynos_dpi_remove(struct device *dev)
 	struct exynos_dpi *ctx = exynos_dpi_display.ctx;
 
 	exynos_dpi_dpms(&exynos_dpi_display, DRM_MODE_DPMS_OFF);
+
+	exynos_dpi_connector_destroy(&ctx->connector);
 	encoder->funcs->destroy(encoder);
-	drm_connector_cleanup(&ctx->connector);
+
+	if (ctx->panel)
+		drm_panel_detach(ctx->panel);
 
 	exynos_drm_component_del(dev, EXYNOS_DEVICE_TYPE_CONNECTOR);
 
-- 
1.9.1

