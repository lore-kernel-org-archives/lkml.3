Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab3JFG1Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 02:27:24 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51223 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751394Ab3JFG1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 02:27:23 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: sonic.zhang@analog.com, gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, uclinux-dist-devel@blackfin.uclinux.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] serial: bfin_uart: remove deprecated IRQF_DISABLED
Date: Sun,  6 Oct 2013 08:27:18 +0200
Message-Id: <1381040838-12748-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/tty/serial/bfin_uart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/bfin_uart.c b/drivers/tty/serial/bfin_uart.c
index 3c75e8e..5e85f35 100644
--- a/drivers/tty/serial/bfin_uart.c
+++ b/drivers/tty/serial/bfin_uart.c
@@ -726,7 +726,7 @@ static int bfin_serial_startup(struct uart_port *port)
 #ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
 	if (uart->cts_pin >= 0) {
 		if (request_irq(uart->status_irq, bfin_serial_mctrl_cts_int,
-			IRQF_DISABLED, "BFIN_UART_MODEM_STATUS", uart)) {
+			0, "BFIN_UART_MODEM_STATUS", uart)) {
 			uart->cts_pin = -1;
 			dev_info(port->dev, "Unable to attach BlackFin UART Modem Status interrupt.\n");
 		}
-- 
1.8.1.2

