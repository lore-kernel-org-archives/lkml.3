Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769Ab3GBRGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 13:06:48 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.102]:20608 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752526Ab3GBRGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 13:06:47 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-160.messagelabs.com!1372784793!7176462!19
X-Originating-IP: [216.166.12.69]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 02/11] spi: spi-ep93xx: use read,write instead of __raw_* variants
Date: Tue, 2 Jul 2013 10:06:26 -0700
User-Agent: KMail/1.9.9
CC: <spi-devel-general@lists.sourceforge.net>, Ryan Mallon <rmallon@gmail.com>,
        <mika.westerberg@iki.fi>, <broonie@kernel.org>,
        <grant.likely@linaro.org>, <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201307021006.26694.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memory resource used by this driver is ioremap()'d and the normal
read,write calls can be used instead of the __raw_* variants.

Also, remove the inline tag on the helper functions and let the compiler
decide if they are inlined.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Mika Westerberg <mika.westerberg@iki.fi>
Cc: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>
---
 drivers/spi/spi-ep93xx.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
index 11e2b99..d7eccfc 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -158,28 +158,26 @@ struct ep93xx_spi_chip {
 /* converts bits per word to CR0.DSS value */
 #define bits_per_word_to_dss(bpw)	((bpw) - 1)
 
-static inline void
-ep93xx_spi_write_u8(const struct ep93xx_spi *espi, u16 reg, u8 value)
+static void ep93xx_spi_write_u8(const struct ep93xx_spi *espi,
+				u16 reg, u8 value)
 {
-	__raw_writeb(value, espi->regs_base + reg);
+	writeb(value, espi->regs_base + reg);
 }
 
-static inline u8
-ep93xx_spi_read_u8(const struct ep93xx_spi *spi, u16 reg)
+static u8 ep93xx_spi_read_u8(const struct ep93xx_spi *spi, u16 reg)
 {
-	return __raw_readb(spi->regs_base + reg);
+	return readb(spi->regs_base + reg);
 }
 
-static inline void
-ep93xx_spi_write_u16(const struct ep93xx_spi *espi, u16 reg, u16 value)
+static void ep93xx_spi_write_u16(const struct ep93xx_spi *espi,
+				 u16 reg, u16 value)
 {
-	__raw_writew(value, espi->regs_base + reg);
+	writew(value, espi->regs_base + reg);
 }
 
-static inline u16
-ep93xx_spi_read_u16(const struct ep93xx_spi *spi, u16 reg)
+static u16 ep93xx_spi_read_u16(const struct ep93xx_spi *spi, u16 reg)
 {
-	return __raw_readw(spi->regs_base + reg);
+	return readw(spi->regs_base + reg);
 }
 
 static int ep93xx_spi_enable(const struct ep93xx_spi *espi)
-- 
1.8.1.4

