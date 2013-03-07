Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275Ab3CGMOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 07:14:51 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:49740 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756836Ab3CGMMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 07:12:49 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: peter@hurleysoftware.com, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/16] crisv10: stop returning info from handle_ser_rx_interrupt
Date: Thu,  7 Mar 2013 13:12:35 +0100
Message-Id: <1362658360-26629-11-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
References: <1362658360-26629-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value is not used anywhere, so no need to return anything.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/serial/crisv10.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
index 50f56f3..1ace22c 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -2263,8 +2263,7 @@ TODO: The break will be delayed until an F or V character is received.
 
 */
 
-static
-struct e100_serial * handle_ser_rx_interrupt_no_dma(struct e100_serial *info)
+static void handle_ser_rx_interrupt_no_dma(struct e100_serial *info)
 {
 	unsigned long data_read;
 
@@ -2370,10 +2369,9 @@ more_data:
 	}
 
 	tty_flip_buffer_push(&info->port);
-	return info;
 }
 
-static struct e100_serial* handle_ser_rx_interrupt(struct e100_serial *info)
+static void handle_ser_rx_interrupt(struct e100_serial *info)
 {
 	unsigned char rstat;
 
@@ -2382,7 +2380,8 @@ static struct e100_serial* handle_ser_rx_interrupt(struct e100_serial *info)
 #endif
 /*	DEBUG_LOG(info->line, "ser_interrupt stat %03X\n", rstat | (i << 8)); */
 	if (!info->uses_dma_in) {
-		return handle_ser_rx_interrupt_no_dma(info);
+		handle_ser_rx_interrupt_no_dma(info);
+		return;
 	}
 	/* DMA is used */
 	rstat = info->ioport[REG_STATUS];
@@ -2489,7 +2488,6 @@ static struct e100_serial* handle_ser_rx_interrupt(struct e100_serial *info)
 	/* Restarting the DMA never hurts */
 	*info->icmdadr = IO_STATE(R_DMA_CH6_CMD, cmd, restart);
 	START_FLUSH_FAST_TIMER(info, "ser_int");
-	return info;
 } /* handle_ser_rx_interrupt */
 
 static void handle_ser_tx_interrupt(struct e100_serial *info)
-- 
1.8.1.4


