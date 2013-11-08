Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab3KHKqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 05:46:15 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:46497
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757027Ab3KHKqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 05:46:09 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzc8kzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h1155h)
From: Jingchang Lu <b35083@freescale.com>
To: <vinod.koul@intel.com>
CC: <dan.j.williams@intel.com>, <shawn.guo@linaro.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, Jingchang Lu <b35083@freescale.com>
Subject: [PATCHv7 2/3] ARM: dts: vf610: Add eDMA node
Date: Fri, 8 Nov 2013 18:01:54 +0800
Message-ID: <1383904915-27634-3-git-send-email-b35083@freescale.com>
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
 no changes in v4 ~ v7.

 changes in v3:
  add vf610 edma dt-bindings namespace with prefix VF610_*.

 changes in v2:
  using generic dma-channels property instead of fsl,dma-channels.

 arch/arm/boot/dts/vf610.dtsi         |  49 +++++++++++++++++
 include/dt-bindings/dma/vf610-edma.h | 103 +++++++++++++++++++++++++++++++++++
 2 files changed, 152 insertions(+)
 create mode 100644 include/dt-bindings/dma/vf610-edma.h

diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
index d31ce1b..365e0fa 100644
--- a/arch/arm/boot/dts/vf610.dtsi
+++ b/arch/arm/boot/dts/vf610.dtsi
@@ -10,6 +10,7 @@
 #include "skeleton.dtsi"
 #include "vf610-pinfunc.h"
 #include <dt-bindings/clock/vf610-clock.h>
+#include <dt-bindings/dma/vf610-edma.h>
 
 / {
 	aliases {
@@ -87,6 +88,30 @@
 				arm,tag-latency = <2 2 2>;
 			};
 
+			edma0: dma-controller@40018000 {
+				#dma-cells = <2>;
+				compatible = "fsl,vf610-edma";
+				reg = <0x40018000 0x2000>;
+				interrupts = <0 8 0x04>, <0 9 0x04>;
+				interrupt-names = "edma-tx", "edma-err";
+				dma-channels = <32>;
+				fsl,dma-mux = <&dmamux0>, <&dmamux1>;
+			};
+
+			dmamux0: dmamux@40024000 {
+				reg = <0x40024000 0x1000>;
+				fsl,dmamux-id = <0>;
+				clocks = <&clks VF610_CLK_DMAMUX0>;
+				clock-names = "dmamux";
+			};
+
+			dmamux1: dmamux@40025000 {
+				reg = <0x40025000 0x1000>;
+				fsl,dmamux-id = <1>;
+				clocks = <&clks VF610_CLK_DMAMUX1>;
+				clock-names = "dmamux";
+			};
+
 			uart0: serial@40027000 {
 				compatible = "fsl,vf610-lpuart";
 				reg = <0x40027000 0x1000>;
@@ -432,6 +457,30 @@
 			reg = <0x40080000 0x80000>;
 			ranges;
 
+			edma1: dma-controller@40098000 {
+				#dma-cells = <2>;
+				compatible = "fsl,vf610-edma";
+				reg = <0x40098000 0x2000>;
+				interrupts = <0 10 0x04>, <0 11 0x04>;
+				interrupt-names = "edma-tx", "edma-err";
+				dma-channels = <32>;
+				fsl,dma-mux = <&dmamux2>, <&dmamux3>;
+			};
+
+			dmamux2: dmamux@400a1000 {
+				reg = <0x400a1000 0x1000>;
+				fsl,dmamux-id = <1>;
+				clocks = <&clks VF610_CLK_DMAMUX2>;
+				clock-names = "dmamux";
+			};
+
+			dmamux3: dmamux@400a2000 {
+				reg = <0x400a2000 0x1000>;
+				fsl,dmamux-id = <0>;
+				clocks = <&clks VF610_CLK_DMAMUX3>;
+				clock-names = "dmamux";
+			};
+
 			uart4: serial@400a9000 {
 				compatible = "fsl,vf610-lpuart";
 				reg = <0x400a9000 0x1000>;
diff --git a/include/dt-bindings/dma/vf610-edma.h b/include/dt-bindings/dma/vf610-edma.h
new file mode 100644
index 0000000..dbe1db2
--- /dev/null
+++ b/include/dt-bindings/dma/vf610-edma.h
@@ -0,0 +1,103 @@
+/*
+ * Copyright 2013 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ */
+
+#ifndef __DT_BINDINGS_VF610_EDMA_H__
+#define __DT_BINDINGS_VF610_EDMA_H__
+
+/* DMAMUX0,3 reqeust source(slot) number */
+#define VF610_EDMA_MUXID0_UART0_RX	2
+#define VF610_EDMA_MUXID0_UART0_TX	3
+#define VF610_EDMA_MUXID0_UART1_RX	4
+#define VF610_EDMA_MUXID0_UART1_TX	5
+#define VF610_EDMA_MUXID0_UART2_RX	6
+#define VF610_EDMA_MUXID0_UART2_TX	7
+#define VF610_EDMA_MUXID0_UART3_RX	8
+#define VF610_EDMA_MUXID0_UART3_TX	9
+#define VF610_EDMA_MUXID0_DSPI0_RX	12
+#define VF610_EDMA_MUXID0_DSPI0_TX	13
+#define VF610_EDMA_MUXID0_DSPI1_RX	14
+#define VF610_EDMA_MUXID0_DSPI1_TX	15
+#define VF610_EDMA_MUXID0_SAI0_RX	16
+#define VF610_EDMA_MUXID0_SAI0_TX	17
+#define VF610_EDMA_MUXID0_SAI1_RX	18
+#define VF610_EDMA_MUXID0_SAI1_TX	19
+#define VF610_EDMA_MUXID0_SAI2_RX	20
+#define VF610_EDMA_MUXID0_SAI2_TX	21
+#define VF610_EDMA_MUXID0_PDB		22
+#define VF610_EDMA_MUXID0_FTM0_CH0	24
+#define VF610_EDMA_MUXID0_FTM0_CH1	25
+#define VF610_EDMA_MUXID0_FTM0_CH2	26
+#define VF610_EDMA_MUXID0_FTM0_CH3	27
+#define VF610_EDMA_MUXID0_FTM0_CH4	28
+#define VF610_EDMA_MUXID0_FTM0_CH5	29
+#define VF610_EDMA_MUXID0_FTM0_CH6	30
+#define VF610_EDMA_MUXID0_FTM0_CH7	31
+#define VF610_EDMA_MUXID0_FTM1_CH0	32
+#define VF610_EDMA_MUXID0_FTM1_CH1	33
+#define VF610_EDMA_MUXID0_ADC0		34
+#define VF610_EDMA_MUXID0_QUADSPI0	36
+#define VF610_EDMA_MUXID0_GPIOA		38
+#define VF610_EDMA_MUXID0_GPIOB		39
+#define VF610_EDMA_MUXID0_GPIOC		40
+#define VF610_EDMA_MUXID0_GPIOD		41
+#define VF610_EDMA_MUXID0_GPIOE		42
+#define VF610_EDMA_MUXID0_RLE_RX	45
+#define VF610_EDMA_MUXID0_RLE_TX	46
+#define VF610_EDMA_MUXID0_SPDIF_RX	47
+#define VF610_EDMA_MUXID0_SPDIF_TX	48
+#define VF610_EDMA_MUXID0_I2C0_RX	50
+#define VF610_EDMA_MUXID0_I2C0_TX	51
+#define VF610_EDMA_MUXID0_I2C1_RX	52
+#define VF610_EDMA_MUXID0_I2C1_TX	53
+
+/* DMA MUX1,2 request source(slot) number */
+#define VF610_EDMA_MUXID1_UART4_RX	2
+#define VF610_EDMA_MUXID1_UART4_TX	3
+#define VF610_EDMA_MUXID1_UART5_RX	4
+#define VF610_EDMA_MUXID1_UART5_TX	5
+#define VF610_EDMA_MUXID1_SAI3_RX	8
+#define VF610_EDMA_MUXID1_SAI3_TX	9
+#define VF610_EDMA_MUXID1_DSPI2_RX	10
+#define VF610_EDMA_MUXID1_DSPI2_TX	11
+#define VF610_EDMA_MUXID1_DSPI3_RX	12
+#define VF610_EDMA_MUXID1_DSPI3_TX	13
+#define VF610_EDMA_MUXID1_FTM2_CH0	16
+#define VF610_EDMA_MUXID1_FTM2_CH1	17
+#define VF610_EDMA_MUXID1_FTM3_CH0	18
+#define VF610_EDMA_MUXID1_FTM3_CH1	19
+#define VF610_EDMA_MUXID1_FTM3_CH2	20
+#define VF610_EDMA_MUXID1_FTM3_CH3	21
+#define VF610_EDMA_MUXID1_FTM3_CH4	22
+#define VF610_EDMA_MUXID1_FTM3_CH5	24
+#define VF610_EDMA_MUXID1_FTM3_CH6	25
+#define VF610_EDMA_MUXID1_FTM3_CH7	26
+#define VF610_EDMA_MUXID1_QUADSPI1	27
+#define VF610_EDMA_MUXID1_DAC0		32
+#define VF610_EDMA_MUXID1_DAC1		33
+#define VF610_EDMA_MUXID1_ESAI_BIFIFO_TX	34
+#define VF610_EDMA_MUXID1_ESAI_BIFIFO_RX	35
+#define VF610_EDMA_MUXID1_I2C2_RX	36
+#define VF610_EDMA_MUXID1_I2C2_TX	37
+#define VF610_EDMA_MUXID1_I2C3_RX	38
+#define VF610_EDMA_MUXID1_I2C3_TX	39
+#define VF610_EDMA_MUXID1_ASRC0_TX	40
+#define VF610_EDMA_MUXID1_ASRC0_RX	41
+#define VF610_EDMA_MUXID1_ASRC1_TX	42
+#define VF610_EDMA_MUXID1_ASRC1_RX	43
+#define VF610_EDMA_MUXID1_TIMER0	44
+#define VF610_EDMA_MUXID1_TIMER1	45
+#define VF610_EDMA_MUXID1_TIMER2	46
+#define VF610_EDMA_MUXID1_TIMER3	47
+#define VF610_EDMA_MUXID1_TIMER4	48
+#define VF610_EDMA_MUXID1_TIMER5	49
+#define VF610_EDMA_MUXID1_TIMER6	50
+#define VF610_EDMA_MUXID1_TIMER7	51
+
+#endif
-- 
1.8.0


