Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964833Ab3HBKEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:04:24 -0400
Received: from up.free-electrons.com ([94.23.35.102]:58830 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964815Ab3HBKEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:04:22 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv2 8/9] ARM: sun7i: a20-olinuxino: Enable UARTs muxing
Date: Fri,  2 Aug 2013 12:02:52 +0200
Message-Id: <1375437773-3211-9-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1375437773-3211-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1375437773-3211-1-git-send-email-maxime.ripard@free-electrons.com>
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
index 29edf8b..96e8c56 100644
--- a/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
+++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-micro.dts
@@ -20,14 +20,20 @@
 
 	soc@01c20000 {
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

