Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbaDOMPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:15:01 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:57359
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751001AbaDOMO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:14:57 -0400
From: Anders Berg <anders.berg@lsi.com>
To: <arnd@arndb.de>, <olof@lixom.net>, <mturquette@linaro.org>,
        <mark.rutland@arm.com>, <dbaryshkov@gmail.com>
CC: <linus.walleij@linaro.org>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Anders Berg <anders.berg@lsi.com>
Subject: [PATCH 0/5] Add platform support for LSI AXM55xx
Date: Tue, 15 Apr 2014 14:06:09 +0200
Message-ID: <cover.1397552154.git.anders.berg@lsi.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [213.121.150.226]
X-ClientProxiedBy: BY2PR07CA048.namprd07.prod.outlook.com (10.141.251.23) To
 BLUPR07MB370.namprd07.prod.outlook.com (10.141.26.147)
X-Forefront-PRVS: 0182DBBB05
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019001)(6009001)(428001)(199002)(189002)(19580395003)(89996001)(80976001)(81542001)(2201001)(87976001)(62966002)(87286001)(36756003)(80022001)(20776003)(66066001)(47776003)(79102001)(50986999)(46102001)(77982001)(99396002)(53416003)(92726001)(74502001)(81342001)(76482001)(48376002)(83072002)(33646001)(4396001)(85852003)(83322001)(50466002)(86362001)(77156001)(93916002)(88136002)(50226001)(42186004)(74662001)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR07MB370;H:swsaberg01.lsi.com;FPR:6AFA7C24.FC1488A1.1BD1ABF7.DCC66243.201D3;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This set of patches introduces basic platform support for the LSI AXM5516 SoC.
This is another 16 core machine (4x4 cluster config). Please review and provide
feedback.

Regards,
Anders


Anders Berg (5):
  ARM: Add platform support for LSI AXM55xx SoC
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
 arch/arm/mach-axxia/Kconfig                        |  19 ++
 arch/arm/mach-axxia/Makefile                       |   2 +
 arch/arm/mach-axxia/Makefile.boot                  |   2 +
 arch/arm/mach-axxia/axxia.c                        | 117 ++++++++
 arch/arm/mach-axxia/axxia.h                        |  42 +++
 arch/arm/mach-axxia/headsmp.S                      |  44 +++
 arch/arm/mach-axxia/platsmp.c                      | 183 ++++++++++++
 drivers/clk/Makefile                               |   1 +
 drivers/clk/clk-axxia.c                            | 281 +++++++++++++++++++
 drivers/power/reset/Kconfig                        |   8 +
 drivers/power/reset/Makefile                       |   1 +
 drivers/power/reset/axxia-reset.c                  |  97 +++++++
 22 files changed, 1736 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/axxia.txt
 create mode 100644 Documentation/devicetree/bindings/clock/clk-axxia.txt
 create mode 100644 Documentation/devicetree/bindings/power_supply/axxia-reset.txt
 create mode 100644 arch/arm/boot/dts/axm5516-amarillo.dts
 create mode 100644 arch/arm/boot/dts/axm5516-cpus.dtsi
 create mode 100644 arch/arm/boot/dts/axm55xx.dtsi
 create mode 100644 arch/arm/configs/axm55xx_defconfig
 create mode 100644 arch/arm/mach-axxia/Kconfig
 create mode 100644 arch/arm/mach-axxia/Makefile
 create mode 100644 arch/arm/mach-axxia/Makefile.boot
 create mode 100644 arch/arm/mach-axxia/axxia.c
 create mode 100644 arch/arm/mach-axxia/axxia.h
 create mode 100644 arch/arm/mach-axxia/headsmp.S
 create mode 100644 arch/arm/mach-axxia/platsmp.c
 create mode 100644 drivers/clk/clk-axxia.c
 create mode 100644 drivers/power/reset/axxia-reset.c

-- 
1.8.3.2

