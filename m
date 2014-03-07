Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbaCGMRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 07:17:53 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:57339 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbaCGMRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 07:17:50 -0500
From: Sricharan R <r.sricharan@ti.com>
To: <r.sricharan@ti.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <dmaengine@vger.kernel.org>
CC: <santosh.shilimkar@ti.com>, <rnayak@ti.com>, <nsekhar@ti.com>,
        <tony@atomide.com>, <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <dan.j.williams@intel.com>, <nm@ti.com>
Subject: [RFC PATCH 7/9] arm: dts: dra: Add dma-request crossbar phandle to dma-specs
Date: Fri, 7 Mar 2014 17:46:14 +0530
Message-ID: <1394194576-23741-8-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394194576-23741-1-git-send-email-r.sricharan@ti.com>
References: <1394194576-23741-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dma-request lines from peripherals are connected to
the dma-controller through a crossbar router. Adding this
crossbar phandle to the peripheral's dma-specs. This is
used by the driver to identify the router associated with
a dma-request line and map it.

Signed-off-by: Sricharan R <r.sricharan@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index f84991b..baa781e 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -165,7 +165,7 @@
 				     <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>;
-			#dma-cells = <1>;
+			#dma-cells = <2>;
 			#dma-channels = <32>;
 			#dma-requests = <127>;
 		};
@@ -528,7 +528,7 @@
 			ti,hwmods = "mmc1";
 			ti,dual-volt;
 			ti,needs-special-reset;
-			dmas = <&sdma 61>, <&sdma 62>;
+			dmas = <&sdma 61 &dmacb>, <&sdma 62 &dmacb>;
 			dma-names = "tx", "rx";
 			status = "disabled";
 		};
@@ -539,7 +539,7 @@
 			interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "mmc2";
 			ti,needs-special-reset;
-			dmas = <&sdma 47>, <&sdma 48>;
+			dmas = <&sdma 47 &dmacb>, <&sdma 48 &dmacb>;
 			dma-names = "tx", "rx";
 			status = "disabled";
 		};
@@ -550,7 +550,7 @@
 			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "mmc3";
 			ti,needs-special-reset;
-			dmas = <&sdma 77>, <&sdma 78>;
+			dmas = <&sdma 77 &dmacb>, <&sdma 78 &dmacb>;
 			dma-names = "tx", "rx";
 			status = "disabled";
 		};
@@ -561,7 +561,7 @@
 			interrupts = <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "mmc4";
 			ti,needs-special-reset;
-			dmas = <&sdma 57>, <&sdma 58>;
+			dmas = <&sdma 57 &dmacb>, <&sdma 58 &dmacb>;
 			dma-names = "tx", "rx";
 			status = "disabled";
 		};
@@ -574,14 +574,14 @@
 			#size-cells = <0>;
 			ti,hwmods = "mcspi1";
 			ti,spi-num-cs = <4>;
-			dmas = <&sdma 35>,
-			       <&sdma 36>,
-			       <&sdma 37>,
-			       <&sdma 38>,
-			       <&sdma 39>,
-			       <&sdma 40>,
-			       <&sdma 41>,
-			       <&sdma 42>;
+			dmas = <&sdma 35 &dmacb>,
+			       <&sdma 36 &dmacb>,
+			       <&sdma 37 &dmacb>,
+			       <&sdma 38 &dmacb>,
+			       <&sdma 39 &dmacb>,
+			       <&sdma 40 &dmacb>,
+			       <&sdma 41 &dmacb>,
+			       <&sdma 42 &dmacb>;
 			dma-names = "tx0", "rx0", "tx1", "rx1",
 				    "tx2", "rx2", "tx3", "rx3";
 			status = "disabled";
@@ -595,10 +595,10 @@
 			#size-cells = <0>;
 			ti,hwmods = "mcspi2";
 			ti,spi-num-cs = <2>;
-			dmas = <&sdma 43>,
-			       <&sdma 44>,
-			       <&sdma 45>,
-			       <&sdma 46>;
+			dmas = <&sdma 43 &dmacb>,
+			       <&sdma 44 &dmacb>,
+			       <&sdma 45 &dmacb>,
+			       <&sdma 46 &dmacb>;
 			dma-names = "tx0", "rx0", "tx1", "rx1";
 			status = "disabled";
 		};
@@ -611,7 +611,7 @@
 			#size-cells = <0>;
 			ti,hwmods = "mcspi3";
 			ti,spi-num-cs = <2>;
-			dmas = <&sdma 15>, <&sdma 16>;
+			dmas = <&sdma 15 &dmacb>, <&sdma 16 &dmacb>;
 			dma-names = "tx0", "rx0";
 			status = "disabled";
 		};
@@ -624,7 +624,7 @@
 			#size-cells = <0>;
 			ti,hwmods = "mcspi4";
 			ti,spi-num-cs = <1>;
-			dmas = <&sdma 70>, <&sdma 71>;
+			dmas = <&sdma 70 &dmacb>, <&sdma 71 &dmacb>;
 			dma-names = "tx0", "rx0";
 			status = "disabled";
 		};
-- 
1.7.9.5

