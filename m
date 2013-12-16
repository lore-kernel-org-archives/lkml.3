Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab3LPV0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 16:26:08 -0500
Received: from 13.mo1.mail-out.ovh.net ([178.33.253.128]:50414 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752276Ab3LPV0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 16:26:06 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Landley <rob@landley.net>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 10/10] ARM: at91/dt: add new AIC irq mux definitions for sama5 SoCs
Date: Mon, 16 Dec 2013 22:25:40 +0100
Message-Id: <1387229140-7642-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387225461-6201-1-git-send-email-b.brezillon@overkiz.com>
References: <1387225461-6201-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 8071013482370791522
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrleeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrleeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add irq line muxing definition for sama5 SoCs.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/sama5d3.dtsi      |   40 ++++++++++++++++++++++++++++++++++-
 arch/arm/boot/dts/sama5d3_tcb1.dtsi |   22 +++++++++++++++++++
 2 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index de9fece..1e8f4b5 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -390,6 +390,44 @@
 				interrupt-controller;
 				reg = <0xfffff000 0x200>;
 				atmel,external-irqs = <47>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				atmel,aic-irq-mapping = <0xffffffff 0x7ffff>;
+
+				sysc_irq_mux: irq-mux@1 {
+					compatible = "atmel,aic-mux";
+					reg = <1>;
+
+					pmc_irq {
+						compatible = "atmel,aic-mux-3reg-irq";
+						atmel,aic-mux-irq-reg = <&pmc 0 0x64 0x5074b>;
+					};
+
+					rtc_irq {
+						compatible = "atmel,aic-mux-3reg-irq";
+						atmel,aic-mux-irq-reg = <&rtc 0 0x24 0x1f>;
+					};
+				};
+
+				tcb0_irq_mux: irq-mux@26 {
+					compatible = "atmel,aic-mux";
+					reg = <26>;
+
+					tc0_irq {
+						compatible = "atmel,aic-mux-3reg-irq";
+						atmel,aic-mux-irq-reg = <&tcb0 0 0x28 0xff>;
+					};
+
+					tc1_irq {
+						compatible = "atmel,aic-mux-3reg-irq";
+						atmel,aic-mux-irq-reg = <&tcb0 0 0x68 0xff>;
+					};
+
+					tc2_irq {
+						compatible = "atmel,aic-mux-3reg-irq";
+						atmel,aic-mux-irq-reg = <&tcb0 0 0xa8 0xff>;
+					};
+				};
 			};
 
 			pinctrl@fffff200 {
@@ -1061,7 +1099,7 @@
 				status = "disabled";
 			};
 
-			rtc@fffffeb0 {
+			rtc: rtc@fffffeb0 {
 				compatible = "atmel,at91rm9200-rtc";
 				reg = <0xfffffeb0 0x30>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
diff --git a/arch/arm/boot/dts/sama5d3_tcb1.dtsi b/arch/arm/boot/dts/sama5d3_tcb1.dtsi
index 382b044..123b153 100644
--- a/arch/arm/boot/dts/sama5d3_tcb1.dtsi
+++ b/arch/arm/boot/dts/sama5d3_tcb1.dtsi
@@ -18,6 +18,28 @@
 
 	ahb {
 		apb {
+			aic: interrupt-controller@fffff000 {
+				tcb1_irq_mux: irq-mux@27 {
+					compatible = "atmel,aic-mux";
+					reg = <27>;
+
+					tc3_irq {
+						compatible = "atmel,aic-mux-3reg-irq";
+						atmel,aic-mux-irq-reg = <&tcb1 0 0x28 0xff>;
+					};
+
+					tc4_irq {
+						compatible = "atmel,aic-mux-3reg-irq";
+						atmel,aic-mux-irq-reg = <&tcb1 0 0x68 0xff>;
+					};
+
+					tc5_irq {
+						compatible = "atmel,aic-mux-3reg-irq";
+						atmel,aic-mux-irq-reg = <&tcb1 0 0xa8 0xff>;
+					};
+				};
+			};
+
 			pmc: pmc@fffffc00 {
 				periphck {
 					tcb1_clk: tcb1_clk {
-- 
1.7.9.5

