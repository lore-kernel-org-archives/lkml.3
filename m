Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759204AbaGOR1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:27:50 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:64479 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012AbaGORCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:07 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>,
        Tomasz Figa <t.figa@samsung.com>, sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 11/94] clk: exynos5420: Remove aclk66_peric from the clock tree description
Date: Tue, 15 Jul 2014 20:00:26 +0300
Message-Id: <1405443709-15288-11-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Anderson <dianders@chromium.org>

The "aclk66_peric" clock is a gate clock with a whole bunch of gates
underneath it.  This big gate isn't very useful to include in our
clock tree.  If any of the children need to be turned on then the big
gate will need to be on anyway.  ...and there are plenty of other "big
gates" that aren't described in our clock tree, some of which shut off
collections of clocks that have no relationship in the hierarchy so
are hard to model.

"aclk66_peric" is causing earlyprintk problems since it gets disabled
as part of the boot process, so let's just remove it.

Strangely (and for no good reason) this clock is exported as part of
the common clock bindings.  Remove it since there are no in-kernel
device trees using it and no reason anyone out of tree should refer to
it either.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 drivers/clk/samsung/clk-exynos5420.c   |   85 +++++++++++++++++++++-----------
 include/dt-bindings/clock/exynos5420.h |    1 -
 2 files changed, 55 insertions(+), 31 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos5420.c b/drivers/clk/samsung/clk-exynos5420.c
index 9d7d7ee..61eccf0 100644
--- a/drivers/clk/samsung/clk-exynos5420.c
+++ b/drivers/clk/samsung/clk-exynos5420.c
@@ -890,8 +890,6 @@ static struct samsung_gate_clock exynos5x_gate_clks[] __initdata = {
 			GATE_BUS_TOP, 9, CLK_IGNORE_UNUSED, 0),
 	GATE(0, "aclk66_psgen", "mout_user_aclk66_psgen",
 			GATE_BUS_TOP, 10, CLK_IGNORE_UNUSED, 0),
-	GATE(CLK_ACLK66_PERIC, "aclk66_peric", "mout_user_aclk66_peric",
-			GATE_BUS_TOP, 11, CLK_IGNORE_UNUSED, 0),
 	GATE(0, "aclk266_isp", "mout_user_aclk266_isp",
 			GATE_BUS_TOP, 13, 0, 0),
 	GATE(0, "aclk166", "mout_user_aclk166",
@@ -994,34 +992,61 @@ static struct samsung_gate_clock exynos5x_gate_clks[] __initdata = {
 			SRC_MASK_FSYS, 24, CLK_SET_RATE_PARENT, 0),
 
 	/* PERIC Block */
-	GATE(CLK_UART0, "uart0", "aclk66_peric", GATE_IP_PERIC, 0, 0, 0),
-	GATE(CLK_UART1, "uart1", "aclk66_peric", GATE_IP_PERIC, 1, 0, 0),
-	GATE(CLK_UART2, "uart2", "aclk66_peric", GATE_IP_PERIC, 2, 0, 0),
-	GATE(CLK_UART3, "uart3", "aclk66_peric", GATE_IP_PERIC, 3, 0, 0),
-	GATE(CLK_I2C0, "i2c0", "aclk66_peric", GATE_IP_PERIC, 6, 0, 0),
-	GATE(CLK_I2C1, "i2c1", "aclk66_peric", GATE_IP_PERIC, 7, 0, 0),
-	GATE(CLK_I2C2, "i2c2", "aclk66_peric", GATE_IP_PERIC, 8, 0, 0),
-	GATE(CLK_I2C3, "i2c3", "aclk66_peric", GATE_IP_PERIC, 9, 0, 0),
-	GATE(CLK_USI0, "usi0", "aclk66_peric", GATE_IP_PERIC, 10, 0, 0),
-	GATE(CLK_USI1, "usi1", "aclk66_peric", GATE_IP_PERIC, 11, 0, 0),
-	GATE(CLK_USI2, "usi2", "aclk66_peric", GATE_IP_PERIC, 12, 0, 0),
-	GATE(CLK_USI3, "usi3", "aclk66_peric", GATE_IP_PERIC, 13, 0, 0),
-	GATE(CLK_I2C_HDMI, "i2c_hdmi", "aclk66_peric", GATE_IP_PERIC, 14, 0, 0),
-	GATE(CLK_TSADC, "tsadc", "aclk66_peric", GATE_IP_PERIC, 15, 0, 0),
-	GATE(CLK_SPI0, "spi0", "aclk66_peric", GATE_IP_PERIC, 16, 0, 0),
-	GATE(CLK_SPI1, "spi1", "aclk66_peric", GATE_IP_PERIC, 17, 0, 0),
-	GATE(CLK_SPI2, "spi2", "aclk66_peric", GATE_IP_PERIC, 18, 0, 0),
-	GATE(CLK_I2S1, "i2s1", "aclk66_peric", GATE_IP_PERIC, 20, 0, 0),
-	GATE(CLK_I2S2, "i2s2", "aclk66_peric", GATE_IP_PERIC, 21, 0, 0),
-	GATE(CLK_PCM1, "pcm1", "aclk66_peric", GATE_IP_PERIC, 22, 0, 0),
-	GATE(CLK_PCM2, "pcm2", "aclk66_peric", GATE_IP_PERIC, 23, 0, 0),
-	GATE(CLK_PWM, "pwm", "aclk66_peric", GATE_IP_PERIC, 24, 0, 0),
-	GATE(CLK_SPDIF, "spdif", "aclk66_peric", GATE_IP_PERIC, 26, 0, 0),
-	GATE(CLK_USI4, "usi4", "aclk66_peric", GATE_IP_PERIC, 28, 0, 0),
-	GATE(CLK_USI5, "usi5", "aclk66_peric", GATE_IP_PERIC, 30, 0, 0),
-	GATE(CLK_USI6, "usi6", "aclk66_peric", GATE_IP_PERIC, 31, 0, 0),
-
-	GATE(CLK_KEYIF, "keyif", "aclk66_peric", GATE_BUS_PERIC, 22, 0, 0),
+	GATE(CLK_UART0, "uart0", "mout_user_aclk66_peric",
+			GATE_IP_PERIC, 0, 0, 0),
+	GATE(CLK_UART1, "uart1", "mout_user_aclk66_peric",
+			GATE_IP_PERIC, 1, 0, 0),
+	GATE(CLK_UART2, "uart2", "mout_user_aclk66_peric",
+			GATE_IP_PERIC, 2, 0, 0),
+	GATE(CLK_UART3, "uart3", "mout_user_aclk66_peric",
+			GATE_IP_PERIC, 3, 0, 0),
+	GATE(CLK_I2C0, "i2c0", "mout_user_aclk66_peric",
+			GATE_IP_PERIC, 6, 0, 0),
+	GATE(CLK_I2C1, "i2c1", "mout_user_aclk66_peric",
+			GATE_IP_PERIC, 7, 0, 0),
+	GATE(CLK_I2C2, "i2c2", "mout_user_aclk66_peric",
+			GATE_IP_PERIC, 8, 0, 0),
+	GATE(CLK_I2C3, "i2c3", "mout_user_aclk66_peric",
+			GATE_IP_PERIC, 9, 0, 0),
+	GATE(CLK_USI0, "usi0", "mout_user_aclk66_peric",
+			GATE_IP_PERIC, 10, 0, 0),
+	GATE(CLK_USI1, "usi1", "mout_user_aclk66_peric",
+			GATE_IP_PERIC, 11, 0, 0),
+	GATE(CLK_USI2, "usi2", "mout_user_aclk66_peric",
+			GATE_IP_PERIC, 12, 0, 0),
+	GATE(CLK_USI3, "usi3", "mout_user_aclk66_peric",
+			GATE_IP_PERIC, 13, 0, 0),
+	GATE(CLK_I2C_HDMI, "i2c_hdmi", "mout_user_aclk66_peric",
+			GATE_IP_PERIC, 14, 0, 0),
+	GATE(CLK_TSADC, "tsadc", "mout_user_aclk66_peric",
+			GATE_IP_PERIC, 15, 0, 0),
+	GATE(CLK_SPI0, "spi0", "mout_user_aclk66_peric",
+			GATE_IP_PERIC, 16, 0, 0),
+	GATE(CLK_SPI1, "spi1", "mout_user_aclk66_peric",
+			GATE_IP_PERIC, 17, 0, 0),
+	GATE(CLK_SPI2, "spi2", "mout_user_aclk66_peric",
+			GATE_IP_PERIC, 18, 0, 0),
+	GATE(CLK_I2S1, "i2s1", "mout_user_aclk66_peric",
+			GATE_IP_PERIC, 20, 0, 0),
+	GATE(CLK_I2S2, "i2s2", "mout_user_aclk66_peric",
+			GATE_IP_PERIC, 21, 0, 0),
+	GATE(CLK_PCM1, "pcm1", "mout_user_aclk66_peric",
+			GATE_IP_PERIC, 22, 0, 0),
+	GATE(CLK_PCM2, "pcm2", "mout_user_aclk66_peric",
+			GATE_IP_PERIC, 23, 0, 0),
+	GATE(CLK_PWM, "pwm", "mout_user_aclk66_peric",
+			GATE_IP_PERIC, 24, 0, 0),
+	GATE(CLK_SPDIF, "spdif", "mout_user_aclk66_peric",
+			GATE_IP_PERIC, 26, 0, 0),
+	GATE(CLK_USI4, "usi4", "mout_user_aclk66_peric",
+			GATE_IP_PERIC, 28, 0, 0),
+	GATE(CLK_USI5, "usi5", "mout_user_aclk66_peric",
+			GATE_IP_PERIC, 30, 0, 0),
+	GATE(CLK_USI6, "usi6", "mout_user_aclk66_peric",
+			GATE_IP_PERIC, 31, 0, 0),
+
+	GATE(CLK_KEYIF, "keyif", "mout_user_aclk66_peric",
+			GATE_BUS_PERIC, 22, 0, 0),
 
 	/* PERIS Block */
 	GATE(CLK_CHIPID, "chipid", "aclk66_psgen",
diff --git a/include/dt-bindings/clock/exynos5420.h b/include/dt-bindings/clock/exynos5420.h
index 97dcb89..14e1c8f 100644
--- a/include/dt-bindings/clock/exynos5420.h
+++ b/include/dt-bindings/clock/exynos5420.h
@@ -63,7 +63,6 @@
 #define CLK_SCLK_MPHY_IXTAL24	161
 
 /* gate clocks */
-#define CLK_ACLK66_PERIC	256
 #define CLK_UART0		257
 #define CLK_UART1		258
 #define CLK_UART2		259
-- 
1.7.10.4

