Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbaC0IMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 04:12:19 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:47329 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbaC0IMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 04:12:15 -0400
From: Boris BREZILLON <brezillonboris@gmail.com>
To: Fabio Estevam <festevam@gmail.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@linaro.org>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: [PATCH] ARM: imx6/dt: add ccm dependency upon ckil, ckih1 and osc clocks
Date: Thu, 27 Mar 2014 09:11:53 +0100
Message-Id: <1395907913-23808-1-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <5333DA13.2080505@gmail.com>
References: <5333DA13.2080505@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
---
 arch/arm/boot/dts/imx6qdl.dtsi |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index cfc85be..060e94c 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -62,16 +62,19 @@
 
 		ckil {
 			compatible = "fsl,imx-ckil", "fixed-clock";
+			#clock-cells = <0>;
 			clock-frequency = <32768>;
 		};
 
 		ckih1 {
 			compatible = "fsl,imx-ckih1", "fixed-clock";
+			#clock-cells = <0>;
 			clock-frequency = <0>;
 		};
 
 		osc {
 			compatible = "fsl,imx-osc", "fixed-clock";
+			#clock-cells = <0>;
 			clock-frequency = <24000000>;
 		};
 	};
@@ -489,6 +492,7 @@
 				interrupts = <0 87 IRQ_TYPE_LEVEL_HIGH>,
 					     <0 88 IRQ_TYPE_LEVEL_HIGH>;
 				#clock-cells = <1>;
+				clocks = <&ckil &ckih1 &osc>;
 			};
 
 			anatop: anatop@020c8000 {
-- 
1.7.9.5

