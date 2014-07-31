Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448AbaGaKMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 06:12:55 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55376 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932404AbaGaKMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 06:12:46 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <joelf@ti.com>, <vinod.koul@intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <dmaengine@vger.kernel.org>
Subject: [PATCH 2/2] dmaengine: edma: Do not register second device when booted with DT
Date: Thu, 31 Jul 2014 13:12:38 +0300
Message-ID: <1406801558-13126-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <1406801558-13126-1-git-send-email-peter.ujfalusi@ti.com>
References: <1406801558-13126-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DT boot does not yet support more than one edma device. To avoid issues at
runtime we should not register the second device when the kernel is booted
with DT.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/dma/edma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 2953de0f53f3..d99351361fcb 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -23,6 +23,7 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <linux/of.h>
 
 #include <linux/platform_data/edma.h>
 
@@ -1133,7 +1134,7 @@ static int edma_init(void)
 		}
 	}
 
-	if (EDMA_CTLRS == 2) {
+	if (!of_have_populated_dt() && EDMA_CTLRS == 2) {
 		pdev1 = platform_device_register_full(&edma_dev_info1);
 		if (IS_ERR(pdev1)) {
 			platform_driver_unregister(&edma_driver);
-- 
2.0.2

