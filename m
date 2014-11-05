Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbaKERCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:02:49 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:43892 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535AbaKERAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:00:37 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        pekon@pek-sem.com, linux-mtd@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: [PATCH v4 07/11] mtd: nand: stm_nand_bch: provide Device Tree documentation
Date: Wed,  5 Nov 2014 16:59:49 +0000
Message-Id: <1415206793-25670-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415206793-25670-1-git-send-email-lee.jones@linaro.org>
References: <1415206793-25670-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is where we describe the different new and generic options used by
the ST BCH driver.

Cc: devicetree@vger.kernel.org
Reviewed-by: Pekon Gupta <pekon@pek-sem.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 Documentation/devicetree/bindings/mtd/stm-nand.txt | 74 ++++++++++++++++++++++
 1 file changed, 74 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mtd/stm-nand.txt

diff --git a/Documentation/devicetree/bindings/mtd/stm-nand.txt b/Documentation/devicetree/bindings/mtd/stm-nand.txt
new file mode 100644
index 0000000..9b87cde
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
+
+Optional properties:
+
+- nand-ecc-strength	: Generic NAND property (See mtd/nand.txt)
+			  Options are; 0, 18 or 30. If not present, the driver
+			  will choose the strongest scheme compatible if the
+			  OOB size.
+
+Required sub-node:
+
+- bank			: Subnode representing one of NAND Flash, connected
+			  to an STM NAND Controller (see description below).
+			  There should be one of these per connect bank.
+
+Optional sub-node properies:
+
+- nand-chip-select	: Generic NAND property (See mtd/nand.txt)
+- st,nand-timing-relax	: Number of IP clock cycles by which to "relax" timing
+			  configuration.  Required on some boards to accommodate
+			  board-level limitations. Applies to ONFI timing mode
+			  configuration.
+- nand-on-flash-bbt	: Generic NAND property (See mtd/nand.txt)
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
+		bank {
+			nand-on-flash-bbt;
+			st,nand-csn		= <0>;
+
+			partitions {
+				#address-cells	= <1>;
+				#size-cells	= <1>;
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

