Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbbAWQKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:10:19 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:36006 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536AbbAWQJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:09:19 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mark Brown <broonie@kernel.org>, Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 16/18] spi/xilinx: Reset core before buffer_size detection
Date: Fri, 23 Jan 2015 17:08:48 +0100
Message-Id: <1422029330-10971-17-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1422029330-10971-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the core had some data on the buffer, the size detection could show
up a smaller size than real, affecting performance.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/spi/spi-xilinx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index 704613c..8c25c59 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -295,6 +295,13 @@ static int xilinx_spi_find_buffer_size(struct xilinx_spi *xspi)
 	u8 sr;
 	int n_words = 0;
 
+	/*
+	 * Before the buffer_size detection we reset the core
+	 * to make sure we start with a clean state.
+	 */
+	xspi->write_fn(XIPIF_V123B_RESET_MASK,
+		xspi->regs + XIPIF_V123B_RESETR_OFFSET);
+
 	/* Fill the Tx FIFO with as many words as possible */
 	do {
 		xspi->write_fn(0, xspi->regs + XSPI_TXD_OFFSET);
-- 
2.1.4

