Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbaEUWyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:54:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57919 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbaEUWyo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:54:44 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "xobs@kosagi.com" <xobs@kosagi.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
CC: Mohit Kumar <mohit.kumar@st.com>, Pratyush Anand <pratyush.anand@st.com>,
        Richard Zhu <r65037@freescale.com>,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>, Marek Vasut <marex@denx.de>
Subject: RE: [RFC PATCH] pcie-designware: DT documentation update to clarify
 DT properties
Thread-Topic: [RFC PATCH] pcie-designware: DT documentation update to
 clarify DT properties
Thread-Index: AQHPdUdZgd1HL0eEgEOoLsS8Jeg70ptLpILQ
Date: Wed, 21 May 2014 22:54:21 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B70474C9AB@DFLE11.ent.ti.com>
References: <1400712749-6490-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1400712749-6490-1-git-send-email-m-karicheri2@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Karicheri, Muralidharan
>Sent: Wednesday, May 21, 2014 6:52 PM
>To: jg1.han@samsung.com; xobs@kosagi.com; devicetree@vger.kernel.org; linux-
>doc@vger.kernel.org; linux-kernel@vger.kernel.org; arnd@arndb.de
>Cc: Karicheri, Muralidharan; Mohit Kumar; Pratyush Anand; Richard Zhu; ABRAHAM,
>KISHON VIJAY; Marek Vasut
>Subject: [RFC PATCH] pcie-designware: DT documentation update to clarify DT properties
>
>Current documentation is not clear enough about the mandatory bindings to be present in
>the device node of a snps,dw-pcie compatible pcie controller. In some cases the property is
>not present in all drivers.
>For example pcie_bus is specified as a clock, but only one of the driver uses it. This patch
>attempts to make the documentation consistent with current implementation so that it is
>clear enough for anyone who develops a dw-pcie compatible pcie driver.
>
>CC: Mohit Kumar <mohit.kumar@st.com>
>CC: Jingoo Han <jg1.han@samsung.com>
>CC: Pratyush Anand <pratyush.anand@st.com>
>CC: Richard Zhu <r65037@freescale.com>
>CC: Kishon Vijay Abraham I <kishon@ti.com>
>CC: Marek Vasut <marex@denx.de>
>
>Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>---
> .../devicetree/bindings/pci/designware-pcie.txt    |   10 ++++++----
> 1 file changed, 6 insertions(+), 4 deletions(-)
>
>diff --git a/Documentation/devicetree/bindings/pci/designware-pcie.txt
>b/Documentation/devicetree/bindings/pci/designware-pcie.txt
>index d6fae13..8b9dc52 100644
>--- a/Documentation/devicetree/bindings/pci/designware-pcie.txt
>+++ b/Documentation/devicetree/bindings/pci/designware-pcie.txt
>@@ -4,12 +4,14 @@ Required properties:
> - compatible: should contain "snps,dw-pcie" to identify the
> 	core, plus an identifier for the specific instance, such
> 	as "samsung,exynos5440-pcie" or "fsl,imx6q-pcie".
>-- reg: base addresses and lengths of the pcie controller,
>-	the phy controller, additional register for the phy controller.
>+- reg: base addresses and lengths of the pcie controller.
>+    index 0 - base address and length of RC's config space.
>+    index 1 and above: additional registers for the PCI controller
>+    that are specific to an implementation.
> - interrupts: interrupt values for level interrupt,
> 	pulse interrupt, special interrupt.
>-- clocks: from common clock binding: handle to pci clock.
>-- clock-names: from common clock binding: should be "pcie" and "pcie_bus".
>+- clocks: from common clock binding: handle to list of pci clock.
>+- clock-names: from common clock binding: pci clock names: "pcie"
> - #address-cells: set to <3>
> - #size-cells: set to <2>
> - device_type: set to "pci"
>--
>1.7.9.5

+ Adding to the pci list.
