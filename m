Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbaIINRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 09:17:35 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:34290 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741AbaIINRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 09:17:15 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-d6-540efdd9ca90
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
Subject: [PATCH 9/9] drm/exynos/hdmi: unregister connector on removal
Date: Tue, 09 Sep 2014 15:16:13 +0200
Message-id: <1410268573-2297-10-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410268573-2297-1-git-send-email-a.hajda@samsung.com>
References: <1410268573-2297-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMJMWRmVeSWpSXmKPExsVy+t/xK7o3//KFGMz8Jmlxa905VosrX9+z
	WUy6P4HF4sW9iywWZ5vesFtc3jWHzWLG+X1MFmuP3GW3mDH5JZsDp8f97uNMHn1bVjF6fN4k
	F8AcxWWTkpqTWZZapG+XwJXRf12ooIuzYtG7uWwNjK/Zuxg5OCQETCQuHzXtYuQEMsUkLtxb
	z9bFyMUhJLCUUaJ5xXdWkISQQB+TxMITtiA2m4CmxN/NN9lAbBEBZYlV+9rZQRqYBT4ySVxZ
	+oYZJCEs4Crxr2UlWDOLgKrEipd3WUBsXgFniUkHDjBDbJOTOHlsMivIEZxA8bf/AiB2OUks
	ePuNfQIj7wJGhlWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYIQH1ZQfj4mNWhxgFOBiVeHgb
	MvhChFgTy4orcw8xSnAwK4nwWr8ACvGmJFZWpRblxxeV5qQWH2Jk4uCUamBkDjjtwXjQ9tJN
	8RWSj/izOaOj+8QYGr9N2qT4aQOTKkvZhFlTvW6fcWXnbd0yR/KuX/uMKQHZ+y7Oeddh32sn
	Hhww80XobfW2TfoebIwnVFZLaO5dzudmsqJH7alESu6ncLnlprvak5ibzkkaJfud8nKv6Lc8
	LOV/gKNP+Ej6jvWX4j9e6ldiKc5INNRiLipOBABJH0rIBgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During component removal driver should unregister connector.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_hdmi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index 562966d..7910fb3 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -1040,6 +1040,8 @@ static enum drm_connector_status hdmi_detect(struct drm_connector *connector,
 
 static void hdmi_connector_destroy(struct drm_connector *connector)
 {
+	drm_connector_unregister(connector);
+	drm_connector_cleanup(connector);
 }
 
 static struct drm_connector_funcs hdmi_connector_funcs = {
@@ -2314,8 +2316,8 @@ static void hdmi_unbind(struct device *dev, struct device *master, void *data)
 	struct drm_encoder *encoder = display->encoder;
 	struct hdmi_context *hdata = display->ctx;
 
+	hdmi_connector_destroy(&hdata->connector);
 	encoder->funcs->destroy(encoder);
-	drm_connector_cleanup(&hdata->connector);
 }
 
 static const struct component_ops hdmi_component_ops = {
-- 
1.9.1

