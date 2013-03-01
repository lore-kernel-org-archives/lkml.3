Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253Ab3CANSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 08:18:36 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:45332 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab3CANSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 08:18:34 -0500
From: Steven Noonan <steven@uplinklabs.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Steven Noonan <steven@uplinklabs.net>
Subject: [PATCH] s3c24xx: fix link failure if CONFIG_CONSOLE_POLL but !CONFIG_SERIAL_SAMSUNG_CONSOLE
Date: Fri,  1 Mar 2013 05:18:14 -0800
Message-Id: <1362143894-4586-1-git-send-email-steven@uplinklabs.net>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resolves this link failure:
	ERROR: "s3c24xx_serial_get_poll_char" [drivers/tty/serial/samsung.ko] undefined!
	ERROR: "s3c24xx_serial_put_poll_char" [drivers/tty/serial/samsung.ko] undefined!

Signed-off-by: Steven Noonan <steven@uplinklabs.net>
---
 drivers/tty/serial/samsung.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index 2769a38..1290646 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -889,17 +889,17 @@ static int __init s3c24xx_serial_console_init(void)
 }
 console_initcall(s3c24xx_serial_console_init);
 
-#define S3C24XX_SERIAL_CONSOLE &s3c24xx_serial_console
-#else
-#define S3C24XX_SERIAL_CONSOLE NULL
-#endif
-
 #ifdef CONFIG_CONSOLE_POLL
 static int s3c24xx_serial_get_poll_char(struct uart_port *port);
 static void s3c24xx_serial_put_poll_char(struct uart_port *port,
 			 unsigned char c);
 #endif
 
+#define S3C24XX_SERIAL_CONSOLE &s3c24xx_serial_console
+#else
+#define S3C24XX_SERIAL_CONSOLE NULL
+#endif
+
 static struct uart_ops s3c24xx_serial_ops = {
 	.pm		= s3c24xx_serial_pm,
 	.tx_empty	= s3c24xx_serial_tx_empty,
@@ -918,7 +918,7 @@ static struct uart_ops s3c24xx_serial_ops = {
 	.request_port	= s3c24xx_serial_request_port,
 	.config_port	= s3c24xx_serial_config_port,
 	.verify_port	= s3c24xx_serial_verify_port,
-#ifdef CONFIG_CONSOLE_POLL
+#if defined(CONFIG_CONSOLE_POLL) && defined(CONFIG_SERIAL_SAMSUNG_CONSOLE)
 	.poll_get_char = s3c24xx_serial_get_poll_char,
 	.poll_put_char = s3c24xx_serial_put_poll_char,
 #endif
-- 
1.8.1.2

