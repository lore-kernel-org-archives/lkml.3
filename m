Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759229Ab3GRQog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 12:44:36 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57012 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759213Ab3GRQoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 12:44:34 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <nm@ti.com>, <rnayak@ti.com>,
        <balbi@ti.com>, <r.sricharan@ti.com>
Subject: [PATCH 2/3] ARM: dts: DRA: Add crossbar device binding
Date: Thu, 18 Jul 2013 22:13:49 +0530
Message-ID: <1374165830-6367-3-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374165830-6367-1-git-send-email-r.sricharan@ti.com>
References: <1374165830-6367-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the irq/dma crossbar device nodes.

There is a IRQ and DMA crossbar device in the soc, which
maps the irq/dma requests from the peripherals to the
mpu/dsp/ipu/eve interrupt and sdma/edma controller's inputs.
The Peripheral irq/dma requests are connected to only one crossbar
input and the output of the crossbar is connected to only one
controller's input line. On POR, there are some mappings which
are done by default. Those peripherals which do not have a
mapping on POR, should be configured to route its requests
using the crossbar control registers.

The irq/dma mapping for some peripherals are
added with the crossbar nodes here.

Signed-off-by: Sricharan R <r.sricharan@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index a5d9350..e6208b4 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -85,6 +85,25 @@
 		ranges;
 		ti,hwmods = "l3_main_1", "l3_main_2";
 
+		crossbar_mpu: mpuirq@4a002a48 {
+			compatible = "crossbar";
+			crossbar-name = "mpu-irq";
+			reg = <0x4a002a48 0x0130>;
+			reg-width = <16>;
+			crossbar-lines = "mpu-irq", "rtc-ss-alarm", <0x9f 0xd9 0x12c>,
+					 "mpu-irq", "mcasp3-arevt", <0x9e 0x96 0x12a>,
+					 "mpu-irq", "mcasp3-axevt", <0x9d 0x97 0x128>;
+		};
+
+		crossbar_dma: dmareq@4a002b78 {
+			compatible = "crossbar";
+			crossbar-name = "dma-req";
+			reg = <0x4a002b78 0x0100>;
+			reg-width = <16>;
+			crossbar-lines = "dma-req", "mcasp3-rx", <0x7e 0x84 0xfc>,
+					 "dma-req", "mcasp3-tx", <0x7d 0x85 0xfa>;
+		};
+
 		counter32k: counter@4ae04000 {
 			compatible = "ti,omap-counter32k";
 			reg = <0x4ae04000 0x40>;
-- 
1.7.9.5

