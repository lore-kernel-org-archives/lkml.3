Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbaIPIoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 04:44:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44671 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752770AbaIPIoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 04:44:08 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] ARM: at91/dt: sama5d3: add the nfc clock
Date: Tue, 16 Sep 2014 10:43:57 +0200
Message-Id: <1410857037-24445-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The atmel_nand driver is now able to handle the nfc clock, add it to sama5d3.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/sama5d3.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index 7702a0d120cb..cd36c76fd4e3 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -1005,6 +1005,11 @@
 						reg = <2>;
 					};
 
+					hsmc_clk: hsmc_clk {
+						#clock-cells = <0>;
+						reg = <5>;
+					};
+
 					pioA_clk: pioA_clk {
 						#clock-cells = <0>;
 						reg = <6>;
@@ -1405,6 +1410,7 @@
 					0xffffc000 0x00000070	/* NFC HSMC regs */
 					0x00200000 0x00100000	/* NFC SRAM banks */
 					>;
+				clocks = <&hsmc_clk>;
 			};
 		};
 	};
-- 
1.9.1

