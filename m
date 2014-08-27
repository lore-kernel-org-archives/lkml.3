Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934114AbaH0Mmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 08:42:53 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:54432 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933994AbaH0Mmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 08:42:50 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        pekon@pek-sem.com, linux-mtd@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: [PATCH 5/9] mtd: nand: stm_nand_bch: provide Device Tree documentation
Date: Wed, 27 Aug 2014 13:42:20 +0100
Message-Id: <1409143344-22458-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409143344-22458-1-git-send-email-lee.jones@linaro.org>
References: <1409143344-22458-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is where we describe the different new and generic options used by
the ST BCH driver.

Cc: devicetree@vger.kernel.org
Reviewed-By: Pekon Gupta <pekon@pek-sem.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 Documentation/devicetree/bindings/mtd/stm-nand.txt | 74 ++++++++++++++++++++++
 1 file changed, 74 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mtd/stm-nand.txt

diff --git a/Documentation/devicetree/bindings/mtd/stm-nand.txt b/Documentation/devicetree/bindings/mtd/stm-nand.txt
new file mode 100644
index 0000000..5872a39
--- /dev/null
+++ b/Documentation/devicetree/bindings/mtd/stm-nand.txt
@@ -0,0 +1,74 @@
+STM BCH NAND Support
+--------------------
+
+Required properties:
+
+- compatible		: Should be "st,nand-bch"
+- reg			: Should contain register's location and length
+- reg-names		: "emi_nand" - NAND Controller register map
+			  "emiss" - External Memory Interface Subsystem base
+- interrupts		: Interrupt number
+- interrupt-names	: "nand_irq" - NAND Controller IRQ
+- st,nand-banks		: Subnode representing one or more "banks" of NAND
+			  Flash, connected to an STM NAND Controller (see
+			  description below).
+- nand-ecc-strength	: Generic NAND property (See mtd/nand.txt)
+			  Options are; 0, 18 or 30. If not present, the driver
+			  will choose the strongest scheme compatible if the
+			  OOB size.
+
+Properties describing Bank of NAND Flash ("st,nand-banks"):
+
+- st,nand-csn		: Chip select associated with the Bank.
+
+- st,nand-timing-relax	: [Optional] Number of IP clock cycles by which to
+			  "relax" timing configuration.  Required on some boards
+			  to accommodate board-level limitations. Applies to
+			  ONFI timing mode configuration.
+
+- nand-on-flash-bbt	: Generic NAND property (See mtd/nand.txt)
+
+- partitions		: [Optional] Subnode describing MTD partition map
+			  (see mtd/partition.txt)
+
+Note, during initialisation, the NAND Controller timing registers are configured
+according to one of the following methods, in order of precedence:
+
+	   1. Configuration based on ONFI timing mode, as advertised by the
+	      device during ONFI-probing (ONFI-compliant NAND only).
+
+	   2. Use reset/safe timing values
+
+Example:
+
+	nand@fe901000 {
+		compatible = "st,nand-bch";
+		reg = <0xfe901000 0x1000>, <0xfef00800 0x0800>;
+		reg-names = "emi_nand", "emiss";
+		interrupts = <0 139 0x0>;
+		interrupt-names = "nand_irq";
+		nand-ecc-strength = <30>;
+
+		status = "okay";
+
+		bank0 {
+			/* NAND_BBT_USE_FLASH */
+			nand-on-flash-bbt;
+			st,nand-csn		= <0>;
+
+			partitions {
+				#address-cells = <1>;
+				#size-cells = <1>;
+
+				partition@0{
+					label = "NANDFlash1";
+					reg = <0x00000000 0x00800000>;
+				};
+
+				partition@800000{
+					label = "NANDFlash2";
+					reg = <0x00800000 0x0f800000>;
+				};
+			};
+		};
+	};
-- 
1.9.1

