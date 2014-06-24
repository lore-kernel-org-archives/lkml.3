Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbaFXN7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 09:59:05 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39857 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbaFXN5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 09:57:49 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-e9-53a983d97cc4
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Tomasz Figa <t.figa@samsung.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 3/6] clk: samsung: exynos4: Remove SRC_MASK_ISP gates
Date: Tue, 24 Jun 2014 15:57:12 +0200
Message-id: <1403618235-19353-4-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
References: <1403618235-19353-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNJMWRmVeSWpSXmKPExsVy+t/xq7o3m1cGG0x+qW3Ru+Aqm8Wmx9dY
	LS7vmsNmMeP8PiaLtUfusls8nXCRzWL9jNcsFqt2/WF04PDYOesuu8eda3vYPDYvqffo27KK
	0ePzJrkA1igum5TUnMyy1CJ9uwSujFnPLjIXnBeo+Likm6WBcQdfFyMnh4SAiUTjh6nMELaY
	xIV769m6GLk4hASWMkqs/viTCcLpY5KYM6GBBaSKTUBN4nPDIzYQW0RAVeJz2wJ2kCJmkKKu
	zqVgCWEBV4m9/24wgtgsQEVXj74Ds3kFnCR+b+hkglgnJ9G77Q3Yak4BZ4md7dtYQWwhoJr/
	J5uYJjDyLmBkWMUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kREmBfdjAuPmZ1iFGAg1GJh/fC
	rhXBQqyJZcWVuYcYJTiYlUR4b9SsDBbiTUmsrEotyo8vKs1JLT7EyMTBKdXA6H9IKjZutebz
	dbYbJ8sdYT7wu2Bl2xETmag3zWVTNk2MXX3G7nbvul1/19sa24QfKTwasvXaAaeV5bkynqJX
	RY+F/fjTzDX5UqZ/ivGLXZOXqbJcaO95tvTJN+97e/54FfFbXJ+kE5Y/5eu7T9Wsu29PuuW4
	VX7OaRm5meZTGOoumW9vfftocqwSS3FGoqEWc1FxIgA0Wm4tDgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ISP special clocks have dedicated gating registers and so MUX SRC_MASK
register should not be used. This patch fixes the problem of
Exynos4x12-based boards freezing on system suspend, because those
mux outputs need not to be masked while suspending.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Cc: Mike Turquette <mturquette@linaro.org>
---
 drivers/clk/samsung/clk-exynos4.c | 16 ++++------------
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
1.9.3

