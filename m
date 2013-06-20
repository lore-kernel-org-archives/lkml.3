Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965494Ab3FTMEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:04:48 -0400
Received: from multi.imgtec.com ([194.200.65.239]:27111 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965198Ab3FTMDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:03:22 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/7] metag: tz1090: select and instantiate irq-imgpdc
Date: Thu, 20 Jun 2013 13:02:34 +0100
Message-ID: <1371729758-10196-4-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371729758-10196-1-git-send-email-james.hogan@imgtec.com>
References: <1371729758-10196-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_06_20_13_03_19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Select IMGPDC_IRQ from SOC_TZ1090 to enable the PDC interrupt controller
driver once it is merged, and instantiate it from tz1090.dtsi.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/metag/Kconfig.soc          |  1 +
 arch/metag/boot/dts/tz1090.dtsi | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/arch/metag/Kconfig.soc b/arch/metag/Kconfig.soc
index 653b479..433befd 100644
--- a/arch/metag/Kconfig.soc
+++ b/arch/metag/Kconfig.soc
@@ -16,6 +16,7 @@ config META21_FPGA
 
 config SOC_TZ1090
 	bool "Toumaz Xenif TZ1090 SoC (Comet)"
+	select IMGPDC_IRQ
 	select METAG_LNKGET_AROUND_CACHE
 	select METAG_META21
 	select METAG_SMP_WRITE_REORDERING
diff --git a/arch/metag/boot/dts/tz1090.dtsi b/arch/metag/boot/dts/tz1090.dtsi
index ff7bb74..0ed8023 100644
--- a/arch/metag/boot/dts/tz1090.dtsi
+++ b/arch/metag/boot/dts/tz1090.dtsi
@@ -8,6 +8,8 @@
 
 #include "skeleton.dtsi"
 
+#include <dt-bindings/interrupt-controller/irq.h>
+
 / {
 	compatible = "toumaz,tz1090", "img,meta";
 
@@ -25,5 +27,21 @@
 		#address-cells = <1>;
 		#size-cells = <1>;
 		ranges;
+
+		pdc: pdc@0x02006000 {
+			interrupt-controller;
+			#interrupt-cells = <2>;
+
+			reg = <0x02006000 0x1000>;
+			compatible = "img,pdc-intc";
+
+			num-perips = <3>;
+			num-syswakes = <3>;
+
+			interrupts = <18 IRQ_TYPE_LEVEL_HIGH>, /* Syswakes */
+			             <30 IRQ_TYPE_LEVEL_HIGH>, /* Perip 0 (RTC) */
+			             <29 IRQ_TYPE_LEVEL_HIGH>, /* Perip 1 (IR) */
+			             <31 IRQ_TYPE_LEVEL_HIGH>; /* Perip 2 (WDT) */
+		};
 	};
 };
-- 
1.8.1.2


