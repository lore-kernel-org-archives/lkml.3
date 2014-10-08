Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbaJHT6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 15:58:16 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:53225 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691AbaJHT6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:58:13 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 02/12] serial/sc16is7xx: Remove obsolete #ifset TIOC[SG]RS485
Date: Wed,  8 Oct 2014 21:57:28 +0200
Message-Id: <1412798258-23655-3-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1412798258-23655-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1412798258-23655-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e676253b19b2 ("serial/8250: Add support for RS485 IOCTLs") added
references to TIOC[SG]RS48 on 8250_core.c. This change triggered the
need to define them in all the arches that uses tty/serial.

This made #ifdef TIOC[SG]RS48 obsolete.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/tty/serial/sc16is7xx.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 3284c31..3ab5d1b 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -830,7 +830,6 @@ static void sc16is7xx_set_termios(struct uart_port *port,
 	uart_update_timeout(port, termios->c_cflag, baud);
 }
 
-#if defined(TIOCSRS485) && defined(TIOCGRS485)
 static void sc16is7xx_config_rs485(struct uart_port *port,
 				   struct serial_rs485 *rs485)
 {
@@ -848,12 +847,10 @@ static void sc16is7xx_config_rs485(struct uart_port *port,
 				      0);
 	}
 }
-#endif
 
 static int sc16is7xx_ioctl(struct uart_port *port, unsigned int cmd,
 			   unsigned long arg)
 {
-#if defined(TIOCSRS485) && defined(TIOCGRS485)
 	struct serial_rs485 rs485;
 
 	switch (cmd) {
@@ -872,7 +869,6 @@ static int sc16is7xx_ioctl(struct uart_port *port, unsigned int cmd,
 	default:
 		break;
 	}
-#endif
 
 	return -ENOIOCTLCMD;
 }
-- 
2.1.1

