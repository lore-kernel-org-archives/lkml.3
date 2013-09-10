Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab3IJRKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 13:10:31 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:43648 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab3IJRKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 13:10:30 -0400
From: Ben Gardiner <ben.l.gardiner@gmail.com>
To: grant.likely@secretlab.ca, spi-devel-general@lists.sourceforge.net,
        davinci-linux-open-source@linux.davincidsp.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] spi: spi-davinci: deassert CS on setup()
Date: Tue, 10 Sep 2013 13:10:22 -0400
Message-Id: <1378833022-31046-1-git-send-email-ben.l.gardiner@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mmc_spi driver's mmc_cs_off() function states that "chipselect will always
be inactive after setup()"; however, the spi-davinci driver's setup() leaves CS
state unchanged.

Add a call to davinci_spi_chipselect(spi, BITBANG_CS_INACTIVE) to the spi-
davinci drivers' setup() function.

Signed-off-by: Ben Gardiner <ben.l.gardiner@gmail.com>
---
 drivers/spi/spi-davinci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-davinci.c b/drivers/spi/spi-davinci.c
index 707966b..f0f4dbd 100644
--- a/drivers/spi/spi-davinci.c
+++ b/drivers/spi/spi-davinci.c
@@ -404,6 +404,7 @@ static int davinci_spi_setup(struct spi_device *spi)
 		    (pdata->chip_sel[spi->chip_select] == SPI_INTERN_CS))
 			set_io_bits(dspi->base + SPIPC0, 1 << spi->chip_select);
 
+		davinci_spi_chipselect(spi, BITBANG_CS_INACTIVE);
 	}
 
 	if (spi->mode & SPI_READY)
-- 
1.8.1.2

