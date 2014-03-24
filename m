Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaCXIfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 04:35:34 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:41075 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbaCXIbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 04:31:53 -0400
From: Boris BREZILLON <brezillonboris@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mike Turquette <mturquette@linaro.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: [PATCH v2 02/11] clk: at91: update main clk documentation
Date: Mon, 24 Mar 2014 09:27:14 +0100
Message-Id: <1395649643-9146-3-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395649643-9146-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1395649643-9146-1-git-send-email-b.brezillon.dev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update main clk documentation to match main clk implementation rework.

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
---
 .../devicetree/bindings/clock/at91-clock.txt       |   56 ++++++++++++++++----
 1 file changed, 47 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/at91-clock.txt b/Documentation/devicetree/bindings/clock/at91-clock.txt
index cd5e239..9a7025b 100644
--- a/Documentation/devicetree/bindings/clock/at91-clock.txt
+++ b/Documentation/devicetree/bindings/clock/at91-clock.txt
@@ -15,8 +15,13 @@ Required properties:
 		All at91 specific clocks (clocks defined below) must be child
 		node of the PMC node.
 
+	"atmel,at91rm9200-clk-main-osc"
+	"atmel,at91sam9x5-clk-main-rc-osc"
+		at91 main clk sources
+
+	"atmel,at91sam9x5-clk-main"
 	"atmel,at91rm9200-clk-main":
-		at91 main oscillator
+		at91 main clock
 
 	"atmel,at91rm9200-clk-master" or
 	"atmel,at91sam9x5-clk-master":
@@ -85,24 +90,57 @@ For example:
 		/* put at91 clocks here */
 	};
 
+Required properties for main clock oscillator:
+- interrupt-parent : must reference the PMC node.
+- interrupts : shall be set to "<0>".
+- clock-frequency : define the internal RC oscillator frequency.
+
+Optional properties:
+- clock-accuracy : define the internal RC oscillator accuracy.
+
+For example:
+	main_rc_osc: main_rc_osc {
+		compatible = "atmel,at91sam9x5-clk-main-rc-osc";
+		interrupt-parent = <&pmc>;
+		interrupts = <0>;
+		clock-frequency = <12000000>;
+		clock-accuracy = <50000000>;
+	};
+
+Required properties for main clock internal RC oscillator:
+- interrupt-parent : must reference the PMC node.
+- interrupts : shall be set to "<0>".
+- #clock-cells : from common clock binding; shall be set to 0.
+- clocks : shall encode the main osc source clk sources (see atmel datasheet).
+
+Optional properties:
+- atmel,osc-bypass : boolean property. Specified if a clock signal is provided
+  on XIN.
+
+  clock signal is directly provided on XIN pin.
+
+For example:
+	main_osc: main_osc {
+		compatible = "atmel,at91rm9200-clk-main-osc";
+		interrupt-parent = <&pmc>;
+		interrupts = <0>;
+		#clock-cells = <0>;
+		clocks = <&main_xtal>;
+	};
+
 Required properties for main clock:
 - interrupt-parent : must reference the PMC node.
 - interrupts : shall be set to "<0>".
 - #clock-cells : from common clock binding; shall be set to 0.
-- clocks (optional if clock-frequency is provided) : shall be the slow clock
-	phandle. This clock is used to calculate the main clock rate if
-	"clock-frequency" is not provided.
-- clock-frequency : the main oscillator frequency.Prefer the use of
-	"clock-frequency" over automatic clock rate calculation.
+- clocks : shall encode the main clk sources (see atmel datasheet).
 
 For example:
 	main: mainck {
-		compatible = "atmel,at91rm9200-clk-main";
+		compatible = "atmel,at91sam9x5-clk-main";
 		interrupt-parent = <&pmc>;
 		interrupts = <0>;
 		#clock-cells = <0>;
-		clocks = <&ck32k>;
-		clock-frequency = <18432000>;
+		clocks = <&main_rc_osc &main_osc>;
 	};
 
 Required properties for master clock:
-- 
1.7.9.5

