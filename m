Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbaGAOOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:14:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35593 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758033AbaGAON6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:13:58 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 10/33] ARM: at91/dt: sam9g20: define clocks
Date: Tue,  1 Jul 2014 16:12:19 +0200
Message-Id: <1404223962-30471-11-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the at91sam9g20 clocks that differ from at91sam9260 in the SoC dtsi file.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9g20.dtsi | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9g20.dtsi b/arch/arm/boot/dts/at91sam9g20.dtsi
index b8e79466014f..31f7652612fc 100644
--- a/arch/arm/boot/dts/at91sam9g20.dtsi
+++ b/arch/arm/boot/dts/at91sam9g20.dtsi
@@ -25,6 +25,30 @@
 			adc0: adc@fffe0000 {
 				atmel,adc-startup-time = <40>;
 			};
+
+			pmc: pmc@fffffc00 {
+				plla: pllack {
+					atmel,clk-input-range = <2000000 32000000>;
+					atmel,pll-clk-output-ranges = <745000000 800000000 0 0>,
+								<695000000 750000000 1 0>,
+								<645000000 700000000 2 0>,
+								<595000000 650000000 3 0>,
+								<545000000 600000000 0 1>,
+								<495000000 550000000 1 1>,
+								<445000000 500000000 2 1>,
+								<400000000 450000000 3 1>;
+				};
+
+				pllb: pllbck {
+					atmel,clk-input-range = <2000000 32000000>;
+					atmel,pll-clk-output-ranges = <30000000 100000000 0 0>;
+				};
+
+				mck: masterck {
+					atmel,clk-output-range = <0 133000000>;
+					atmel,clk-divisors = <1 2 4 6>;
+				};
+			};
 		};
 	};
 };
-- 
1.9.1

