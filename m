Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbaEDPlW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:41:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35939 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbaEDPlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Axel Lin <axel.lin@ingics.com>, Baruch Siach <baruch@tkos.co.il>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.14 031/158] spi: dw: Dont call kfree for memory allocated by devm_kzalloc
Date: Sun,  4 May 2014 11:39:00 -0400
Message-Id: <20140504154034.187182485@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit c63f5da00845143de621e991ea186be0829647ee upstream.

With devm_kzalloc, the memory is automatically freed when spi_device detach from
the bus.

Fixes: commit 43f627ac9de42 (spi: dw: fix memory leak on error path)
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-dw.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -671,12 +671,6 @@ static int dw_spi_setup(struct spi_devic
 	return 0;
 }
 
-static void dw_spi_cleanup(struct spi_device *spi)
-{
-	struct chip_data *chip = spi_get_ctldata(spi);
-	kfree(chip);
-}
-
 static int init_queue(struct dw_spi *dws)
 {
 	INIT_LIST_HEAD(&dws->queue);
@@ -806,7 +800,6 @@ int dw_spi_add_host(struct device *dev,
 	master->bits_per_word_mask = SPI_BPW_MASK(8) | SPI_BPW_MASK(16);
 	master->bus_num = dws->bus_num;
 	master->num_chipselect = dws->num_cs;
-	master->cleanup = dw_spi_cleanup;
 	master->setup = dw_spi_setup;
 	master->transfer = dw_spi_transfer;
 


