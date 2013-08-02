Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab3HAQuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 12:50:12 -0400
Received: from vaxjo.synopsys.com ([198.182.60.75]:43654 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577Ab3HAQuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 12:50:10 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-serial@vger.kernel.org>
CC: Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] serial/arc-uart: Remove the goto/label
Date: Thu, 1 Aug 2013 21:49:20 -0700
Message-ID: <1375418960-21491-2-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375418960-21491-1-git-send-email-vgupta@synopsys.com>
References: <1375418960-21491-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.9.21.33]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Mischa Jonker <mjonker@synopsys.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/tty/serial/arc_uart.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/arc_uart.c b/drivers/tty/serial/arc_uart.c
index 10f981b..c7aa313a 100644
--- a/drivers/tty/serial/arc_uart.c
+++ b/drivers/tty/serial/arc_uart.c
@@ -248,12 +248,9 @@ static void arc_serial_rx_chars(struct arc_uart_port *uart, unsigned int status)
 		ch = UART_GET_DATA(uart);
 		uart->port.icount.rx++;
 
-		if (unlikely(uart_handle_sysrq_char(&uart->port, ch)))
-			goto done;
+		if (!(uart_handle_sysrq_char(&uart->port, ch)))
+			uart_insert_char(&uart->port, status, RXOERR, ch, flg);
 
-		uart_insert_char(&uart->port, status, RXOERR, ch, flg);
-
-done:
 		tty_flip_buffer_push(&uart->port.state->port);
 	} while (!((status = UART_GET_STATUS(uart)) & RXEMPTY));
 }
-- 
1.8.1.2

