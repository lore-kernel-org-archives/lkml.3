Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbaLCUrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:47:13 -0500
Received: from down.free-electrons.com ([37.187.137.238]:42904 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751891AbaLCUo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:44:26 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v5 04/11] mfd: syscon: Add Atmel SMC binding doc
Date: Wed,  3 Dec 2014 21:44:08 +0100
Message-Id: <1417639455-17410-5-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417639455-17410-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1417639455-17410-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SMC registers are used to configure Atmel EBI (External Bus Interface)
to interface with standard memory devices (NAND, NOR, SRAM or specialized
devices like FPGAs).

Declare this memory region as a syscon, so that different drivers can
configure the SMC interface (mostly timing configuration) according to
their need.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 Documentation/devicetree/bindings/mfd/atmel-smc.txt | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/atmel-smc.txt

diff --git a/Documentation/devicetree/bindings/mfd/atmel-smc.txt b/Documentation/devicetree/bindings/mfd/atmel-smc.txt
new file mode 100644
index 0000000..26eeed3
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/atmel-smc.txt
@@ -0,0 +1,19 @@
+* Device tree bindings for Atmel SMC (Static Memory Controller)
+
+The SMC registers are used to configure Atmel EBI (External Bus Interface)
+to interface with standard memory devices (NAND, NOR, SRAM or specialized
+devices like FPGAs).
+
+Required properties:
+- compatible:		Should be one of the following
+			"atmel,at91sam9260-smc", "syscon"
+			"atmel,sama5d3-smc", "syscon"
+- reg:			Contains offset/length value of the SMC memory
+			region.
+
+Example:
+
+smc: smc@ffffc000 {
+	compatible = "atmel,sama5d3-smc", "syscon";
+	reg = <0xffffc000 0x1000>;
+};
-- 
1.9.1

