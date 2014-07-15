Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147AbaGOM5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 08:57:18 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:45290 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758994AbaGOM43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 08:56:29 -0400
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@freescale.com, mkl@pengutronix.de
Cc: kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH v3 2/4] ARM: imx: clk-vf610: fix FlexCAN clock gating
Date: Tue, 15 Jul 2014 14:56:19 +0200
Message-Id: <4c6656872b8e827671a4bf20a50fb62552b20dee.1405428166.git.stefan@agner.ch>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <cover.1405428166.git.stefan@agner.ch>
References: <cover.1405428166.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend the clock control for FlexCAN with the second gate which
enable the clocks in the Clock Divider (CCM_CSCDR2) register too.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/mach-imx/clk-vf610.c           | 6 ++++--
 include/dt-bindings/clock/vf610-clock.h | 4 +++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-imx/clk-vf610.c b/arch/arm/mach-imx/clk-vf610.c
index 22dc3ee..f964079 100644
--- a/arch/arm/mach-imx/clk-vf610.c
+++ b/arch/arm/mach-imx/clk-vf610.c
@@ -295,8 +295,10 @@ static void __init vf610_clocks_init(struct device_node *ccm_node)
 
 	clk[VF610_CLK_ASRC] = imx_clk_gate2("asrc", "ipg_bus", CCM_CCGR4, CCM_CCGRx_CGn(1));
 
-	clk[VF610_CLK_FLEXCAN0] = imx_clk_gate2("flexcan0", "ipg_bus", CCM_CCGR0, CCM_CCGRx_CGn(0));
-	clk[VF610_CLK_FLEXCAN1] = imx_clk_gate2("flexcan1", "ipg_bus", CCM_CCGR9, CCM_CCGRx_CGn(4));
+	clk[VF610_CLK_FLEXCAN0_EN] = imx_clk_gate("flexcan0_en", "ipg_bus", CCM_CSCDR2, 11);
+	clk[VF610_CLK_FLEXCAN0] = imx_clk_gate2("flexcan0", "flexcan0_en", CCM_CCGR0, CCM_CCGRx_CGn(0));
+	clk[VF610_CLK_FLEXCAN1_EN] = imx_clk_gate("flexcan1_en", "ipg_bus", CCM_CSCDR2, 12);
+	clk[VF610_CLK_FLEXCAN1] = imx_clk_gate2("flexcan1", "flexcan1_en", CCM_CCGR9, CCM_CCGRx_CGn(4));
 
 	clk[VF610_CLK_DMAMUX0] = imx_clk_gate2("dmamux0", "platform_bus", CCM_CCGR0, CCM_CCGRx_CGn(4));
 	clk[VF610_CLK_DMAMUX1] = imx_clk_gate2("dmamux1", "platform_bus", CCM_CCGR0, CCM_CCGRx_CGn(5));
diff --git a/include/dt-bindings/clock/vf610-clock.h b/include/dt-bindings/clock/vf610-clock.h
index a916029..00953d9 100644
--- a/include/dt-bindings/clock/vf610-clock.h
+++ b/include/dt-bindings/clock/vf610-clock.h
@@ -164,6 +164,8 @@
 #define VF610_CLK_DMAMUX1		151
 #define VF610_CLK_DMAMUX2		152
 #define VF610_CLK_DMAMUX3		153
-#define VF610_CLK_END			154
+#define VF610_CLK_FLEXCAN0_EN		154
+#define VF610_CLK_FLEXCAN1_EN		155
+#define VF610_CLK_END			156
 
 #endif /* __DT_BINDINGS_CLOCK_VF610_H */
-- 
2.0.1

