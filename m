Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbaFPNRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:17:51 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:41028 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751389AbaFPNRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:17:49 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH tty-next 08/22] serial: Use UPF_* constants with struct uart_port flags
Date: Mon, 16 Jun 2014 09:17:05 -0400
Message-Id: <1402924639-5164-9-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
References: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix ASYNC_* constant usage that should be the corresponding UPF_*
constant.

CC: Grant Likely <grant.likely@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>
CC: devicetree@vger.kernel.org
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/lantiq.c | 2 +-
 drivers/tty/serial/mcf.c    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/lantiq.c b/drivers/tty/serial/lantiq.c
index 88d01e0..6e29b01 100644
--- a/drivers/tty/serial/lantiq.c
+++ b/drivers/tty/serial/lantiq.c
@@ -709,7 +709,7 @@ lqasc_probe(struct platform_device *pdev)
 	port = &ltq_port->port;
 
 	port->iotype	= SERIAL_IO_MEM;
-	port->flags	= ASYNC_BOOT_AUTOCONF | UPF_IOREMAP;
+	port->flags	= UPF_BOOT_AUTOCONF | UPF_IOREMAP;
 	port->ops	= &lqasc_pops;
 	port->fifosize	= 16;
 	port->type	= PORT_LTQ_ASC,
diff --git a/drivers/tty/serial/mcf.c b/drivers/tty/serial/mcf.c
index 0edfaf8..1e59faf 100644
--- a/drivers/tty/serial/mcf.c
+++ b/drivers/tty/serial/mcf.c
@@ -538,7 +538,7 @@ int __init early_mcf_setup(struct mcf_platform_uart *platp)
 		port->iotype = SERIAL_IO_MEM;
 		port->irq = platp[i].irq;
 		port->uartclk = MCF_BUSCLK;
-		port->flags = ASYNC_BOOT_AUTOCONF;
+		port->flags = UPF_BOOT_AUTOCONF;
 		port->ops = &mcf_uart_ops;
 	}
 
@@ -663,7 +663,7 @@ static int mcf_probe(struct platform_device *pdev)
 		port->irq = platp[i].irq;
 		port->uartclk = MCF_BUSCLK;
 		port->ops = &mcf_uart_ops;
-		port->flags = ASYNC_BOOT_AUTOCONF;
+		port->flags = UPF_BOOT_AUTOCONF;
 
 		uart_add_one_port(&mcf_driver, port);
 	}
-- 
2.0.0

