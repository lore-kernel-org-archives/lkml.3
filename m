Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbaLLVI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 16:08:56 -0500
Received: from 3.mo2.mail-out.ovh.net ([46.105.58.226]:48430 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753235AbaLLVIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 16:08:55 -0500
From: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
To: Heiko Stuebner <heiko@sntech.de>, Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Rockchip
	SoC...),
        linux-rockchip@lists.infradead.org (open list:ARM/Rockchip SoC...),
        linux-kernel@vger.kernel.org (open list:COMMON CLK FRAMEWORK)
Cc: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
Subject: [PATCH v2] clk: rockchip: add CLK_IGNORE_UNUSED flag to fix USB Host
Date: Fri, 12 Dec 2014 22:05:52 +0100
Message-Id: <1418418352-3947-1-git-send-email-julien.chauveau@neo-technologies.fr>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1418396066-31360-1-git-send-email-julien.chauveau@neo-technologies.fr>
References: <1418396066-31360-1-git-send-email-julien.chauveau@neo-technologies.fr>
X-Ovh-Tracer-Id: 6440991893206663229
X-Ovh-Remote: 193.248.240.88 (laubervilliers-656-1-116-88.w193-248.abo.wanadoo.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejiedrgeejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejiedrgeejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds CLK_IGNORE_UNUSED flag to hclk_usb_peri, hclk_usbotg0
and hclk_usbotg1 because these clocks must remain enabled to use the
USB controllers in host mode.

This fixes a regression introduced by commit 78eaf6095cc7
("clk: rockchip: disable unused clocks").

Signed-off-by: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
---
Changes since v1:
- update commit message: refer to commit ID instead of mailing list

 drivers/clk/rockchip/clk-rk3188.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/rockchip/clk-rk3188.c b/drivers/clk/rockchip/clk-rk3188.c
index c540789..25ddb09 100644
--- a/drivers/clk/rockchip/clk-rk3188.c
+++ b/drivers/clk/rockchip/clk-rk3188.c
@@ -430,8 +430,10 @@ static struct rockchip_clk_branch common_clk_branches[] __initdata = {
 	GATE(0, "hclk_emem_peri", "hclk_peri", 0, RK2928_CLKGATE_CON(4), 7, GFLAGS),
 	GATE(HCLK_EMAC, "hclk_emac", "hclk_peri", 0, RK2928_CLKGATE_CON(7), 0, GFLAGS),
 	GATE(HCLK_NANDC0, "hclk_nandc0", "hclk_peri", 0, RK2928_CLKGATE_CON(5), 9, GFLAGS),
-	GATE(0, "hclk_usb_peri", "hclk_peri", 0, RK2928_CLKGATE_CON(4), 5, GFLAGS),
-	GATE(HCLK_OTG0, "hclk_usbotg0", "hclk_peri", 0, RK2928_CLKGATE_CON(5), 13, GFLAGS),
+	GATE(0, "hclk_usb_peri", "hclk_peri", CLK_IGNORE_UNUSED,
+			RK2928_CLKGATE_CON(4), 5, GFLAGS),
+	GATE(HCLK_OTG0, "hclk_usbotg0", "hclk_peri", CLK_IGNORE_UNUSED,
+			RK2928_CLKGATE_CON(5), 13, GFLAGS),
 	GATE(HCLK_HSADC, "hclk_hsadc", "hclk_peri", 0, RK2928_CLKGATE_CON(7), 5, GFLAGS),
 	GATE(HCLK_PIDF, "hclk_pidfilter", "hclk_peri", 0, RK2928_CLKGATE_CON(7), 6, GFLAGS),
 	GATE(HCLK_SDMMC, "hclk_sdmmc", "hclk_peri", 0, RK2928_CLKGATE_CON(5), 10, GFLAGS),
@@ -592,7 +594,8 @@ static struct rockchip_clk_branch rk3066a_clk_branches[] __initdata = {
 	GATE(0, "hclk_cif1", "hclk_cpu", 0, RK2928_CLKGATE_CON(6), 6, GFLAGS),
 	GATE(0, "hclk_hdmi", "hclk_cpu", 0, RK2928_CLKGATE_CON(4), 14, GFLAGS),
 
-	GATE(HCLK_OTG1, "hclk_usbotg1", "hclk_peri", 0, RK2928_CLKGATE_CON(5), 14, GFLAGS),
+	GATE(HCLK_OTG1, "hclk_usbotg1", "hclk_peri", CLK_IGNORE_UNUSED,
+			RK2928_CLKGATE_CON(5), 14, GFLAGS),
 
 	GATE(0, "aclk_cif1", "aclk_vio1", 0, RK2928_CLKGATE_CON(6), 7, GFLAGS),
 
@@ -680,7 +683,8 @@ static struct rockchip_clk_branch rk3188_clk_branches[] __initdata = {
 	GATE(0, "hclk_imem0", "hclk_cpu", 0, RK2928_CLKGATE_CON(4), 14, GFLAGS),
 	GATE(0, "hclk_imem1", "hclk_cpu", 0, RK2928_CLKGATE_CON(4), 15, GFLAGS),
 
-	GATE(HCLK_OTG1, "hclk_usbotg1", "hclk_peri", 0, RK2928_CLKGATE_CON(7), 3, GFLAGS),
+	GATE(HCLK_OTG1, "hclk_usbotg1", "hclk_peri", CLK_IGNORE_UNUSED,
+			RK2928_CLKGATE_CON(7), 3, GFLAGS),
 	GATE(HCLK_HSIC, "hclk_hsic", "hclk_peri", 0, RK2928_CLKGATE_CON(7), 4, GFLAGS),
 
 	GATE(PCLK_TIMER3, "pclk_timer3", "pclk_cpu", 0, RK2928_CLKGATE_CON(7), 9, GFLAGS),
-- 
2.1.0

