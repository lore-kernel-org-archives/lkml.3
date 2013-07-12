Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965346Ab3GLUIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 16:08:11 -0400
Received: from smtp.outflux.net ([198.145.64.163]:53976 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965180Ab3GLUIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 16:08:09 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Landley <rob@landley.net>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-doc@vger.kernel.org,
        linux-serial@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: [PATCH 2/3] serial: report base_baud after initialization
Date: Fri, 12 Jul 2013 13:07:39 -0700
Message-Id: <1373659660-31123-2-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373659660-31123-1-git-send-email-keescook@chromium.org>
References: <1373659660-31123-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some serial ports will not use the standard base baud rate. Report
this after initialization so it might be discovered and used for early
console configuration.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/tty/serial/serial_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 28cdd28..0f02351 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2095,12 +2095,12 @@ uart_report_port(struct uart_driver *drv, struct uart_port *port)
 		break;
 	}
 
-	printk(KERN_INFO "%s%s%s%d at %s (irq = %d) is a %s\n",
+	printk(KERN_INFO "%s%s%s%d at %s (irq = %d, base_baud = %d) is a %s\n",
 	       port->dev ? dev_name(port->dev) : "",
 	       port->dev ? ": " : "",
 	       drv->dev_name,
 	       drv->tty_driver->name_base + port->line,
-	       address, port->irq, uart_type(port));
+	       address, port->irq, port->uartclk / 16, uart_type(port));
 }
 
 static void
-- 
1.7.9.5

