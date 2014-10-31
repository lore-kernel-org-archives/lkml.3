Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315AbaJaJaD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 05:30:03 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:43290 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196AbaJaJaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 05:30:00 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: Mike Turquette <mturquette@linaro.org>, Heiko Stuebner <heiko@sntech.de>
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, hj@rock-chips.com,
        dkl@rock-chips.com, huangtao@rock-chips.com,
        linux-rockchip@lists.infradead.org,
        Kever Yang <kever.yang@rock-chips.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] clk: rockchip: change hierarchy for some clocks
Date: Fri, 31 Oct 2014 17:29:37 +0800
Message-Id: <1414747777-12625-1-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch change the hierarchy for some clocks, to met the following
bus hierarchy:
hclk_usb_peri is bus clock for
|- hclk_otg0,
|- hclk_host0,
|- hclk_host1,
|- hclk_hsic

hclk_emem is bus clock for
|- hclk_nandc0
|- hclk_nandc1

hclk_mem is bus clock for
|- hclk_sdmmc
|- hclk_sdio0
|- hclk_sdio1
|- hclk_emmc

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---

 drivers/clk/rockchip/clk-rk3288.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index 7a0741d..e1106ad 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -652,21 +652,21 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 
 	/* hclk_peri gates */
 	GATE(0, "hclk_peri_matrix", "hclk_peri", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(6), 0, GFLAGS),
-	GATE(HCLK_OTG0, "hclk_otg0", "hclk_peri", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(7), 4, GFLAGS),
-	GATE(HCLK_USBHOST0, "hclk_host0", "hclk_peri", 0, RK3288_CLKGATE_CON(7), 6, GFLAGS),
-	GATE(HCLK_USBHOST1, "hclk_host1", "hclk_peri", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(7), 7, GFLAGS),
-	GATE(HCLK_HSIC, "hclk_hsic", "hclk_peri", 0, RK3288_CLKGATE_CON(7), 8, GFLAGS),
+	GATE(HCLK_OTG0, "hclk_otg0", "hclk_usb_peri", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(7), 4, GFLAGS),
+	GATE(HCLK_USBHOST0, "hclk_host0", "hclk_usb_peri", 0, RK3288_CLKGATE_CON(7), 6, GFLAGS),
+	GATE(HCLK_USBHOST1, "hclk_host1", "hclk_usb_peri", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(7), 7, GFLAGS),
+	GATE(HCLK_HSIC, "hclk_hsic", "hclk_usb_peri", 0, RK3288_CLKGATE_CON(7), 8, GFLAGS),
 	GATE(0, "hclk_usb_peri", "hclk_peri", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(7), 9, GFLAGS),
 	GATE(0, "hclk_peri_ahb_arbi", "hclk_peri", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(7), 10, GFLAGS),
 	GATE(0, "hclk_emem", "hclk_peri", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(7), 12, GFLAGS),
 	GATE(0, "hclk_mem", "hclk_peri", CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(7), 13, GFLAGS),
-	GATE(HCLK_NANDC0, "hclk_nandc0", "hclk_peri", 0, RK3288_CLKGATE_CON(7), 14, GFLAGS),
-	GATE(HCLK_NANDC1, "hclk_nandc1", "hclk_peri", 0, RK3288_CLKGATE_CON(7), 15, GFLAGS),
+	GATE(HCLK_NANDC0, "hclk_nandc0", "hclk_emem", 0, RK3288_CLKGATE_CON(7), 14, GFLAGS),
+	GATE(HCLK_NANDC1, "hclk_nandc1", "hclk_emem", 0, RK3288_CLKGATE_CON(7), 15, GFLAGS),
 	GATE(HCLK_TSP, "hclk_tsp", "hclk_peri", 0, RK3288_CLKGATE_CON(8), 8, GFLAGS),
-	GATE(HCLK_SDMMC, "hclk_sdmmc", "hclk_peri", 0, RK3288_CLKGATE_CON(8), 3, GFLAGS),
-	GATE(HCLK_SDIO0, "hclk_sdio0", "hclk_peri", 0, RK3288_CLKGATE_CON(8), 4, GFLAGS),
-	GATE(HCLK_SDIO1, "hclk_sdio1", "hclk_peri", 0, RK3288_CLKGATE_CON(8), 5, GFLAGS),
-	GATE(HCLK_EMMC, "hclk_emmc", "hclk_peri", 0, RK3288_CLKGATE_CON(8), 6, GFLAGS),
+	GATE(HCLK_SDMMC, "hclk_sdmmc", "hclk_mem", 0, RK3288_CLKGATE_CON(8), 3, GFLAGS),
+	GATE(HCLK_SDIO0, "hclk_sdio0", "hclk_mem", 0, RK3288_CLKGATE_CON(8), 4, GFLAGS),
+	GATE(HCLK_SDIO1, "hclk_sdio1", "hclk_mem", 0, RK3288_CLKGATE_CON(8), 5, GFLAGS),
+	GATE(HCLK_EMMC, "hclk_emmc", "hclk_mem", 0, RK3288_CLKGATE_CON(8), 6, GFLAGS),
 	GATE(HCLK_HSADC, "hclk_hsadc", "hclk_peri", 0, RK3288_CLKGATE_CON(8), 7, GFLAGS),
 	GATE(0, "pmu_hclk_otg0", "hclk_peri", 0, RK3288_CLKGATE_CON(7), 5, GFLAGS),
 
-- 
1.9.1

