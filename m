Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab3LETax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 14:30:53 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:43285 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab3LETau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 14:30:50 -0500
X-IronPort-AV: E=Sophos;i="4.93,835,1378882800"; 
   d="scan'208";a="365452"
From: Tim Kryger <tim.kryger@linaro.org>
To: Christian Daudt <bcm@fixthebug.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Ball <cjb@laptop.org>,
        Axel Lin <axel.lin@ingics.com>
CC: Tim Kryger <tim.kryger@linaro.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linaro Patches List <patches@linaro.org>
Subject: [PATCH v4 2/8] ARM: dts: Specify clocks for UARTs on bcm11351
Date: Thu, 5 Dec 2013 11:20:38 -0800
Message-ID: <1386271244-3927-3-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1386271244-3927-1-git-send-email-tim.kryger@linaro.org>
References: <1386271244-3927-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The frequency property in "snps,dw-apb-uart" entries are no longer
required if the rate of the external clock can be determined using the
clk api (see e302cd9 serial: 8250_dw: add support for clk api).

This patch replaces the frequency property in the UART nodes of
bcm11351.dtsi with references to the relevant clocks following the
common clock binding.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
---
 arch/arm/boot/dts/bcm11351.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
index eca6fbc..9b99c52 100644
--- a/arch/arm/boot/dts/bcm11351.dtsi
+++ b/arch/arm/boot/dts/bcm11351.dtsi
@@ -43,7 +43,7 @@
 		compatible = "brcm,bcm11351-dw-apb-uart", "snps,dw-apb-uart";
 		status = "disabled";
 		reg = <0x3e000000 0x1000>;
-		clock-frequency = <13000000>;
+		clocks = <&uartb_clk>;
 		interrupts = <GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>;
 		reg-shift = <2>;
 		reg-io-width = <4>;
@@ -53,7 +53,7 @@
 		compatible = "brcm,bcm11351-dw-apb-uart", "snps,dw-apb-uart";
 		status = "disabled";
 		reg = <0x3e001000 0x1000>;
-		clock-frequency = <13000000>;
+		clocks = <&uartb2_clk>;
 		interrupts = <GIC_SPI 66 IRQ_TYPE_LEVEL_HIGH>;
 		reg-shift = <2>;
 		reg-io-width = <4>;
@@ -63,7 +63,7 @@
 		compatible = "brcm,bcm11351-dw-apb-uart", "snps,dw-apb-uart";
 		status = "disabled";
 		reg = <0x3e002000 0x1000>;
-		clock-frequency = <13000000>;
+		clocks = <&uartb3_clk>;
 		interrupts = <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH>;
 		reg-shift = <2>;
 		reg-io-width = <4>;
@@ -73,7 +73,7 @@
 		compatible = "brcm,bcm11351-dw-apb-uart", "snps,dw-apb-uart";
 		status = "disabled";
 		reg = <0x3e003000 0x1000>;
-		clock-frequency = <13000000>;
+		clocks = <&uartb4_clk>;
 		interrupts = <GIC_SPI 64 IRQ_TYPE_LEVEL_HIGH>;
 		reg-shift = <2>;
 		reg-io-width = <4>;
-- 
1.8.0.1

