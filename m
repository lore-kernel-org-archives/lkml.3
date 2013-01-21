Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab3AUJc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 04:32:27 -0500
Received: from mga01.intel.com ([192.55.52.88]:56387 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581Ab3AUJbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 04:31:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,505,1355126400"; 
   d="scan'208";a="279685573"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, chao.bi@intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 08/10] spi/pxa2xx: add support for SPI_LOOP
Date: Mon, 21 Jan 2013 11:32:01 +0200
Message-Id: <1358760723-32752-9-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358760723-32752-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1358760723-32752-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is useful when testing the functionality of the controller from userspace
and there aren't any real SPI slave devices connected to the bus.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/spi-pxa2xx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index 7fa2e8e..1a56faa 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -854,6 +854,9 @@ static int setup(struct spi_device *spi)
 	chip->cr1 |= (((spi->mode & SPI_CPHA) != 0) ? SSCR1_SPH : 0)
 			| (((spi->mode & SPI_CPOL) != 0) ? SSCR1_SPO : 0);
 
+	if (spi->mode & SPI_LOOP)
+		chip->cr1 |= SSCR1_LBM;
+
 	/* NOTE:  PXA25x_SSP _could_ use external clocking ... */
 	if (!pxa25x_ssp_comp(drv_data))
 		dev_dbg(&spi->dev, "%ld Hz actual, %s\n",
@@ -947,7 +950,7 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 	master->dev.parent = &pdev->dev;
 	master->dev.of_node = pdev->dev.of_node;
 	/* the spi->mode bits understood by this driver: */
-	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
+	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH | SPI_LOOP;
 
 	master->bus_num = ssp->port_id;
 	master->num_chipselect = platform_info->num_chipselect;
-- 
1.7.10.4

