Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327Ab3HNWSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 18:18:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37969 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933115Ab3HNWSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 18:18:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-serial@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] serial: pch_uart: fix compilation warning
Date: Wed, 14 Aug 2013 23:18:37 +0100
Message-Id: <1376518717-11854-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function wait_for_xmitr is invoked only on functions that either depend
on CONFIG_CONSOLE_POLL or CONFIG_SERIAL_PCH_UART_CONSOLE.

This patch fixes the following warning:

drivers/tty/serial/pch_uart.c:1504:13: warning: ‘wait_for_xmitr’ defined but not used [-Wunused-function]

Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/serial/pch_uart.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 572d481..1e22a49 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1498,6 +1498,7 @@ static int pch_uart_verify_port(struct uart_port *port,
 	return 0;
 }
 
+#if defined(CONFIG_CONSOLE_POLL) || defined(CONFIG_SERIAL_PCH_UART_CONSOLE)
 /*
  *	Wait for transmitter & holding register to empty
  */
@@ -1528,6 +1529,7 @@ static void wait_for_xmitr(struct eg20t_port *up, int bits)
 		}
 	}
 }
+#endif /* CONFIG_CONSOLE_POLL || CONFIG_SERIAL_PCH_UART_CONSOLE */
 
 #ifdef CONFIG_CONSOLE_POLL
 /*
-- 
1.8.3.2

