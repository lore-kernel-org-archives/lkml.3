Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaEUWwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:52:53 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50812 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbaEUWwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:52:50 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <jg1.han@samsung.com>, <xobs@kosagi.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>
CC: Murali Karicheri <m-karicheri2@ti.com>, Mohit Kumar <mohit.kumar@st.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Richard Zhu <r65037@freescale.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Marek Vasut <marex@denx.de>
Subject: [RFC PATCH] pcie-designware: DT documentation update to clarify DT properties
Date: Wed, 21 May 2014 18:52:29 -0400
Message-ID: <1400712749-6490-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current documentation is not clear enough about the mandatory bindings
to be present in the device node of a snps,dw-pcie compatible pcie
controller. In some cases the property is not present in all drivers.
For example pcie_bus is specified as a clock, but only one of the driver
uses it. This patch attempts to make the documentation consistent with
current implementation so that it is clear enough for anyone who develops
a dw-pcie compatible pcie driver.

CC: Mohit Kumar <mohit.kumar@st.com>
CC: Jingoo Han <jg1.han@samsung.com>
CC: Pratyush Anand <pratyush.anand@st.com>
CC: Richard Zhu <r65037@freescale.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>
CC: Marek Vasut <marex@denx.de>

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 .../devicetree/bindings/pci/designware-pcie.txt    |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/pci/designware-pcie.txt b/Documentation/devicetree/bindings/pci/designware-pcie.txt
index d6fae13..8b9dc52 100644
--- a/Documentation/devicetree/bindings/pci/designware-pcie.txt
+++ b/Documentation/devicetree/bindings/pci/designware-pcie.txt
@@ -4,12 +4,14 @@ Required properties:
 - compatible: should contain "snps,dw-pcie" to identify the
 	core, plus an identifier for the specific instance, such
 	as "samsung,exynos5440-pcie" or "fsl,imx6q-pcie".
-- reg: base addresses and lengths of the pcie controller,
-	the phy controller, additional register for the phy controller.
+- reg: base addresses and lengths of the pcie controller.
+    index 0 - base address and length of RC's config space.
+    index 1 and above: additional registers for the PCI controller
+    that are specific to an implementation.
 - interrupts: interrupt values for level interrupt,
 	pulse interrupt, special interrupt.
-- clocks: from common clock binding: handle to pci clock.
-- clock-names: from common clock binding: should be "pcie" and "pcie_bus".
+- clocks: from common clock binding: handle to list of pci clock.
+- clock-names: from common clock binding: pci clock names: "pcie"
 - #address-cells: set to <3>
 - #size-cells: set to <2>
 - device_type: set to "pci"
-- 
1.7.9.5

