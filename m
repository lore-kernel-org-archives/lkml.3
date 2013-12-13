Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab3LMPhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:37:33 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:48460
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752285Ab3LMPhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:37:32 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: <shawn.guo@linaro.org>, <kernel@pengutronix.de>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: imx6: Derive spdif clock from pll3_pfd3_454m
Date: Fri, 13 Dec 2013 23:37:52 +0800
Message-ID: <1386949072-6520-1-git-send-email-Guangyu.Chen@freescale.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPDIF can derive a TX clock for playback from one of its clock sources --
spdif root clock to match its supporting sample rates. So this patch set
the spdif root clock's parent to pll3_pfd3_454m since the pll3_pfd3_454m
can approximately meet its sample rate requirement.

Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
---
 arch/arm/mach-imx/clk-imx6q.c  | 3 +++
 arch/arm/mach-imx/clk-imx6sl.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/arch/arm/mach-imx/clk-imx6q.c b/arch/arm/mach-imx/clk-imx6q.c
index 74ecceb..af2e582 100644
--- a/arch/arm/mach-imx/clk-imx6q.c
+++ b/arch/arm/mach-imx/clk-imx6q.c
@@ -475,6 +475,9 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 	if (ret)
 		pr_warn("failed to set up CLKO: %d\n", ret);
 
+	/* Audio-related clocks configuration */
+	clk_set_parent(clk[spdif_sel], clk[pll3_pfd3_454m]);
+
 	/* All existing boards with PCIe use LVDS1 */
 	if (IS_ENABLED(CONFIG_PCI_IMX6))
 		clk_set_parent(clk[lvds1_sel], clk[sata_ref]);
diff --git a/arch/arm/mach-imx/clk-imx6sl.c b/arch/arm/mach-imx/clk-imx6sl.c
index a747a7d..a222280 100644
--- a/arch/arm/mach-imx/clk-imx6sl.c
+++ b/arch/arm/mach-imx/clk-imx6sl.c
@@ -261,6 +261,9 @@ static void __init imx6sl_clocks_init(struct device_node *ccm_node)
 		clk_prepare_enable(clks[IMX6SL_CLK_USBPHY2_GATE]);
 	}
 
+	/* Audio-related clocks configuration */
+	clk_set_parent(clks[IMX6SL_CLK_SPDIF0_SEL], clks[IMX6SL_CLK_PLL3_PFD3]);
+
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx6sl-gpt");
 	base = of_iomap(np, 0);
 	WARN_ON(!base);
-- 
1.8.4


