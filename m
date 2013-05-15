Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab3EOPgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 11:36:01 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52066 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759111Ab3EOPf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 11:35:56 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <khilman@linaro.org>
CC: <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sourav Poddar <sourav.poddar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: [Resend/PATCHv5 1/2] driver: tty: serial: Move "uart_console" def to core header file.
Date: Wed, 15 May 2013 21:05:37 +0530
Message-ID: <1368632138-31695-2-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1368632138-31695-1-git-send-email-sourav.poddar@ti.com>
References: <1368632138-31695-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move "uart_console" definition to serial core header file, so that it can be
used by serial drivers.
Get rid of the uart_console defintion from mpc52xx_uart driver.

Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Rajendra nayak <rnayak@ti.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>
Reviewed-by: Kevin Hilman<khilman@linaro.org>
Tested-by: Kevin Hilman<khilman@linaro.org>
Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
---
 drivers/tty/serial/mpc52xx_uart.c |   10 ----------
 drivers/tty/serial/serial_core.c  |    6 ------
 include/linux/serial_core.h       |    7 +++++++
 3 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/tty/serial/mpc52xx_uart.c b/drivers/tty/serial/mpc52xx_uart.c
index 018bad9..d74ac06 100644
--- a/drivers/tty/serial/mpc52xx_uart.c
+++ b/drivers/tty/serial/mpc52xx_uart.c
@@ -84,16 +84,6 @@ static void mpc52xx_uart_of_enumerate(void);
 static irqreturn_t mpc52xx_uart_int(int irq, void *dev_id);
 static irqreturn_t mpc5xxx_uart_process_int(struct uart_port *port);
 
-
-/* Simple macro to test if a port is console or not. This one is taken
- * for serial_core.c and maybe should be moved to serial_core.h ? */
-#ifdef CONFIG_SERIAL_CORE_CONSOLE
-#define uart_console(port) \
-	((port)->cons && (port)->cons->index == (port)->line)
-#else
-#define uart_console(port)	(0)
-#endif
-
 /* ======================================================================== */
 /* PSC fifo operations for isolating differences between 52xx and 512x      */
 /* ======================================================================== */
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index f87dbfd..28cdd28 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -50,12 +50,6 @@ static struct lock_class_key port_lock_key;
 
 #define HIGH_BITS_OFFSET	((sizeof(long)-sizeof(int))*8)
 
-#ifdef CONFIG_SERIAL_CORE_CONSOLE
-#define uart_console(port)	((port)->cons && (port)->cons->index == (port)->line)
-#else
-#define uart_console(port)	(0)
-#endif
-
 static void uart_change_speed(struct tty_struct *tty, struct uart_state *state,
 					struct ktermios *old_termios);
 static void uart_wait_until_sent(struct tty_struct *tty, int timeout);
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 87d4bbc..b98291a 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -31,6 +31,13 @@
 #include <linux/sysrq.h>
 #include <uapi/linux/serial_core.h>
 
+#ifdef CONFIG_SERIAL_CORE_CONSOLE
+#define uart_console(port) \
+	((port)->cons && (port)->cons->index == (port)->line)
+#else
+#define uart_console(port)      (0)
+#endif
+
 struct uart_port;
 struct serial_struct;
 struct device;
-- 
1.7.1

