Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbaJHT6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 15:58:12 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:56215 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaJHT6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:58:10 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 01/12] serial/max310x: Remove obsolete #ifset TIOC[SG]RS485
Date: Wed,  8 Oct 2014 21:57:27 +0200
Message-Id: <1412798258-23655-2-git-send-email-ricardo.ribalda@gmail.com>
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
 drivers/tty/serial/max310x.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index 82573dc..670aba4 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -877,7 +877,6 @@ static void max310x_set_termios(struct uart_port *port,
 static int max310x_ioctl(struct uart_port *port, unsigned int cmd,
 			 unsigned long arg)
 {
-#if defined(TIOCSRS485) && defined(TIOCGRS485)
 	struct serial_rs485 rs485;
 	unsigned int val;
 
@@ -920,7 +919,6 @@ static int max310x_ioctl(struct uart_port *port, unsigned int cmd,
 	default:
 		break;
 	}
-#endif
 
 	return -ENOIOCTLCMD;
 }
-- 
2.1.1

