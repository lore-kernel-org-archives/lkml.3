Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbaL3N2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 08:28:05 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:46371 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbaL3N2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 08:28:03 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH] serial: mcf: Remove unused variables
Date: Tue, 30 Dec 2014 08:27:47 -0500
Message-Id: <1419946067-8533-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'pp' is unused in mcf_set_termios() and mcf_config_rs485().

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/mcf.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/tty/serial/mcf.c b/drivers/tty/serial/mcf.c
index 1049667..1ca67d0 100644
--- a/drivers/tty/serial/mcf.c
+++ b/drivers/tty/serial/mcf.c
@@ -198,7 +198,6 @@ static void mcf_shutdown(struct uart_port *port)
 static void mcf_set_termios(struct uart_port *port, struct ktermios *termios,
 	struct ktermios *old)
 {
-	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
 	unsigned long flags;
 	unsigned int baud, baudclk;
 #if defined(CONFIG_M5272)
@@ -441,7 +440,6 @@ static int mcf_verify_port(struct uart_port *port, struct serial_struct *ser)
 /* Enable or disable the RS485 support */
 static int mcf_config_rs485(struct uart_port *port, struct serial_rs485 *rs485)
 {
-	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
 	unsigned char mr1, mr2;
 
 	/* Get mode registers */
-- 
2.2.1

