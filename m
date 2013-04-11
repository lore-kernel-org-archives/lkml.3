Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935566Ab3DKMn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 08:43:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:38398 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262Ab3DKMnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 08:43:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,454,1363158000"; 
   d="scan'208";a="284770109"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH 9/9] serial: 8250_dw: Convert to devm_ioremap()
Date: Thu, 11 Apr 2013 15:43:21 +0300
Message-Id: <1365684201-11793-1-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130411122053.GA2982@xps8300>
References: <20130411122053.GA2982@xps8300>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource managed ioremap.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/tty/serial/8250/8250_dw.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index b7c7d6a..39b7ae4 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -250,7 +250,8 @@ static int dw8250_probe(struct platform_device *pdev)
 	uart.port.flags = UPF_SHARE_IRQ | UPF_BOOT_AUTOCONF | UPF_FIXED_PORT;
 	uart.port.dev = &pdev->dev;
 
-	uart.port.membase = ioremap(regs->start, resource_size(regs));
+	uart.port.membase = devm_ioremap(&pdev->dev, regs->start,
+					 resource_size(regs));
 	if (!uart.port.membase)
 		return -ENOMEM;
 
-- 
1.7.10.4

