Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab3ANTJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 14:09:34 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:58463 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756440Ab3ANTJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 14:09:33 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH] tty: 8250_dw: Fix inverted arguments to serial_out in IRQ handler
Date: Mon, 14 Jan 2013 20:09:26 +0100
Message-Id: <1358190567-6304-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/tty/serial/8250/8250_dw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index 1d0dba2..096d2ef 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -79,7 +79,7 @@ static int dw8250_handle_irq(struct uart_port *p)
 	} else if ((iir & UART_IIR_BUSY) == UART_IIR_BUSY) {
 		/* Clear the USR and write the LCR again. */
 		(void)p->serial_in(p, UART_USR);
-		p->serial_out(p, d->last_lcr, UART_LCR);
+		p->serial_out(p, UART_LCR, d->last_lcr);
 
 		return 1;
 	}
-- 
1.7.10.4

