Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbaDWIx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:53:57 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55327 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753112AbaDWIxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:53:49 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 3/3] ARM: at91/dt: sam9rl: Fix PLL output range and mck divisors
Date: Wed, 23 Apr 2014 10:53:40 +0200
Message-Id: <1398243220-20874-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398243220-20874-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1398243220-20874-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Argument 3 (OUT) and 4 (ICPLL) of the atmel,pll-clk-output-ranges were missing.
Also, the at91sam9rl doesn't really have a by 3 divisor.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9rl.dtsi | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9rl.dtsi b/arch/arm/boot/dts/at91sam9rl.dtsi
index a19a7c26a7fc..1109e7fbf9bd 100644
--- a/arch/arm/boot/dts/at91sam9rl.dtsi
+++ b/arch/arm/boot/dts/at91sam9rl.dtsi
@@ -574,8 +574,9 @@
 					clocks = <&main>;
 					reg = <0>;
 					atmel,clk-input-range = <1000000 32000000>;
-					#atmel,pll-clk-output-range-cells = <4>;
-					atmel,pll-clk-output-ranges = <80000000 200000000 190000000 240000000>;
+					#atmel,pll-clk-output-range-cells = <3>;
+					atmel,pll-clk-output-ranges = <80000000 200000000 0>,
+								<190000000 240000000 2>;
 				};
 
 				utmi: utmick {
@@ -592,7 +593,7 @@
 					interrupts-extended = <&pmc AT91_PMC_MCKRDY>;
 					clocks = <&clk32k>, <&main>, <&plla>, <&utmi>;
 					atmel,clk-output-range = <0 94000000>;
-					atmel,clk-divisors = <1 2 4 3>;
+					atmel,clk-divisors = <1 2 4 0>;
 				};
 
 				prog: progck {
-- 
1.9.1

