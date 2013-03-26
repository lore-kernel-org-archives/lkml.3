Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934336Ab3CZJ16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 05:27:58 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:42583 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756982Ab3CZJ1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 05:27:48 -0400
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH] spi: spi-s3c64xx.c Remove unused argument.
Date: Tue, 26 Mar 2013 10:27:35 +0100
Message-Id: <1364290055-2970-1-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pointer to the driver data is never used to get the slave
controller data. We can delete the unused argument from the function.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 drivers/spi/spi-s3c64xx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index e862ab8..7f5f8ee 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -817,7 +817,6 @@ static int s3c64xx_spi_unprepare_transfer(struct spi_master *spi)
 }
 
 static struct s3c64xx_spi_csinfo *s3c64xx_get_slave_ctrldata(
-				struct s3c64xx_spi_driver_data *sdd,
 				struct spi_device *spi)
 {
 	struct s3c64xx_spi_csinfo *cs;
@@ -874,7 +873,7 @@ static int s3c64xx_spi_setup(struct spi_device *spi)
 
 	sdd = spi_master_get_devdata(spi->master);
 	if (!cs && spi->dev.of_node) {
-		cs = s3c64xx_get_slave_ctrldata(sdd, spi);
+		cs = s3c64xx_get_slave_ctrldata(spi);
 		spi->controller_data = cs;
 	}
 
-- 
1.7.11.7

