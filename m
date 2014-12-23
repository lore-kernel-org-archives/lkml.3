Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaLWRtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 12:49:31 -0500
Received: from www.osadl.org ([62.245.132.105]:33696 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbaLWRta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 12:49:30 -0500
X-Greylist: delayed 2360 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Dec 2014 12:49:29 EST
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH] spi: unnecessary double init_completion removed
Date: Tue, 23 Dec 2014 18:41:33 +0100
Message-Id: <1419356493-22539-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The double call to init_completion(&mpc8xxx_spi->done); is not needed
presumably this is a editing mistake only.


Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 drivers/spi/spi-fsl-lib.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/spi/spi-fsl-lib.c b/drivers/spi/spi-fsl-lib.c
index 446b737..9d3f9e0 100644
--- a/drivers/spi/spi-fsl-lib.c
+++ b/drivers/spi/spi-fsl-lib.c
@@ -102,8 +102,6 @@ void mpc8xxx_spi_probe(struct device *dev, struct resource *mem,
 	mpc8xxx_spi->rx_shift = 0;
 	mpc8xxx_spi->tx_shift = 0;

-	init_completion(&mpc8xxx_spi->done);
-
 	master->bus_num = pdata->bus_num;
 	master->num_chipselect = pdata->max_chipselect;

--
1.7.10.4

