Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaLAKbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 05:31:03 -0500
Received: from down.free-electrons.com ([37.187.137.238]:50385 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752767AbaLAK1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 05:27:33 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 02/11] mfd: syscon: Add Atmel Matrix bus DT binding documentation
Date: Mon,  1 Dec 2014 11:27:18 +0100
Message-Id: <1417429647-3419-3-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417429647-3419-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1417429647-3419-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Matrix registers are provided to configure internal bus behavior on
at91 SoCs.
Some registers might be access by several drivers (e.g. to configure
external memory bus timings), hence we declare this register set as a
syscon device.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 .../devicetree/bindings/mfd/atmel-matrix.txt       | 24 ++++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/atmel-matrix.txt

diff --git a/Documentation/devicetree/bindings/mfd/atmel-matrix.txt b/Documentation/devicetree/bindings/mfd/atmel-matrix.txt
new file mode 100644
index 0000000..e56e27a
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/atmel-matrix.txt
@@ -0,0 +1,24 @@
+* Device tree bindings for Atmel Bus Matrix
+
+The Bus Matrix registers are used to configure Atmel SoCs internal bus
+behavior (master/slave priorities, undefined burst length type, ...)
+
+Required properties:
+- compatible:		Should be one of the following
+			"atmel,at91sam9260-matrix", "syscon"
+			"atmel,at91sam9261-matrix", "syscon"
+			"atmel,at91sam9263-matrix", "syscon"
+			"atmel,at91sam9263-matrix", "syscon"
+			"atmel,at91sam9g45-matrix", "syscon"
+			"atmel,at91sam9n12-matrix", "syscon"
+			"atmel,at91sam9x5-matrix", "syscon"
+			"atmel,sama5d3-matrix", "syscon"
+- reg:			Contains offset/length value of the Bus Matrix
+			memory region.
+
+Example:
+
+matrix: matrix@ffffec00 {
+	compatible = "atmel,sama5d3-matrix", "syscon";
+	reg = <0xffffec00 0x200>;
+};
-- 
1.9.1

