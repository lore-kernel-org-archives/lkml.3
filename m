Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbaAXIo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 03:44:27 -0500
Received: from andre.telenet-ops.be ([195.130.132.53]:39013 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbaAXIoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 03:44:20 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH v2 12/14] spi: rspi: Use NULL as the clock ID
Date: Fri, 24 Jan 2014 09:44:02 +0100
Message-Id: <1390553044-11860-13-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
References: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

There's only one RSPI/QSPI clock, so we can use NULL as the clock ID

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
v2:
  - No changes

 drivers/spi/spi-rspi.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
index a648b40c271b..d79a7ed9b92e 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -1004,7 +1004,6 @@ static int rspi_probe(struct platform_device *pdev)
 	struct spi_master *master;
 	struct rspi_data *rspi;
 	int ret;
-	char clk_name[16];
 	const struct rspi_plat_data *rspi_pd = dev_get_platdata(&pdev->dev);
 	const struct spi_ops *ops;
 	const struct platform_device_id *id_entry = pdev->id_entry;
@@ -1034,8 +1033,7 @@ static int rspi_probe(struct platform_device *pdev)
 		goto error1;
 	}
 
-	snprintf(clk_name, sizeof(clk_name), "%s%d", id_entry->name, pdev->id);
-	rspi->clk = devm_clk_get(&pdev->dev, clk_name);
+	rspi->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(rspi->clk)) {
 		dev_err(&pdev->dev, "cannot get clock\n");
 		ret = PTR_ERR(rspi->clk);
-- 
1.7.9.5

