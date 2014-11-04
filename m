Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaKDHzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 02:55:40 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:37819 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaKDHzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 02:55:36 -0500
From: Kever Yang <kever.yang@rock-chips.com>
To: Mike Turquette <mturquette@linaro.org>, Heiko Stuebner <heiko@sntech.de>
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, fzf@rock-chips.com, ykk@rock-chips.com,
        yzq@rock-chips.com, dkl@rock-chips.com, huangtao@rock-chips.com,
        Kever Yang <kever.yang@rock-chips.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] clk: rockchip: change DCLK_VOP0 to use new COMPOSITE_DIVOPS
Date: Tue,  4 Nov 2014 15:52:39 +0800
Message-Id: <1415087559-19444-6-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415087559-19444-1-git-send-email-kever.yang@rock-chips.com>
References: <1415087559-19444-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HDMI clock is actually provide by DCLK_VOP0, so we need this
patch to handle the HDMI clock correctly

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---

 drivers/clk/rockchip/clk-rk3288.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index 0151140..073a719 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -396,8 +396,10 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 			RK3288_CLKSEL_CON(30), 14, 2, MFLAGS, 8, 5, DFLAGS,
 			RK3288_CLKGATE_CON(3), 4, GFLAGS),
 
-	COMPOSITE(DCLK_VOP0, "dclk_vop0", mux_pll_src_cpll_gpll_npll_p, 0,
+	COMPOSITE_DIVOPS(DCLK_VOP0, "dclk_vop0", mux_pll_src_cpll_gpll_npll_p,
+			(CLK_IGNORE_UNUSED | CLK_SET_RATE_PARENT),
 			RK3288_CLKSEL_CON(27), 0, 2, MFLAGS, 8, 8, DFLAGS,
+			&dclk_vop_ops,
 			RK3288_CLKGATE_CON(3), 1, GFLAGS),
 	COMPOSITE(DCLK_VOP1, "dclk_vop1", mux_pll_src_cpll_gpll_npll_p, 0,
 			RK3288_CLKSEL_CON(29), 6, 2, MFLAGS, 8, 8, DFLAGS,
-- 
1.9.1

