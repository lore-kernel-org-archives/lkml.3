Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaEYVNW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 17:13:22 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:21723 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbaEYVNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 17:13:20 -0400
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH] serial: efm32: add module_exit
Date: Sun, 25 May 2014 23:13:05 +0200
Message-Id: <1401052385-3786-1-git-send-email-vincent.stehle@laposte.net>
X-Mailer: git-send-email 2.0.0.rc2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing specification of efm32_uart_exit as module_exit.

This fixes the following compilation warning:

  drivers/tty/serial/efm32-uart.c:840:123: warning: ‘efm32_uart_exit’ defined but not used [-Wunused-function]

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Jiri Slaby <jslaby@suse.cz>
---

Hi,

This can be seen with e.g. arm allmodconfig.

Best regards,

V.

 drivers/tty/serial/efm32-uart.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/efm32-uart.c b/drivers/tty/serial/efm32-uart.c
index c167a71..b373f64 100644
--- a/drivers/tty/serial/efm32-uart.c
+++ b/drivers/tty/serial/efm32-uart.c
@@ -842,6 +842,7 @@ static void __exit efm32_uart_exit(void)
 	platform_driver_unregister(&efm32_uart_driver);
 	uart_unregister_driver(&efm32_uart_reg);
 }
+module_exit(efm32_uart_exit);
 
 MODULE_AUTHOR("Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>");
 MODULE_DESCRIPTION("EFM32 UART/USART driver");
-- 
2.0.0.rc2

