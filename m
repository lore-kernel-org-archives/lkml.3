Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab3ASB23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:28:29 -0500
Received: from mail.kernel.org ([198.145.19.201]:56875 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756114Ab3ASBT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:19:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [ 19/21] tty: 8250_dw: Fix inverted arguments to serial_out in IRQ handler
Date: Fri, 18 Jan 2013 17:19:37 -0800
Message-Id: <20130119010714.537381066@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130119010710.897187774@linuxfoundation.org>
References: <20130119010710.897187774@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <maxime.ripard@free-electrons.com>

commit 68e56cb3a068f9c30971c6117fbbd1e32918e49e upstream.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/8250/8250_dw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -79,7 +79,7 @@ static int dw8250_handle_irq(struct uart
 	} else if ((iir & UART_IIR_BUSY) == UART_IIR_BUSY) {
 		/* Clear the USR and write the LCR again. */
 		(void)p->serial_in(p, UART_USR);
-		p->serial_out(p, d->last_lcr, UART_LCR);
+		p->serial_out(p, UART_LCR, d->last_lcr);
 
 		return 1;
 	}


