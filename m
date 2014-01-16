Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbaAPD1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 22:27:50 -0500
Received: from mail-db9lp0249.outbound.messaging.microsoft.com ([213.199.154.249]:27050
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752264AbaAPD1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 22:27:43 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h2461h2487h1155h)
From: Jingchang Lu <b35083@freescale.com>
To: <vinod.koul@intel.com>
CC: <dan.j.williams@intel.com>, <arnd@arndb.de>, <shawn.guo@linaro.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, Jingchang Lu <b35083@freescale.com>
Subject: [PATCHv9 1/2] ARM: dts: vf610: Add eDMA node
Date: Thu, 16 Jan 2014 10:29:59 +0800
Message-ID: <1389839400-29728-2-git-send-email-b35083@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1389839400-29728-1-git-send-email-b35083@freescale.com>
References: <1389839400-29728-1-git-send-email-b35083@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jingchang Lu <b35083@freescale.com>
---
changes in v9:
 remove include/dt-bindings/dma/vf610-edma.h, the request source ID
 is the same as SoC's reference manual.

changes in v8:
 describe dmamux info in edma node to avoid confusion.
 change eDMA requst source macro definitions.

 changes in v7:
 fix dmamux2 and dmamux3 register number.

 no changes in v2 ~ v6.

 arch/arm/boot/dts/vf610.dtsi | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
index 48dbfe5..8febb29f 100644
--- a/arch/arm/boot/dts/vf610.dtsi
+++ b/arch/arm/boot/dts/vf610.dtsi
@@ -88,6 +88,21 @@
 				arm,tag-latency = <2 2 2>;
 			};
 
+			edma0: dma-controller@40018000 {
+				#dma-cells = <2>;
+				compatible = "fsl,vf610-edma";
+				reg = <0x40018000 0x2000>,
+					<0x40024000 0x1000>,
+					<0x40025000 0x1000>;
+				interrupts = <0 8 IRQ_TYPE_LEVEL_HIGH>,
+						<0 9 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "edma-tx", "edma-err";
+				dma-channels = <32>;
+				clock-names = "dmamux0", "dmamux1";
+				clocks = <&clks VF610_CLK_DMAMUX0>,
+					<&clks VF610_CLK_DMAMUX1>;
+			};
+
 			uart0: serial@40027000 {
 				compatible = "fsl,vf610-lpuart";
 				reg = <0x40027000 0x1000>;
@@ -263,6 +278,21 @@
 			reg = <0x40080000 0x80000>;
 			ranges;
 
+			edma1: dma-controller@40098000 {
+				#dma-cells = <2>;
+				compatible = "fsl,vf610-edma";
+				reg = <0x40098000 0x2000>,
+					<0x400a1000 0x1000>,
+					<0x400a2000 0x1000>;
+				interrupts = <0 10 IRQ_TYPE_LEVEL_HIGH>,
+						<0 11 IRQ_TYPE_LEVEL_HIGH>;
+				interrupt-names = "edma-tx", "edma-err";
+				dma-channels = <32>;
+				clock-names = "dmamux0", "dmamux1";
+				clocks = <&clks VF610_CLK_DMAMUX2>,
+					<&clks VF610_CLK_DMAMUX3>;
+			};
+
 			uart4: serial@400a9000 {
 				compatible = "fsl,vf610-lpuart";
 				reg = <0x400a9000 0x1000>;
-- 
1.8.0


