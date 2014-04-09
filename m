Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964772AbaDIN5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 09:57:41 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60861 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933114AbaDINve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 09:51:34 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 09/15] clk: sunxi: add A31 APB0 reset line defintions
Date: Wed,  9 Apr 2014 15:51:12 +0200
Message-Id: <1397051478-4113-10-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add APB0 reset line support for the A31 SoC.
This reset lines are controlled by the PRCM (Power/Reset/Clock Management) block
and thus will act on a different iomem range.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 arch/arm/boot/dts/sun6i-a31.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
index 61e8b34..ed9c2c1 100644
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -237,6 +237,12 @@
 			reg = <0x01c202c0 0xc>;
 		};
 
+		apb0_rst: reset@01f014b0 {
+			#reset-cells = <1>;
+			compatible = "allwinner,sun6i-a31-clock-reset";
+			reg = <0x01f014b0 0x4>;
+		};
+
 		apb1_rst: reset@01c202d0 {
 			#reset-cells = <1>;
 			compatible = "allwinner,sun6i-a31-clock-reset";
-- 
1.8.3.2

