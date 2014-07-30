Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbaG3Mot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:44:49 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36634 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752751AbaG3MPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Thompson <daniel.thompson@linaro.org>,
        Jiri Slaby <jslaby@suse.cz>, Qipan Li <Qipan.Li@csr.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 3.12 04/94] serial: sirf: Fix compilation failure
Date: Wed, 30 Jul 2014 14:13:53 +0200
Message-Id: <a2c27add78eb2823f4fc588cc851327f8b5644e1.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Thompson <daniel.thompson@linaro.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

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

