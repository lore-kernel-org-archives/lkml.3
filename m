Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab3LMPpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:45:55 -0500
Received: from [216.32.180.12] ([216.32.180.12]:29401 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752460Ab3LMPpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:45:51 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zcb8kzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: <shawn.guo@linaro.org>, <kernel@pengutronix.de>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <devicetree@vger.kernel.org>
Subject: [PATCH 2/2] ARM: imx6sl: Add missing spba clock to clock tree
Date: Fri, 13 Dec 2013 23:44:08 +0800
Message-ID: <af095eb33a2e5083bde4066bc1c910276d72daa1.1386949189.git.Guangyu.Chen@freescale.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1386949189.git.Guangyu.Chen@freescale.com>
References: <cover.1386949189.git.Guangyu.Chen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are missing spba clock in imx6sl's clock tree, thus add it.

Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
---
 arch/arm/mach-imx/clk-imx6sl.c           | 1 +
 include/dt-bindings/clock/imx6sl-clock.h | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/clk-imx6sl.c b/arch/arm/mach-imx/clk-imx6sl.c
index 5eb5522..3781a18 100644
--- a/arch/arm/mach-imx/clk-imx6sl.c
+++ b/arch/arm/mach-imx/clk-imx6sl.c
@@ -233,6 +233,7 @@ static void __init imx6sl_clocks_init(struct device_node *ccm_node)
 	clks[IMX6SL_CLK_PWM3]         = imx_clk_gate2("pwm3",         "perclk",            base + 0x78, 20);
 	clks[IMX6SL_CLK_PWM4]         = imx_clk_gate2("pwm4",         "perclk",            base + 0x78, 22);
 	clks[IMX6SL_CLK_SDMA]         = imx_clk_gate2("sdma",         "ipg",               base + 0x7c, 6);
+	clks[IMX6SL_CLK_SPBA]         = imx_clk_gate2("spba",         "ipg",               base + 0x7c, 12);
 	clks[IMX6SL_CLK_SPDIF]        = imx_clk_gate2("spdif",        "spdif0_podf",       base + 0x7c, 14);
 	clks[IMX6SL_CLK_SSI1]         = imx_clk_gate2("ssi1",         "ssi1_podf",         base + 0x7c, 18);
 	clks[IMX6SL_CLK_SSI2]         = imx_clk_gate2("ssi2",         "ssi2_podf",         base + 0x7c, 20);
diff --git a/include/dt-bindings/clock/imx6sl-clock.h b/include/dt-bindings/clock/imx6sl-clock.h
index 4735e84..7cf5c99 100644
--- a/include/dt-bindings/clock/imx6sl-clock.h
+++ b/include/dt-bindings/clock/imx6sl-clock.h
@@ -144,6 +144,7 @@
 #define IMX6SL_CLK_USDHC3		131
 #define IMX6SL_CLK_USDHC4		132
 #define IMX6SL_CLK_PLL4_AUDIO_DIV	133
-#define IMX6SL_CLK_END			134
+#define IMX6SL_CLK_SPBA			134
+#define IMX6SL_CLK_END			135
 
 #endif /* __DT_BINDINGS_CLOCK_IMX6SL_H */
-- 
1.8.4


