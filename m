Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339AbaABHsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 02:48:13 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:22261
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733AbaABHrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 02:47:39 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzc8kzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Jingchang Lu <b35083@freescale.com>
To: <vinod.koul@intel.com>
CC: <dan.j.williams@intel.com>, <shawn.guo@linaro.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, Jingchang Lu <b35083@freescale.com>
Subject: [PATCHv8 1/2] ARM: dts: vf610: Add eDMA node
Date: Thu, 2 Jan 2014 14:52:23 +0800
Message-ID: <1388645544-5596-2-git-send-email-b35083@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1388645544-5596-1-git-send-email-b35083@freescale.com>
References: <1388645544-5596-1-git-send-email-b35083@freescale.com>
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
 changes in v8:
 describe dmamux info in edma node to avoid confusion.
 change eDMA requst source macro definitions.

 changes in v7:
 fix dmamux2 and dmamux3 register number.

 no changes in v2 ~ v6.

 arch/arm/boot/dts/vf610.dtsi         |  31 ++++++
 include/dt-bindings/dma/vf610-edma.h | 195 +++++++++++++++++++++++++++++++++++
 2 files changed, 226 insertions(+)
 create mode 100644 include/dt-bindings/dma/vf610-edma.h

diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
index ef8a0ee..9f433b4 100644
--- a/arch/arm/boot/dts/vf610.dtsi
+++ b/arch/arm/boot/dts/vf610.dtsi
@@ -10,6 +10,7 @@
 #include "skeleton.dtsi"
 #include "vf610-pingrp.h"
 #include <dt-bindings/clock/vf610-clock.h>
+#include <dt-bindings/dma/vf610-edma.h>
 
 / {
 	aliases {
@@ -87,6 +88,21 @@
 				arm,tag-latency = <2 2 2>;
 			};
 
+			edma0: dma-controller@40018000 {
+				#dma-cells = <2>;
+				compatible = "fsl,vf610-edma";
+				reg = <0x40018000 0x2000>,
+					<0x40024000 0x1000>,
+					<0x40025000 0x1000>;
+				interrupts = <0 8 0x04>,
+						<0 9 0x04>;
+				interrupt-names = "edma-tx", "edma-err";
+				dma-channels = <32>;
+				clocks = <&clks VF610_CLK_DMAMUX0>,
+					<&clks VF610_CLK_DMAMUX1>;
+				clock-names = "dmamux0", "dmamux1";
+			};
+
 			uart0: serial@40027000 {
 				compatible = "fsl,vf610-lpuart";
 				reg = <0x40027000 0x1000>;
@@ -262,6 +278,21 @@
 			reg = <0x40080000 0x80000>;
 			ranges;
 
+			edma1: dma-controller@40098000 {
+				#dma-cells = <2>;
+				compatible = "fsl,vf610-edma";
+				reg = <0x40098000 0x2000>,
+					<0x400a1000 0x1000>,
+					<0x400a2000 0x1000>;
+				interrupts = <0 10 0x04>,
+						<0 11 0x04>;
+				interrupt-names = "edma-tx", "edma-err";
+				dma-channels = <32>;
+				clocks = <&clks VF610_CLK_DMAMUX2>,
+					<&clks VF610_CLK_DMAMUX3>;
+				clock-names = "dmamux0", "dmamux1";
+			};
+
 			uart4: serial@400a9000 {
 				compatible = "fsl,vf610-lpuart";
 				reg = <0x400a9000 0x1000>;
diff --git a/include/dt-bindings/dma/vf610-edma.h b/include/dt-bindings/dma/vf610-edma.h
new file mode 100644
index 0000000..2c04142
--- /dev/null
+++ b/include/dt-bindings/dma/vf610-edma.h
@@ -0,0 +1,195 @@
+/*
+ * Copyright 2013-2014 Freescale Semiconductor, Inc.
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
+#define VF610_EDMA_DMAMUX0		0
+#define VF610_EDMA_DMAMUX1		1
+
+/* eDMA0 DMAMUX0 group reqeust source(slot) number */
+#define VF610_EDMA0_MUX0_UART0_RX	2
+#define VF610_EDMA0_MUX0_UART0_TX	3
+#define VF610_EDMA0_MUX0_UART1_RX	4
+#define VF610_EDMA0_MUX0_UART1_TX	5
+#define VF610_EDMA0_MUX0_UART2_RX	6
+#define VF610_EDMA0_MUX0_UART2_TX	7
+#define VF610_EDMA0_MUX0_UART3_RX	8
+#define VF610_EDMA0_MUX0_UART3_TX	9
+#define VF610_EDMA0_MUX0_DSPI0_RX	12
+#define VF610_EDMA0_MUX0_DSPI0_TX	13
+#define VF610_EDMA0_MUX0_DSPI1_RX	14
+#define VF610_EDMA0_MUX0_DSPI1_TX	15
+#define VF610_EDMA0_MUX0_SAI0_RX	16
+#define VF610_EDMA0_MUX0_SAI0_TX	17
+#define VF610_EDMA0_MUX0_SAI1_RX	18
+#define VF610_EDMA0_MUX0_SAI1_TX	19
+#define VF610_EDMA0_MUX0_SAI2_RX	20
+#define VF610_EDMA0_MUX0_SAI2_TX	21
+#define VF610_EDMA0_MUX0_PDB		22
+#define VF610_EDMA0_MUX0_FTM0_CH0	24
+#define VF610_EDMA0_MUX0_FTM0_CH1	25
+#define VF610_EDMA0_MUX0_FTM0_CH2	26
+#define VF610_EDMA0_MUX0_FTM0_CH3	27
+#define VF610_EDMA0_MUX0_FTM0_CH4	28
+#define VF610_EDMA0_MUX0_FTM0_CH5	29
+#define VF610_EDMA0_MUX0_FTM0_CH6	30
+#define VF610_EDMA0_MUX0_FTM0_CH7	31
+#define VF610_EDMA0_MUX0_FTM1_CH0	32
+#define VF610_EDMA0_MUX0_FTM1_CH1	33
+#define VF610_EDMA0_MUX0_ADC0		34
+#define VF610_EDMA0_MUX0_QUADSPI0	36
+#define VF610_EDMA0_MUX0_GPIOA		38
+#define VF610_EDMA0_MUX0_GPIOB		39
+#define VF610_EDMA0_MUX0_GPIOC		40
+#define VF610_EDMA0_MUX0_GPIOD		41
+#define VF610_EDMA0_MUX0_GPIOE		42
+#define VF610_EDMA0_MUX0_RLE_RX		45
+#define VF610_EDMA0_MUX0_RLE_TX		46
+#define VF610_EDMA0_MUX0_SPDIF_RX	47
+#define VF610_EDMA0_MUX0_SPDIF_TX	48
+#define VF610_EDMA0_MUX0_I2C0_RX	50
+#define VF610_EDMA0_MUX0_I2C0_TX	51
+#define VF610_EDMA0_MUX0_I2C1_RX	52
+#define VF610_EDMA0_MUX0_I2C1_TX	53
+
+/* eDMA DMAMUX1 group request source(slot) number */
+#define VF610_EDMA0_MUX1_UART4_RX	2
+#define VF610_EDMA0_MUX1_UART4_TX	3
+#define VF610_EDMA0_MUX1_UART5_RX	4
+#define VF610_EDMA0_MUX1_UART5_TX	5
+#define VF610_EDMA0_MUX1_SAI3_RX	8
+#define VF610_EDMA0_MUX1_SAI3_TX	9
+#define VF610_EDMA0_MUX1_DSPI2_RX	10
+#define VF610_EDMA0_MUX1_DSPI2_TX	11
+#define VF610_EDMA0_MUX1_DSPI3_RX	12
+#define VF610_EDMA0_MUX1_DSPI3_TX	13
+#define VF610_EDMA0_MUX1_FTM2_CH0	16
+#define VF610_EDMA0_MUX1_FTM2_CH1	17
+#define VF610_EDMA0_MUX1_FTM3_CH0	18
+#define VF610_EDMA0_MUX1_FTM3_CH1	19
+#define VF610_EDMA0_MUX1_FTM3_CH2	20
+#define VF610_EDMA0_MUX1_FTM3_CH3	21
+#define VF610_EDMA0_MUX1_FTM3_CH4	22
+#define VF610_EDMA0_MUX1_FTM3_CH5	24
+#define VF610_EDMA0_MUX1_FTM3_CH6	25
+#define VF610_EDMA0_MUX1_FTM3_CH7	26
+#define VF610_EDMA0_MUX1_QUADSPI1	27
+#define VF610_EDMA0_MUX1_DAC0		32
+#define VF610_EDMA0_MUX1_DAC1		33
+#define VF610_EDMA0_MUX1_ESAI_BIFIFO_TX	34
+#define VF610_EDMA0_MUX1_ESAI_BIFIFO_RX	35
+#define VF610_EDMA0_MUX1_I2C2_RX	36
+#define VF610_EDMA0_MUX1_I2C2_TX	37
+#define VF610_EDMA0_MUX1_I2C3_RX	38
+#define VF610_EDMA0_MUX1_I2C3_TX	39
+#define VF610_EDMA0_MUX1_ASRC0_TX	40
+#define VF610_EDMA0_MUX1_ASRC0_RX	41
+#define VF610_EDMA0_MUX1_ASRC1_TX	42
+#define VF610_EDMA0_MUX1_ASRC1_RX	43
+#define VF610_EDMA0_MUX1_TIMER0		44
+#define VF610_EDMA0_MUX1_TIMER1		45
+#define VF610_EDMA0_MUX1_TIMER2		46
+#define VF610_EDMA0_MUX1_TIMER3		47
+#define VF610_EDMA0_MUX1_TIMER4		48
+#define VF610_EDMA0_MUX1_TIMER5		49
+#define VF610_EDMA0_MUX1_TIMER6		50
+#define VF610_EDMA0_MUX1_TIMER7		51
+
+/* eDMA1 DMAMUX0 request source(slot) number */
+#define VF610_EDMA1_MUX0_UART4_RX	2
+#define VF610_EDMA1_MUX0_UART4_TX	3
+#define VF610_EDMA1_MUX0_UART5_RX	4
+#define VF610_EDMA1_MUX0_UART5_TX	5
+#define VF610_EDMA1_MUX0_SAI3_RX	8
+#define VF610_EDMA1_MUX0_SAI3_TX	9
+#define VF610_EDMA1_MUX0_DSPI2_RX	10
+#define VF610_EDMA1_MUX0_DSPI2_TX	11
+#define VF610_EDMA1_MUX0_DSPI3_RX	12
+#define VF610_EDMA1_MUX0_DSPI3_TX	13
+#define VF610_EDMA1_MUX0_FTM2_CH0	16
+#define VF610_EDMA1_MUX0_FTM2_CH1	17
+#define VF610_EDMA1_MUX0_FTM3_CH0	18
+#define VF610_EDMA1_MUX0_FTM3_CH1	19
+#define VF610_EDMA1_MUX0_FTM3_CH2	20
+#define VF610_EDMA1_MUX0_FTM3_CH3	21
+#define VF610_EDMA1_MUX0_FTM3_CH4	22
+#define VF610_EDMA1_MUX0_FTM3_CH5	24
+#define VF610_EDMA1_MUX0_FTM3_CH6	25
+#define VF610_EDMA1_MUX0_FTM3_CH7	26
+#define VF610_EDMA1_MUX0_QUADSPI1	27
+#define VF610_EDMA1_MUX0_DAC0		32
+#define VF610_EDMA1_MUX0_DAC1		33
+#define VF610_EDMA1_MUX0_ESAI_BIFIFO_TX	34
+#define VF610_EDMA1_MUX0_ESAI_BIFIFO_RX	35
+#define VF610_EDMA1_MUX0_I2C2_RX	36
+#define VF610_EDMA1_MUX0_I2C2_TX	37
+#define VF610_EDMA1_MUX0_I2C3_RX	38
+#define VF610_EDMA1_MUX0_I2C3_TX	39
+#define VF610_EDMA1_MUX0_ASRC0_TX	40
+#define VF610_EDMA1_MUX0_ASRC0_RX	41
+#define VF610_EDMA1_MUX0_ASRC1_TX	42
+#define VF610_EDMA1_MUX0_ASRC1_RX	43
+#define VF610_EDMA1_MUX0_TIMER0		44
+#define VF610_EDMA1_MUX0_TIMER1		45
+#define VF610_EDMA1_MUX0_TIMER2		46
+#define VF610_EDMA1_MUX0_TIMER3		47
+#define VF610_EDMA1_MUX0_TIMER4		48
+#define VF610_EDMA1_MUX0_TIMER5		49
+#define VF610_EDMA1_MUX0_TIMER6		50
+#define VF610_EDMA1_MUX0_TIMER7		51
+
+/* eDMA1 DMAMUX1 group reqeust source(slot) number */
+#define VF610_EDMA1_MUX1_UART0_RX	2
+#define VF610_EDMA1_MUX1_UART0_TX	3
+#define VF610_EDMA1_MUX1_UART1_RX	4
+#define VF610_EDMA1_MUX1_UART1_TX	5
+#define VF610_EDMA1_MUX1_UART2_RX	6
+#define VF610_EDMA1_MUX1_UART2_TX	7
+#define VF610_EDMA1_MUX1_UART3_RX	8
+#define VF610_EDMA1_MUX1_UART3_TX	9
+#define VF610_EDMA1_MUX1_DSPI0_RX	12
+#define VF610_EDMA1_MUX1_DSPI0_TX	13
+#define VF610_EDMA1_MUX1_DSPI1_RX	14
+#define VF610_EDMA1_MUX1_DSPI1_TX	15
+#define VF610_EDMA1_MUX1_SAI0_RX	16
+#define VF610_EDMA1_MUX1_SAI0_TX	17
+#define VF610_EDMA1_MUX1_SAI1_RX	18
+#define VF610_EDMA1_MUX1_SAI1_TX	19
+#define VF610_EDMA1_MUX1_SAI2_RX	20
+#define VF610_EDMA1_MUX1_SAI2_TX	21
+#define VF610_EDMA1_MUX1_PDB		22
+#define VF610_EDMA1_MUX1_FTM0_CH0	24
+#define VF610_EDMA1_MUX1_FTM0_CH1	25
+#define VF610_EDMA1_MUX1_FTM0_CH2	26
+#define VF610_EDMA1_MUX1_FTM0_CH3	27
+#define VF610_EDMA1_MUX1_FTM0_CH4	28
+#define VF610_EDMA1_MUX1_FTM0_CH5	29
+#define VF610_EDMA1_MUX1_FTM0_CH6	30
+#define VF610_EDMA1_MUX1_FTM0_CH7	31
+#define VF610_EDMA1_MUX1_FTM1_CH0	32
+#define VF610_EDMA1_MUX1_FTM1_CH1	33
+#define VF610_EDMA1_MUX1_ADC0		34
+#define VF610_EDMA1_MUX1_QUADSPI0	36
+#define VF610_EDMA1_MUX1_GPIOA		38
+#define VF610_EDMA1_MUX1_GPIOB		39
+#define VF610_EDMA1_MUX1_GPIOC		40
+#define VF610_EDMA1_MUX1_GPIOD		41
+#define VF610_EDMA1_MUX1_GPIOE		42
+#define VF610_EDMA1_MUX1_RLE_RX		45
+#define VF610_EDMA1_MUX1_RLE_TX		46
+#define VF610_EDMA1_MUX1_SPDIF_RX	47
+#define VF610_EDMA1_MUX1_SPDIF_TX	48
+#define VF610_EDMA1_MUX1_I2C0_RX	50
+#define VF610_EDMA1_MUX1_I2C0_TX	51
+#define VF610_EDMA1_MUX1_I2C1_RX	52
+#define VF610_EDMA1_MUX1_I2C1_TX	53
+
+#endif
-- 
1.8.0


