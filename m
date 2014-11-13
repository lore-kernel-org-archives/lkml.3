Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbaKMHVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 02:21:50 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:64469 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaKMHVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 02:21:49 -0500
From: Kever Yang <kever.yang@rock-chips.com>
To: Heiko Stuebner <heiko@sntech.de>, Mike Turquette <mturquette@linaro.org>
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, dkl@rock-chips.com, huangtao@rock-chips.com,
        linux-rockchip@lists.infradead.org,
        Kever Yang <kever.yang@rock-chips.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] clk: rockchip: fix clk_usbphy480m_gate bit location in register
Date: Thu, 13 Nov 2014 15:19:21 +0800
Message-Id: <1415863161-15495-1-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to rk3288 trm, the clk_usbphy480m_gate is locate at
bit 14 of CRU_CLKGATE5_CON register.

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---

 drivers/clk/rockchip/clk-rk3288.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index 1a9d03c..74f8324 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -588,7 +588,7 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 
 	COMPOSITE_NODIV(0, "usbphy480m_src", mux_usbphy480m_p, 0,
 			RK3288_CLKSEL_CON(13), 11, 2, MFLAGS,
-			RK3288_CLKGATE_CON(5), 15, GFLAGS),
+			RK3288_CLKGATE_CON(5), 14, GFLAGS),
 	COMPOSITE_NODIV(SCLK_HSICPHY480M, "sclk_hsicphy480m", mux_hsicphy480m_p, 0,
 			RK3288_CLKSEL_CON(29), 0, 2, MFLAGS,
 			RK3288_CLKGATE_CON(3), 6, GFLAGS),
-- 
1.9.1

