Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbaLOOzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:55:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38608 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbaLOO2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Qipan Li <Qipan.Li@csr.com>, Barry Song <Baohua.Song@csr.com>,
        Mark Brown <broonie@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 082/168] spi: sirf: fix word width configuration
Date: Mon, 15 Dec 2014 14:25:36 +0000
Message-Id: <1418653622-21105-83-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qipan Li <Qipan.Li@csr.com>

commit 9c4b19a07dddda3ba35a2eb9b4134d485908e2f5 upstream.

commit 8c328a262f ("spi: sirf: Avoid duplicate code in various
bits_per_word cases") is wrong in setting data width register of
fifo is not right, it should use sspi->word_width >> 1 to set
related bits. According to hardware spec, the mapping between
register value and data width:
0 - byte
1 - WORD
2 - DWORD

Fixes: 8c328a262f ("spi: sirf: Avoid duplicate code in various bits_per_word cases") is wrong in setting data width register of
Signed-off-by: Qipan Li <Qipan.Li@csr.com>
Signed-off-by: Barry Song <Baohua.Song@csr.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/spi/spi-sirf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-sirf.c b/drivers/spi/spi-sirf.c
index 1a5161336730..633a38337787 100644
--- a/drivers/spi/spi-sirf.c
+++ b/drivers/spi/spi-sirf.c
@@ -563,9 +563,9 @@ spi_sirfsoc_setup_transfer(struct spi_device *spi, struct spi_transfer *t)
 
 	sspi->word_width = DIV_ROUND_UP(bits_per_word, 8);
 	txfifo_ctrl = SIRFSOC_SPI_FIFO_THD(SIRFSOC_SPI_FIFO_SIZE / 2) |
-					   sspi->word_width;
+					   (sspi->word_width >> 1);
 	rxfifo_ctrl = SIRFSOC_SPI_FIFO_THD(SIRFSOC_SPI_FIFO_SIZE / 2) |
-					   sspi->word_width;
+					   (sspi->word_width >> 1);
 
 	if (!(spi->mode & SPI_CS_HIGH))
 		regval |= SIRFSOC_SPI_CS_IDLE_STAT;
-- 
2.1.3

