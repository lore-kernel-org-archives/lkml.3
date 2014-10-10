Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbaJJNud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 09:50:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39505 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751722AbaJJNua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 09:50:30 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: at91/dt: sam9263: fix PLLB frequencies
Date: Fri, 10 Oct 2014 15:50:21 +0200
Message-Id: <1412949021-15150-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris Brezillon <boris.brezillon@free-electrons.com>

PLLB input and output ranges were wrongly copied from at91sam9261 as the
datasheet didn't mention explicitly PLLB. Correct their values.

This fixes USB.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9263.dtsi | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9263.dtsi b/arch/arm/boot/dts/at91sam9263.dtsi
index d68b3c4862bc..51416c7d0625 100644
--- a/arch/arm/boot/dts/at91sam9263.dtsi
+++ b/arch/arm/boot/dts/at91sam9263.dtsi
@@ -122,9 +122,10 @@
 					interrupts-extended = <&pmc AT91_PMC_LOCKB>;
 					clocks = <&main>;
 					reg = <1>;
-					atmel,clk-input-range = <1000000 5000000>;
+					atmel,clk-input-range = <1000000 32000000>;
 					#atmel,pll-clk-output-range-cells = <4>;
-					atmel,pll-clk-output-ranges = <70000000 130000000 1 1>;
+					atmel,pll-clk-output-ranges = <80000000 200000000 0 1>,
+								<190000000 240000000 2 1>;
 				};
 
 				mck: masterck {
-- 
1.9.1

