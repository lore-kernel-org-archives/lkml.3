Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468Ab3DWOg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 10:36:56 -0400
Received: from multi.imgtec.com ([194.200.65.239]:40821 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755794Ab3DWOeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 10:34:31 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        James Hogan <james.hogan@imgtec.com>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/8] Add some TZ1090 SoC infrastructure
Date: Tue, 23 Apr 2013 15:33:19 +0100
Message-ID: <1366727607-27444-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_04_23_15_34_27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Toumaz Xenif TZ1090 SoC (AKA Comet) contains a 2-threaded
Linux-capable HTP (Meta 2), and is found in a number of development
boards and digital radios, such as the Minimorph Development Platform.

This patchset adds some core infrastructure for the TZ1090, including
drivers for the powerdown controller (PDC) irqchip, general/PDC pin
controllers, and general/PDC GPIO controllers. It's not yet enough to
get the UARTs going (no common clock framework) so JTAG/QEMU with DA TTY
is still needed to get a shell.

A QEMU with a Meta frontend and some TZ1090 emulation, and the SoC
Technical Reference Manual which documents the registers used by both
GPIO drivers and both pin control drivers can be downloaded from the
Minimorph SDK (registration of a Minimorph is currently required):
http://imgtec.com/meta_insider/metaflow-sdk.asp

I aim to get whatever I can of this patchset into v3.10 (at least the
first two patches) so all review is very much appreciated.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>

James Hogan (8):
  metag: of_platform_populate from arch generic code
  metag: minimal TZ1090 (Comet) SoC infrastructure
  irq-imgpdc: add ImgTec PDC irqchip driver
  metag: tz1090: add <asm/soc-tz1090/gpio.h>
  pinctrl-tz1090: add TZ1090 pinctrl driver
  gpio-tz1090: add TZ1090 gpio driver
  pinctrl-tz1090-pdc: add TZ1090 PDC pinctrl driver
  gpio-tz1090pdc: add TZ1090 PDC gpio driver

 .../devicetree/bindings/gpio/gpio-tz1090-pdc.txt   |   40 +
 .../devicetree/bindings/gpio/gpio-tz1090.txt       |   77 +
 .../devicetree/bindings/metag/pdc-intc.txt         |  112 ++
 .../bindings/pinctrl/img,tz1090-pdc-pinctrl.txt    |  125 ++
 .../bindings/pinctrl/img,tz1090-pinctrl.txt        |  214 +++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 arch/metag/Kconfig.soc                             |   14 +
 arch/metag/Makefile                                |    8 +-
 arch/metag/boot/dts/Makefile                       |    2 +
 arch/metag/boot/dts/tz1090.dtsi                    |  106 +
 arch/metag/boot/dts/tz1090_generic.dts             |   10 +
 arch/metag/configs/tz1090_defconfig                |   41 +
 arch/metag/include/asm/soc-tz1090/gpio.h           |  121 ++
 arch/metag/kernel/setup.c                          |    4 +
 arch/metag/soc/tz1090/Makefile                     |    5 +
 arch/metag/soc/tz1090/setup.c                      |   21 +
 drivers/gpio/Kconfig                               |   14 +
 drivers/gpio/Makefile                              |    2 +
 drivers/gpio/gpio-tz1090-pdc.c                     |  237 +++
 drivers/gpio/gpio-tz1090.c                         |  628 ++++++
 drivers/irqchip/Kconfig                            |    4 +
 drivers/irqchip/Makefile                           |    1 +
 drivers/irqchip/irq-imgpdc.c                       |  553 ++++++
 drivers/pinctrl/Kconfig                            |   12 +
 drivers/pinctrl/Makefile                           |    2 +
 drivers/pinctrl/pinctrl-tz1090-pdc.c               | 1114 +++++++++++
 drivers/pinctrl/pinctrl-tz1090-pdc.h               |   58 +
 drivers/pinctrl/pinctrl-tz1090.c                   | 2018 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-tz1090.h                   |   58 +
 29 files changed, 5601 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-tz1090-pdc.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-tz1090.txt
 create mode 100644 Documentation/devicetree/bindings/metag/pdc-intc.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/img,tz1090-pdc-pinctrl.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/img,tz1090-pinctrl.txt
 create mode 100644 arch/metag/boot/dts/tz1090.dtsi
 create mode 100644 arch/metag/boot/dts/tz1090_generic.dts
 create mode 100644 arch/metag/configs/tz1090_defconfig
 create mode 100644 arch/metag/include/asm/soc-tz1090/gpio.h
 create mode 100644 arch/metag/soc/tz1090/Makefile
 create mode 100644 arch/metag/soc/tz1090/setup.c
 create mode 100644 drivers/gpio/gpio-tz1090-pdc.c
 create mode 100644 drivers/gpio/gpio-tz1090.c
 create mode 100644 drivers/irqchip/irq-imgpdc.c
 create mode 100644 drivers/pinctrl/pinctrl-tz1090-pdc.c
 create mode 100644 drivers/pinctrl/pinctrl-tz1090-pdc.h
 create mode 100644 drivers/pinctrl/pinctrl-tz1090.c
 create mode 100644 drivers/pinctrl/pinctrl-tz1090.h

-- 
1.8.1.2


