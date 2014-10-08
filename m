Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbaJHUeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:34:11 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:58921 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbaJHUeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:34:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: torvalds@linux-foundation.org
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL 5/7] ARM: SoC driver updates for 3.18
Date: Wed, 08 Oct 2014 22:33:39 +0200
Message-ID: <2129640.aH5niGdlpV@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1922034.HH2lvbiFi0@wuerfel>
References: <1922034.HH2lvbiFi0@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:tl2z0v1SuAYFTNuAbavNxFow85tfGSkNYnJxwA9RvfK
 VBQfERgmk4S3KbJ4tSt9Ia21jQe5er/GGzN4CaRzrL5gn6jUy6
 Aw1g/G0R7Ui1bpO6ypkKwMd1WAU1A0KTYnmpxVM5HqLTv/RtTB
 SP1K3+N7OBMPwDiVy7euV185gCTuTed7zyQV3zkrWDrBZRnXo9
 U2iRTL++dsTQMOG38/IUYfyulC3yU02KN/t3ozfm1EcBDaKk7K
 kJr7GDZLHmLXJ/WLstAuE1CQJvctuyXu+h6jULQzl5CF8TRZ6J
 6rjy5FsdBL8PjLviELGMeRXOfIhVDgS2c5PdpZ/elS4VZRqV+F
 6ttAB/vwdInFw6ZzQ7nc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 69e273c0b0a3c337a521d083374c918dc52c666f:

  Linux 3.17-rc3 (2014-08-31 18:23:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/drivers-for-linus

for you to fetch changes up to fa637bf0595ee1796d728a0d33b6b7fff12e1f3d:

  bus: arm-ccn: Fix spurious warning message (2014-10-08 21:31:14 +0200)

----------------------------------------------------------------
ARM: SoC driver updates for 3.18

These are changes for drivers that are intimately tied to some SoC
and for some reason could not get merged through the respective
subsystem maintainer tree.

Most of the new code is for the Keystone Navigator driver, which is
new base support that is going to be needed for their hardware
accelerated network driver and other units.

Most of the commits are for moving old code around from at91 and omap
for things that are done in device drivers nowadays.

- at91: move reset, poweroff, memory and clocksource code into drivers
  directories
- socfpga: add edac driver (through arm-soc, as requested by Boris)
- omap: move omap-intc code to drivers/irqchip
- sunxi: added an RTC driver for sun6i
- omap: mailbox driver related changes
- keystone: support for the "Navigator" component
- versatile: new reboot, led and soc drivers

----------------------------------------------------------------
Alexandre Belloni (5):
      ARM: at91: Add new binding for sama5d3-ddramc
      memory: add a driver for atmel ram controllers
      ARM: at91: select ATMEL_SDRAMC when using OF
      clk: at91: remove the useless CLK_IGNORE_UNUSED flag
      ARM: at91: fix ramc standby function registration

Arnd Bergmann (5):
      Merge tag 'at91-drivers' of git://github.com/at91linux/linux-at91 into next/drivers
      Merge tag 'socfpga_driver_for_v3.18' of git://git.rocketboards.org/linux-socfpga-next into next/drivers
      Merge tag 'sunxi-drivers-for-3.18' of git://git.kernel.org/.../mripard/linux into next/drivers
      Merge tag 'intc-part2-for-v3.18' of git://git.kernel.org/.../tmlind/linux-omap into next/drivers
      Merge branch 'next/drivers' into HEAD

Chen-Yu Tsai (2):
      rtc: sun6i: Add sun6i RTC driver
      rtc: sunxi: Depend on platforms sun4i/sun7i that actually have the rtc

Felipe Balbi (39):
      arm: omap: irq: make omap_irq_base global
      arm: omap: irq: define INTC_ILR0 register
      arm: omap: irq: start to remove irq_banks array
      arm: omap: irq: add a global omap_nr_irqs variable
      arm: omap: irq: remove rest of irq_banks usage
      arm: omap: irq: remove unused macro
      arm: omap: irq: switch over to intc_readl on omap_intc_handle_irq
      arm: omap: irq: remove unnecessary base_addr argument
      arm: omap: irq: rename omap3_intc_regs
      arm: omap: irq: always define omap3 support
      arm: omap: irq: reorganize code a little bit
      arm: omap: irq: make intc_of_init static
      arm: omap: irq: call set_handle_irq() from intc_of_init
      arm: omap: irq: use IRQCHIP_DECLARE macro
      arm: omap: irq: drop .handle_irq and .init_irq fields
      arm: omap: irq: add specific compatibles for omap3 and am33xx devices
      arm: omap: irq: use compatible flag to figure out number of IRQ lines
      arm: boot: dts: am33xx/omap3: fix intc compatible flag
      arm: omap: irq: drop ti,intc-size support
      arm: boot: dts: omap2/3/am33xx: drop ti,intc-size
      arm: omap: irq: move some more code around
      arm: omap: irq: call set_handle_irq() from .init_irq
      arm: omap: irq: drop omap3_intc_handle_irq()
      arm: omap: irq: drop omap2_intc_handle_irq()
      arm: omap: irq: remove unnecessary header
      arm: omap: irq: remove nr_irqs argument
      arm: omap: irq: introduce omap_nr_pending
      arm: omap: irq: get rid of ifdef hack
      arm: omap: intc: switch over to linear irq domain
      arm: omap2: n8x0: move i2c devices to DT
      irqchip: add irq-omap-intc.h header
      arm: omap: irq: move irq.c to drivers/irqchip/
      irqchip: omap-intc: minor improvement to omap_irq_pending()
      irqchip: omap-intc: comment style cleanup
      irqchip: omap-intc: remove unnecesary of_address_to_resource() call
      irqchip: omap-intc: enable IP protection
      irqchip: omap-intc: enable TURBO idle mode
      irqchip: omap-intc: correct maximum number or MIR registers
      irqchip: omap-intc: remove unnecessary comments

Linus Walleij (4):
      leds: add a driver for syscon-based LEDs
      power: reset: driver for the Versatile syscon reboot
      soc: add driver for the ARM RealView
      leds: add device tree bindings for register bit LEDs

Maxime Ripard (30):
      power: reset: Add if statement instead of multiple depends on
      power: reset: Add AT91 reset driver
      power: reset: Add AT91 poweroff driver
      ARM: at91: setup: Switch to pr_fmt
      ARM: at91: Rework ramc mapping code
      ARM: at91: Remove the old-style reset probing
      ARM: at91/soc: Introduce register_devices callback
      ARM: at91: Probe the reset driver
      ARM: at91: Call at91_register_devices in the board files
      ARM: at91: Remove reset code from the machine code
      ARM: at91: Remove poweroff DT probing
      ARM: at91: Register the poweroff driver
      ARM: at91: Remove poweroff code
      ARM: at91/pm: Remove show_reset_status function
      ARM: at91: Remove rstc and shdwnc global base addresses
      ARM: at91: Remove rstc and shdwc headers
      ARM: at91: PIT: Follow the general coding rules
      ARM: at91: generic.h: Add include safe guards
      ARM: at91: PIT: Use DIV_ROUND_CLOSEST to compute the cycles
      ARM: at91: PIT: Use of_have_populated_dt instead of CONFIG_OF
      ARM: at91: PIT: Rework probe functions
      ARM: at91: dt: Remove init_time definitions
      ARM: at91: PIT: Use consistent exit path in probe
      ARM: at91: PIT: Use pr_fmt
      ARM: at91: PIT: use request_irq instead of setup_irq
      ARM: at91: PIT: (Almost) remove the global variables
      ARM: at91: soc: Add init_time callback
      ARM: at91: Convert the boards to the init_time callback
      ARM: at91: Give the PIT irq as an argument of at91sam926x_pit_init
      ARM: at91: PIT: Move the driver to drivers/clocksource

Nicolas Ferre (4):
      Merge branches 'at91-3.18-cleanup' and 'at91-3.18-dt' into at91-3.18-drivers
      Merge tag 'at91-drivers-for-3.17' of git://git.kernel.org/.../mripard/linux
      ARM: at91/power/reset: fix Kconfig "depends on" directive
      power: reset: at91-poweroff: fix wakeup status register index

Olof Johansson (5):
      Merge tag 'at91-drivers2' of git://github.com/at91linux/linux-at91 into next/drivers
      Merge tag 'intc-for-v3.18' of git://git.kernel.org/.../tmlind/linux-omap into next/drivers
      Merge tag 'mailbox-for-v3.18' of git://git.kernel.org/.../tmlind/linux-omap into next/drivers
      Merge tag 'drivers-soc-ti-v2' of git://git.kernel.org/.../ssantosh/linux-keystone into next/drivers
      drivers/soc: ti: fix build break with modules

Sandeep Nair (2):
      Documentation: dt: soc: add Keystone Navigator QMSS bindings
      soc: ti: add Keystone Navigator QMSS driver

Santosh Shilimkar (3):
      Documentation: dt: soc: add Keystone Navigator DMA bindings
      soc: ti: add Keystone Navigator DMA support
      MAINTAINERS: Add Keystone Multicore Navigator drivers entry

Suman Anna (2):
      Documentation: dt: add omap mailbox bindings
      mailbox/omap: add support for parsing dt devices

Thor Thayer (1):
      edac: altera: Add Altera SDRAM EDAC support

Tony Lindgren (1):
      Merge branch 'omap-for-v3.18/fixes-not-urgent' into omap-for-v3.18/intc-v2


 .../devicetree/bindings/arm/atmel-at91.txt         |    8 +-
 .../devicetree/bindings/leds/register-bit-led.txt  |   99 ++
 .../devicetree/bindings/mailbox/omap-mailbox.txt   |  108 ++
 .../devicetree/bindings/rtc/sun6i-rtc.txt          |   17 +
 .../bindings/soc/ti/keystone-navigator-dma.txt     |  111 ++
 .../bindings/soc/ti/keystone-navigator-qmss.txt    |  232 +++
 MAINTAINERS                                        |   14 +
 arch/arm/boot/dts/am33xx.dtsi                      |    3 +-
 arch/arm/boot/dts/omap2.dtsi                       |    1 -
 arch/arm/boot/dts/omap2420-n810.dts                |    7 +
 arch/arm/boot/dts/omap2420-n8x0-common.dtsi        |    6 +
 arch/arm/boot/dts/omap3.dtsi                       |    3 +-
 arch/arm/mach-at91/Kconfig                         |   17 +-
 arch/arm/mach-at91/Makefile                        |    3 -
 arch/arm/mach-at91/at91_rstc.h                     |   53 -
 arch/arm/mach-at91/at91_shdwc.h                    |   50 -
 arch/arm/mach-at91/at91sam9260.c                   |   51 +-
 arch/arm/mach-at91/at91sam9261.c                   |   51 +-
 arch/arm/mach-at91/at91sam9263.c                   |   51 +-
 arch/arm/mach-at91/at91sam926x_time.c              |  294 ----
 arch/arm/mach-at91/at91sam9_alt_reset.S            |   40 -
 arch/arm/mach-at91/at91sam9g45.c                   |   55 +-
 arch/arm/mach-at91/at91sam9g45_reset.S             |   45 -
 arch/arm/mach-at91/at91sam9rl.c                    |   51 +-
 arch/arm/mach-at91/board-afeb-9260v1.c             |    4 +-
 arch/arm/mach-at91/board-cam60.c                   |    4 +-
 arch/arm/mach-at91/board-cpu9krea.c                |    4 +-
 arch/arm/mach-at91/board-dt-sam9.c                 |   10 -
 arch/arm/mach-at91/board-dt-sama5.c                |    9 -
 arch/arm/mach-at91/board-flexibity.c               |    4 +-
 arch/arm/mach-at91/board-gsia18s.c                 |    2 +-
 arch/arm/mach-at91/board-pcontrol-g20.c            |    2 +-
 arch/arm/mach-at91/board-sam9-l9260.c              |    4 +-
 arch/arm/mach-at91/board-sam9260ek.c               |    5 +-
 arch/arm/mach-at91/board-sam9261ek.c               |    7 +-
 arch/arm/mach-at91/board-sam9263ek.c               |    5 +-
 arch/arm/mach-at91/board-sam9g20ek.c               |    4 +-
 arch/arm/mach-at91/board-sam9m10g45ek.c            |    5 +-
 arch/arm/mach-at91/board-sam9rlek.c                |    5 +-
 arch/arm/mach-at91/board-snapper9260.c             |    4 +-
 arch/arm/mach-at91/board-stamp9g20.c               |    4 +-
 arch/arm/mach-at91/generic.h                       |   18 +-
 arch/arm/mach-at91/pm.c                            |   72 -
 arch/arm/mach-at91/setup.c                         |  185 +-
 arch/arm/mach-at91/soc.h                           |    2 +
 arch/arm/mach-omap2/Kconfig                        |    1 +
 arch/arm/mach-omap2/Makefile                       |    3 +-
 arch/arm/mach-omap2/board-3430sdp.c                |    1 -
 arch/arm/mach-omap2/board-am3517crane.c            |    1 -
 arch/arm/mach-omap2/board-am3517evm.c              |    1 -
 arch/arm/mach-omap2/board-cm-t35.c                 |    2 -
 arch/arm/mach-omap2/board-cm-t3517.c               |    1 -
 arch/arm/mach-omap2/board-devkit8000.c             |    1 -
 arch/arm/mach-omap2/board-generic.c                |   14 -
 arch/arm/mach-omap2/board-ldp.c                    |    1 -
 arch/arm/mach-omap2/board-n8x0.c                   |   26 +-
 arch/arm/mach-omap2/board-omap3beagle.c            |    1 -
 arch/arm/mach-omap2/board-omap3logic.c             |    2 -
 arch/arm/mach-omap2/board-omap3pandora.c           |    1 -
 arch/arm/mach-omap2/board-omap3stalker.c           |    1 -
 arch/arm/mach-omap2/board-omap3touchbook.c         |    1 -
 arch/arm/mach-omap2/board-overo.c                  |    1 -
 arch/arm/mach-omap2/board-rx51.c                   |    1 -
 arch/arm/mach-omap2/common-board-devices.h         |    5 +
 arch/arm/mach-omap2/common.h                       |   23 +-
 arch/arm/mach-omap2/irq.c                          |  380 ----
 arch/arm/mach-omap2/pdata-quirks.c                 |    2 +
 drivers/Kconfig                                    |    2 +
 drivers/clk/at91/clk-system.c                      |    8 +-
 drivers/clocksource/Kconfig                        |    4 +
 drivers/clocksource/Makefile                       |    1 +
 drivers/clocksource/timer-atmel-pit.c              |  296 ++++
 drivers/edac/Kconfig                               |    9 +
 drivers/edac/Makefile                              |    2 +
 drivers/edac/altera_edac.c                         |  410 +++++
 drivers/irqchip/Kconfig                            |    5 +
 drivers/irqchip/Makefile                           |    1 +
 drivers/irqchip/irq-omap-intc.c                    |  403 +++++
 drivers/leds/Kconfig                               |   10 +
 drivers/leds/Makefile                              |    1 +
 drivers/leds/leds-syscon.c                         |  166 ++
 drivers/mailbox/omap-mailbox.c                     |  156 +-
 drivers/memory/Kconfig                             |   10 +
 drivers/memory/Makefile                            |    1 +
 drivers/memory/atmel-sdramc.c                      |   98 ++
 drivers/power/reset/Kconfig                        |   42 +-
 drivers/power/reset/Makefile                       |    3 +
 drivers/power/reset/arm-versatile-reboot.c         |  111 ++
 drivers/power/reset/at91-poweroff.c                |  156 ++
 drivers/power/reset/at91-reset.c                   |  252 +++
 drivers/rtc/Kconfig                                |    9 +-
 drivers/rtc/Makefile                               |    1 +
 drivers/rtc/rtc-sun6i.c                            |  447 +++++
 drivers/soc/Kconfig                                |    2 +
 drivers/soc/Makefile                               |    2 +
 drivers/soc/ti/Kconfig                             |   31 +
 drivers/soc/ti/Makefile                            |    5 +
 drivers/soc/ti/knav_dma.c                          |  815 +++++++++
 drivers/soc/ti/knav_qmss.h                         |  386 +++++
 drivers/soc/ti/knav_qmss_acc.c                     |  591 +++++++
 drivers/soc/ti/knav_qmss_queue.c                   | 1816 ++++++++++++++++++++
 drivers/soc/versatile/Kconfig                      |   10 +
 drivers/soc/versatile/Makefile                     |    1 +
 drivers/soc/versatile/soc-realview.c               |  144 ++
 include/linux/irqchip/irq-omap-intc.h              |   32 +
 include/linux/soc/ti/knav_dma.h                    |  175 ++
 include/linux/soc/ti/knav_qmss.h                   |   90 +
 107 files changed, 7605 insertions(+), 1298 deletions(-)

