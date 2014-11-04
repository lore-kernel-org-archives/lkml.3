Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbaKDLRC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:17:02 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:48377 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbaKDLQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:16:32 -0500
From: Vignesh R <vigneshr@ti.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Vignesh R <vigneshr@ti.com>
Subject: [PATCH v2 3/3] ARM: dts: AM43xx: add tscadc DT entries for am437x-evm and am43x-epos-evm
Date: Tue, 4 Nov 2014 16:45:28 +0530
Message-ID: <1415099728-10959-4-git-send-email-vigneshr@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415099728-10959-1-git-send-email-vigneshr@ti.com>
References: <1415099728-10959-1-git-send-email-vigneshr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds tscadc DT entries for am437x-gp-evm and am43x-epos-evm.

Signed-off-by: Vignesh R <vigneshr@ti.com>
---
 arch/arm/boot/dts/am4372.dtsi        | 20 ++++++++++++++++++++
 arch/arm/boot/dts/am437x-gp-evm.dts  |  8 ++++++++
 arch/arm/boot/dts/am43x-epos-evm.dts |  8 ++++++++
 3 files changed, 36 insertions(+)

diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
index 46660ffd2b65..cb73e5eb6971 100644
--- a/arch/arm/boot/dts/am4372.dtsi
+++ b/arch/arm/boot/dts/am4372.dtsi
@@ -667,6 +667,26 @@
 			};
 		};
 
+		tscadc: tscadc@44e0d000 {
+			compatible = "ti,am3359-tscadc";
+			reg = <0x44e0d000 0x1000>;
+			ti,hwmods = "adc_tsc";
+			interrupts = <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&adc_tsc_fck>;
+			clock-names = "fck";
+			status = "disabled";
+
+			tsc {
+				compatible = "ti,am3359-tsc";
+			};
+
+			adc {
+				#io-channel-cells = <1>;
+				compatible = "ti,am3359-adc";
+			};
+
+		};
+
 		sham: sham@53100000 {
 			compatible = "ti,omap5-sham";
 			ti,hwmods = "sham";
diff --git a/arch/arm/boot/dts/am437x-gp-evm.dts b/arch/arm/boot/dts/am437x-gp-evm.dts
index e7ac47fa6615..2ffd6d6dcc87 100644
--- a/arch/arm/boot/dts/am437x-gp-evm.dts
+++ b/arch/arm/boot/dts/am437x-gp-evm.dts
@@ -343,6 +343,14 @@
 	status = "okay";
 };
 
+&tscadc {
+	status = "okay";
+
+	adc {
+		ti,adc-channels = <0 1 2 3 4 5 6 7>;
+	};
+};
+
 &ecap0 {
 	status = "okay";
 	pinctrl-names = "default";
diff --git a/arch/arm/boot/dts/am43x-epos-evm.dts b/arch/arm/boot/dts/am43x-epos-evm.dts
index ac3e4859935f..f9bc607f3b3a 100644
--- a/arch/arm/boot/dts/am43x-epos-evm.dts
+++ b/arch/arm/boot/dts/am43x-epos-evm.dts
@@ -519,6 +519,14 @@
 	status = "okay";
 };
 
+&tscadc {
+	status = "okay";
+
+	adc {
+		ti,adc-channels = <0 1 2 3 4 5 6 7>;
+	};
+};
+
 &ecap0 {
 		status = "okay";
 		pinctrl-names = "default";
-- 
1.9.1

