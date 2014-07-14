Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbaGNHtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 03:49:07 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:33943 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbaGNHsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 03:48:41 -0400
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@freescale.com, mkl@pengutronix.de
Cc: kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH v2 2/4] ARM: imx: clk-vf610: fix FlexCAN clock gating
Date: Mon, 14 Jul 2014 09:48:29 +0200
Message-Id: <94282392d8355ac25bb998b89032c1c980d5ccce.1405322992.git.stefan@agner.ch>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <cover.1405322992.git.stefan@agner.ch>
References: <cover.1405322992.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend the clock control for FlexCAN with the second gate which
enable the clocks in the Clock Divider (CCM_CSCDR2) register too.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/mach-imx/clk-vf610.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-imx/clk-vf610.c b/arch/arm/mach-imx/clk-vf610.c
index 22dc3ee..b12b888 100644
--- a/arch/arm/mach-imx/clk-vf610.c
+++ b/arch/arm/mach-imx/clk-vf610.c
@@ -295,8 +295,10 @@ static void __init vf610_clocks_init(struct device_node *ccm_node)
 
 	clk[VF610_CLK_ASRC] = imx_clk_gate2("asrc", "ipg_bus", CCM_CCGR4, CCM_CCGRx_CGn(1));
 
-	clk[VF610_CLK_FLEXCAN0] = imx_clk_gate2("flexcan0", "ipg_bus", CCM_CCGR0, CCM_CCGRx_CGn(0));
-	clk[VF610_CLK_FLEXCAN1] = imx_clk_gate2("flexcan1", "ipg_bus", CCM_CCGR9, CCM_CCGRx_CGn(4));
+	clk[VF610_CLK_FLEXCAN0] = imx_clk_gate("flexcan0_en", "ipg_bus", CCM_CSCDR2, 11);
+	clk[VF610_CLK_FLEXCAN0] = imx_clk_gate2("flexcan0", "flexcan0_en", CCM_CCGR0, CCM_CCGRx_CGn(0));
+	clk[VF610_CLK_FLEXCAN1] = imx_clk_gate("flexcan1_en", "ipg_bus", CCM_CSCDR2, 12);
+	clk[VF610_CLK_FLEXCAN1] = imx_clk_gate2("flexcan1", "flexcan1_en", CCM_CCGR9, CCM_CCGRx_CGn(4));
 
 	clk[VF610_CLK_DMAMUX0] = imx_clk_gate2("dmamux0", "platform_bus", CCM_CCGR0, CCM_CCGRx_CGn(4));
 	clk[VF610_CLK_DMAMUX1] = imx_clk_gate2("dmamux1", "platform_bus", CCM_CCGR0, CCM_CCGRx_CGn(5));
-- 
2.0.1

