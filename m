Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933407Ab3GQQrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:47:15 -0400
Received: from 2.mo1.mail-out.ovh.net ([178.32.119.250]:43744 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933167Ab3GQQrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:47:12 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH v2 34/42] ARM: at91/dt: move at91sam9g20 SoC to new at91 clk implem
Date: Wed, 17 Jul 2013 18:45:53 +0200
Message-Id: <1374079553-20942-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
References: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 14587440669506762860
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define at91sam9g20 clocks in at91sam9g20 device tree.
Add references to the appropriate clocks in each peripheral.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/at91sam9g20.dtsi |   37 ++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9g20.dtsi b/arch/arm/boot/dts/at91sam9g20.dtsi
index b8e7946..60a20ec 100644
--- a/arch/arm/boot/dts/at91sam9g20.dtsi
+++ b/arch/arm/boot/dts/at91sam9g20.dtsi
@@ -25,6 +25,43 @@
 			adc0: adc@fffe0000 {
 				atmel,adc-startup-time = <40>;
 			};
+
+			pmc: pmc@fffffc00 {
+				plla: pllack {
+					compatible = "atmel,at91sam9g45-clk-pll";
+					#clock-cells = <0>;
+					clocks = <&main>;
+					id = <0>;
+					input = <2000000 32000000>;
+					output = <74500000 800000000
+							  69500000 750000000
+							  64500000 700000000
+							  59500000 650000000
+							  54500000 600000000
+							  49500000 550000000
+							  44500000 500000000
+							  40000000 450000000>;
+					out = <0 1 2 3 0 1 2 3>;
+					icpll = <0 0 0 0 1 1 1 1>;
+				};
+
+				pllb: pllbck {
+					compatible = "atmel,at91sam9g20-clk-pllb";
+					#clock-cells = <0>;
+					clocks = <&main>;
+					id = <1>;
+					input = <2000000 32000000>;
+					output = <30000000 100000000>;
+					out = <0>;
+				};
+
+				mck: masterck {
+					#clock-cells = <0>;
+					clocks = <&clk32k>, <&main>, <&plla>, <&pllb>;
+					output = <0 133000000>;
+					divisors = <1 2 4 6>;
+				};
+			};
 		};
 	};
 };
-- 
1.7.9.5

