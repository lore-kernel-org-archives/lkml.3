Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761332Ab3EBRWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 13:22:00 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:32881 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761160Ab3EBRU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 13:20:57 -0400
From: Nishanth Menon <nm@ti.com>
To: Mark Brown <broonie@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH v3 0/5] regulator/OMAP: Support TI Adaptive Body Bias(ABB) on-chip LDO driver
Date: Thu, 2 May 2013 12:20:09 -0500
Message-ID: <1367515215-30753-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adaptive Body Biasing (ABB) modulates transistor bias voltages
dynamically in order to optimize switching speed versus leakage.

Texas Instruments' SoC processors have an on chip LDO subsystem which
is part of the SmartReflex 2 technology and provides support for this
power management technique with Forward Body Biasing (FBB) and Reverse
Body Biasing (RBB). These modulate the body voltage of transistor
cells or blocks dynamically to gain performance and reduce leakage.

This series introduces ABB regulator and associated data for
controlling ABB module on OMAP3630+ TI SoCs. Usage of ABB LDO is part
of SoC's OPP voltage transition sequence. We just introduce the
regulator in this series for LDO control, however, the actual sequence
of control of this regulator is left to the implementation of SoC OPP
voltage transition of the appropriate domain.

Note: We only support device tree supported boot in this series.

Testing and Caveats:
	- Sanity tested on OMAP3,4,5 platforms - verified with omapconf.
	- Testing performed with regulator virtual consumer:
		http://pastebin.com/Knp1fSxA
	- OMAP5 clock nodes are introduced, but clock data is missing in
		upstream - tested with private tree with requisite clock nodes
		introduced. Clock node has been commented out in this series.

V3 of this series also available (with testing patch):
http link: https://github.com/nmenon/linux-2.6-playground/commits/devel/abb-regulator-v3
git link: git://github.com/nmenon/linux-2.6-playground.git
branch: devel/abb-regulator-v3

Changes in V3:
	- Regulator is purely meant to control ABB LDO.
	- The "regulator chaining" for doing voltage scale for entire
	  SoC voltage domain has been dropped.
	- Debugfs entries meant to expose ABB registers has been dropped as
	  the same functionality can be achieved with readmem like omapconf
	  application.
	- Re-factored regulator logic to make it simpler using the existing
	  voltage indexing support of regulator framework.
	- Implemented efuse based detection strategy and provided requisite
	  data to cover all existing OMAPs using ABB.
	- Depends on OMAP clock driver introduced in:
		http://marc.info/?t=136580758500001&r=1&w=2

V2: http://marc.info/?t=136603261400007&r=1&w=2&n=3
V1/RFC: http://marc.info/?l=linux-omap&m=136449099409794&w=2

Andrii.Tseglytskyi (5):
  regulator: Introduce TI Adaptive Body Bias(ABB) on-chip LDO driver
  ARM: dts: OMAP36xx: Add device node for ABB
  ARM: dts: OMAP443x: Add device nodes for ABB
  ARM: dts: OMAP4460: Add device nodes for ABB
  ARM: dts: OMAP5: Add device nodes for ABB

 .../bindings/regulator/ti-abb-regulator.txt        |  128 +++
 arch/arm/boot/dts/omap3.dtsi                       |    5 +
 arch/arm/boot/dts/omap36xx.dtsi                    |   20 +
 arch/arm/boot/dts/omap4.dtsi                       |   32 +
 arch/arm/boot/dts/omap443x.dtsi                    |   26 +
 arch/arm/boot/dts/omap4460.dtsi                    |   38 +
 arch/arm/boot/dts/omap5.dtsi                       |   67 ++
 drivers/regulator/Kconfig                          |   10 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/ti-abb-regulator.c               |  912 ++++++++++++++++++++
 10 files changed, 1239 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/regulator/ti-abb-regulator.txt
 create mode 100644 drivers/regulator/ti-abb-regulator.c

-- 
1.7.9.5

