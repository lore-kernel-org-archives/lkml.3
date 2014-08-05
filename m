Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380AbaHEH41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 03:56:27 -0400
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:50351 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932363AbaHEH4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 03:56:24 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: davidb@codeaurora.org
Cc: dwalker@fifo99.com, bryanh@codeaurora.org, sboyd@codeaurora.org,
        gregkh@linuxfoundation.org, jslaby@suse.cz,
        kiran.padwal@smartplayin.com, linux-arm-msm@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] tty: serial: msm: Fix style warnings relating to printk()
Date: Tue,  5 Aug 2014 13:22:01 +0530
Message-Id: <1407225124-25074-4-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1407225124-25074-1-git-send-email-kiran.padwal@smartplayin.com>
References: <1407225124-25074-1-git-send-email-kiran.padwal@smartplayin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch.pl warning:

WARNING: Prefer [subsystem eg: netdev]_err([subsystem]dev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

WARNING: Prefer [subsystem eg: netdev]_info([subsystem]dev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
 drivers/tty/serial/msm_serial.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index 0295493..e70d4e8 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -677,7 +677,7 @@ static void msm_power(struct uart_port *port, unsigned int state,
 		clk_disable_unprepare(msm_port->pclk);
 		break;
 	default:
-		printk(KERN_ERR "msm_serial: Unknown PM state %d\n", state);
+		pr_err("msm_serial: Unknown PM state %d\n", state);
 	}
 }
 
@@ -957,7 +957,7 @@ static int __init msm_console_setup(struct console *co, char *options)
 		msm_write(port, UART_CR_TX_ENABLE, UART_CR);
 	}
 
-	printk(KERN_INFO "msm_serial: console setup on port #%d\n", port->line);
+	pr_info("msm_serial: console setup on port #%d\n", port->line);
 
 	return uart_set_options(port, co, baud, parity, bits, flow);
 }
@@ -1012,7 +1012,7 @@ static int msm_serial_probe(struct platform_device *pdev)
 	if (unlikely(pdev->id < 0 || pdev->id >= UART_NR))
 		return -ENXIO;
 
-	printk(KERN_INFO "msm_serial: detected port #%d\n", pdev->id);
+	dev_info(&pdev->dev, "msm_serial: detected port #%d\n", pdev->id);
 
 	port = get_port_from_line(pdev->id);
 	port->dev = &pdev->dev;
@@ -1037,8 +1037,7 @@ static int msm_serial_probe(struct platform_device *pdev)
 	}
 
 	port->uartclk = clk_get_rate(msm_port->clk);
-	printk(KERN_INFO "uartclk = %d\n", port->uartclk);
-
+	dev_info(&pdev->dev, "uartclk = %d\n", port->uartclk);
 
 	resource = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (unlikely(!resource))
@@ -1092,7 +1091,7 @@ static int __init msm_serial_init(void)
 	if (unlikely(ret))
 		uart_unregister_driver(&msm_uart_driver);
 
-	printk(KERN_INFO "msm_serial: driver initialized\n");
+	pr_info("msm_serial: driver initialized\n");
 
 	return ret;
 }
-- 
1.7.9.5

