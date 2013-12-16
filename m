Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab3LPU2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 15:28:00 -0500
Received: from 18.mo1.mail-out.ovh.net ([46.105.35.72]:46711 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752334Ab3LPU16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 15:27:58 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Landley <rob@landley.net>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 09/10] ARM: at91/dt: add new AIC irq mux definitions
Date: Mon, 16 Dec 2013 21:24:20 +0100
Message-Id: <1387225461-6201-10-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387225461-6201-1-git-send-email-b.brezillon@overkiz.com>
References: <1387225461-6201-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 7089510240338999403
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

Add irq line muxing definition for sam9x5 SoCs.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/at91sam9x5.dtsi |  111 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 109 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index 40267a1..619e24a 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -68,6 +68,113 @@
 				interrupt-controller;
 				reg = <0xfffff000 0x200>;
 				atmel,external-irqs = <31>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				sysc_irq_mux: irq-mux@1 {
+					compatible = "atmel,aic-mux";
+					reg = <1>;
+
+					dbgu_irq {
+						compatible = "atmel,aic-mux-3reg-irq";
+						atmel,aic-mux-irq-reg = <&dbgu 0 0xc 0xc00002e3>;
+					};
+
+					pmc_irq {
+						compatible = "atmel,aic-mux-3reg-irq";
+						atmel,aic-mux-irq-reg = <&pmc 0 0x64 0x7034b>;
+					};
+
+					pmecc_irq {
+						compatible = "atmel,aic-mux-3reg-irq";
+						atmel,aic-mux-irq-reg = <&nand0 1 0x20 0x1>;
+					};
+
+					pmerrloc_irq {
+						compatible = "atmel,aic-mux-3reg-irq";
+						atmel,aic-mux-irq-reg = <&nand0 2 0x18 0x1>;
+					};
+
+					pit_irq {
+						compatible = "atmel,aic-mux-1reg-irq";
+						atmel,aic-mux-irq-reg = <&pit 0 0x0 0x2000000>;
+					};
+
+					wdt_irq {
+						compatible = "atmel,aic-mux-1reg-irq";
+						atmel,aic-mux-irq-reg = <&wdt 0 0x4 0x1000>;
+					};
+
+					rtc_irq {
+						compatible = "atmel,aic-mux-3reg-irq";
+						atmel,aic-mux-irq-reg = <&rtc 0 0x24 0x1f>;
+					};
+				};
+
+				pioAB_irq_mux: irq-mux@2 {
+					compatible = "atmel,aic-mux";
+					reg = <2>;
+
+					pioA_irq {
+						compatible = "atmel,aic-mux-3reg-irq";
+						atmel,aic-mux-irq-reg = <&pioA 0 0x44 0xffffffff>;
+					};
+
+					pioB_irq {
+						compatible = "atmel,aic-mux-3reg-irq";
+						atmel,aic-mux-irq-reg = <&pioB 0 0x44 0xffffffff>;
+					};
+				};
+
+				pioCD_irq_mux: irq-mux@3 {
+					compatible = "atmel,aic-mux";
+					reg = <3>;
+
+					pioC_irq {
+						compatible = "atmel,aic-mux-3reg-irq";
+						atmel,aic-mux-irq-reg = <&pioC 0 0x44 0xffffffff>;
+					};
+
+					pioD_irq {
+						compatible = "atmel,aic-mux-3reg-irq";
+						atmel,aic-mux-irq-reg = <&pioD 0 0x44 0xffffffff>;
+					};
+				};
+
+				tcb_irq_mux: irq-mux@17 {
+					compatible = "atmel,aic-mux";
+					reg = <17>;
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
 			};
 
 			ramc0: ramc@ffffe800 {
@@ -750,13 +857,13 @@
 				};
 			};
 
-			watchdog@fffffe40 {
+			wdt: watchdog@fffffe40 {
 				compatible = "atmel,at91sam9260-wdt";
 				reg = <0xfffffe40 0x10>;
 				status = "disabled";
 			};
 
-			rtc@fffffeb0 {
+			rtc: rtc@fffffeb0 {
 				compatible = "atmel,at91sam9x5-rtc";
 				reg = <0xfffffeb0 0x40>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
-- 
1.7.9.5

