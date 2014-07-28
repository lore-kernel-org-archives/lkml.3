Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbaG1HuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 03:50:14 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51636 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751766AbaG1HuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 03:50:08 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Thompson <daniel.thompson@linaro.org>,
        Jiri Slaby <jslaby@suse.cz>, Qipan Li <Qipan.Li@csr.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [patch added to the 3.12 stable tree] serial: sirf: Fix compilation failure
Date: Mon, 28 Jul 2014 09:50:05 +0200
Message-Id: <1406533805-8321-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Thompson <daniel.thompson@linaro.org>

This patch has been added to the 3.12 stable tree. If you have any
objections, please let us know.

===============

commit 58eb97c99da6a82c556ddec70683eb3863d4f617 upstream.

After 07d410e0) serial: sirf: fix spinlock deadlock issue it is no longer
possiblet to compile this driver. The rename of one of the spinlocks is
faulty. After looking at the original patch I believe this is the correct
fix.

Compile tested using ARM's multi_v7_defconfig

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Qipan Li <Qipan.Li@csr.com>
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Acked-by: Barry Song <baohua@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/serial/sirfsoc_uart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/sirfsoc_uart.c b/drivers/tty/serial/sirfsoc_uart.c
index ef61908cf9c3..25aecf0fa339 100644
--- a/drivers/tty/serial/sirfsoc_uart.c
+++ b/drivers/tty/serial/sirfsoc_uart.c
@@ -700,7 +700,7 @@ static void sirfsoc_uart_rx_dma_complete_tl(unsigned long param)
 	struct sirfsoc_uart_port *sirfport = (struct sirfsoc_uart_port *)param;
 	struct uart_port *port = &sirfport->port;
 	unsigned long flags;
-	spin_lock_irqsave(&port->rx_lock, flags);
+	spin_lock_irqsave(&port->lock, flags);
 	while (sirfport->rx_completed != sirfport->rx_issued) {
 		sirfsoc_uart_insert_rx_buf_to_tty(sirfport,
 					SIRFSOC_RX_DMA_BUF_SIZE);
-- 
2.0.1

