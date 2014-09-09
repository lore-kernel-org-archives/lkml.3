Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbaIINR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 09:17:59 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:34290 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719AbaIINRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 09:17:14 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-ce-540efdd77b00
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
Subject: [PATCH 8/9] drm/exynos/dp: unregister connector on removal
Date: Tue, 09 Sep 2014 15:16:12 +0200
Message-id: <1410268573-2297-9-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410268573-2297-1-git-send-email-a.hajda@samsung.com>
References: <1410268573-2297-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKJMWRmVeSWpSXmKPExsVy+t/xK7rX//KFGGw6pGpxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJVxYM1jloJTHBVrts1lbmDczt7FyMkhIWAiMbXhLzOELSZx4d56
	ti5GLg4hgaWMEmsuP4Vy+pgkLu9eyQpSxSagKfF38002EFtEQFli1b52dpAiZoGPTBJXlr4B
	GyUs4CzRsew9I4jNIqAqsWv1aqYuRg4OXgEniR8XQiG2yUmcPDaZFSTMCVT+9l8ASFgIqGLB
	22/sExh5FzAyrGIUTS1NLihOSs811CtOzC0uzUvXS87P3cQICaovOxgXH7M6xCjAwajEw9uQ
	wRcixJpYVlyZe4hRgoNZSYTX+gVQiDclsbIqtSg/vqg0J7X4ECMTB6dUA2NNvtncWY8StXQ8
	RDomun9fq+iWvWHHcmaGkDPzvkTpxwY3rJTbWvW8edsr1yxmjXY/5eTNttURtzJlDEp5n/x2
	eVvfeEi0aVLbCaaSu5d5Tlpc/eB5lc9l1nqZv9Xe017UbHz51XfZW8vGj47vBabHGKc13rzq
	e+z2RrGVnA63Uz8tkrm8xVSJpTgj0VCLuag4EQA64RCeCAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During component removal driver should unregister connector.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_dp_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_dp_core.c b/drivers/gpu/drm/exynos/exynos_dp_core.c
index 4f3c7eb..32716c0 100644
--- a/drivers/gpu/drm/exynos/exynos_dp_core.c
+++ b/drivers/gpu/drm/exynos/exynos_dp_core.c
@@ -937,6 +937,8 @@ static enum drm_connector_status exynos_dp_detect(
 
 static void exynos_dp_connector_destroy(struct drm_connector *connector)
 {
+	drm_connector_unregister(connector);
+	drm_connector_cleanup(connector);
 }
 
 static struct drm_connector_funcs exynos_dp_connector_funcs = {
@@ -1358,8 +1360,8 @@ static void exynos_dp_unbind(struct device *dev, struct device *master,
 
 	exynos_dp_dpms(display, DRM_MODE_DPMS_OFF);
 
+	exynos_dp_connector_destroy(&dp->connector);
 	encoder->funcs->destroy(encoder);
-	drm_connector_cleanup(&dp->connector);
 }
 
 static const struct component_ops exynos_dp_ops = {
-- 
1.9.1

