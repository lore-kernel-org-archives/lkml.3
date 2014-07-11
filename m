Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbaGKQPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:15:31 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:50187 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553AbaGKQNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:13:37 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Kosina <trivial@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH v2 trivial 4/6] serial: pch_uart: Update error message for dmaengine_prep_slave_sg() API
Date: Fri, 11 Jul 2014 18:13:26 +0200
Message-Id: <1405095208-14642-4-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405095208-14642-1-git-send-email-geert+renesas@glider.be>
References: <1405095208-14642-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 16052827d98fbc13c31ebad560af4bd53e2b4dd5 ("dmaengine/dma_slave:
introduce inline wrappers") changed the code to use the new API, but forgot
to update an error message.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: linux-serial@vger.kernel.org
--
v2:
  - New
---
 drivers/tty/serial/pch_uart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 0cb6a8e52bd0..2f06e5a71396 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1047,7 +1047,7 @@ static unsigned int dma_handle_tx(struct eg20t_port *priv)
 					priv->sg_tx_p, nent, DMA_MEM_TO_DEV,
 					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!desc) {
-		dev_err(priv->port.dev, "%s:device_prep_slave_sg Failed\n",
+		dev_err(priv->port.dev, "%s:dmaengine_prep_slave_sg Failed\n",
 			__func__);
 		return 0;
 	}
-- 
1.9.1

