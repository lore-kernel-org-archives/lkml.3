Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbaAIDE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 22:04:59 -0500
Received: from mail-db9lp0250.outbound.messaging.microsoft.com ([213.199.154.250]:56336
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751109AbaAIDEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 22:04:55 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zcb8kzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h1155h)
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: <shawn.guo@linaro.org>, <kernel@pengutronix.de>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <devicetree@vger.kernel.org>, <rob@landley.net>
Subject: [PATCH] ARM: imx6q: Add missing esai_ahb clock to current clock tree
Date: Thu, 9 Jan 2014 11:04:59 +0800
Message-ID: <1389236699-10387-1-git-send-email-Guangyu.Chen@freescale.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

esai_ahb clock is derived from ahb and used to provide ESAI the capability of
register accessing and FSYS clock source for I2S clocks dividing. Although the
gate of this esai_ahb is duplicated with esai clock -- the baud clock, yet
considering about the differences of their clock rates, it's quite essential
to patch this missing clock.

Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
---
 Documentation/devicetree/bindings/clock/imx6q-clock.txt | 1 +
 arch/arm/mach-imx/clk-imx6q.c                           | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/clock/imx6q-clock.txt b/Documentation/devicetree/bindings/clock/imx6q-clock.txt
index 6aab72b..90ec91f 100644
--- a/Documentation/devicetree/bindings/clock/imx6q-clock.txt
+++ b/Documentation/devicetree/bindings/clock/imx6q-clock.txt
@@ -220,6 +220,7 @@ clocks and IDs.
 	lvds2_sel		205
 	lvds1_gate		206
 	lvds2_gate		207
+	esai_ahb		208
 
 Examples:
 
diff --git a/arch/arm/mach-imx/clk-imx6q.c b/arch/arm/mach-imx/clk-imx6q.c
index af2e582..20215b9 100644
--- a/arch/arm/mach-imx/clk-imx6q.c
+++ b/arch/arm/mach-imx/clk-imx6q.c
@@ -107,7 +107,7 @@ enum mx6q_clks {
 	sata_ref, sata_ref_100m, pcie_ref, pcie_ref_125m, enet_ref, usbphy1_gate,
 	usbphy2_gate, pll4_post_div, pll5_post_div, pll5_video_div, eim_slow,
 	spdif, cko2_sel, cko2_podf, cko2, cko, vdoa, pll4_audio_div,
-	lvds1_sel, lvds2_sel, lvds1_gate, lvds2_gate, clk_max
+	lvds1_sel, lvds2_sel, lvds1_gate, lvds2_gate, esai_ahb, clk_max
 };
 
 static struct clk *clk[clk_max];
@@ -355,6 +355,7 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 	clk[ecspi5]       = imx_clk_gate2("ecspi5",        "ecspi_root",        base + 0x6c, 8);
 	clk[enet]         = imx_clk_gate2("enet",          "ipg",               base + 0x6c, 10);
 	clk[esai]         = imx_clk_gate2("esai",          "esai_podf",         base + 0x6c, 16);
+	clk[esai_ahb]     = imx_clk_gate2("esai_ahb",      "ahb",               base + 0x6c, 16);
 	clk[gpt_ipg]      = imx_clk_gate2("gpt_ipg",       "ipg",               base + 0x6c, 20);
 	clk[gpt_ipg_per]  = imx_clk_gate2("gpt_ipg_per",   "ipg_per",           base + 0x6c, 22);
 	if (cpu_is_imx6dl())
-- 
1.8.4


