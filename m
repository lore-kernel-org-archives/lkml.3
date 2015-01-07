Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbbAGPh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 10:37:29 -0500
Received: from laurent.telenet-ops.be ([195.130.137.89]:38442 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbbAGPh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 10:37:28 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Mark Brown <broonie@kernel.org>
Cc: Hisashi Nakamura <hisashi.nakamura.ak@renesas.com>,
        Yoshihiro Kaneko <ykaneko0929@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] spi: sh-msiof: Use async pm_runtime_put() in sh_msiof_spi_setup()
Date: Wed,  7 Jan 2015 16:37:25 +0100
Message-Id: <1420645045-18804-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to use the synchronous version.

Reported-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Fixes: 015760563ec77bf1 ("spi: sh-msiof: Add runtime PM lock in initializing")
---
Please note that 015760563ec77bf1 is marked for stable.

 drivers/spi/spi-sh-msiof.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-sh-msiof.c b/drivers/spi/spi-sh-msiof.c
index 3f7ea2d49456e754..050e9188df1b309c 100644
--- a/drivers/spi/spi-sh-msiof.c
+++ b/drivers/spi/spi-sh-msiof.c
@@ -546,7 +546,7 @@ static int sh_msiof_spi_setup(struct spi_device *spi)
 		gpio_set_value(spi->cs_gpio, !(spi->mode & SPI_CS_HIGH));
 
 
-	pm_runtime_put_sync(&p->pdev->dev);
+	pm_runtime_put(&p->pdev->dev);
 
 	return 0;
 }
-- 
1.9.1

