Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933695AbaDIN6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 09:58:49 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60845 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932748AbaDINvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 09:51:32 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 07/15] ARM: sunxi: dt: define A31's APB0 clk gates node
Date: Wed,  9 Apr 2014 15:51:10 +0200
Message-Id: <1397051478-4113-8-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the APB0 clk gates controlled by the PRCM (Power/Reset/Clock
Management) block.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 arch/arm/boot/dts/sun6i-a31.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
index 3858424..61e8b34 100644
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -141,6 +141,16 @@
 					"ahb1_drc0", "ahb1_drc1";
 		};
 
+		apb0_gates: apb0_gates@01f01428 {
+			#clock-cells = <1>;
+			compatible = "allwinner,sun6i-a31-apb0-gates-clk";
+			reg = <0x01f01428 0x4>;
+			clock-output-names = "apb0_pio", "apb0_ir",
+					"apb0_timer01", "apb0_p2wi",
+					"apb0_uart", "apb0_1wire",
+					"apb0_i2c";
+		};
+
 		apb1: apb1@01c20054 {
 			#clock-cells = <0>;
 			compatible = "allwinner,sun4i-apb0-clk";
-- 
1.8.3.2

