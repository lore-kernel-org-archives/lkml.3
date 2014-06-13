Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaFMNnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:43:52 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45958 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751244AbaFMNng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:43:36 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 3/3] ARM: at91/dt: sam9261: correctly define mainck
Date: Fri, 13 Jun 2014 15:43:21 +0200
Message-Id: <1402667001-11207-4-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402667001-11207-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1402667001-11207-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mainck (CKGR_MCFR register) is actually using main_osc (CKGR_MOR register).

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/at91sam9261.dtsi | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9261.dtsi b/arch/arm/boot/dts/at91sam9261.dtsi
index b309c1c6e848..9de312e9bb3e 100644
--- a/arch/arm/boot/dts/at91sam9261.dtsi
+++ b/arch/arm/boot/dts/at91sam9261.dtsi
@@ -581,13 +581,19 @@
 					clocks = <&slow_rc_osc &slow_xtal>;
 				};
 
-				main: mainck {
-					compatible = "atmel,at91rm9200-clk-main";
+				main_osc: main_osc {
+					compatible = "atmel,at91rm9200-clk-main-osc";
 					#clock-cells = <0>;
 					interrupts-extended = <&pmc AT91_PMC_MOSCS>;
 					clocks = <&main_xtal>;
 				};
 
+				main: mainck {
+					compatible = "atmel,at91rm9200-clk-main";
+					#clock-cells = <0>;
+					clocks = <&main_osc>;
+				};
+
 				plla: pllack {
 					compatible = "atmel,at91rm9200-clk-pll";
 					#clock-cells = <0>;
-- 
1.9.1

