Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbaFFLSv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 07:18:51 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9462 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbaFFLSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 07:18:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 06 Jun 2014 04:13:37 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <gregkh@linuxfoundation.org>
CC: <swarren@wwwdotorg.org>, <linux-serial@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Pradeep Goudagunta <pgoudagunta@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/2] serial: tegra: update tx_circular buffer only when TX_DMA is in progress
Date: Fri, 6 Jun 2014 16:48:08 +0530
Message-ID: <1402053489-21262-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pradeep Goudagunta <pgoudagunta@nvidia.com>

When channel is require to stop transmit then update the Tx circular
buffer only when DMA based transfer is in progress. If there is no
DMA based transfer then no need to update the Tx buffer.

Signed-off-by: Pradeep Goudagunta <pgoudagunta@nvidia.com>
Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/tty/serial/serial-tegra.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index d5c2a28..117d8d1 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -482,6 +482,9 @@ static void tegra_uart_stop_tx(struct uart_port *u)
 	struct dma_tx_state state;
 	int count;
 
+	if (tup->tx_in_progress != TEGRA_UART_TX_DMA)
+		return;
+
 	dmaengine_terminate_all(tup->tx_dma_chan);
 	dmaengine_tx_status(tup->tx_dma_chan, tup->tx_cookie, &state);
 	count = tup->tx_bytes_requested - state.residue;
-- 
1.8.1.5

