Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbaJGMBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:01:38 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:25365 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbaJGMBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:01:34 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-28-5433d61cd9ee
From: Andrzej Hajda <a.hajda@samsung.com>
To: Inki Dae <inki.dae@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR E...),
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 3/4] drm/exynos/dsi: remove redundant encoder field
Date: Tue, 07 Oct 2014 14:01:10 +0200
Message-id: <1412683271-15835-4-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1412683271-15835-1-git-send-email-a.hajda@samsung.com>
References: <1412683271-15835-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDJMWRmVeSWpSXmKPExsVy+t/xK7oy14xDDF5c5rO4te4cq8WVr+/Z
	LCbdn8Bi8eLeRRaL3gVX2SzONr1ht7i8aw6bxYzz+5gs1h65y24xY/JLNgcuj/vdx5k8+ras
	YvT4vEkugDmKyyYlNSezLLVI3y6BK+PRiy7Ggn28FZ/65rI3MO7g7mLk5JAQMJGY9nAiI4Qt
	JnHh3nq2LkYuDiGBpYwSz76uZ4Rw+pgktn09BlbFJqAp8XfzTTYQW0RAWWLVvnZ2kCJmgR3M
	EkcvHWUCSQgLOEtsOPueBcRmEVCV2HJtMyuIzQsU33VpNgvEOjmJk8cmg8U5BVwk5m14BTZU
	CKhm8umtTBMYeRcwMqxiFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECAmxLzsYFx+zOsQowMGo
	xMO7wdA4RIg1say4MvcQowQHs5II7+mLQCHelMTKqtSi/Pii0pzU4kOMTBycUg2Mru8Ys/uf
	TVcxc9NOuNvj/mHx4Zmdq4onsfnZrq+PmfovWPimpPqv6ctz7HfYXrgpsUUmqbt867XXCbpX
	go0ZTVdI+nmdXLlZ1nRXo5X+InvF9bt41m21Pno3dtaGC1OCjm2yq1E2Op2cu6i4eabWxM/r
	DJh2qTW47/q4XeT050DjUt2KPd+OKbEUZyQaajEXFScCAFMZVyAPAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch removes redundant encoder field from private DSI context.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_dsi.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_dsi.c b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
index 39ec450..634904a 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dsi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
@@ -271,7 +271,6 @@ struct exynos_dsi {
 	struct exynos_drm_display display;
 	struct mipi_dsi_host dsi_host;
 	struct drm_connector connector;
-	struct drm_encoder *encoder;
 	struct device_node *panel_node;
 	struct drm_panel *panel;
 	struct device *dev;
@@ -1105,7 +1104,7 @@ static irqreturn_t exynos_dsi_irq(int irq, void *dev_id)
 static irqreturn_t exynos_dsi_te_irq_handler(int irq, void *dev_id)
 {
 	struct exynos_dsi *dsi = (struct exynos_dsi *)dev_id;
-	struct drm_encoder *encoder = dsi->encoder;
+	struct drm_encoder *encoder = dsi->display.encoder;
 
 	if (dsi->state & DSIM_STATE_ENABLED)
 		exynos_drm_crtc_te_handler(encoder->crtc);
@@ -1475,7 +1474,7 @@ exynos_dsi_best_encoder(struct drm_connector *connector)
 {
 	struct exynos_dsi *dsi = connector_to_dsi(connector);
 
-	return dsi->encoder;
+	return dsi->display.encoder;
 }
 
 static struct drm_connector_helper_funcs exynos_dsi_connector_helper_funcs = {
@@ -1491,8 +1490,6 @@ static int exynos_dsi_create_connector(struct exynos_drm_display *display,
 	struct drm_connector *connector = &dsi->connector;
 	int ret;
 
-	dsi->encoder = encoder;
-
 	connector->polled = DRM_CONNECTOR_POLL_HPD;
 
 	ret = drm_connector_init(encoder->dev, connector,
-- 
1.9.1

