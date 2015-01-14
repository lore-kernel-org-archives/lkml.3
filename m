Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbbANOQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:16:59 -0500
Received: from sauhun.de ([89.238.76.85]:39524 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753199AbbANOQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:16:57 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: dmaengine@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] dmaengine: of: bail out early if "dmas" property is not present
Date: Wed, 14 Jan 2015 15:16:28 +0100
Message-Id: <1421244988-11794-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

And don't print an error: not configured is not an error.

Reported-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---

In response to Philipp's patch silencing the warning in the driver:
http://patchwork.ozlabs.org/patch/425696/

I think this should be handled in the core.

 drivers/dma/of-dma.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
index d5fbeaa1e7ba..ca31f1b45366 100644
--- a/drivers/dma/of-dma.c
+++ b/drivers/dma/of-dma.c
@@ -159,6 +159,10 @@ struct dma_chan *of_dma_request_slave_channel(struct device_node *np,
 		return ERR_PTR(-ENODEV);
 	}
 
+	/* Silently fail if there is not even the "dmas" property */
+	if (!of_find_property(np, "dmas", NULL))
+		return ERR_PTR(-ENODEV);
+
 	count = of_property_count_strings(np, "dma-names");
 	if (count < 0) {
 		pr_err("%s: dma-names property of node '%s' missing or empty\n",
-- 
2.1.3

