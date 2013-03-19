Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab3CSKgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 06:36:47 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:42786 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab3CSKfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 06:35:44 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: kevin@allwinnertech.com, sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-serial@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] ARM: sunxi: dt: Move uart0 to sun4i-a10.dtsi
Date: Tue, 19 Mar 2013 11:35:13 +0100
Message-Id: <1363689316-7847-5-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363689316-7847-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1363689316-7847-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The UART0 is only available on the Allwinner A10 SoCs, and not on the
A13, so move the uart0 node to sun4i-a10.dtsi.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Acked-by: Emilio López <emilio@elopez.com.ar>
Tested-by: Emilio López <emilio@elopez.com.ar>
---
 arch/arm/boot/dts/sun4i-a10.dtsi |   10 ++++++++++
 arch/arm/boot/dts/sunxi.dtsi     |   10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
index 03d2b53..b605672 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -47,5 +47,15 @@
 				allwinner,pull = <0>;
 			};
 		};
+
+		uart0: serial@01c28000 {
+			compatible = "snps,dw-apb-uart";
+			reg = <0x01c28000 0x400>;
+			interrupts = <1>;
+			reg-shift = <2>;
+			reg-io-width = <4>;
+			clocks = <&osc>;
+			status = "disabled";
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/sunxi.dtsi b/arch/arm/boot/dts/sunxi.dtsi
index 1e0f4b5..cf53c43 100644
--- a/arch/arm/boot/dts/sunxi.dtsi
+++ b/arch/arm/boot/dts/sunxi.dtsi
@@ -59,16 +59,6 @@
 			#interrupt-cells = <1>;
 		};
 
-		uart0: serial@01c28000 {
-			compatible = "snps,dw-apb-uart";
-			reg = <0x01c28000 0x400>;
-			interrupts = <1>;
-			reg-shift = <2>;
-			reg-io-width = <4>;
-			clocks = <&osc>;
-			status = "disabled";
-		};
-
 		uart1: serial@01c28400 {
 			compatible = "snps,dw-apb-uart";
 			reg = <0x01c28400 0x400>;
-- 
1.7.10.4

