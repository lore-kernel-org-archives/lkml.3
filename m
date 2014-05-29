Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbaE2KNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 06:13:54 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:51477 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbaE2KNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 06:13:52 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, Jiri Slaby <jslaby@suse.cz>,
        Barry Song <baohua@kernel.org>, Qipan Li <Qipan.Li@csr.com>,
        linux-serial@vger.kernel.org
Subject: [PATCH tty-next] serial: sirf: Fix compilation failure
Date: Thu, 29 May 2014 11:13:43 +0100
Message-Id: <1401358423-31532-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396010535-2654-1-git-send-email-daniel.thompson@linaro.org>
References: <1396010535-2654-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After 07d410e0) serial: sirf: fix spinlock deadlock issue it is no longer
possiblet to compile this driver. The rename of one of the spinlocks is
faulty. After looking at the original patch I believe this is the correct
fix.

Compile tested using ARM's multi_v7_defconfig

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Barry Song <baohua@kernel.org>
Cc: Qipan Li <Qipan.Li@csr.com>
Cc: linux-serial@vger.kernel.org
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---

Notes:
    Sorry to resend within a few minutes. Patch is identical to parent but the
    subject line has been corrected. The original 'v6' was just utterly
    wrong! This patch is a not-previously-shared patch to fix a build
    regression that appears in tty-next.

 drivers/tty/serial/sirfsoc_uart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/sirfsoc_uart.c b/drivers/tty/serial/sirfsoc_uart.c
index 236f892..1f2be48 100644
--- a/drivers/tty/serial/sirfsoc_uart.c
+++ b/drivers/tty/serial/sirfsoc_uart.c
@@ -704,7 +704,7 @@ static void sirfsoc_uart_rx_dma_complete_tl(unsigned long param)
 	struct sirfsoc_int_en *uint_en = &sirfport->uart_reg->uart_int_en;
 	unsigned long flags;
 	struct dma_tx_state tx_state;
-	spin_lock_irqsave(&port->rx_lock, flags);
+	spin_lock_irqsave(&port->lock, flags);
 	while (DMA_COMPLETE == dmaengine_tx_status(sirfport->rx_dma_chan,
 			sirfport->rx_dma_items[sirfport->rx_completed].cookie, &tx_state)) {
 		sirfsoc_uart_insert_rx_buf_to_tty(sirfport,
-- 
1.9.0

