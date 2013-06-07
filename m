Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958Ab3FGSOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 14:14:06 -0400
Received: from 10.mo1.mail-out.ovh.net ([178.32.96.102]:60750 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756200Ab3FGSOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 14:14:04 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Mike Turquette <mturquette@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Boris BREZILLON <b.brezillon@overkiz.com>,
        Russell King <linux@arm.linux.org.uk>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [RFC PATCH 42/50] ARM: at91/dt: move at91sam9g20 SoC to new at91 clk implem
Date: Fri,  7 Jun 2013 20:13:59 +0200
Message-Id: <1370628840-3015-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
References: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 2557481640293595164
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrgeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrgeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
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

