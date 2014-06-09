Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784AbaFIJRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:17:45 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58396 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754832AbaFIIvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Loic Poulain <loic.poulain@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 023/146] 8250_core: Fix unwanted TX chars write
Date: Mon,  9 Jun 2014 10:49:18 +0200
Message-Id: <9ebff4b62caaf11ad6a701f8c4905411410b7728.1402303820.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Loic Poulain <loic.poulain@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b08c9c317e3f7764a91d522cd031639ba42b98cc upstream.

On transmit-hold-register empty, serial8250_tx_chars
should be called only if we don't use DMA.
DMA has its own tx cycle.

Signed-off-by: Loic Poulain <loic.poulain@intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/serial/8250/8250_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index aa6db8f4ee18..bf9d2ac9c9ed 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -1520,7 +1520,7 @@ int serial8250_handle_irq(struct uart_port *port, unsigned int iir)
 			status = serial8250_rx_chars(up, status);
 	}
 	serial8250_modem_status(up);
-	if (status & UART_LSR_THRE)
+	if (!up->dma && (status & UART_LSR_THRE))
 		serial8250_tx_chars(up);
 
 	spin_unlock_irqrestore(&port->lock, flags);
-- 
1.9.3

