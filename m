Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbaLIJLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:11:50 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:62422 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbaLIJLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:11:43 -0500
From: Jiada Wang <jiada_wang@mentor.com>
To: <gregkh@linuxfoundation.org>, <jslaby@suse.cz>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <jiada_wang@mentor.com>, <anton_bondarenko@mentor.com>,
        <dirk.behme@de.bosch.com>
Subject: [PATCH v1 03/15] serial: imx: remove unneeded imx_transmit_buffer() from imx_start_tx()
Date: Tue, 9 Dec 2014 18:11:24 +0900
Message-ID: <1418116296-12082-4-git-send-email-jiada_wang@mentor.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418116296-12082-1-git-send-email-jiada_wang@mentor.com>
References: <1418116296-12082-1-git-send-email-jiada_wang@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Behme <dirk.behme@de.bosch.com>

Use imx_start_tx() just to enable the TX interrupt. It's the job of the
TX interrupt ISR to fill the transmit buffer, then. If the transmit buffer
is empty, the TX interrupt should be executed as soon as the start_tx()
enables the interrupt, so there is no reason for the extra
imx_transmit_buffer() call, here. Remove it.

Signed-off-by: Dirk Behme <dirk.behme@de.bosch.com>
Signed-off-by: Andy Lowe <andy_lowe@mentor.com>
---
 drivers/tty/serial/imx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 969bc65..be05b75 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -621,9 +621,6 @@ static void imx_start_tx(struct uart_port *port)
 			imx_dma_tx(sport);
 		return;
 	}
-
-	if (readl(sport->port.membase + uts_reg(sport)) & UTS_TXEMPTY)
-		imx_transmit_buffer(sport);
 }
 
 static irqreturn_t imx_rtsint(int irq, void *dev_id)
-- 
1.9.3

