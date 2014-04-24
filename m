Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbaDXKqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:46:16 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:40279
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755786AbaDXKqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:46:06 -0400
From: Anders Berg <anders.berg@lsi.com>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Mike Turquette <mturquette@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Anders Berg <anders.berg@lsi.com>
Subject: [PATCH v2 0/6] Add platform support for LSI AXM55xx
Date: Thu, 24 Apr 2014 12:44:03 +0200
Message-ID: <cover.1398335771.git.anders.berg@lsi.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [213.121.150.226]
X-ClientProxiedBy: BY2PR07CA040.namprd07.prod.outlook.com (10.141.251.15) To
 CO1PR07MB377.namprd07.prod.outlook.com (10.141.74.156)
X-Forefront-PRVS: 01917B1794
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019001)(6009001)(428001)(189002)(199002)(80976001)(83322001)(50226001)(53416003)(31966008)(74662001)(19580395003)(99396002)(85852003)(77982001)(89996001)(47776003)(46102001)(83072002)(42186004)(79102001)(76482001)(20776003)(80022001)(66066001)(4396001)(74502001)(86362001)(93916002)(87286001)(88136002)(36756003)(50466002)(33646001)(87976001)(77156001)(50986999)(81542001)(81342001)(62966002)(48376002)(92726001)(92566001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR07MB377;H:swsaberg01.lsi.com;FPR:68D9FCE4.90548CA0.19D31B07.9EC4624B.2027C;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Verion 2 of this series to introduces basic platform support for the LSI
AXM5516 SoC. When this is in shape, could it be merged into the arm-soc tree?

Changes:

v2:
    * Rebased to arm-soc/for-next
    * Removed redundant HAVE_SMP and ARCH_WANT_OPTIONAL_GPIOLIB from Kconfig
    * Use CPU_METHOD_OF_DECLARE to register smp_operations
    * Rework smp operations to avoid holding pen and custom headsmp.S
    * Clean up board file
    * Corrected clock properties for arm,sp804 dts node.
    * Changed machine compatible strings to include full model number.
    * Break out clk-axxia driver as separate patch
    * Removed Makefile.boot

Anders Berg (6):
  ARM: Add platform support for LSI AXM55xx SoC
  clk: Add clock driver for AXM55xx SoC
  ARM: dts: Device tree for AXM55xx.
  ARM: axxia: Adding defconfig for AXM55xx
  power: reset: Add Axxia system reset driver
  ARM: dts: axxia: Add reset controller

 Documentation/devicetree/bindings/arm/axxia.txt    |  12 +
 .../devicetree/bindings/clock/clk-axxia.txt        |  88 ++++++
 .../bindings/power_supply/axxia-reset.txt          |  20 ++
 arch/arm/Kconfig                                   |   2 +
 arch/arm/Makefile                                  |   2 +
 arch/arm/boot/dts/Makefile                         |   1 +
 arch/arm/boot/dts/axm5516-amarillo.dts             |  51 ++++
 arch/arm/boot/dts/axm5516-cpus.dtsi                | 204 ++++++++++++++
 arch/arm/boot/dts/axm55xx.dtsi                     | 311 +++++++++++++++++++++
 arch/arm/configs/axm55xx_defconfig                 | 248 ++++++++++++++++
 arch/arm/mach-axxia/Kconfig                        |  16 ++
 arch/arm/mach-axxia/Makefile                       |   2 +
 arch/arm/mach-axxia/axxia.c                        |  28 ++
 arch/arm/mach-axxia/platsmp.c                      |  89 ++++++
 drivers/clk/Makefile                               |   1 +
 drivers/clk/clk-axxia.c                            | 281 +++++++++++++++++++
 drivers/power/reset/Kconfig                        |   8 +
 drivers/power/reset/Makefile                       |   1 +
 drivers/power/reset/axxia-reset.c                  |  97 +++++++
 19 files changed, 1462 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/axxia.txt
 create mode 100644 Documentation/devicetree/bindings/clock/clk-axxia.txt
 create mode 100644 Documentation/devicetree/bindings/power_supply/axxia-reset.txt
 create mode 100644 arch/arm/boot/dts/axm5516-amarillo.dts
 create mode 100644 arch/arm/boot/dts/axm5516-cpus.dtsi
 create mode 100644 arch/arm/boot/dts/axm55xx.dtsi
 create mode 100644 arch/arm/configs/axm55xx_defconfig
 create mode 100644 arch/arm/mach-axxia/Kconfig
 create mode 100644 arch/arm/mach-axxia/Makefile
 create mode 100644 arch/arm/mach-axxia/axxia.c
 create mode 100644 arch/arm/mach-axxia/platsmp.c
 create mode 100644 drivers/clk/clk-axxia.c
 create mode 100644 drivers/power/reset/axxia-reset.c

-- 
1.8.3.2

