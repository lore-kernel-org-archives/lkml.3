Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbaJHIzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 04:55:33 -0400
Received: from mail-ig0-f201.google.com ([209.85.213.201]:48353 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726AbaJHIz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 04:55:28 -0400
From: Sonny Rao <sonnyrao@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>
Cc: linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, dianders@chromium.org,
        Mike Turquette <mturquette@linaro.org>,
        Sonny Rao <sonnyrao@chromium.org>
Subject: [PATCH] clk: rockchip: fix parent for spdif_8ch_frac on rk3288
Date: Wed,  8 Oct 2014 01:55:16 -0700
Message-Id: <1412758516-18285-1-git-send-email-sonnyrao@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The parent should be spdif_8ch_pre not spdif_8ch_src, which doesn't
exist and looks to be a typo.  The TRM also confirms this.

Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
---
 drivers/clk/rockchip/clk-rk3288.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
index 2327829..e41ae1f 100644
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -325,7 +325,7 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
 	COMPOSITE_NOMUX(0, "spdif_8ch_pre", "spdif_src", 0,
 			RK3288_CLKSEL_CON(40), 0, 7, DFLAGS,
 			RK3288_CLKGATE_CON(4), 7, GFLAGS),
-	COMPOSITE_FRAC(0, "spdif_8ch_frac", "spdif_8ch_src", 0,
+	COMPOSITE_FRAC(0, "spdif_8ch_frac", "spdif_8ch_pre", 0,
 			RK3288_CLKSEL_CON(41), 0,
 			RK3288_CLKGATE_CON(4), 8, GFLAGS),
 	COMPOSITE_NODIV(SCLK_SPDIF8CH, "sclk_spdif_8ch", mux_spdif_8ch_p, 0,
-- 
1.8.3.2

