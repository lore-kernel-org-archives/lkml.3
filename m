Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbaKEQGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:06:47 -0500
Received: from down.free-electrons.com ([37.187.137.238]:43028 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755204AbaKEQBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:01:35 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 04/11] mfd: syscon: Add Atmel SMC binding doc
Date: Wed,  5 Nov 2014 17:01:20 +0100
Message-Id: <1415203287-21517-5-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415203287-21517-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1415203287-21517-1-git-send-email-boris.brezillon@free-electrons.com>
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
---
 Documentation/devicetree/bindings/mfd/atmel-smc.txt | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/atmel-smc.txt

diff --git a/Documentation/devicetree/bindings/mfd/atmel-smc.txt b/Documentation/devicetree/bindings/mfd/atmel-smc.txt
new file mode 100644
index 0000000..0c0cc3d
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
+- compatible:		should be one of the following
+			"atmel,at91sam9260-smc", "syscon"
+			"atmel,sama5d3-smc", "syscon"
+- reg:			contains offset/length value of the SMC memory
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

