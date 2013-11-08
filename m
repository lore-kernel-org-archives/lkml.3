Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab3KHKqG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 05:46:06 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:38004
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757027Ab3KHKqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 05:46:03 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h1155h)
From: Jingchang Lu <b35083@freescale.com>
To: <vinod.koul@intel.com>
CC: <dan.j.williams@intel.com>, <shawn.guo@linaro.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, Jingchang Lu <b35083@freescale.com>
Subject: [PATCHv7 1/3] ARM: imx: Add DMAMUX clock for Vybrid vf610 SoC
Date: Fri, 8 Nov 2013 18:01:53 +0800
Message-ID: <1383904915-27634-2-git-send-email-b35083@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1383904915-27634-1-git-send-email-b35083@freescale.com>
References: <1383904915-27634-1-git-send-email-b35083@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jingchang Lu <b35083@freescale.com>
---
 changes in v7:
 fix dmamux2 and dmamux3 register number.

 no changes in v2 ~ v6.

 arch/arm/mach-imx/clk-vf610.c           | 5 +++++
 include/dt-bindings/clock/vf610-clock.h | 6 +++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/clk-vf610.c b/arch/arm/mach-imx/clk-vf610.c
index b169a39..ecd66d8 100644
--- a/arch/arm/mach-imx/clk-vf610.c
+++ b/arch/arm/mach-imx/clk-vf610.c
@@ -298,6 +298,11 @@ static void __init vf610_clocks_init(struct device_node *ccm_node)
 	clk[VF610_CLK_FLEXCAN0] = imx_clk_gate2("flexcan0", "ipg_bus", CCM_CCGR0, CCM_CCGRx_CGn(0));
 	clk[VF610_CLK_FLEXCAN1] = imx_clk_gate2("flexcan1", "ipg_bus", CCM_CCGR9, CCM_CCGRx_CGn(4));
 
+	clk[VF610_CLK_DMAMUX0] = imx_clk_gate2("dmamux0", "platform_bus", CCM_CCGR0, CCM_CCGRx_CGn(4));
+	clk[VF610_CLK_DMAMUX1] = imx_clk_gate2("dmamux1", "platform_bus", CCM_CCGR0, CCM_CCGRx_CGn(5));
+	clk[VF610_CLK_DMAMUX2] = imx_clk_gate2("dmamux2", "platform_bus", CCM_CCGR6, CCM_CCGRx_CGn(1));
+	clk[VF610_CLK_DMAMUX3] = imx_clk_gate2("dmamux3", "platform_bus", CCM_CCGR6, CCM_CCGRx_CGn(2));
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


