Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759650Ab3GaObE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 10:31:04 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:56068 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab3GaObC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 10:31:02 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-kernel@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 07/25] dma: of: make error message more meaningful by adding the node name
Date: Wed, 31 Jul 2013 16:14:35 +0200
Message-Id: <1375280075-18482-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/dma/of-dma.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
index 75334bd..0b88dd3 100644
--- a/drivers/dma/of-dma.c
+++ b/drivers/dma/of-dma.c
@@ -160,7 +160,8 @@ struct dma_chan *of_dma_request_slave_channel(struct device_node *np,
 
 	count = of_property_count_strings(np, "dma-names");
 	if (count < 0) {
-		pr_err("%s: dma-names property missing or empty\n", __func__);
+		pr_err("%s: dma-names property of node '%s' missing or empty\n",
+			__func__, np->full_name);
 		return NULL;
 	}
 
-- 
1.7.2.5

