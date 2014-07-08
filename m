Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbaGHQWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 12:22:32 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39705 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754067AbaGHQV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 12:21:28 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv2 4/6] ARM: at91/dt: sama5d3: define mpddr clock and ramc clocks
Date: Tue,  8 Jul 2014 18:21:14 +0200
Message-Id: <1404836476-23787-5-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404836476-23787-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1404836476-23787-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the available clock for mprddr and take both mpddr_clk and ddrck in the
ram controller driver.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/sama5d3.dtsi | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index e0b15a6e8897..04c35ce1e33e 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -402,8 +402,10 @@
 			};
 
 			ramc0: ramc@ffffea00 {
-				compatible = "atmel,at91sam9g45-ddramc";
+				compatible = "atmel,sama5d3-ddramc";
 				reg = <0xffffea00 0x200>;
+				clocks = <&ddrck>, <&mpddr_clk>;
+				clock-names = "ddrck", "mpddr";
 			};
 
 			dbgu: serial@ffffee00 {
@@ -1170,6 +1172,11 @@
 						#clock-cells = <0>;
 						reg = <48>;
 					};
+
+					mpddr_clk: mpddr_clk {
+						#clock-cells = <0>;
+						reg = <49>;
+					};
 				};
 			};
 
-- 
1.9.1

