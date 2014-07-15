Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634AbaGORMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:12:05 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:42325 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904AbaGORCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:19 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 65/94] serial: arc_uart: Use uart_circ_empty() for open-coded comparison
Date: Tue, 15 Jul 2014 20:01:20 +0300
Message-Id: <1405443709-15288-65-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Hurley <peter@hurleysoftware.com>

Replace open-coded test for empty tx ring buffer with equivalent
helper function, uart_circ_empty(). No functional change.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 drivers/tty/serial/arc_uart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/arc_uart.c b/drivers/tty/serial/arc_uart.c
index c9f5c9d..008c223 100644
--- a/drivers/tty/serial/arc_uart.c
+++ b/drivers/tty/serial/arc_uart.c
@@ -177,7 +177,7 @@ static void arc_serial_tx_chars(struct arc_uart_port *uart)
 		uart->port.icount.tx++;
 		uart->port.x_char = 0;
 		sent = 1;
-	} else if (xmit->tail != xmit->head) {	/* TODO: uart_circ_empty */
+	} else if (!uart_circ_empty(xmit)) {
 		ch = xmit->buf[xmit->tail];
 		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
 		uart->port.icount.tx++;
-- 
1.7.10.4

