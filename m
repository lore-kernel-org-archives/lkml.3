Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab3FQRph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:45:37 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41489 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab3FQRnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:43:21 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH/RESEND 01/12] msm_serial: Convert to clk_prepare/unprepare
Date: Mon, 17 Jun 2013 10:43:08 -0700
Message-Id: <1371490999-15501-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.1.378.g9926f66
In-Reply-To: <1371490999-15501-1-git-send-email-sboyd@codeaurora.org>
References: <1371490999-15501-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add calls to clk_prepare and unprepare so that MSM can migrate to
the common clock framework.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/tty/serial/msm_serial.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index b11e997..0149603 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -408,9 +408,9 @@ static void msm_init_clock(struct uart_port *port)
 {
 	struct msm_port *msm_port = UART_TO_MSM(port);
 
-	clk_enable(msm_port->clk);
+	clk_prepare_enable(msm_port->clk);
 	if (!IS_ERR(msm_port->pclk))
-		clk_enable(msm_port->pclk);
+		clk_prepare_enable(msm_port->pclk);
 	msm_serial_set_mnd_regs(port);
 }
 
@@ -486,7 +486,7 @@ static void msm_shutdown(struct uart_port *port)
 	msm_port->imr = 0;
 	msm_write(port, 0, UART_IMR); /* disable interrupts */
 
-	clk_disable(msm_port->clk);
+	clk_disable_unprepare(msm_port->clk);
 
 	free_irq(port->irq, port);
 }
@@ -688,14 +688,14 @@ static void msm_power(struct uart_port *port, unsigned int state,
 
 	switch (state) {
 	case 0:
-		clk_enable(msm_port->clk);
+		clk_prepare_enable(msm_port->clk);
 		if (!IS_ERR(msm_port->pclk))
-			clk_enable(msm_port->pclk);
+			clk_prepare_enable(msm_port->pclk);
 		break;
 	case 3:
-		clk_disable(msm_port->clk);
+		clk_disable_unprepare(msm_port->clk);
 		if (!IS_ERR(msm_port->pclk))
-			clk_disable(msm_port->pclk);
+			clk_disable_unprepare(msm_port->pclk);
 		break;
 	default:
 		printk(KERN_ERR "msm_serial: Unknown PM state %d\n", state);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

