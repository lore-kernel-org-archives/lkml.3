Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbaIKPeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:34:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55955 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630AbaIKPdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:33:25 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3 4/8] of: Add for_each_endpoint_of_node helper macro
Date: Thu, 11 Sep 2014 17:33:03 +0200
Message-Id: <1410449587-1677-5-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1410449587-1677-1-git-send-email-p.zabel@pengutronix.de>
References: <1410449587-1677-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.120
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note that while of_graph_get_next_endpoint decrements the reference count
of the child node passed to it, of_node_put(child) still has to be called
manually when breaking out of the loop.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/linux/of_graph.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/of_graph.h b/include/linux/of_graph.h
index befef42..e43442e 100644
--- a/include/linux/of_graph.h
+++ b/include/linux/of_graph.h
@@ -26,6 +26,17 @@ struct of_endpoint {
 	const struct device_node *local_node;
 };
 
+/**
+ * for_each_endpoint_of_node - iterate over every endpoint in a device node
+ * @parent: parent device node containing ports and endpoints
+ * @child: loop variable pointing to the current endpoint node
+ *
+ * When breaking out of the loop, of_node_put(child) has to be called manually.
+ */
+#define for_each_endpoint_of_node(parent, child) \
+	for (child = of_graph_get_next_endpoint(parent, NULL); child != NULL; \
+	     child = of_graph_get_next_endpoint(parent, child))
+
 #ifdef CONFIG_OF
 int of_graph_parse_endpoint(const struct device_node *node,
 				struct of_endpoint *endpoint);
-- 
2.1.0

