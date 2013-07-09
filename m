Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab3GIOiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 10:38:07 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45003 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab3GIOiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 10:38:04 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, hi@hello.com,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 1/3] DMA: shdma: (cosmetic) don't re-calculate a pointer
Date: Tue,  9 Jul 2013 15:37:54 +0100
Message-Id: <1373380677-450-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1373380677-450-1-git-send-email-lee.jones@linaro.org>
References: <1373380677-450-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Use an existing pointer instead of retrieving it again.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/dma/sh/shdma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/sh/shdma.c b/drivers/dma/sh/shdma.c
index b70709b..a5a1887 100644
--- a/drivers/dma/sh/shdma.c
+++ b/drivers/dma/sh/shdma.c
@@ -729,7 +729,7 @@ static int sh_dmae_probe(struct platform_device *pdev)
 		goto eshdma;
 
 	/* platform data */
-	shdev->pdata = pdev->dev.platform_data;
+	shdev->pdata = pdata;
 
 	if (pdata->chcr_offset)
 		shdev->chcr_offset = pdata->chcr_offset;
-- 
1.7.10.4

