Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758405AbaKUKKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 05:10:53 -0500
Received: from mo4.mail-out.ovh.net ([178.32.228.4]:43793 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062AbaKUKJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 05:09:07 -0500
From: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
To: Heiko Stuebner <heiko@sntech.de>, Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Rockchip
	SoC...),
        linux-rockchip@lists.infradead.org (open list:ARM/Rockchip SoC...),
        linux-kernel@vger.kernel.org (open list:COMMON CLK FRAMEWORK)
Cc: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
Subject: [PATCH] clk: rockchip: fix rk3188 USB HSIC PHY clock divider
Date: Fri, 21 Nov 2014 11:08:47 +0100
Message-Id: <1416564527-21327-1-git-send-email-julien.chauveau@neo-technologies.fr>
X-Mailer: git-send-email 2.1.0
X-Ovh-Tracer-Id: 1097470935502290972
X-Ovh-Remote: 193.248.240.88 (laubervilliers-656-1-116-88.w193-248.abo.wanadoo.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrkeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrkeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USB HSIC PHY clock divider is set in the register RK2928_CLKSEL_CON(11).

Signed-off-by: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
---
 drivers/clk/rockchip/clk-rk3188.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/rockchip/clk-rk3188.c b/drivers/clk/rockchip/clk-rk3188.c
index 725d841..f27ea47 100644
--- a/drivers/clk/rockchip/clk-rk3188.c
+++ b/drivers/clk/rockchip/clk-rk3188.c
@@ -664,7 +664,7 @@ static struct rockchip_clk_branch rk3188_clk_branches[] __initdata = {
 			RK2928_CLKSEL_CON(30), 0, 2, DFLAGS,
 			RK2928_CLKGATE_CON(3), 6, GFLAGS),
 	DIV(0, "sclk_hsicphy_12m", "sclk_hsicphy_480m", 0,
-			RK2928_CLKGATE_CON(11), 8, 6, DFLAGS),
+			RK2928_CLKSEL_CON(11), 8, 6, DFLAGS),
 
 	MUX(0, "i2s_src", mux_pll_src_gpll_cpll_p, 0,
 			RK2928_CLKSEL_CON(2), 15, 1, MFLAGS),
-- 
2.1.0

