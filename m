Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbaIXPeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:34:06 -0400
Received: from mail-pd0-f195.google.com ([209.85.192.195]:39987 "EHLO
	mail-pd0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaIXPeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:34:03 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: heiko@sntech.de, Mike Turquette <mturquette@linaro.org>
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, hj@rock-chips.com,
        huangtao@rock-chips.com, linux-rockchip@lists.infradead.org,
        Kever Yang <kever.yang@rock-chips.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] clk: rockchip: add clock node in PD_VIDEO
Date: Wed, 24 Sep 2014 23:33:22 +0800
Message-Id: <1411572802-22042-4-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411572802-22042-1-git-send-email-kever.yang@rock-chips.com>
References: <1411572802-22042-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add the clock node in PD_VIDEO

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
---

Changes in v2:
- split out the patch

 drivers/clk/rockchip/clk-rk3288.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index d691a56..2cfcfb6 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -296,6 +296,17 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 	COMPOSITE(0, "aclk_vdpu", mux_pll_src_cpll_gpll_usb480m_p, 0,
 			RK3288_CLKSEL_CON(32), 14, 2, MFLAGS, 8, 5, DFLAGS,
 			RK3288_CLKGATE_CON(3), 11, GFLAGS),
+	/*
+	 * We use aclk_vdpu by default GRF_SOC_CON0[7] setting in system,
+	 * so we ignore the mux and make clocks nodes as following,
+	 * NOTE THAT hclk_vcodec is fix div by 4 from aclk_vcodec_pre.
+	 */
+	GATE(ACLK_VCODEC, "aclk_vcodec", "aclk_vdpu", 0,
+		RK3288_CLKGATE_CON(9), 0, GFLAGS),
+	GATE(0, "hclk_vcodec_pre", "aclk_vdpu", 0,
+		RK3288_CLKGATE_CON(3), 10, GFLAGS),
+	GATE(HCLK_VCODEC, "hclk_vcodec", "hclk_vcodec_pre", 0,
+		RK3288_CLKGATE_CON(9), 1, GFLAGS),
 
 	COMPOSITE(0, "aclk_vio0", mux_pll_src_cpll_gpll_usb480m_p, 0,
 			RK3288_CLKSEL_CON(31), 6, 2, MFLAGS, 0, 5, DFLAGS,
-- 
1.9.1

