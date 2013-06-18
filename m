Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab3FRO1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 10:27:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:60264 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755798Ab3FRO1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 10:27:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,889,1363158000"; 
   d="scan'208";a="351757629"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 1/2] spi/pxa2xx: use GFP_ATOMIC in sg table allocation
Date: Tue, 18 Jun 2013 17:29:44 +0300
Message-Id: <1371565785-31332-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pxa2xx_spi_map_dma_buffer() gets called in tasklet context so we can't
sleep when we allocate a new sg table. Use GFP_ATOMIC here instead.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/spi-pxa2xx-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-pxa2xx-dma.c b/drivers/spi/spi-pxa2xx-dma.c
index f4cb744..3c0b551 100644
--- a/drivers/spi/spi-pxa2xx-dma.c
+++ b/drivers/spi/spi-pxa2xx-dma.c
@@ -59,7 +59,7 @@ static int pxa2xx_spi_map_dma_buffer(struct driver_data *drv_data,
 		int ret;
 
 		sg_free_table(sgt);
-		ret = sg_alloc_table(sgt, nents, GFP_KERNEL);
+		ret = sg_alloc_table(sgt, nents, GFP_ATOMIC);
 		if (ret)
 			return ret;
 	}
-- 
1.8.3.1

