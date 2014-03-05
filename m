Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbaCEJVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 04:21:09 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53735 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbaCEJVA (ORCPT
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
Subject: [PATCH v6 4/8] of: Reduce indentation in of_graph_get_next_endpoint
Date: Wed,  5 Mar 2014 10:20:38 +0100
Message-Id: <1394011242-16783-5-git-send-email-p.zabel@pengutronix.de>
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

A 'return endpoint;' at the end of the (!prev) case allows to
reduce the indentation level of the (prev) case.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/of/base.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index b5e690b..a8e47d3 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -2026,32 +2026,34 @@ struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
 			pr_err("%s(): no endpoint nodes specified for %s\n",
 			       __func__, parent->full_name);
 		of_node_put(node);
-	} else {
-		port = of_get_parent(prev);
-		if (WARN_ONCE(!port, "%s(): endpoint %s has no parent node\n",
-			      __func__, prev->full_name))
-			return NULL;
 
-		/* Avoid dropping prev node refcount to 0. */
-		of_node_get(prev);
-		endpoint = of_get_next_child(port, prev);
-		if (endpoint) {
-			of_node_put(port);
-			return endpoint;
-		}
+		return endpoint;
+	}
 
-		/* No more endpoints under this port, try the next one. */
-		do {
-			port = of_get_next_child(parent, port);
-			if (!port)
-				return NULL;
-		} while (of_node_cmp(port->name, "port"));
+	port = of_get_parent(prev);
+	if (WARN_ONCE(!port, "%s(): endpoint %s has no parent node\n",
+		      __func__, prev->full_name))
+		return NULL;
 
-		/* Pick up the first endpoint in this port. */
-		endpoint = of_get_next_child(port, NULL);
+	/* Avoid dropping prev node refcount to 0. */
+	of_node_get(prev);
+	endpoint = of_get_next_child(port, prev);
+	if (endpoint) {
 		of_node_put(port);
+		return endpoint;
 	}
 
+	/* No more endpoints under this port, try the next one. */
+	do {
+		port = of_get_next_child(parent, port);
+		if (!port)
+			return NULL;
+	} while (of_node_cmp(port->name, "port"));
+
+	/* Pick up the first endpoint in this port. */
+	endpoint = of_get_next_child(port, NULL);
+	of_node_put(port);
+
 	return endpoint;
 }
 EXPORT_SYMBOL(of_graph_get_next_endpoint);
-- 
1.9.0.rc3

