Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965232Ab3DRDPC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 23:15:02 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:38064 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965089Ab3DRDPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 23:15:00 -0400
MIME-Version: 1.0
Date: Thu, 18 Apr 2013 11:14:59 +0800
Message-ID: <CAPgLHd8qt3o285vskc-JzNOh0Yorehgxy+SEUoJ_kccy3cjcMQ@mail.gmail.com>
Subject: [PATCH -next] spi: omap2-mcspi: fix error return code in omap2_mcspi_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: grant.likely@secretlab.ca, broonie@kernel.org, rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, spi-devel-general@lists.sourceforge.net,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as returned elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/spi/spi-omap2-mcspi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 893c3d7..c31a1c0 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1277,7 +1277,8 @@ static int omap2_mcspi_probe(struct platform_device *pdev)
 	pm_runtime_set_autosuspend_delay(&pdev->dev, SPI_AUTOSUSPEND_TIMEOUT);
 	pm_runtime_enable(&pdev->dev);
 
-	if (status || omap2_mcspi_master_setup(mcspi) < 0)
+	status = omap2_mcspi_master_setup(mcspi);
+	if (status < 0)
 		goto disable_pm;
 
 	status = spi_register_master(master);

