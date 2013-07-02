Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab3GBRHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 13:07:19 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.200]:6585 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752502Ab3GBRHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 13:07:17 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-132.messagelabs.com!1372784833!11530249!5
X-Originating-IP: [216.166.12.97]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 03/11] spi: spi-ep93xx: remove bits_per_word() helper
Date: Tue, 2 Jul 2013 10:07:01 -0700
User-Agent: KMail/1.9.9
CC: <spi-devel-general@lists.sourceforge.net>, Ryan Mallon <rmallon@gmail.com>,
        <mika.westerberg@iki.fi>, <broonie@kernel.org>,
        <grant.likely@linaro.org>, <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201307021007.01896.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check t->bits_per_word directly and remove the inline helper function.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Mika Westerberg <mika.westerberg@iki.fi>
Cc: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>
---
 drivers/spi/spi-ep93xx.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
index d7eccfc..d5e6420 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -429,17 +429,9 @@ static void ep93xx_spi_chip_setup(const struct ep93xx_spi *espi,
 	ep93xx_spi_write_u16(espi, SSPCR0, cr0);
 }
 
-static inline int bits_per_word(const struct ep93xx_spi *espi)
-{
-	struct spi_message *msg = espi->current_msg;
-	struct spi_transfer *t = msg->state;
-
-	return t->bits_per_word;
-}
-
 static void ep93xx_do_write(struct ep93xx_spi *espi, struct spi_transfer *t)
 {
-	if (bits_per_word(espi) > 8) {
+	if (t->bits_per_word > 8) {
 		u16 tx_val = 0;
 
 		if (t->tx_buf)
@@ -458,7 +450,7 @@ static void ep93xx_do_write(struct ep93xx_spi *espi, struct spi_transfer *t)
 
 static void ep93xx_do_read(struct ep93xx_spi *espi, struct spi_transfer *t)
 {
-	if (bits_per_word(espi) > 8) {
+	if (t->bits_per_word > 8) {
 		u16 rx_val;
 
 		rx_val = ep93xx_spi_read_u16(espi, SSPDR);
@@ -544,7 +536,7 @@ ep93xx_spi_dma_prepare(struct ep93xx_spi *espi, enum dma_transfer_direction dir)
 	size_t len = t->len;
 	int i, ret, nents;
 
-	if (bits_per_word(espi) > 8)
+	if (t->bits_per_word > 8)
 		buswidth = DMA_SLAVE_BUSWIDTH_2_BYTES;
 	else
 		buswidth = DMA_SLAVE_BUSWIDTH_1_BYTE;
-- 
1.8.1.4

