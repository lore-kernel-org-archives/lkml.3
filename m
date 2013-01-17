Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab3AQMpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 07:45:47 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:25808
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755606Ab3AQMpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 07:45:44 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h1155h)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <gregkh@linuxfoundation.org>
CC: <jslaby@suse.cz>, <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] serial: imx: Remove unused 'tty' variable
Date: Thu, 17 Jan 2013 10:45:13 -0200
Message-ID: <1358426713-16780-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2e124b4a39 (TTY: switch tty_flip_buffer_push) introduced the following 
build warning:

drivers/tty/serial/imx.c:519:21: warning: unused variable 'tty' [-Wunused-variable]

Remove the unused 'tty' variable.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/tty/serial/imx.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index be26345..a220f77 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -516,7 +516,6 @@ static irqreturn_t imx_rxint(int irq, void *dev_id)
 {
 	struct imx_port *sport = dev_id;
 	unsigned int rx, flg, ignored = 0;
-	struct tty_struct *tty = sport->port.state->port.tty;
 	struct tty_port *port = &sport->port.state->port;
 	unsigned long flags, temp;
 
-- 
1.7.9.5


