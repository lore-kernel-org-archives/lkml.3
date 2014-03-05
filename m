Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbaCEJ0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 04:26:31 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53738 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbaCEJVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 04:21:00 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Grant Likely <grant.likely@linaro.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Rob Herring <robh+dt@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v6 3/8] of: Warn if of_graph_get_next_endpoint is called with the root node
Date: Wed,  5 Mar 2014 10:20:37 +0100
Message-Id: <1394011242-16783-4-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.9.0.rc3
In-Reply-To: <1394011242-16783-1-git-send-email-p.zabel@pengutronix.de>
References: <1394011242-16783-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.120
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If of_graph_get_next_endpoint is given a parentless node instead of an
endpoint node, it is clearly a bug.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v5:
 - Added parentless previous endpoint's full name to warning
---
 drivers/of/base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index b2f223f..b5e690b 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -2028,8 +2028,8 @@ struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
 		of_node_put(node);
 	} else {
 		port = of_get_parent(prev);
-		if (!port)
-			/* Hm, has someone given us the root node ?... */
+		if (WARN_ONCE(!port, "%s(): endpoint %s has no parent node\n",
+			      __func__, prev->full_name))
 			return NULL;
 
 		/* Avoid dropping prev node refcount to 0. */
-- 
1.9.0.rc3

