Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242Ab3HBIu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 04:50:57 -0400
Received: from [216.32.180.14] ([216.32.180.14]:59758 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758090Ab3HBIuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 04:50:54 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1155h)
From: Jingchang Lu <b35083@freescale.com>
To: <vinod.koul@intel.com>
CC: <djbw@fb.com>, <shawn.guo@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Jingchang Lu <b35083@freescale.com>
Subject: [PATCH 1/3] ARM: imx: Add DMAMUX clock for Vybrid vf610 SoC
Date: Fri, 2 Aug 2013 15:55:46 +0800
Message-ID: <1375430148-4550-1-git-send-email-b35083@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jingchang Lu <b35083@freescale.com>
---
 arch/arm/mach-imx/clk-vf610.c           | 5 +++++
 include/dt-bindings/clock/vf610-clock.h | 6 +++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/clk-vf610.c b/arch/arm/mach-imx/clk-vf610.c
index b169a39..29f88a2 100644
--- a/arch/arm/mach-imx/clk-vf610.c
+++ b/arch/arm/mach-imx/clk-vf610.c
@@ -298,6 +298,11 @@ static void __init vf610_clocks_init(struct device_node *ccm_node)
 	clk[VF610_CLK_FLEXCAN0] = imx_clk_gate2("flexcan0", "ipg_bus", CCM_CCGR0, CCM_CCGRx_CGn(0));
 	clk[VF610_CLK_FLEXCAN1] = imx_clk_gate2("flexcan1", "ipg_bus", CCM_CCGR9, CCM_CCGRx_CGn(4));
 
+	clk[VF610_CLK_DMAMUX0] = imx_clk_gate2("dmamux0", "platform_bus", CCM_CCGR0, CCM_CCGRx_CGn(4));
+	clk[VF610_CLK_DMAMUX1] = imx_clk_gate2("dmamux1", "platform_bus", CCM_CCGR0, CCM_CCGRx_CGn(5));
+	clk[VF610_CLK_DMAMUX2] = imx_clk_gate2("dmamux2", "platform_bus", CCM_CCGR0, CCM_CCGRx_CGn(1));
+	clk[VF610_CLK_DMAMUX3] = imx_clk_gate2("dmamux3", "platform_bus", CCM_CCGR0, CCM_CCGRx_CGn(2));
+
 	clk_set_parent(clk[VF610_CLK_QSPI0_SEL], clk[VF610_CLK_PLL1_PFD4]);
 	clk_set_rate(clk[VF610_CLK_QSPI0_X4_DIV], clk_get_rate(clk[VF610_CLK_QSPI0_SEL]) / 2);
 	clk_set_rate(clk[VF610_CLK_QSPI0_X2_DIV], clk_get_rate(clk[VF610_CLK_QSPI0_X4_DIV]) / 2);
diff --git a/include/dt-bindings/clock/vf610-clock.h b/include/dt-bindings/clock/vf610-clock.h
index 4aa2b48..a916029 100644
--- a/include/dt-bindings/clock/vf610-clock.h
+++ b/include/dt-bindings/clock/vf610-clock.h
@@ -160,6 +160,10 @@
 #define VF610_CLK_GPU2D			147
 #define VF610_CLK_ENET0			148
 #define VF610_CLK_ENET1			149
-#define VF610_CLK_END			150
+#define VF610_CLK_DMAMUX0		150
+#define VF610_CLK_DMAMUX1		151
+#define VF610_CLK_DMAMUX2		152
+#define VF610_CLK_DMAMUX3		153
+#define VF610_CLK_END			154
 
 #endif /* __DT_BINDINGS_CLOCK_VF610_H */
-- 
1.8.0


