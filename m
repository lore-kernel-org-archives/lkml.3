Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351Ab3ANTJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 14:09:49 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:58466 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082Ab3ANTJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 14:09:34 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH] ARM: sunxi: Use the Synosys APB UART instead of ns8250
Date: Mon, 14 Jan 2013 20:09:27 +0100
Message-Id: <1358190567-6304-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The UART controller used in the A10/A13 is the Synopsys DesignWare 8250.
The wrong use of a regular 8250 driver may lead to a oops during kernel
boot with "irq 17: nobody cared", because the apb UART as an extra
interrupt that gets raised when writing to the LCR when busy.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sunxi.dtsi |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/sunxi.dtsi b/arch/arm/boot/dts/sunxi.dtsi
index 8bbc2bf..8b36abe 100644
--- a/arch/arm/boot/dts/sunxi.dtsi
+++ b/arch/arm/boot/dts/sunxi.dtsi
@@ -60,19 +60,21 @@
 		};
 
 		uart0: uart@01c28000 {
-			compatible = "ns8250";
+			compatible = "snps,dw-apb-uart";
 			reg = <0x01c28000 0x400>;
 			interrupts = <1>;
 			reg-shift = <2>;
+			reg-io-width = <4>;
 			clock-frequency = <24000000>;
 			status = "disabled";
 		};
 
 		uart1: uart@01c28400 {
-			compatible = "ns8250";
+			compatible = "snps,dw-apb-uart";
 			reg = <0x01c28400 0x400>;
 			interrupts = <2>;
 			reg-shift = <2>;
+			reg-io-width = <4>;
 			clock-frequency = <24000000>;
 			status = "disabled";
 		};
-- 
1.7.10.4

