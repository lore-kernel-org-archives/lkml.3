Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031267AbaLLRuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:50:44 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:33266 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030962AbaLLRun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:50:43 -0500
From: Romain Perier <romain.perier@gmail.com>
To: heiko@sntech.de
Cc: mturquette@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] clk: rockchip: Fix clock gate for rk3188 hclk_emem_peri
Date: Fri, 12 Dec 2014 17:50:39 +0000
Message-Id: <1418406639-13668-1-git-send-email-romain.perier@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not disable clock gate "hclk_emem_peri", otherwise EMAC clocks no longer work
and it breaks ethernet on RK3066 and RK3188. It fixes a regression introduced by
commit 78eaf6095cc763c1a228ebac5682852f04e85205 ("clk: rockchip: disable unused clocks").

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 drivers/clk/rockchip/clk-rk3188.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/rockchip/clk-rk3188.c b/drivers/clk/rockchip/clk-rk3188.c
index c540789..dcf63a6 100644
--- a/drivers/clk/rockchip/clk-rk3188.c
+++ b/drivers/clk/rockchip/clk-rk3188.c
@@ -427,8 +427,7 @@ static struct rockchip_clk_branch common_clk_branches[] __initdata = {
 	/* hclk_peri gates */
 	GATE(0, "hclk_peri_axi_matrix", "hclk_peri", CLK_IGNORE_UNUSED, RK2928_CLKGATE_CON(4), 0, GFLAGS),
 	GATE(0, "hclk_peri_ahb_arbi", "hclk_peri", CLK_IGNORE_UNUSED, RK2928_CLKGATE_CON(4), 6, GFLAGS),
-	GATE(0, "hclk_emem_peri", "hclk_peri", 0, RK2928_CLKGATE_CON(4), 7, GFLAGS),
+	GATE(0, "hclk_emem_peri", "hclk_peri", CLK_IGNORE_UNUSED, RK2928_CLKGATE_CON(4), 7, GFLAGS),
 	GATE(HCLK_EMAC, "hclk_emac", "hclk_peri", 0, RK2928_CLKGATE_CON(7), 0, GFLAGS),
 	GATE(HCLK_NANDC0, "hclk_nandc0", "hclk_peri", 0, RK2928_CLKGATE_CON(5), 9, GFLAGS),
 	GATE(0, "hclk_usb_peri", "hclk_peri", 0, RK2928_CLKGATE_CON(4), 5, GFLAGS),
--
1.9.1

