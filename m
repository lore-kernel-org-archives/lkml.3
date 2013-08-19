Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547Ab3HSVkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 17:40:05 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34884 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab3HSVkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 17:40:00 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        David Brown <davidb@codeaurora.org>
Subject: [PATCH 1/4] msm_serial: Switch clock consumer strings and simplify code
Date: Mon, 19 Aug 2013 14:39:54 -0700
Message-Id: <1376948397-6882-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.4.rc3.2.g2c2b664
In-Reply-To: <1376948397-6882-1-git-send-email-sboyd@codeaurora.org>
References: <1376948397-6882-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In downstream kernels we've standardized the clock consumer names
that MSM device drivers use. Replace the uart specific clock
names in this driver with the more standard 'core_clk' and
'iface_clk' names. Also simplify the code by assuming that
clk_prepare_enable() and clk_disable_unprepare() will properly
check for NULL pointers (it will because MSM uses the common
clock framework).

Cc: David Brown <davidb@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/devices-msm7x00.c |  6 +++---
 arch/arm/mach-msm/devices-msm7x30.c |  2 +-
 arch/arm/mach-msm/devices-qsd8x50.c |  6 +++---
 drivers/tty/serial/msm_serial.c     | 19 +++++--------------
 4 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mach-msm/devices-msm7x00.c b/arch/arm/mach-msm/devices-msm7x00.c
index 6d50fb9..aa2a3c7 100644
--- a/arch/arm/mach-msm/devices-msm7x00.c
+++ b/arch/arm/mach-msm/devices-msm7x00.c
@@ -456,9 +456,9 @@ static struct clk_pcom_desc msm_clocks_7x01a[] = {
 	CLK_PCOM("tsif_ref_clk",	TSIF_REF_CLK,	NULL, 0),
 	CLK_PCOM("tv_dac_clk",	TV_DAC_CLK,	NULL, 0),
 	CLK_PCOM("tv_enc_clk",	TV_ENC_CLK,	NULL, 0),
-	CLK_PCOM("uart_clk",	UART1_CLK,	"msm_serial.0", OFF),
-	CLK_PCOM("uart_clk",	UART2_CLK,	"msm_serial.1", 0),
-	CLK_PCOM("uart_clk",	UART3_CLK,	"msm_serial.2", OFF),
+	CLK_PCOM("core_clk",	UART1_CLK,	"msm_serial.0", OFF),
+	CLK_PCOM("core_clk",	UART2_CLK,	"msm_serial.1", 0),
+	CLK_PCOM("core_clk",	UART3_CLK,	"msm_serial.2", OFF),
 	CLK_PCOM("uart1dm_clk",	UART1DM_CLK,	NULL, OFF),
 	CLK_PCOM("uart2dm_clk",	UART2DM_CLK,	NULL, 0),
 	CLK_PCOM("usb_hs_clk",	USB_HS_CLK,	"msm_hsusb", OFF),
diff --git a/arch/arm/mach-msm/devices-msm7x30.c b/arch/arm/mach-msm/devices-msm7x30.c
index d4db75a..597251e 100644
--- a/arch/arm/mach-msm/devices-msm7x30.c
+++ b/arch/arm/mach-msm/devices-msm7x30.c
@@ -211,7 +211,7 @@ static struct clk_pcom_desc msm_clocks_7x30[] = {
 	CLK_PCOM("spi_pclk",	SPI_P_CLK,	NULL, 0),
 	CLK_PCOM("tv_dac_clk",	TV_DAC_CLK,	NULL, 0),
 	CLK_PCOM("tv_enc_clk",	TV_ENC_CLK,	NULL, 0),
-	CLK_PCOM("uart_clk",	UART2_CLK,	"msm_serial.1", 0),
+	CLK_PCOM("core_clk",	UART2_CLK,	"msm_serial.1", 0),
 	CLK_PCOM("usb_phy_clk",	USB_PHY_CLK,	NULL, 0),
 	CLK_PCOM("usb_hs_clk",		USB_HS_CLK,		NULL, OFF),
 	CLK_PCOM("usb_hs_pclk",		USB_HS_P_CLK,		NULL, OFF),
diff --git a/arch/arm/mach-msm/devices-qsd8x50.c b/arch/arm/mach-msm/devices-qsd8x50.c
index f551811..b7344a4 100644
--- a/arch/arm/mach-msm/devices-qsd8x50.c
+++ b/arch/arm/mach-msm/devices-qsd8x50.c
@@ -358,9 +358,9 @@ static struct clk_pcom_desc msm_clocks_8x50[] = {
 	CLK_PCOM("tsif_ref_clk",	TSIF_REF_CLK,	NULL, 0),
 	CLK_PCOM("tv_dac_clk",	TV_DAC_CLK,	NULL, 0),
 	CLK_PCOM("tv_enc_clk",	TV_ENC_CLK,	NULL, 0),
-	CLK_PCOM("uart_clk",	UART1_CLK,	NULL, OFF),
-	CLK_PCOM("uart_clk",	UART2_CLK,	NULL, 0),
-	CLK_PCOM("uart_clk",	UART3_CLK,	"msm_serial.2", OFF),
+	CLK_PCOM("core_clk",	UART1_CLK,	NULL, OFF),
+	CLK_PCOM("core_clk",	UART2_CLK,	NULL, 0),
+	CLK_PCOM("core_clk",	UART3_CLK,	"msm_serial.2", OFF),
 	CLK_PCOM("uartdm_clk",	UART1DM_CLK,	NULL, OFF),
 	CLK_PCOM("uartdm_clk",	UART2DM_CLK,	NULL, 0),
 	CLK_PCOM("usb_hs_clk",	USB_HS_CLK,	NULL, OFF),
diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index 97642ec..7631313 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -416,8 +416,7 @@ static void msm_init_clock(struct uart_port *port)
 	struct msm_port *msm_port = UART_TO_MSM(port);
 
 	clk_prepare_enable(msm_port->clk);
-	if (!IS_ERR(msm_port->pclk))
-		clk_prepare_enable(msm_port->pclk);
+	clk_prepare_enable(msm_port->pclk);
 	msm_serial_set_mnd_regs(port);
 }
 
@@ -693,13 +692,11 @@ static void msm_power(struct uart_port *port, unsigned int state,
 	switch (state) {
 	case 0:
 		clk_prepare_enable(msm_port->clk);
-		if (!IS_ERR(msm_port->pclk))
-			clk_prepare_enable(msm_port->pclk);
+		clk_prepare_enable(msm_port->pclk);
 		break;
 	case 3:
 		clk_disable_unprepare(msm_port->clk);
-		if (!IS_ERR(msm_port->pclk))
-			clk_disable_unprepare(msm_port->pclk);
+		clk_disable_unprepare(msm_port->pclk);
 		break;
 	default:
 		printk(KERN_ERR "msm_serial: Unknown PM state %d\n", state);
@@ -887,18 +884,12 @@ static int __init msm_serial_probe(struct platform_device *pdev)
 	else
 		msm_port->is_uartdm = 0;
 
-	if (msm_port->is_uartdm) {
-		msm_port->clk = devm_clk_get(&pdev->dev, "gsbi_uart_clk");
-		msm_port->pclk = devm_clk_get(&pdev->dev, "gsbi_pclk");
-	} else {
-		msm_port->clk = devm_clk_get(&pdev->dev, "uart_clk");
-		msm_port->pclk = ERR_PTR(-ENOENT);
-	}
-
+	msm_port->clk = devm_clk_get(&pdev->dev, "core_clk");
 	if (IS_ERR(msm_port->clk))
 		return PTR_ERR(msm_port->clk);
 
 	if (msm_port->is_uartdm) {
+		msm_port->pclk = devm_clk_get(&pdev->dev, "iface_clk");
 		if (IS_ERR(msm_port->pclk))
 			return PTR_ERR(msm_port->pclk);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

