Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab3HDJ7j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 05:59:39 -0400
Received: from up.free-electrons.com ([94.23.35.102]:37169 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752762Ab3HDJ7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 05:59:23 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv3 8/9] ARM: sun7i: a20-olinuxino: Enable UARTs muxing
Date: Sun,  4 Aug 2013 11:58:49 +0200
Message-Id: <1375610330-18185-9-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1375610330-18185-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1375610330-18185-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of relying on the bootloader to mux the UART pins properly, do
it on our own and register the rightful pins for the A20-olinuxino in
the DT using pinctrl.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts b/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
index d339584..4d988df 100644
--- a/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
+++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
@@ -20,14 +20,20 @@
 
 	soc@01c00000 {
 		uart0: serial@01c28000 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&uart0_pins_a>;
 			status = "okay";
 		};
 
 		uart6: serial@01c29800 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&uart6_pins_a>;
 			status = "okay";
 		};
 
 		uart7: serial@01c29c00 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&uart7_pins_a>;
 			status = "okay";
 		};
 	};
-- 
1.8.3.4

