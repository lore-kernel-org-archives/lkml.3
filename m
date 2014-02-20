Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbaBUAkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:40:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45685 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbaBTXwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:52:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.12 24/82] spi: nuc900: Set SPI_LSB_FIRST for master->mode_bits if hw->pdata->lsb is true
Date: Thu, 20 Feb 2014 15:52:07 -0800
Message-Id: <20140220235020.202882178@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235019.483734207@linuxfoundation.org>
References: <20140220235019.483734207@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit f7db1588d6028c97c098bb6445eaabc56a25fed8 upstream.

Otherwise, spi_setup() fails with unsupported mode bits message.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-nuc900.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/spi/spi-nuc900.c
+++ b/drivers/spi/spi-nuc900.c
@@ -363,6 +363,8 @@ static int nuc900_spi_probe(struct platf
 	init_completion(&hw->done);
 
 	master->mode_bits          = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
+	if (hw->pdata->lsb)
+		master->mode_bits |= SPI_LSB_FIRST;
 	master->num_chipselect     = hw->pdata->num_cs;
 	master->bus_num            = hw->pdata->bus_num;
 	hw->bitbang.master         = hw->master;


