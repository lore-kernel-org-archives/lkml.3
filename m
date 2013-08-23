Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab3HWLJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 07:09:16 -0400
Received: from mail-db9lp0250.outbound.messaging.microsoft.com ([213.199.154.250]:35218
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754630Ab3HWLJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 07:09:13 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(zcb8kzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Nicolin Chen <b42378@freescale.com>
To: <shawn.guo@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <rob.herring@calxeda.com>
Subject: [PATCH] ARM: imx6q: Add pll4_audio_div to clock tree
Date: Fri, 23 Aug 2013 19:20:34 +0800
Message-ID: <1377256834-19825-1-git-send-email-b42378@freescale.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a pll4_audio_div clock, an extra divider for pll4, missing
in current clock tree, thus add it.

Signed-off-by: Nicolin Chen <b42378@freescale.com>
---
 .../devicetree/bindings/clock/imx6q-clock.txt      |    1 +
 arch/arm/mach-imx/clk-imx6q.c                      |    9 +++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/imx6q-clock.txt b/Documentation/devicetree/bindings/clock/imx6q-clock.txt
index 5a90a72..e8b1baa 100644
--- a/Documentation/devicetree/bindings/clock/imx6q-clock.txt
+++ b/Documentation/devicetree/bindings/clock/imx6q-clock.txt
@@ -215,6 +215,7 @@ clocks and IDs.
 	cko2      		200
 	cko      		201
 	vdoa      		202
+	pll4_audio_div		203
 
 Examples:
 
diff --git a/arch/arm/mach-imx/clk-imx6q.c b/arch/arm/mach-imx/clk-imx6q.c
index 929e8cc..2616b46 100644
--- a/arch/arm/mach-imx/clk-imx6q.c
+++ b/arch/arm/mach-imx/clk-imx6q.c
@@ -182,7 +182,7 @@ static const char *periph2_clk2_sels[]	= { "pll3_usb_otg", "pll2_bus", };
 static const char *periph_sels[]	= { "periph_pre", "periph_clk2", };
 static const char *periph2_sels[]	= { "periph2_pre", "periph2_clk2", };
 static const char *axi_sels[]		= { "periph", "pll2_pfd2_396m", "periph", "pll3_pfd1_540m", };
-static const char *audio_sels[]	= { "pll4_post_div", "pll3_pfd2_508m", "pll3_pfd3_454m", "pll3_usb_otg", };
+static const char *audio_sels[]	= { "pll4_audio_div", "pll3_pfd2_508m", "pll3_pfd3_454m", "pll3_usb_otg", };
 static const char *gpu_axi_sels[]	= { "axi", "ahb", };
 static const char *gpu2d_core_sels[]	= { "axi", "pll3_usb_otg", "pll2_pfd0_352m", "pll2_pfd2_396m", };
 static const char *gpu3d_core_sels[]	= { "mmdc_ch0_axi", "pll3_usb_otg", "pll2_pfd1_594m", "pll2_pfd2_396m", };
@@ -196,7 +196,7 @@ static const char *ipu2_di0_sels[]	= { "ipu2_di0_pre", "dummy", "dummy", "ldb_di
 static const char *ipu2_di1_sels[]	= { "ipu2_di1_pre", "dummy", "dummy", "ldb_di0", "ldb_di1", };
 static const char *hsi_tx_sels[]	= { "pll3_120m", "pll2_pfd2_396m", };
 static const char *pcie_axi_sels[]	= { "axi", "ahb", };
-static const char *ssi_sels[]		= { "pll3_pfd2_508m", "pll3_pfd3_454m", "pll4_post_div", };
+static const char *ssi_sels[]		= { "pll3_pfd2_508m", "pll3_pfd3_454m", "pll4_audio_div", };
 static const char *usdhc_sels[]	= { "pll2_pfd2_396m", "pll2_pfd0_352m", };
 static const char *enfc_sels[]	= { "pll2_pfd0_352m", "pll2_bus", "pll3_usb_otg", "pll2_pfd2_396m", };
 static const char *emi_sels[]		= { "pll2_pfd2_396m", "pll3_usb_otg", "axi", "pll2_pfd0_352m", };
@@ -205,7 +205,7 @@ static const char *vdo_axi_sels[]	= { "axi", "ahb", };
 static const char *vpu_axi_sels[]	= { "axi", "pll2_pfd2_396m", "pll2_pfd0_352m", };
 static const char *cko1_sels[]	= { "pll3_usb_otg", "pll2_bus", "pll1_sys", "pll5_video_div",
 				    "dummy", "axi", "enfc", "ipu1_di0", "ipu1_di1", "ipu2_di0",
-				    "ipu2_di1", "ahb", "ipg", "ipg_per", "ckil", "pll4_post_div", };
+				    "ipu2_di1", "ahb", "ipg", "ipg_per", "ckil", "pll4_audio_div", };
 static const char *cko2_sels[] = {
 	"mmdc_ch0_axi", "mmdc_ch1_axi", "usdhc4", "usdhc1",
 	"gpu2d_axi", "dummy", "ecspi_root", "gpu3d_axi",
@@ -251,7 +251,7 @@ enum mx6q_clks {
 	ssi2_ipg, ssi3_ipg, rom, usbphy1, usbphy2, ldb_di0_div_3_5, ldb_di1_div_3_5,
 	sata_ref, sata_ref_100m, pcie_ref, pcie_ref_125m, enet_ref, usbphy1_gate,
 	usbphy2_gate, pll4_post_div, pll5_post_div, pll5_video_div, eim_slow,
-	spdif, cko2_sel, cko2_podf, cko2, cko, vdoa, clk_max
+	spdif, cko2_sel, cko2_podf, cko2, cko, vdoa, pll4_audio_div, clk_max
 };
 
 static struct clk *clk[clk_max];
@@ -359,6 +359,7 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 	clk[twd]       = imx_clk_fixed_factor("twd",       "arm",            1, 2);
 
 	clk[pll4_post_div] = clk_register_divider_table(NULL, "pll4_post_div", "pll4_audio", CLK_SET_RATE_PARENT, base + 0x70, 19, 2, 0, post_div_table, &imx_ccm_lock);
+	clk[pll4_audio_div] = clk_register_divider(NULL, "pll4_audio_div", "pll4_post_div", CLK_SET_RATE_PARENT, base + 0x170, 15, 1, 0, &imx_ccm_lock);
 	clk[pll5_post_div] = clk_register_divider_table(NULL, "pll5_post_div", "pll5_video", CLK_SET_RATE_PARENT, base + 0xa0, 19, 2, 0, post_div_table, &imx_ccm_lock);
 	clk[pll5_video_div] = clk_register_divider_table(NULL, "pll5_video_div", "pll5_post_div", CLK_SET_RATE_PARENT, base + 0x170, 30, 2, 0, video_div_table, &imx_ccm_lock);
 
-- 
1.7.1


