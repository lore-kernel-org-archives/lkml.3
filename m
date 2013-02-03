Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab3BCPPx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:15:53 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34282 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754178Ab3BCO4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:56:06 -0500
Message-Id: <20130203144648.837868768@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:38 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 054/128] tty: 8250_dw: Fix inverted arguments to serial_out in IRQ handler
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <maxime.ripard@free-electrons.com>

commit 68e56cb3a068f9c30971c6117fbbd1e32918e49e upstream.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/serial/8250/8250_dw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/8250_dw.c
+++ b/drivers/tty/serial/8250_dw.c
@@ -79,7 +79,7 @@ static int dw8250_handle_irq(struct uart
 	} else if ((iir & UART_IIR_BUSY) == UART_IIR_BUSY) {
 		/* Clear the USR and write the LCR again. */
 		(void)p->serial_in(p, UART_USR);
-		p->serial_out(p, d->last_lcr, UART_LCR);
+		p->serial_out(p, UART_LCR, d->last_lcr);
 
 		return 1;
 	}


