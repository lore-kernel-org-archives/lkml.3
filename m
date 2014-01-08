Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbaAHIpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:45:46 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:10764
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755415AbaAHIpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:45:31 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzdchz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <kernel@pengutronix.de>, <shawn.guo@linaro.org>,
        <fabio.estevam@freescale.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 1/2] Revert "ARM: dts: imx: use dual-fifo sdma script for ssi"
Date: Wed, 8 Jan 2014 16:45:55 +0800
Message-ID: <1389170756-22351-2-git-send-email-Guangyu.Chen@freescale.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1389170756-22351-1-git-send-email-Guangyu.Chen@freescale.com>
References: <1389170756-22351-1-git-send-email-Guangyu.Chen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit b1d27c79c8377df1880447375deffa3bb82c7bd3.

Previously we switched the SSI scriprt to dual-fifo mode to reduce playback
underrun issue, which is only included by SDMA firmware version 2. However,
there are quite a lot people still using version 1 or default firmware in
the ROM code of SoC while these two kinds of firmwares do not support the
dual-fifo script and the audio function on their platform would be broken.

Thus this patch provisionally reverts the dual-fifo script to the original
single fifo script to meet all kinds of users' requirements, including the
version 1/2 or inner ROM firmware.

Reported-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
---
 arch/arm/boot/dts/imx51.dtsi   |  4 ++--
 arch/arm/boot/dts/imx53.dtsi   |  4 ++--
 arch/arm/boot/dts/imx6qdl.dtsi | 12 ++++++------
 arch/arm/boot/dts/imx6sl.dtsi  | 12 ++++++------
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/arm/boot/dts/imx51.dtsi b/arch/arm/boot/dts/imx51.dtsi
index 5be2837..4bcdd3a 100644
--- a/arch/arm/boot/dts/imx51.dtsi
+++ b/arch/arm/boot/dts/imx51.dtsi
@@ -159,8 +159,8 @@
 					reg = <0x70014000 0x4000>;
 					interrupts = <30>;
 					clocks = <&clks 49>;
-					dmas = <&sdma 24 22 0>,
-					       <&sdma 25 22 0>;
+					dmas = <&sdma 24 1 0>,
+					       <&sdma 25 1 0>;
 					dma-names = "rx", "tx";
 					fsl,fifo-depth = <15>;
 					fsl,ssi-dma-events = <25 24 23 22>; /* TX0 RX0 TX1 RX1 */
diff --git a/arch/arm/boot/dts/imx53.dtsi b/arch/arm/boot/dts/imx53.dtsi
index 7208fde..4307e80 100644
--- a/arch/arm/boot/dts/imx53.dtsi
+++ b/arch/arm/boot/dts/imx53.dtsi
@@ -153,8 +153,8 @@
 					reg = <0x50014000 0x4000>;
 					interrupts = <30>;
 					clocks = <&clks 49>;
-					dmas = <&sdma 24 22 0>,
-					       <&sdma 25 22 0>;
+					dmas = <&sdma 24 1 0>,
+					       <&sdma 25 1 0>;
 					dma-names = "rx", "tx";
 					fsl,fifo-depth = <15>;
 					fsl,ssi-dma-events = <25 24 23 22>; /* TX0 RX0 TX1 RX1 */
diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index e9534f2..fb28b2e 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -236,8 +236,8 @@
 					reg = <0x02028000 0x4000>;
 					interrupts = <0 46 0x04>;
 					clocks = <&clks 178>;
-					dmas = <&sdma 37 22 0>,
-					       <&sdma 38 22 0>;
+					dmas = <&sdma 37 1 0>,
+					       <&sdma 38 1 0>;
 					dma-names = "rx", "tx";
 					fsl,fifo-depth = <15>;
 					fsl,ssi-dma-events = <38 37>;
@@ -249,8 +249,8 @@
 					reg = <0x0202c000 0x4000>;
 					interrupts = <0 47 0x04>;
 					clocks = <&clks 179>;
-					dmas = <&sdma 41 22 0>,
-					       <&sdma 42 22 0>;
+					dmas = <&sdma 41 1 0>,
+					       <&sdma 42 1 0>;
 					dma-names = "rx", "tx";
 					fsl,fifo-depth = <15>;
 					fsl,ssi-dma-events = <42 41>;
@@ -262,8 +262,8 @@
 					reg = <0x02030000 0x4000>;
 					interrupts = <0 48 0x04>;
 					clocks = <&clks 180>;
-					dmas = <&sdma 45 22 0>,
-					       <&sdma 46 22 0>;
+					dmas = <&sdma 45 1 0>,
+					       <&sdma 46 1 0>;
 					dma-names = "rx", "tx";
 					fsl,fifo-depth = <15>;
 					fsl,ssi-dma-events = <46 45>;
diff --git a/arch/arm/boot/dts/imx6sl.dtsi b/arch/arm/boot/dts/imx6sl.dtsi
index 7b57fec..28558f1 100644
--- a/arch/arm/boot/dts/imx6sl.dtsi
+++ b/arch/arm/boot/dts/imx6sl.dtsi
@@ -199,8 +199,8 @@
 					reg = <0x02028000 0x4000>;
 					interrupts = <0 46 0x04>;
 					clocks = <&clks IMX6SL_CLK_SSI1>;
-					dmas = <&sdma 37 22 0>,
-					       <&sdma 38 22 0>;
+					dmas = <&sdma 37 1 0>,
+					       <&sdma 38 1 0>;
 					dma-names = "rx", "tx";
 					fsl,fifo-depth = <15>;
 					status = "disabled";
@@ -211,8 +211,8 @@
 					reg = <0x0202c000 0x4000>;
 					interrupts = <0 47 0x04>;
 					clocks = <&clks IMX6SL_CLK_SSI2>;
-					dmas = <&sdma 41 22 0>,
-					       <&sdma 42 22 0>;
+					dmas = <&sdma 41 1 0>,
+					       <&sdma 42 1 0>;
 					dma-names = "rx", "tx";
 					fsl,fifo-depth = <15>;
 					status = "disabled";
@@ -223,8 +223,8 @@
 					reg = <0x02030000 0x4000>;
 					interrupts = <0 48 0x04>;
 					clocks = <&clks IMX6SL_CLK_SSI3>;
-					dmas = <&sdma 45 22 0>,
-					       <&sdma 46 22 0>;
+					dmas = <&sdma 45 1 0>,
+					       <&sdma 46 1 0>;
 					dma-names = "rx", "tx";
 					fsl,fifo-depth = <15>;
 					status = "disabled";
-- 
1.8.4


