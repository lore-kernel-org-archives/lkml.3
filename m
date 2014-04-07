Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973AbaDGIWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 04:22:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56250 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941AbaDGIWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 04:22:51 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] imx-drm: imx-drm-core: Fix imx_drm_encoder_get_mux_id
Date: Mon,  7 Apr 2014 10:22:36 +0200
Message-Id: <1396858956-7096-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.9.1
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The decoder mux id is equal to the port id of the encoder's input port
that is connected to the given crtc, not to the endpoint id (which is
arbitrary and usually zero).

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/imx-drm/imx-drm-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/imx-drm/imx-drm-core.c b/drivers/staging/imx-drm/imx-drm-core.c
index 4144a75..bc7f8bd 100644
--- a/drivers/staging/imx-drm/imx-drm-core.c
+++ b/drivers/staging/imx-drm/imx-drm-core.c
@@ -517,7 +517,7 @@ int imx_drm_encoder_get_mux_id(struct device_node *node,
 		of_node_put(port);
 		if (port == imx_crtc->port) {
 			ret = of_graph_parse_endpoint(ep, &endpoint);
-			return ret ? ret : endpoint.id;
+			return ret ? ret : endpoint.port;
 		}
 	} while (ep);
 
-- 
1.9.1

