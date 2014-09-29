Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaI2IQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 04:16:43 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48345 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbaI2IQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 04:16:38 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v4 6/8] drm: use for_each_endpoint_of_node macro in drm_of_find_possible_crtcs
Date: Mon, 29 Sep 2014 10:15:49 +0200
Message-Id: <1411978551-30480-7-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1411978551-30480-1-git-send-email-p.zabel@pengutronix.de>
References: <1411978551-30480-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.120
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the for_each_... macro should make the code a bit shorter and
easier to read.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/gpu/drm/drm_of.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/drm_of.c b/drivers/gpu/drm/drm_of.c
index 16150a0..024fa77 100644
--- a/drivers/gpu/drm/drm_of.c
+++ b/drivers/gpu/drm/drm_of.c
@@ -46,11 +46,7 @@ uint32_t drm_of_find_possible_crtcs(struct drm_device *dev,
 	struct device_node *remote_port, *ep = NULL;
 	uint32_t possible_crtcs = 0;
 
-	do {
-		ep = of_graph_get_next_endpoint(port, ep);
-		if (!ep)
-			break;
-
+	for_each_endpoint_of_node(port, ep) {
 		remote_port = of_graph_get_remote_port(ep);
 		if (!remote_port) {
 			of_node_put(ep);
@@ -60,7 +56,7 @@ uint32_t drm_of_find_possible_crtcs(struct drm_device *dev,
 		possible_crtcs |= drm_crtc_port_mask(dev, remote_port);
 
 		of_node_put(remote_port);
-	} while (1);
+	}
 
 	return possible_crtcs;
 }
-- 
2.1.0

