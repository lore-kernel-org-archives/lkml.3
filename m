Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbaJKQV7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 12:21:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:29315 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbaJKQU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 12:20:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,699,1406617200"; 
   d="scan'208";a="603887854"
From: Vinod Koul <vinod.koul@intel.com>
To: dmaengine@vger.kernel.org
Cc: Li Yang <leoli@freescale.com>, Zhang Wei <zw@zh-kernel.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 4/6] carma-fpga: move to fsl_dma_external_start()
Date: Sat, 11 Oct 2014 21:16:46 +0530
Message-Id: <1413042408-28491-5-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1413042408-28491-1-git-send-email-vinod.koul@intel.com>
References: <1413042408-28491-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

carma-fpga driver uses device control with custom FSLDMA_EXTERNAL_START
command. Since we wnat to deprecate the device control, move this driver to
use new fsl_dma_external_start() API

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/misc/carma/carma-fpga-program.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/carma/carma-fpga-program.c b/drivers/misc/carma/carma-fpga-program.c
index fd0cb8b..298f912 100644
--- a/drivers/misc/carma/carma-fpga-program.c
+++ b/drivers/misc/carma/carma-fpga-program.c
@@ -16,6 +16,7 @@
 #include <linux/completion.h>
 #include <linux/miscdevice.h>
 #include <linux/dmaengine.h>
+#include <linux/fsldma.h>
 #include <linux/interrupt.h>
 #include <linux/highmem.h>
 #include <linux/kernel.h>
@@ -524,7 +525,7 @@ static noinline int fpga_program_dma(struct fpga_dev *priv)
 		goto out_dma_unmap;
 	}
 
-	ret = chan->device->device_control(chan, FSLDMA_EXTERNAL_START, 1);
+	ret = fsl_dma_external_start(chan, 1)
 	if (ret) {
 		dev_err(priv->dev, "DMA external control setup failed\n");
 		goto out_dma_unmap;
-- 
1.7.0.4

