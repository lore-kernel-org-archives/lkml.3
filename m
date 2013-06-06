Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab3FFNxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 09:53:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:40947 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab3FFNxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:53:03 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Paul Walmsley <paul@pwsan.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Philip Avinash <avinashphilip@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 2/4] ARM: dts: AM33XX: Add PWMSS device tree nodes
Date: Thu,  6 Jun 2013 15:52:37 +0200
Message-Id: <1370526759-31163-3-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370526759-31163-1-git-send-email-bigeasy@linutronix.de>
References: <1370526759-31163-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip Avinash <avinashphilip@ti.com>

Add PWMSS device tree nodes in relation with ECAP & EHRPWM DT nodes to
AM33XX SoC family. Also populates device tree nodes for ECAP & EHRPWM by
adding necessary properties like pwm-cells, base reg & set disabled as
status.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/arm/boot/dts/am33xx.dtsi |   84 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 1460d9b..7fa9c5f 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -343,6 +343,90 @@
 			ti,hwmods = "usb_otg_hs";
 		};
 
+		epwmss0: epwmss@48300000 {
+			compatible = "ti,am33xx-pwmss";
+			reg = <0x48300000 0x10>;
+			ti,hwmods = "epwmss0";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			status = "disabled";
+			ranges = <0x48300100 0x48300100 0x80   /* ECAP */
+				  0x48300180 0x48300180 0x80   /* EQEP */
+				  0x48300200 0x48300200 0x80>; /* EHRPWM */
+
+			ecap0: ecap@48300100 {
+				compatible = "ti,am33xx-ecap";
+				#pwm-cells = <3>;
+				reg = <0x48300100 0x80>;
+				ti,hwmods = "ecap0";
+				status = "disabled";
+			};
+
+			ehrpwm0: ehrpwm@48300200 {
+				compatible = "ti,am33xx-ehrpwm";
+				#pwm-cells = <3>;
+				reg = <0x48300200 0x80>;
+				ti,hwmods = "ehrpwm0";
+				status = "disabled";
+			};
+		};
+
+		epwmss1: epwmss@48302000 {
+			compatible = "ti,am33xx-pwmss";
+			reg = <0x48302000 0x10>;
+			ti,hwmods = "epwmss1";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			status = "disabled";
+			ranges = <0x48302100 0x48302100 0x80   /* ECAP */
+				  0x48302180 0x48302180 0x80   /* EQEP */
+				  0x48302200 0x48302200 0x80>; /* EHRPWM */
+
+			ecap1: ecap@48302100 {
+				compatible = "ti,am33xx-ecap";
+				#pwm-cells = <3>;
+				reg = <0x48302100 0x80>;
+				ti,hwmods = "ecap1";
+				status = "disabled";
+			};
+
+			ehrpwm1: ehrpwm@48302200 {
+				compatible = "ti,am33xx-ehrpwm";
+				#pwm-cells = <3>;
+				reg = <0x48302200 0x80>;
+				ti,hwmods = "ehrpwm1";
+				status = "disabled";
+			};
+		};
+
+		epwmss2: epwmss@48304000 {
+			compatible = "ti,am33xx-pwmss";
+			reg = <0x48304000 0x10>;
+			ti,hwmods = "epwmss2";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			status = "disabled";
+			ranges = <0x48304100 0x48304100 0x80   /* ECAP */
+				  0x48304180 0x48304180 0x80   /* EQEP */
+				  0x48304200 0x48304200 0x80>; /* EHRPWM */
+
+			ecap2: ecap@48304100 {
+				compatible = "ti,am33xx-ecap";
+				#pwm-cells = <3>;
+				reg = <0x48304100 0x80>;
+				ti,hwmods = "ecap2";
+				status = "disabled";
+			};
+
+			ehrpwm2: ehrpwm@48304200 {
+				compatible = "ti,am33xx-ehrpwm";
+				#pwm-cells = <3>;
+				reg = <0x48304200 0x80>;
+				ti,hwmods = "ehrpwm2";
+				status = "disabled";
+			};
+		};
+
 		mac: ethernet@4a100000 {
 			compatible = "ti,cpsw";
 			ti,hwmods = "cpgmac0";
-- 
1.7.10.4

