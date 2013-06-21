Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422814Ab3FUAfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 20:35:46 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:41597 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965778Ab3FUAfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 20:35:44 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene.kim@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>, Nicolas Pitre <nico@fluxnic.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>, Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH v6 0/8] Initial Device Tree support for S3C64xx
Date: Fri, 21 Jun 2013 02:35:16 +0200
Message-Id: <1371774924-9224-1-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds Device Tree support for Samsung S3C64xx SoC series.

It fixes several problems preventing from booting an S3C64xx-based system
using Device Tree, adds all the infrastructure for Device Tree-based board
support, including mach-s3c64xx-dt and dts include files for S3C64xx SoCs,
and basic device tree source for FriendlyARM Mini6410 and SAMSUNG SMDK6410
boards.

Current support is somewhat limite, but should be fine as a start and
will be extended in future, hopefully with help of S3C64xx board
maintainers.

Depends on:
 - [PATCH 0/7] Common Clock Framework support for Samsung S3C64xx
   http://comments.gmane.org/gmane.linux.usb.general/87571

Changes since v5:
 - Rebased onto current for-next branch of Kgene's tree,
 - Added support for new Common Clock Framework based clock driver,
 - Introduced hierarchical structure of device nodes (representing
   physical AHB and APB buses),
 - Bypassed most of legacy initialization when booting with DT,
 - Used preprocessor macros in dts files to improve readabilty,
 - Added support for SMDK6410 board.

Changes since v4:
 - Rebased onto current for-next branch of Kgene's tree
 - Added support for pinctrl (driver merged through pinctrl tree)
 - Added labels to all nodes that can be overridden from board dts
 - Modified board dts to use the &label syntax to reference device nodes

Changes since v3:
 - Rebased onto current for-next branch of Kgene's tree
 - Updated timer node for next version of samsung-time patches
 - Replaced local s3c64xx_dt_init_irq with irqchip_init

Changes since v2:
 - Updated timer node for next version of samsung-time patches

Changes since v1:
 - Dropped two VIC-related patches that are no longer necessary
 - Added Device Tree-based instantation of system timers
 - Corrected VIC interrupt specifiers
 - Adjusted CPU compatible values and dropped @id

Tomasz Figa (8):
  ARM: common: vic: Parse interrupt and resume masks from device tree
  ARM: s3c64xx: Bypass legacy initialization when booting with DT
  gpio: samsung: Skip legacy GPIO registration if pinctrl-s3c64xx is
    present
  ARM: Add .init_platform() callback to machine descriptor
  ARM: s3c64xx: Add board file for boot using Device Tree
  ARM: dts: Add basic dts include files for Samsung S3C64xx SoCs
  ARM: dts: Add dts file for S3C6410-based Mini6410 board
  ARM: dts: Add dts file for S3C6410-based SMDK6410 board

 Documentation/devicetree/bindings/arm/vic.txt |   6 +
 arch/arm/boot/dts/Makefile                    |   2 +
 arch/arm/boot/dts/s3c6400.dtsi                |  41 ++
 arch/arm/boot/dts/s3c6410-mini6410.dts        | 199 ++++++++
 arch/arm/boot/dts/s3c6410-smdk6410.dts        |  93 ++++
 arch/arm/boot/dts/s3c6410.dtsi                |  41 ++
 arch/arm/boot/dts/s3c64xx-pinctrl.dtsi        | 687 ++++++++++++++++++++++++++
 arch/arm/boot/dts/s3c64xx.dtsi                | 190 +++++++
 arch/arm/include/asm/mach/arch.h              |   1 +
 arch/arm/kernel/irq.c                         |   3 +
 arch/arm/mach-s3c64xx/Kconfig                 |  16 +
 arch/arm/mach-s3c64xx/Makefile                |   1 +
 arch/arm/mach-s3c64xx/common.c                |  12 +
 arch/arm/mach-s3c64xx/dma.c                   |   9 +
 arch/arm/mach-s3c64xx/irq-pm.c                |   9 +
 arch/arm/mach-s3c64xx/mach-s3c64xx-dt.c       |  83 ++++
 arch/arm/mach-s3c64xx/s3c6400.c               |   9 +
 arch/arm/mach-s3c64xx/s3c6410.c               |   9 +
 arch/arm/plat-samsung/init.c                  |  12 +-
 drivers/gpio/gpio-samsung.c                   |   3 +-
 drivers/irqchip/irq-vic.c                     |   7 +-
 21 files changed, 1430 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/boot/dts/s3c6400.dtsi
 create mode 100644 arch/arm/boot/dts/s3c6410-mini6410.dts
 create mode 100644 arch/arm/boot/dts/s3c6410-smdk6410.dts
 create mode 100644 arch/arm/boot/dts/s3c6410.dtsi
 create mode 100644 arch/arm/boot/dts/s3c64xx-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/s3c64xx.dtsi
 create mode 100644 arch/arm/mach-s3c64xx/mach-s3c64xx-dt.c

-- 
1.8.2.1

