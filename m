Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbaL2JoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 04:44:17 -0500
Received: from regular1.263xmail.com ([211.150.99.135]:46599 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbaL2JoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 04:44:12 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-ADDR-CHECKED: 0
X-RL-SENDER: roger.chen@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: roger.chen@rock-chips.com
X-UNIQUE-TAG: <229a56f413436c8732be804ec6b47f73>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Roger Chen <roger.chen@rock-chips.com>
To: heiko@sntech.de
Cc: peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        kever.yang@rock-chips.com, eddie.cai@rock-chips.com,
        roger.chen@rock-chips.com
Subject: [PATCH v3 3/6] GMAC: modify CRU config for Rockchip RK3288 SoCs integrated GMAC
Date: Mon, 29 Dec 2014 17:44:07 +0800
Message-Id: <1419846247-14639-1-git-send-email-roger.chen@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1419846152-14531-1-git-send-email-roger.chen@rock-chips.com>
References: <1419846152-14531-1-git-send-email-roger.chen@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

modify CRU config for GMAC driver

changes since v2:
1. remove SCLK_MAC_PLL

Signed-off-by: Roger Chen <roger.chen@rock-chips.com>
---
 drivers/clk/rockchip/clk-rk3288.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index 2327829..6e88a29 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -187,7 +187,7 @@ PNAME(mux_uart2_p)	= { "uart2_src", "uart2_frac", "xin24m" };
 PNAME(mux_uart3_p)	= { "uart3_src", "uart3_frac", "xin24m" };
 PNAME(mux_uart4_p)	= { "uart4_src", "uart4_frac", "xin24m" };
 PNAME(mux_cif_out_p)	= { "cif_src", "xin24m" };
-PNAME(mux_macref_p)	= { "mac_src", "ext_gmac" };
+PNAME(mux_mac_p)	= { "mac_pll_src", "ext_gmac" };
 PNAME(mux_hsadcout_p)	= { "hsadc_src", "ext_hsadc" };
 PNAME(mux_edp_24m_p)	= { "ext_edp_24m", "xin24m" };
 PNAME(mux_tspout_p)	= { "cpll", "gpll", "npll", "xin27m" };
@@ -560,18 +560,18 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 	MUX(SCLK_UART4, "sclk_uart4", mux_uart4_p, 0,
 			RK3288_CLKSEL_CON(3), 8, 2, MFLAGS),
 
-	COMPOSITE(0, "mac_src", mux_pll_src_npll_cpll_gpll_p, 0,
+	COMPOSITE(0, "mac_pll_src", mux_pll_src_npll_cpll_gpll_p, 0,
 			RK3288_CLKSEL_CON(21), 0, 2, MFLAGS, 8, 5, DFLAGS,
 			RK3288_CLKGATE_CON(2), 5, GFLAGS),
-	MUX(0, "macref", mux_macref_p, 0,
+	MUX(SCLK_MAC, "mac_clk", mux_mac_p, 0,
 			RK3288_CLKSEL_CON(21), 4, 1, MFLAGS),
-	GATE(0, "sclk_macref_out", "macref", 0,
+	GATE(SCLK_MACREF_OUT, "sclk_macref_out", "mac_clk", 0,
 			RK3288_CLKGATE_CON(5), 3, GFLAGS),
-	GATE(SCLK_MACREF, "sclk_macref", "macref", 0,
+	GATE(SCLK_MACREF, "sclk_macref", "mac_clk", 0,
 			RK3288_CLKGATE_CON(5), 2, GFLAGS),
-	GATE(SCLK_MAC_RX, "sclk_mac_rx", "macref", 0,
+	GATE(SCLK_MAC_RX, "sclk_mac_rx", "mac_clk", 0,
 			RK3288_CLKGATE_CON(5), 0, GFLAGS),
-	GATE(SCLK_MAC_TX, "sclk_mac_tx", "macref", 0,
+	GATE(SCLK_MAC_TX, "sclk_mac_tx", "mac_clk", 0,
 			RK3288_CLKGATE_CON(5), 1, GFLAGS),
 
 	COMPOSITE(0, "hsadc_src", mux_pll_src_cpll_gpll_p, 0,
-- 
1.7.9.5


