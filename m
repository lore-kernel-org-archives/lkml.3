Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaINITP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 04:19:15 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:64788 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752397AbaINITM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 04:19:12 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/v6oVflpiNbqN/r4NU3HHJRPavbOTd9Co=
X-DKIM: OpenDKIM Filter v2.0.1 titan B20145E1688
Date: Sun, 14 Sep 2014 04:19:09 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] irqchip: Core changes for v3.18
Message-ID: <20140914081909.GS21986@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Here's a round of changes I've had sitting in -next for a while.  The
last couple renesas changes haven't had as much testing as I would like,
but I didn't want to hold up everything else for those small, isolated
changes.

I have some more changes that haven't been in -next yet.  I'll try to
turn those around quickly as the rumblings indicate there might not be
an -rc7.

Please pull.

thx,

Jason.

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.infradead.org/users/jcooper/linux.git tags/irqchip-core-3.18

for you to fetch changes up to 468a903c0e5147e3f93187f0b808a3ef957fd00e:

  Merge branch 'irqchip/handle_domain' into irqchip/core (2014-09-14 07:53:54 +0000)

----------------------------------------------------------------
irqchip core changes for v3.18

 - renesas
    - add suspend to RAM
    - add runtime PM
    - misc cleanup and DT binding docs

 - keystone
    - add new driver

 - hip04
    - add Hisilicon HiP04 driver (without touching irq-gic.c)

 - gic
    - replace magic numbers with defined constants
    - preserve v2 bypass bits in cpu ctrl register

 - handle_domain_irq
    - whole conversion series replacing handle_IRQ

----------------------------------------------------------------
Feng Kan (2):
      irqchip: gic: Replace hex numbers with defines.
      irqchip: gic: Preserve gic V2 bypass bits in cpu ctrl register

Geert Uytterhoeven (7):
      irqchip: renesas-intc-irqpin: Add suspend-to-RAM wake up support
      MAINTAINERS: Add irqchip DT bindings doc path to IRQCHIP DRIVERS section
      irqchip: renesas-intc-irqpin: Document SoC-specific bindings
      irqchip: renesas-irqc: Add DT binding documentation
      irqchip: renesas-irqc: Add binding docs for new R-Car Gen2 SoCs
      irqchip: renesas-intc-irqpin: Add helper variable dev = &pdev->dev
      irqchip: renesas-intc-irqpin: Add minimal runtime PM support

Grygorii Strashko (2):
      irqchip: keystone: Add irq controller ip driver
      irqchip: keystone: Remove warning unsigned 'kirq->irq' is never less than zero

Haojian Zhuang (1):
      irqchip: hip04: Enable Hisilicon HiP04 interrupt controller

Jason Cooper (4):
      Merge branch 'irqchip/keystone' into irqchip/core
      Merge branch 'irqchip/hip04' into irqchip/core
      Merge branch 'irqchip/gic' into irqchip/core
      Merge branch 'irqchip/handle_domain' into irqchip/core

Marc Zyngier (26):
      genirq: Add irq_domain-aware core IRQ handler
      arm64: Convert handle_IRQ to use __handle_domain_irq
      ARM: Convert handle_IRQ to use __handle_domain_irq
      openrisc: Convert handle_IRQ to use __handle_domain_irq
      irqchip: gic: Convert to handle_domain_irq
      irqchip: armada-370-xp: Convert to handle_domain_irq
      irqchip: clps711x: Convert to handle_domain_irq
      irqchip: mmp: Convert to handle_domain_irq
      irqchip: mxs: Convert to handle_domain_irq
      irqchip: orion: Convert to handle_domain_irq
      irqchip: s3c24xx: Convert to handle_domain_irq
      irqchip: sirfsoc: Convert to handle_domain_irq
      irqchip: sun4i: Convert to handle_domain_irq
      irqchip: versatile-fpga: Convert to handle_domain_irq
      irqchip: vic: Convert to handle_domain_irq
      irqchip: vt8500: Convert to handle_domain_irq
      irqchip: zevio: Convert to handle_domain_irq
      irqchip: gic-v3: Convert to handle_domain_irq
      irqchip: atmel-aic: Convert to handle_domain_irq
      irqchip: atmel-aic5: Convert to handle_domain_irq
      irqchip: or1k-pic: Convert to handle_domain_irq
      ARM: imx: avic: Convert to handle_domain_irq
      ARM: imx: tzic: Convert to handle_domain_irq
      ARM: omap2: irq: Convert to handle_domain_irq
      arm64: Get rid of handle_IRQ
      openrisc: Get rid of handle_IRQ

 .../interrupt-controller/renesas,intc-irqpin.txt   |   8 +-
 .../bindings/interrupt-controller/renesas,irqc.txt |  32 ++
 .../interrupt-controller/ti,keystone-irq.txt       |  36 ++
 MAINTAINERS                                        |   1 +
 arch/arm/Kconfig                                   |   1 +
 arch/arm/kernel/irq.c                              |  19 +-
 arch/arm/mach-imx/avic.c                           |   2 +-
 arch/arm/mach-imx/tzic.c                           |   3 +-
 arch/arm/mach-omap2/irq.c                          |   3 +-
 arch/arm64/Kconfig                                 |   1 +
 arch/arm64/include/asm/hardirq.h                   |   2 -
 arch/arm64/kernel/irq.c                            |  27 --
 arch/openrisc/Kconfig                              |   1 +
 arch/openrisc/include/asm/irq.h                    |   1 -
 arch/openrisc/kernel/irq.c                         |  12 -
 drivers/irqchip/Kconfig                            |   7 +
 drivers/irqchip/Makefile                           |   2 +
 drivers/irqchip/irq-armada-370-xp.c                |  19 +-
 drivers/irqchip/irq-atmel-aic.c                    |   4 +-
 drivers/irqchip/irq-atmel-aic5.c                   |   4 +-
 drivers/irqchip/irq-clps711x.c                     |  18 +-
 drivers/irqchip/irq-gic-common.c                   |  15 +-
 drivers/irqchip/irq-gic-v3.c                       |  13 +-
 drivers/irqchip/irq-gic.c                          |  49 ++-
 drivers/irqchip/irq-hip04.c                        | 424 +++++++++++++++++++++
 drivers/irqchip/irq-keystone.c                     | 232 +++++++++++
 drivers/irqchip/irq-mmp.c                          |  10 +-
 drivers/irqchip/irq-mxs.c                          |   3 +-
 drivers/irqchip/irq-or1k-pic.c                     |   4 +-
 drivers/irqchip/irq-orion.c                        |   5 +-
 drivers/irqchip/irq-renesas-intc-irqpin.c          |  85 +++--
 drivers/irqchip/irq-s3c24xx.c                      |   4 +-
 drivers/irqchip/irq-sirfsoc.c                      |   6 +-
 drivers/irqchip/irq-sun4i.c                        |   5 +-
 drivers/irqchip/irq-versatile-fpga.c               |   2 +-
 drivers/irqchip/irq-vic.c                          |   2 +-
 drivers/irqchip/irq-vt8500.c                       |   5 +-
 drivers/irqchip/irq-zevio.c                        |   3 +-
 include/linux/irqchip/arm-gic.h                    |  16 +
 include/linux/irqdesc.h                            |  19 +
 kernel/irq/Kconfig                                 |   3 +
 kernel/irq/irqdesc.c                               |  42 ++
 42 files changed, 971 insertions(+), 179 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/renesas,irqc.txt
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/ti,keystone-irq.txt
 create mode 100644 drivers/irqchip/irq-hip04.c
 create mode 100644 drivers/irqchip/irq-keystone.c
