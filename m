Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab3GWKvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 06:51:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51181 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab3GWKuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 06:50:14 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-sh@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH v4 06/15] DMA: shdma: make multiplexer platform data optional
Date: Tue, 23 Jul 2013 12:50:00 +0200
Message-Id: <1374576609-27748-7-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1374576609-27748-1-git-send-email-g.liakhovetski@gmx.de>
References: <1374576609-27748-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:GxNEUmRb8aHeDMhh5ncW+pr4wueSJDbCxOFALNqdZQU
 9ZZq0YUS2kQ598/79w4mGBwLjDYuXviVixXEKoLBYBi4HSiBFD
 5mN5Jm07+qkbk2J7pasuLI5UrFLHMmFK1+Kwl3SKQz/KVSwC7+
 A5R9EHILuqpyRh+7woASul/wfd35uBgZmwJf7busKeTT2CDU0d
 +fUl5J0x8E6JM+vPZncQOlax0UQmsMBsyjEKPXZwBF0NIqCPF3
 4fhi0kozEVa/BptF0AcO4+hSdMQVMSimHzwFcx2TKA+XV3XiTu
 pnA61JVrSrIJQizC6+PLFlOqZfF2Okq5vmjjH6Lr4u4L4ET7df
 +FE7uVvVX0omb3pvEaAXhch3tyuboUTxy6hhuOPMWlx/67KaYy
 i2CyEDE3sZzww==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of supplying platform data to the shdma dmaengine driver via
AUXDATA in the DT case, we now support platform data via an OF match table.
Make platform data optional.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 drivers/dma/sh/shdma-of.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/sh/shdma-of.c b/drivers/dma/sh/shdma-of.c
index 11bcb05..2acf7b6 100644
--- a/drivers/dma/sh/shdma-of.c
+++ b/drivers/dma/sh/shdma-of.c
@@ -45,9 +45,6 @@ static int shdma_of_probe(struct platform_device *pdev)
 	const struct of_dev_auxdata *lookup = pdev->dev.platform_data;
 	int ret;
 
-	if (!lookup)
-		return -EINVAL;
-
 	ret = of_dma_controller_register(pdev->dev.of_node,
 					 shdma_of_xlate, pdev);
 	if (ret < 0)
-- 
1.7.2.5

