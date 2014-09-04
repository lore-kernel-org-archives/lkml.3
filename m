Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbaIDJcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 05:32:42 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:32707
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755637AbaIDJci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 05:32:38 -0400
From: Fancy Fang <chen.fang@freescale.com>
To: <shawn.guo@freescale.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: clk-imx6sl: correct the pxp and epdc axi clock selections
Date: Thu, 4 Sep 2014 16:28:55 +0800
Message-ID: <1409819335-29094-1-git-send-email-chen.fang@freescale.com>
X-Mailer: git-send-email 1.9.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199003)(48376002)(81156004)(85306004)(90102001)(21056001)(76482001)(46102001)(89996001)(2351001)(87286001)(80022001)(84676001)(6806004)(104016003)(85852003)(81542001)(95666004)(20776003)(106466001)(88136002)(86362001)(44976005)(93916002)(62966002)(2371004)(19580405001)(79102001)(74502001)(77156001)(26826002)(64706001)(229853001)(31966008)(102836001)(107046002)(50466002)(83072002)(33646002)(104166001)(50986999)(105606002)(19580395003)(81342001)(50226001)(74662001)(97736001)(47776003)(92566001)(36756003)(68736004)(77982001)(83322001)(92726001)(110136001)(99396002)(87936001)(69596002)(4396001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB346;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0324C2C0E2
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=chen.fang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The parent clocks of IMX6SL_CLK_PXP_AXI_SEL and IMX6SL_CLK_EPDC_AXI_SEL
clocks are not the same. So split the epdc_pxp_sels into two different
clock selections 'pxp_axi_sels' and 'epdc_axi_sels'.

Signed-off-by: Fancy Fang <chen.fang@freescale.com>
Signed-off-by: Robby Cai <R63905@freescale.com>
Acked-by: Shawn Guo <shawn.guo@freescale.com>
---
 arch/arm/mach-imx/clk-imx6sl.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-imx/clk-imx6sl.c b/arch/arm/mach-imx/clk-imx6sl.c
index 43261ea..d730dfa 100644
--- a/arch/arm/mach-imx/clk-imx6sl.c
+++ b/arch/arm/mach-imx/clk-imx6sl.c
@@ -47,7 +47,8 @@ static const char *csi_lcdif_sels[]	= { "mmdc", "pll2_pfd2", "pll3_120m", "pll3_
 static const char *usdhc_sels[]		= { "pll2_pfd2", "pll2_pfd0", };
 static const char *ssi_sels[]		= { "pll3_pfd2", "pll3_pfd3", "pll4_audio_div", "dummy", };
 static const char *perclk_sels[]	= { "ipg", "osc", };
-static const char *epdc_pxp_sels[]	= { "mmdc", "pll3_usb_otg", "pll5_video_div", "pll2_pfd0", "pll2_pfd2", "pll3_pfd1", };
+static const char *pxp_axi_sels[]	= { "pll2_bus", "pll3_usb_otg", "pll5_video_div", "pll2_pfd0", "pll2_pfd2", "pll3_pfd3", };
+static const char *epdc_axi_sels[]	= { "pll2_bus", "pll3_usb_otg", "pll5_video_div", "pll2_pfd0", "pll2_pfd2", "pll3_pfd2", };
 static const char *gpu2d_ovg_sels[]	= { "pll3_pfd1", "pll3_usb_otg", "pll2_bus", "pll2_pfd2", };
 static const char *gpu2d_sels[]		= { "pll2_pfd2", "pll3_usb_otg", "pll3_pfd1", "pll2_bus", };
 static const char *lcdif_pix_sels[]	= { "pll2_bus", "pll3_usb_otg", "pll5_video_div", "pll2_pfd0", "pll3_pfd0", "pll3_pfd1", };
@@ -251,8 +252,8 @@ static void __init imx6sl_clocks_init(struct device_node *ccm_node)
 	clks[IMX6SL_CLK_SSI2_SEL]         = imx_clk_fixup_mux("ssi2_sel",   base + 0x1c, 12, 2, ssi_sels,          ARRAY_SIZE(ssi_sels),    imx_cscmr1_fixup);
 	clks[IMX6SL_CLK_SSI3_SEL]         = imx_clk_fixup_mux("ssi3_sel",   base + 0x1c, 14, 2, ssi_sels,          ARRAY_SIZE(ssi_sels),    imx_cscmr1_fixup);
 	clks[IMX6SL_CLK_PERCLK_SEL]       = imx_clk_fixup_mux("perclk_sel", base + 0x1c, 6,  1, perclk_sels,       ARRAY_SIZE(perclk_sels), imx_cscmr1_fixup);
-	clks[IMX6SL_CLK_PXP_AXI_SEL]      = imx_clk_mux("pxp_axi_sel",      base + 0x34, 6,  3, epdc_pxp_sels,     ARRAY_SIZE(epdc_pxp_sels));
-	clks[IMX6SL_CLK_EPDC_AXI_SEL]     = imx_clk_mux("epdc_axi_sel",     base + 0x34, 15, 3, epdc_pxp_sels,     ARRAY_SIZE(epdc_pxp_sels));
+	clks[IMX6SL_CLK_PXP_AXI_SEL]      = imx_clk_mux("pxp_axi_sel",      base + 0x34, 6,  3, pxp_axi_sels,      ARRAY_SIZE(pxp_axi_sels));
+	clks[IMX6SL_CLK_EPDC_AXI_SEL]     = imx_clk_mux("epdc_axi_sel",     base + 0x34, 15, 3, epdc_axi_sels,     ARRAY_SIZE(epdc_axi_sels));
 	clks[IMX6SL_CLK_GPU2D_OVG_SEL]    = imx_clk_mux("gpu2d_ovg_sel",    base + 0x18, 4,  2, gpu2d_ovg_sels,    ARRAY_SIZE(gpu2d_ovg_sels));
 	clks[IMX6SL_CLK_GPU2D_SEL]        = imx_clk_mux("gpu2d_sel",        base + 0x18, 8,  2, gpu2d_sels,        ARRAY_SIZE(gpu2d_sels));
 	clks[IMX6SL_CLK_LCDIF_PIX_SEL]    = imx_clk_mux("lcdif_pix_sel",    base + 0x38, 6,  3, lcdif_pix_sels,    ARRAY_SIZE(lcdif_pix_sels));
-- 
1.9.1

