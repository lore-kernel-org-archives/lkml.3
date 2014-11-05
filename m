Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375AbaKERDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:03:36 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:54928 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbaKERA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:00:28 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        pekon@pek-sem.com, linux-mtd@lists.infradead.org
Subject: [PATCH v4 03/11] ARM: sti: Add BCH (NAND Flash) Controller support for STiH41x (Orly) SoCs
Date: Wed,  5 Nov 2014 16:59:45 +0000
Message-Id: <1415206793-25670-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415206793-25670-1-git-send-email-lee.jones@linaro.org>
References: <1415206793-25670-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide device information and flash layout for the NAND Micron
MT29F8G08ABABAWP chip found on the STM B2020 Development Board.

Reviewed-by: Pekon Gupta <pekon@pek-sem.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih41x-b2020.dtsi | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/arm/boot/dts/stih41x-b2020.dtsi b/arch/arm/boot/dts/stih41x-b2020.dtsi
index d8a8429..2ff5fe6 100644
--- a/arch/arm/boot/dts/stih41x-b2020.dtsi
+++ b/arch/arm/boot/dts/stih41x-b2020.dtsi
@@ -74,5 +74,40 @@
 
 			pinctrl-0	= <&pinctrl_rgmii1>;
 		};
+
+		nand@fe901000 {
+			compatible = "st,nand-bch";
+			reg = <0xfe901000 0x1000>, <0xfef00000 0x107c>;
+			reg-names = "emi_nand", "emiss";
+			interrupts = <0 139 0x0>;
+			interrupt-names = "nand_irq";
+			status = "disabled";
+
+			/*
+			 * Micron MT29F8G08ABABAWP:
+			 *  - Size = 8Gib(1GiB); Page = 4096+224; Block = 512KiB
+			 *  - ECC = 4-bit/540B min
+			 *  - ONFI 2.1 (timing parameters retrieved during probe)
+			 */
+			bank {
+				#address-cells		= <1>;
+				#size-cells		= <1>;
+				st,nand-csn		= <0>;
+				st,nand-timing-relax	= <0>;
+				nand-on-flash-bbt;
+
+				partition@0 {
+					/* 8MB */
+					label = "NANDFlash1";
+					reg = <0x00000000 0x00800000>;
+				};
+
+				partition@800000 {
+					/* 8MB - 1GB */
+					label = "NANDFlash2";
+					reg = <0x00800000 0x1f000000>;
+				};
+			};
+		};
 	};
 };
-- 
1.9.1

