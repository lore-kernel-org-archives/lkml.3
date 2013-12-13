Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab3LMPqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:46:40 -0500
Received: from [216.32.180.12] ([216.32.180.12]:21959 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752523Ab3LMPpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:45:47 -0500
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
Subject: [PATCH 1/2] ARM: imx6sl: Add missing pll4_audio_div to the clock tree
Date: Fri, 13 Dec 2013 23:44:07 +0800
Message-ID: <7c2a52ab20e746cf61afa1ec0c1578174f094772.1386949189.git.Guangyu.Chen@freescale.com>
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

There's a dividor for pll4_audio clock missing in clock tree, thus add it.

Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
---
 arch/arm/mach-imx/clk-imx6sl.c           | 5 +++--
 include/dt-bindings/clock/imx6sl-clock.h | 3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-imx/clk-imx6sl.c b/arch/arm/mach-imx/clk-imx6sl.c
index a222280..5eb5522 100644
--- a/arch/arm/mach-imx/clk-imx6sl.c
+++ b/arch/arm/mach-imx/clk-imx6sl.c
@@ -29,14 +29,14 @@ static const char const *periph_sels[]		= { "pre_periph_sel", "periph_clk2_podf"
 static const char const *periph2_sels[]		= { "pre_periph2_sel", "periph2_clk2_podf", };
 static const char const *csi_lcdif_sels[]	= { "mmdc", "pll2_pfd2", "pll3_120m", "pll3_pfd1", };
 static const char const *usdhc_sels[]		= { "pll2_pfd2", "pll2_pfd0", };
-static const char const *ssi_sels[]		= { "pll3_pfd2", "pll3_pfd3", "pll4_post_div", "dummy", };
+static const char const *ssi_sels[]		= { "pll3_pfd2", "pll3_pfd3", "pll4_audio_div", "dummy", };
 static const char const *perclk_sels[]		= { "ipg", "osc", };
 static const char const *epdc_pxp_sels[]	= { "mmdc", "pll3_usb_otg", "pll5_video_div", "pll2_pfd0", "pll2_pfd2", "pll3_pfd1", };
 static const char const *gpu2d_ovg_sels[]	= { "pll3_pfd1", "pll3_usb_otg", "pll2_bus", "pll2_pfd2", };
 static const char const *gpu2d_sels[]		= { "pll2_pfd2", "pll3_usb_otg", "pll3_pfd1", "pll2_bus", };
 static const char const *lcdif_pix_sels[]	= { "pll2_bus", "pll3_usb_otg", "pll5_video_div", "pll2_pfd0", "pll3_pfd0", "pll3_pfd1", };
 static const char const *epdc_pix_sels[]	= { "pll2_bus", "pll3_usb_otg", "pll5_video_div", "pll2_pfd0", "pll2_pfd1", "pll3_pfd1", };
-static const char const *audio_sels[]		= { "pll4_post_div", "pll3_pfd2", "pll3_pfd3", "pll3_usb_otg", };
+static const char const *audio_sels[]		= { "pll4_audio_div", "pll3_pfd2", "pll3_pfd3", "pll3_usb_otg", };
 static const char const *ecspi_sels[]		= { "pll3_60m", "osc", };
 static const char const *uart_sels[]		= { "pll3_80m", "osc", };
 
@@ -104,6 +104,7 @@ static void __init imx6sl_clocks_init(struct device_node *ccm_node)
 
 	/*                                                           dev   name              parent_name      flags                reg        shift width div: flags, div_table lock */
 	clks[IMX6SL_CLK_PLL4_POST_DIV]  = clk_register_divider_table(NULL, "pll4_post_div",  "pll4_audio",    CLK_SET_RATE_PARENT, base + 0x70,  19, 2,   0, post_div_table, &imx_ccm_lock);
+	clks[IMX6SL_CLK_PLL4_AUDIO_DIV] =       clk_register_divider(NULL, "pll4_audio_div", "pll4_post_div", CLK_SET_RATE_PARENT, base + 0x170, 15, 1,   0, &imx_ccm_lock);
 	clks[IMX6SL_CLK_PLL5_POST_DIV]  = clk_register_divider_table(NULL, "pll5_post_div",  "pll5_video",    CLK_SET_RATE_PARENT, base + 0xa0,  19, 2,   0, post_div_table, &imx_ccm_lock);
 	clks[IMX6SL_CLK_PLL5_VIDEO_DIV] = clk_register_divider_table(NULL, "pll5_video_div", "pll5_post_div", CLK_SET_RATE_PARENT, base + 0x170, 30, 2,   0, video_div_table, &imx_ccm_lock);
 	clks[IMX6SL_CLK_ENET_REF]       = clk_register_divider_table(NULL, "enet_ref",       "pll6_enet",     0,                   base + 0xe0,  0,  2,   0, clk_enet_ref_table, &imx_ccm_lock);
diff --git a/include/dt-bindings/clock/imx6sl-clock.h b/include/dt-bindings/clock/imx6sl-clock.h
index 46f7495..4735e84 100644
--- a/include/dt-bindings/clock/imx6sl-clock.h
+++ b/include/dt-bindings/clock/imx6sl-clock.h
@@ -143,6 +143,7 @@
 #define IMX6SL_CLK_USDHC2		130
 #define IMX6SL_CLK_USDHC3		131
 #define IMX6SL_CLK_USDHC4		132
-#define IMX6SL_CLK_END			133
+#define IMX6SL_CLK_PLL4_AUDIO_DIV	133
+#define IMX6SL_CLK_END			134
 
 #endif /* __DT_BINDINGS_CLOCK_IMX6SL_H */
-- 
1.8.4


