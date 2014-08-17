Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243AbaHQDy3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 23:54:29 -0400
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:58641 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaHQDy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 23:54:28 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH 03/12] ARM: dts: sun8i: Add pinmux set for uart0
Date: Sun, 17 Aug 2014 11:52:09 +0800
Message-Id: <1408247538-16950-4-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408247538-16950-1-git-send-email-wens@csie.org>
References: <1408247538-16950-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uart0 on sun8i is only muxed with mmc0, which makes it a poor choice
for the console. However, some tablets only have pads for uart0
available on the circuit board.

Here we add the uart0 pinmux set for people who need it.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun8i-a23.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/sun8i-a23.dtsi b/arch/arm/boot/dts/sun8i-a23.dtsi
index a40e632..0d6bb6d 100644
--- a/arch/arm/boot/dts/sun8i-a23.dtsi
+++ b/arch/arm/boot/dts/sun8i-a23.dtsi
@@ -199,6 +199,13 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 			#gpio-cells = <3>;
+
+			uart0_pins_a: uart0@0 {
+				allwinner,pins = "PF2", "PF4";
+				allwinner,function = "uart0";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
 		};
 
 		ahb1_rst: reset@01c202c0 {
-- 
2.1.0

