Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaHSNy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 09:54:28 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51043 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbaHSNy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 09:54:27 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony <tony@atomide.com>
CC: <nm@ti.com>, <balbi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: dts: DRA7: Add PMU nodes
Date: Tue, 19 Aug 2014 08:54:00 -0500
Message-ID: <1408456440-30171-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lucas Weaver <l-weaver@ti.com>

DRA74x and DRA72x family of processors vary slightly in the number
of CPUs. So, add different instances of PMU for each of these processor
groups. Further, since the interrupts bypass crossbar and are directly
connected to GIC, mark the dts nodes with relevant information.

Tested with perf utility.

Reviewed-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Lucas Weaver <l-weaver@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/boot/dts/dra72x.dtsi |    5 +++++
 arch/arm/boot/dts/dra74x.dtsi |    6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/dra72x.dtsi b/arch/arm/boot/dts/dra72x.dtsi
index f1ec22f..e5a3d23 100644
--- a/arch/arm/boot/dts/dra72x.dtsi
+++ b/arch/arm/boot/dts/dra72x.dtsi
@@ -22,4 +22,9 @@
 			reg = <0>;
 		};
 	};
+
+	pmu {
+		compatible = "arm,cortex-a15-pmu";
+		interrupts = <GIC_SPI DIRECT_IRQ(131) IRQ_TYPE_LEVEL_HIGH>;
+	};
 };
diff --git a/arch/arm/boot/dts/dra74x.dtsi b/arch/arm/boot/dts/dra74x.dtsi
index a4e8bb9..3be544c 100644
--- a/arch/arm/boot/dts/dra74x.dtsi
+++ b/arch/arm/boot/dts/dra74x.dtsi
@@ -38,4 +38,10 @@
 			reg = <1>;
 		};
 	};
+
+	pmu {
+		compatible = "arm,cortex-a15-pmu";
+		interrupts = <GIC_SPI DIRECT_IRQ(131) IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI DIRECT_IRQ(132) IRQ_TYPE_LEVEL_HIGH>;
+	};
 };
-- 
1.7.9.5

