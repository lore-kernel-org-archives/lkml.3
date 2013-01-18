Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684Ab3ARHZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 02:25:57 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:58605 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab3ARHZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 02:25:55 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] serial: lpc32xx: Fix fallout from tty_port conversion
Date: Fri, 18 Jan 2013 08:25:51 +0100
Message-Id: <1358493951-5349-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
X-Provags-ID: V02:K0:vYlJNg/ILSG3noyfxMNwxfOwXXXytvMNWnRWCd9RVSR
 y+NjOJkHWnPl8hzoqLlfwy+M+bdHWNNOwQMzKClKFKUhyp9NAX
 LhrPXZaIn5NnV+ZYBMvZonZsIgc7tP0dp+Yp+BiuzpJFR8VrEX
 HON9n4srjZG8Gs1rFa5/cBzz6RauPmtlMw+m0fzTaodSqfJMGQ
 i5Re89fuPyMNzopllKUxfjDV3yDgNyb2jkhOGCSaa/HcHkTDH7
 lAlsrAlNpe7p9Z63Z27mTi15knsxZ/VZ8wPXNH1WDLqXHgKQep
 M1j7ltBME9ExxFHfOiRhhYDNXyJvbghBhcQyziMjANwP3DINar
 VTJdJevZgSMrOi5OjtMipvdqLveUxE0nMqTsDBUuziZrdc3OSd
 B862CccoTPp1gPXDtSFSPINtFX8MsEuEgL01vLFiAak/RP+KqW
 XpX0A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A duplicate definition of the port variable was introduced in the
interrupt handler, which causes the build to break. The fix is to
rename the variable to tport, which is already properly used in
subsequent code.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/tty/serial/lpc32xx_hs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/lpc32xx_hs.c b/drivers/tty/serial/lpc32xx_hs.c
index c01b58f..dffea6b 100644
--- a/drivers/tty/serial/lpc32xx_hs.c
+++ b/drivers/tty/serial/lpc32xx_hs.c
@@ -322,7 +322,7 @@ exit_tx:
 static irqreturn_t serial_lpc32xx_interrupt(int irq, void *dev_id)
 {
 	struct uart_port *port = dev_id;
-	struct tty_port *port = &port->state->port;
+	struct tty_port *tport = &port->state->port;
 	u32 status;
 
 	spin_lock(&port->lock);
-- 
1.8.1.1

