Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbbA2Brs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:47:48 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:52773 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288AbbA2Bra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:47:30 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mark Brown <broonie@kernel.org>, Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v2 03/15] spi/xilinx: Code cleanup
Date: Wed, 28 Jan 2015 13:23:42 +0100
Message-Id: <1422447834-23116-4-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422447834-23116-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1422447834-23116-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the transmission loop, check for remaining bytes at the loop
condition.

This way we can handle transmissions of 0 bytes and clean the code.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
v2: Changes Requested by Mark Brown <broonie@kernel.org>
Improve description

 drivers/spi/spi-xilinx.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index d933207..a0f7c9d 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -248,7 +248,7 @@ static int xilinx_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
 	xspi->remaining_bytes = t->len;
 	reinit_completion(&xspi->done);
 
-	for (;;) {
+	while (xspi->remaining_bytes) {
 		u16 cr;
 		int n_words;
 
@@ -278,10 +278,6 @@ static int xilinx_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
 		/* Read out all the data from the Rx FIFO */
 		while (n_words--)
 			xspi->rx_fn(xspi);
-
-		/* See if there is more data to send */
-		if (xspi->remaining_bytes <= 0)
-			break;
 	}
 
 	return t->len - xspi->remaining_bytes;
-- 
2.1.4

