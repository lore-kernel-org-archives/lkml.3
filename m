Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759136AbaGOR1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:27:40 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:54760 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086AbaGORCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:07 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 08/94] clk: samsung: exynos4: Remove SRC_MASK_ISP gates
Date: Tue, 15 Jul 2014 20:00:23 +0300
Message-Id: <1405443709-15288-8-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

ISP special clocks have dedicated gating registers and so MUX SRC_MASK
register should not be used. This patch fixes the problem of
Exynos4x12-based boards freezing on system suspend, because those
mux outputs need not to be masked while suspending.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Cc: Mike Turquette <mturquette@linaro.org>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 drivers/clk/samsung/clk-exynos4.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
index 4f150c9..7f4a473 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -925,21 +925,13 @@ static struct samsung_gate_clock exynos4x12_gate_clks[] __initdata = {
 	GATE(CLK_RTC, "rtc", "aclk100", E4X12_GATE_IP_PERIR, 15,
 			0, 0),
 	GATE(CLK_KEYIF, "keyif", "aclk100", E4X12_GATE_IP_PERIR, 16, 0, 0),
-	GATE(CLK_SCLK_PWM_ISP, "sclk_pwm_isp", "div_pwm_isp",
-			E4X12_SRC_MASK_ISP, 0, CLK_SET_RATE_PARENT, 0),
-	GATE(CLK_SCLK_SPI0_ISP, "sclk_spi0_isp", "div_spi0_isp_pre",
-			E4X12_SRC_MASK_ISP, 4, CLK_SET_RATE_PARENT, 0),
-	GATE(CLK_SCLK_SPI1_ISP, "sclk_spi1_isp", "div_spi1_isp_pre",
-			E4X12_SRC_MASK_ISP, 8, CLK_SET_RATE_PARENT, 0),
-	GATE(CLK_SCLK_UART_ISP, "sclk_uart_isp", "div_uart_isp",
-			E4X12_SRC_MASK_ISP, 12, CLK_SET_RATE_PARENT, 0),
-	GATE(CLK_PWM_ISP_SCLK, "pwm_isp_sclk", "sclk_pwm_isp",
+	GATE(CLK_PWM_ISP_SCLK, "pwm_isp_sclk", "div_pwm_isp",
 			E4X12_GATE_IP_ISP, 0, 0, 0),
-	GATE(CLK_SPI0_ISP_SCLK, "spi0_isp_sclk", "sclk_spi0_isp",
+	GATE(CLK_SPI0_ISP_SCLK, "spi0_isp_sclk", "div_spi0_isp_pre",
 			E4X12_GATE_IP_ISP, 1, 0, 0),
-	GATE(CLK_SPI1_ISP_SCLK, "spi1_isp_sclk", "sclk_spi1_isp",
+	GATE(CLK_SPI1_ISP_SCLK, "spi1_isp_sclk", "div_spi1_isp_pre",
 			E4X12_GATE_IP_ISP, 2, 0, 0),
-	GATE(CLK_UART_ISP_SCLK, "uart_isp_sclk", "sclk_uart_isp",
+	GATE(CLK_UART_ISP_SCLK, "uart_isp_sclk", "div_uart_isp",
 			E4X12_GATE_IP_ISP, 3, 0, 0),
 	GATE(CLK_WDT, "watchdog", "aclk100", E4X12_GATE_IP_PERIR, 14, 0, 0),
 	GATE(CLK_PCM0, "pcm0", "aclk100", E4X12_GATE_IP_MAUDIO, 2,
-- 
1.7.10.4

