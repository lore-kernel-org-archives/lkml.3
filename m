Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbaKQNpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:45:07 -0500
Received: from down.free-electrons.com ([37.187.137.238]:48941 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752252AbaKQNpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:45:04 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v5 01/61] serial: at91: Use dmaengine_slave_config API
Date: Mon, 17 Nov 2014 14:41:55 +0100
Message-Id: <1416231775-31252-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are removing the dmaengine_device_control API, that shouldn't even have been
exposed in the first place. Change the callers to use the proper API.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/atmel_serial.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index edde3eca055d..10e6b382d68f 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -862,9 +862,8 @@ static int atmel_prepare_tx_dma(struct uart_port *port)
 	config.dst_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
 	config.dst_addr = port->mapbase + ATMEL_US_THR;
 
-	ret = dmaengine_device_control(atmel_port->chan_tx,
-					DMA_SLAVE_CONFIG,
-					(unsigned long)&config);
+	ret = dmaengine_slave_config(atmel_port->chan_tx,
+				     &config);
 	if (ret) {
 		dev_err(port->dev, "DMA tx slave configuration failed\n");
 		goto chan_err;
@@ -1026,9 +1025,8 @@ static int atmel_prepare_rx_dma(struct uart_port *port)
 	config.src_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
 	config.src_addr = port->mapbase + ATMEL_US_RHR;
 
-	ret = dmaengine_device_control(atmel_port->chan_rx,
-					DMA_SLAVE_CONFIG,
-					(unsigned long)&config);
+	ret = dmaengine_slave_config(atmel_port->chan_rx,
+				     &config);
 	if (ret) {
 		dev_err(port->dev, "DMA rx slave configuration failed\n");
 		goto chan_err;
-- 
2.1.1

