Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760324AbaJCXf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:35:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46368 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481AbaJCWDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:03:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Qipan Li <Qipan.Li@csr.com>, Barry Song <Baohua.Song@csr.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.16 303/357] spi: sirf: enable RX_IO_DMA_INT interrupt
Date: Fri,  3 Oct 2014 14:31:29 -0700
Message-Id: <20141003212942.579526733@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qipan Li <Qipan.Li@csr.com>

commit f2a08b404691ef3e7be6ce81c185335cfc68b6db upstream.

in spi interrupt handler, we need check RX_IO_DMA status to ensure
rx fifo have received the specify count data.

if not set, the while statement in spi isr function will keep loop,
at last, make the kernel hang.

[The code is actually there in the interrupt handler but apparently it
needs the interrupt unmasking so the handler sees the status -- broonie]

Signed-off-by: Qipan Li <Qipan.Li@csr.com>
Signed-off-by: Barry Song <Baohua.Song@csr.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-sirf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-sirf.c
+++ b/drivers/spi/spi-sirf.c
@@ -438,7 +438,8 @@ static void spi_sirfsoc_pio_transfer(str
 			sspi->tx_word(sspi);
 		writel(SIRFSOC_SPI_TXFIFO_EMPTY_INT_EN |
 			SIRFSOC_SPI_TX_UFLOW_INT_EN |
-			SIRFSOC_SPI_RX_OFLOW_INT_EN,
+			SIRFSOC_SPI_RX_OFLOW_INT_EN |
+			SIRFSOC_SPI_RX_IO_DMA_INT_EN,
 			sspi->base + SIRFSOC_SPI_INT_EN);
 		writel(SIRFSOC_SPI_RX_EN | SIRFSOC_SPI_TX_EN,
 			sspi->base + SIRFSOC_SPI_TX_RX_EN);


