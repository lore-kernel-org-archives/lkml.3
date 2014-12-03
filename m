Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaLCUo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:44:29 -0500
Received: from down.free-electrons.com ([37.187.137.238]:42904 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751349AbaLCUoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:44:24 -0500
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
Subject: [PATCH v5 02/11] mfd: syscon: Add Atmel Matrix bus DT binding documentation
Date: Wed,  3 Dec 2014 21:44:06 +0100
Message-Id: <1417639455-17410-3-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417639455-17410-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1417639455-17410-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Matrix registers are provided to configure internal bus behavior on
at91 SoCs.
Some registers might be accessed by several drivers (e.g. to configure
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
index 0000000..e3ef50c
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
+			"atmel,at91sam9rl-matrix", "syscon"
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

