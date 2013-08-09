Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030290Ab3HICEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:04:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55896 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030214Ab3HIB7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christian Eggers <ceggers@gmx.de>, Matt Porter <mporter@ti.com>,
        Mark Brown <broonie@linaro.org>
Subject: [ 086/102] spi: spi-davinci: Fix direction in dma_map_single()
Date: Thu,  8 Aug 2013 18:58:02 -0700
Message-Id: <20130809015030.527010387@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Eggers <ceggers@gmx.de>

commit 89c66ee890af18500fa4598db300cc07c267f900 upstream.

Commit 048177ce3b3962852fd34a7e04938959271c7e70 (spi: spi-davinci:
convert to DMA engine API) introduced a regression: dma_map_single()
is called with direction DMA_FROM_DEVICE for rx and for tx.

Signed-off-by: Christian Eggers <ceggers@gmx.de>
Acked-by: Matt Porter <mporter@ti.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-davinci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi-davinci.c
+++ b/drivers/spi/spi-davinci.c
@@ -610,7 +610,7 @@ static int davinci_spi_bufs(struct spi_d
 		else
 			buf = (void *)t->tx_buf;
 		t->tx_dma = dma_map_single(&spi->dev, buf,
-				t->len, DMA_FROM_DEVICE);
+				t->len, DMA_TO_DEVICE);
 		if (!t->tx_dma) {
 			ret = -EFAULT;
 			goto err_tx_map;


