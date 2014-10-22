Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbaJVPpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:45:11 -0400
Received: from down.free-electrons.com ([37.187.137.238]:53901 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753356AbaJVPpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:45:06 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org
Subject: [PATCH v3 02/59] serial: at91: Use dmaengine_slave_config API
Date: Wed, 22 Oct 2014 17:43:16 +0200
Message-Id: <1413992653-21963-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are removing the dmaengine_device_control API, that shouldn't even have been
exposed in the first place. Change the callers to use the proper API.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
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

