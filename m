Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbaCGTP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 14:15:56 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:63050 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbaCGTOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 14:14:36 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH RFC v2 08/11] tty: xuartps: Rename Kconfig symbols
Date: Fri,  7 Mar 2014 11:13:31 -0800
Message-Id: <1394219614-3197-9-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.0.1.g4196000
In-Reply-To: <1394219614-3197-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1394219614-3197-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the config symbols for the Cadence UART to reflect the driver
rebranding:
  SERIAL_XILINX_PS_UART(_CONSOLE) -> SERIAL_CADENCE_UART(_CONSOLE)

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/tty/serial/Kconfig         | 6 +++---
 drivers/tty/serial/Makefile        | 2 +-
 drivers/tty/serial/xilinx_uartps.c | 8 ++++----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 1294284342bc..8c340dbf9e53 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1367,7 +1367,7 @@ config SERIAL_MXS_AUART_CONSOLE
 	help
 	  Enable a MXS AUART port to be the system console.
 
-config SERIAL_XILINX_PS_UART
+config SERIAL_CADENCE_UART
 	tristate "Cadence (Xilinx Zynq) UART support"
 	depends on OF
 	select SERIAL_CORE
@@ -1375,9 +1375,9 @@ config SERIAL_XILINX_PS_UART
 	  This driver supports the Cadence UART. It is found e.g. in Xilinx
 	  Zynq.
 
-config SERIAL_XILINX_PS_UART_CONSOLE
+config SERIAL_CADENCE_UART_CONSOLE
 	bool "Cadence UART console support"
-	depends on SERIAL_XILINX_PS_UART=y
+	depends on SERIAL_CADENCE_UART=y
 	select SERIAL_CORE_CONSOLE
 	help
 	  Enable a Cadence UART port to be the system console.
diff --git a/drivers/tty/serial/Makefile b/drivers/tty/serial/Makefile
index 3680854fef41..4b57523a34c7 100644
--- a/drivers/tty/serial/Makefile
+++ b/drivers/tty/serial/Makefile
@@ -79,7 +79,7 @@ obj-$(CONFIG_SERIAL_PCH_UART)	+= pch_uart.o
 obj-$(CONFIG_SERIAL_MSM_SMD)	+= msm_smd_tty.o
 obj-$(CONFIG_SERIAL_MXS_AUART) += mxs-auart.o
 obj-$(CONFIG_SERIAL_LANTIQ)	+= lantiq.o
-obj-$(CONFIG_SERIAL_XILINX_PS_UART) += xilinx_uartps.o
+obj-$(CONFIG_SERIAL_CADENCE_UART) += xilinx_uartps.o
 obj-$(CONFIG_SERIAL_SIRFSOC) += sirfsoc_uart.o
 obj-$(CONFIG_SERIAL_TEGRA) += serial-tegra.o
 obj-$(CONFIG_SERIAL_AR933X)   += ar933x_uart.o
diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 0b27efef1cb6..7bfd19a7273d 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -13,7 +13,7 @@
  * still shows in the file name, function/symbol name prefixes.
  */
 
-#if defined(CONFIG_SERIAL_XILINX_PS_UART_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
+#if defined(CONFIG_SERIAL_CADENCE_UART_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
 #define SUPPORT_SYSRQ
 #endif
 
@@ -1030,7 +1030,7 @@ static struct uart_port *cdns_uart_get_port(void)
 	return port;
 }
 
-#ifdef CONFIG_SERIAL_XILINX_PS_UART_CONSOLE
+#ifdef CONFIG_SERIAL_CADENCE_UART_CONSOLE
 /**
  * cdns_uart_console_wait_tx - Wait for the TX to be full
  * @port: Handle to the uart port structure
@@ -1150,7 +1150,7 @@ static int __init cdns_uart_console_init(void)
 
 console_initcall(cdns_uart_console_init);
 
-#endif /* CONFIG_SERIAL_XILINX_PS_UART_CONSOLE */
+#endif /* CONFIG_SERIAL_CADENCE_UART_CONSOLE */
 
 static struct uart_driver cdns_uart_uart_driver = {
 	.owner		= THIS_MODULE,
@@ -1159,7 +1159,7 @@ static struct uart_driver cdns_uart_uart_driver = {
 	.major		= CDNS_UART_MAJOR,
 	.minor		= CDNS_UART_MINOR,
 	.nr		= CDNS_UART_NR_PORTS,
-#ifdef CONFIG_SERIAL_XILINX_PS_UART_CONSOLE
+#ifdef CONFIG_SERIAL_CADENCE_UART_CONSOLE
 	.cons		= &cdns_uart_console,
 #endif
 };
-- 
1.9.0.1.g4196000

