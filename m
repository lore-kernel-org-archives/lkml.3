Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbbA2CEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:04:47 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61202 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbbA2CEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:04:44 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mark Brown <broonie@kernel.org>, Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v2 04/15] spi/xilinx: Use cached value of register
Date: Wed, 28 Jan 2015 13:23:43 +0100
Message-Id: <1422447834-23116-5-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422447834-23116-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1422447834-23116-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The control register has not changed since the previous access.
Therefore we can use the cached value and safe one bus access.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/spi/spi-xilinx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index a0f7c9d..12b311e 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -271,7 +271,6 @@ static int xilinx_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
 		 * transmitter while the Isr refills the transmit register/FIFO,
 		 * or make sure it is stopped if we're done.
 		 */
-		cr = xspi->read_fn(xspi->regs + XSPI_CR_OFFSET);
 		xspi->write_fn(cr | XSPI_CR_TRANS_INHIBIT,
 			       xspi->regs + XSPI_CR_OFFSET);
 
-- 
2.1.4

