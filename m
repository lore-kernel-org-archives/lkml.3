Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843Ab3JFGaW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 02:30:22 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51239 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751359Ab3JFGaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 02:30:21 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: gregkh@linuxfoundation.org, jslaby@suse.cz, swarren@wwwdotorg.org
Cc: linux-serial@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] serial: tegra: remove deprecated IRQF_DISABLED
Date: Sun,  6 Oct 2013 08:30:17 +0200
Message-Id: <1381041017-12806-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/tty/serial/serial-tegra.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index 0489a2b..dfe79cc 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -1018,7 +1018,7 @@ static int tegra_uart_startup(struct uart_port *u)
 		goto fail_hw_init;
 	}
 
-	ret = request_irq(u->irq, tegra_uart_isr, IRQF_DISABLED,
+	ret = request_irq(u->irq, tegra_uart_isr, 0,
 				dev_name(u->dev), tup);
 	if (ret < 0) {
 		dev_err(u->dev, "Failed to register ISR for IRQ %d\n", u->irq);
-- 
1.8.1.2

