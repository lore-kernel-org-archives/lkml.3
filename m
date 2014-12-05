Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaLEWw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:52:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53977 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbaLEWqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:46:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Qipan Li <Qipan.Li@csr.com>, Barry Song <Baohua.Song@csr.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.17 088/122] spi: sirf: fix word width configuration
Date: Fri,  5 Dec 2014 14:44:22 -0800
Message-Id: <20141205223318.991494649@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-sirf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-sirf.c
+++ b/drivers/spi/spi-sirf.c
@@ -565,9 +565,9 @@ spi_sirfsoc_setup_transfer(struct spi_de
 
 	sspi->word_width = DIV_ROUND_UP(bits_per_word, 8);
 	txfifo_ctrl = SIRFSOC_SPI_FIFO_THD(SIRFSOC_SPI_FIFO_SIZE / 2) |
-					   sspi->word_width;
+					   (sspi->word_width >> 1);
 	rxfifo_ctrl = SIRFSOC_SPI_FIFO_THD(SIRFSOC_SPI_FIFO_SIZE / 2) |
-					   sspi->word_width;
+					   (sspi->word_width >> 1);
 
 	if (!(spi->mode & SPI_CS_HIGH))
 		regval |= SIRFSOC_SPI_CS_IDLE_STAT;


