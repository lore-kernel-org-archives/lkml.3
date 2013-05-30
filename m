Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934214Ab3E3QAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:00:04 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59313 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934058Ab3E3P7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 11:59:50 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@kernel.org>, Grant Likely <grant.likely@linaro.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 3/3] spi: fix build break in spi-fsl-espi.c
Date: Thu, 30 May 2013 09:59:41 -0600
Message-Id: <1369929581-30258-3-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369929581-30258-1-git-send-email-swarren@wwwdotorg.org>
References: <1369929581-30258-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Fix a build error introduced by 24778be "spi: convert drivers to use
bits_per_word_mask":

drivers/spi/spi-fsl-espi.c:162:13: error: expected '=', ',', ';', 'asm' or '__attribute__' before '->' token

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/spi/spi-fsl-espi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsl-espi.c b/drivers/spi/spi-fsl-espi.c
index 0ef05f1..6a74d78 100644
--- a/drivers/spi/spi-fsl-espi.c
+++ b/drivers/spi/spi-fsl-espi.c
@@ -153,7 +153,7 @@ static int fsl_espi_setup_transfer(struct spi_device *spi,
 	cs->get_tx = mpc8xxx_spi_tx_buf_u32;
 	if (bits_per_word <= 8) {
 		cs->rx_shift = 8 - bits_per_word;
-	} else
+	} else {
 		cs->rx_shift = 16 - bits_per_word;
 		if (spi->mode & SPI_LSB_FIRST)
 			cs->get_tx = fsl_espi_tx_buf_lsb;
-- 
1.7.10.4

