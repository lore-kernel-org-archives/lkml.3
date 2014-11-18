Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaKRLLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:11:17 -0500
Received: from 3.mo2.mail-out.ovh.net ([46.105.58.226]:60563 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752006AbaKRLLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:11:16 -0500
From: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
To: Heiko Stuebner <heiko@sntech.de>, Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Rockchip
	SoC...),
        linux-rockchip@lists.infradead.org (open list:ARM/Rockchip SoC...),
        linux-kernel@vger.kernel.org (open list:COMMON CLK FRAMEWORK)
Cc: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
Subject: [PATCH] clk: rockchip: fix parent clock for rk3188 hclk_lcdc1
Date: Tue, 18 Nov 2014 12:10:43 +0100
Message-Id: <1416309043-29069-1-git-send-email-julien.chauveau@neo-technologies.fr>
X-Mailer: git-send-email 2.1.0
X-Ovh-Tracer-Id: 2976034929571725340
X-Ovh-Remote: 193.248.240.88 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrkedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrkedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The parent clock for hclk_lcdc1 was set to aclk_cpu instead of hclk_cpu.

Signed-off-by: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
---
 drivers/clk/rockchip/clk-rk3188.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/rockchip/clk-rk3188.c b/drivers/clk/rockchip/clk-rk3188.c
index f88eb7d..e6cd483 100644
--- a/drivers/clk/rockchip/clk-rk3188.c
+++ b/drivers/clk/rockchip/clk-rk3188.c
@@ -410,7 +410,7 @@ static struct rockchip_clk_branch common_clk_branches[] __initdata = {
 	/* hclk_ahb2apb is part of a clk branch */
 	GATE(0, "hclk_vio_bus", "hclk_cpu", 0, RK2928_CLKGATE_CON(6), 12, GFLAGS),
 	GATE(HCLK_LCDC0, "hclk_lcdc0", "hclk_cpu", 0, RK2928_CLKGATE_CON(6), 1, GFLAGS),
-	GATE(HCLK_LCDC1, "hclk_lcdc1", "aclk_cpu", 0, RK2928_CLKGATE_CON(6), 2, GFLAGS),
+	GATE(HCLK_LCDC1, "hclk_lcdc1", "hclk_cpu", 0, RK2928_CLKGATE_CON(6), 2, GFLAGS),
 	GATE(HCLK_CIF0, "hclk_cif0", "hclk_cpu", 0, RK2928_CLKGATE_CON(6), 4, GFLAGS),
 	GATE(HCLK_IPP, "hclk_ipp", "hclk_cpu", 0, RK2928_CLKGATE_CON(6), 9, GFLAGS),
 	GATE(HCLK_RGA, "hclk_rga", "hclk_cpu", 0, RK2928_CLKGATE_CON(6), 10, GFLAGS),
-- 
2.1.0

