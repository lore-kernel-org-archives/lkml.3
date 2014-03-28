Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbaC1R7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:59:52 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:45337 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbaC1R7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:59:46 -0400
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
To: Rob Landley <rob@landley.net>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: [RFC PATCH v2 10/10] ARM: at91/dt: add new AIC irq mux definitions for sama5 SoCs
Date: Fri, 28 Mar 2014 18:59:08 +0100
Message-Id: <1396029548-10928-11-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396029548-10928-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1396029548-10928-1-git-send-email-b.brezillon.dev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add irq line muxing definition for sama5 SoCs.

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
---
 arch/arm/boot/dts/sama5d3.dtsi      |   37 +++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/sama5d3_tcb1.dtsi |   20 +++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index 3d5faf8..ece1f7b 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -416,6 +416,43 @@
 				interrupt-controller;
 				reg = <0xfffff000 0x200>;
 				atmel,external-irqs = <47>;
+				#address-cells = <2>;
+				#size-cells = <1>;
+				ranges = <1 0x0 0xffffc000 0x4000>,
+					 <26 0x0 0xf0010000 0x4000>,
+					 <27 0x0 0xf8014000 0x4000>;
+
+				atmel,aic-irq-mapping = <0xffffffff 0x7ffff>;
+
+				pmc_irq: irq-mux@1,3c64 {
+					compatible = "atmel,aic-mux-3reg-irq";
+					reg = <1 0x3c64 0x4>;
+					atmel,aic-mux-reg-mask = <0x5074b>;
+				};
+
+				rtc_irq: irq-mux@1,3ed4 {
+					compatible = "atmel,aic-mux-3reg-irq";
+					reg = <1 0x3ed4 0x4>;
+					atmel,aic-mux-reg-mask = <0x1f>;
+				};
+
+				tc0_irq: irq-mux@26,28 {
+					compatible = "atmel,aic-mux-3reg-irq";
+					reg = <26 0x28 0x4>;
+					atmel,aic-mux-reg-mask = <0xff>;
+				};
+
+				tc1_irq: irq-mux@26,68 {
+					compatible = "atmel,aic-mux-3reg-irq";
+					reg = <26 0x68 0x4>;
+					atmel,aic-mux-reg-mask = <0xff>;
+				};
+
+				tc2_irq: irq-mux@26,a8 {
+					compatible = "atmel,aic-mux-3reg-irq";
+					reg = <26 0xa8 0x4>;
+					atmel,aic-mux-reg-mask = <0xff>;
+				};
 			};
 
 			pinctrl@fffff200 {
diff --git a/arch/arm/boot/dts/sama5d3_tcb1.dtsi b/arch/arm/boot/dts/sama5d3_tcb1.dtsi
index 382b044..6060bfd 100644
--- a/arch/arm/boot/dts/sama5d3_tcb1.dtsi
+++ b/arch/arm/boot/dts/sama5d3_tcb1.dtsi
@@ -18,6 +18,26 @@
 
 	ahb {
 		apb {
+			aic: interrupt-controller@fffff000 {
+				tc3_irq: irq-mux@27,28 {
+					compatible = "atmel,aic-mux-3reg-irq";
+					reg = <27 0x28 0x4>;
+					atmel,aic-mux-reg-mask = <0xff>;
+				};
+
+				tc4_irq: irq-mux@27,68 {
+					compatible = "atmel,aic-mux-3reg-irq";
+					reg = <27 0x68 0x4>;
+					atmel,aic-mux-reg-mask = <0xff>;
+				};
+
+				tc5_irq: irq-mux@27,a8 {
+					compatible = "atmel,aic-mux-3reg-irq";
+					reg = <27 0xa8 0x4>;
+					atmel,aic-mux-reg-mask = <0xff>;
+				};
+			};
+
 			pmc: pmc@fffffc00 {
 				periphck {
 					tcb1_clk: tcb1_clk {
-- 
1.7.9.5

