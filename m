Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936841Ab3DJN7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:59:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:65142 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936781Ab3DJN6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:58:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,447,1363158000"; 
   d="scan'208";a="284281455"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH 8/9] serial: 8250_dw: Set port capabilities based on CPR register
Date: Wed, 10 Apr 2013 16:58:31 +0300
Message-Id: <1365602312-25436-9-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365602312-25436-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1365602312-25436-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Designware UART has an optional support for 16750
compatible Auto Flow Control. This will enable it based on
the AFCE bit in Component Parameter Register.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/tty/serial/8250/8250_dw.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index 09aaea2..b7c7d6a 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -221,7 +221,11 @@ static void dw8250_setup_port(struct uart_8250_port *up)
 		p->flags |= UPF_FIXED_TYPE;
 		p->fifosize = DW_UART_CPR_FIFO_SIZE(reg);
 		up->tx_loadsz = p->fifosize;
+		up->capabilities = UART_CAP_FIFO;
 	}
+
+	if (reg & DW_UART_CPR_AFCE_MODE)
+		up->capabilities |= UART_CAP_AFE;
 }
 
 static int dw8250_probe(struct platform_device *pdev)
-- 
1.7.10.4

