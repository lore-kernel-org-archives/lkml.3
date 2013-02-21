Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab3BUVM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 16:12:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:50624 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab3BUVMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 16:12:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 00/09] arm-soc: changes for 3.9
Date: Thu, 21 Feb 2013 21:12:20 +0000
Message-Id: <1361481149-27559-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:aeOICkAPGFtZpXd8yxu9X+hIyGj+wzQ3SN6lsXUyH4n
 k/GD8wW2KIT4tYQRuGLxETNyVJ7IflDa7wTZern3XytwAyqhwf
 BzOu1XkBSJGd6ee1krpAX4AqhY6uEFz7AEW0cwbe54niwWyPk+
 OFoFKGDnhixdmHvX4fARbT/6fhIQmGpG5YLV0wLdH91Vj2XAVe
 sWt5Q6WpqTmkBFWeYX04uJHhW8h6/lsRAuuu+Jp7s1MdkAWCw2
 nIj53bFsBmF4Vd/514NTeqnYP8lzkef6KK2QEaWTv1TpYkvq26
 T66ALwOwIfwuVhx67q8/oDe9xwNZ9Q6tQbrVWObOHVvSY7V9+K
 8z37Q43N+GzRAe784GCWNVnGCtyredRofIpG8AhpR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is the usual arm-soc set of pull requests. There is a total
of 645 non-merge changesets, which this time is dominated by the
sh-mobile platform cleanups in size. In the effort to modernize
the way that ARM platform code is structured, sh-mobile has been
a little late to the game, but they are making up for that now.

Another topic that keeps both the patch count and the total
number of changed lines high is the work to remove platform
specific header files. This will keep going on for at least
one or two releases I fear, but we are already seeing the
fruits of it, and now have a total of 18 platforms that started
out separately and can now be built as 'multiplatform' together
with others.

We have reduced the number of separate branches for you a bit,
trying to make things easier for us, and getting fewer conflicts
between the arm-soc branches. These nine branches contain all
the important changes, but there are three more branches with
stuff that came late before the merge window. If everything
goes well, we will send pull requests for those next week,
or leave them for 3.10 if there are problems.

Olof has done almost all the merges again for this round,
since I was on parental leave for half the time, but I'm
sending out the pull requests now since he is currently at
ELC.

The merge conflicts I mention in the tags are all for conflicts
between the arm-soc branches. There are a few more conflicts
with other stuff you already pulled, but it all looks simple
as well. I have uploaded a 'for-linus' branch to the arm-soc
tree with the resolutions I used.

	Arnd

Dirstat:
   0.4% Documentation/devicetree/bindings/
   2.3% arch/arm/boot/dts/
   0.7% arch/arm/common/
   0.9% arch/arm/include/asm/
   0.3% arch/arm/include/
   0.4% arch/arm/kernel/
   4.5% arch/arm/kvm/
   0.3% arch/arm/mach-at91/
   2.6% arch/arm/mach-imx/
   0.7% arch/arm/mach-nomadik/
   3.0% arch/arm/mach-omap2/
   0.8% arch/arm/mach-prima2/
   0.4% arch/arm/mach-s3c2440/
   1.1% arch/arm/mach-s3c24xx/include/mach/
   4.7% arch/arm/mach-s3c24xx/
   0.5% arch/arm/mach-s3c64xx/
   0.3% arch/arm/mach-s5p64x0/
   8.9% arch/arm/mach-shmobile/
   5.8% arch/arm/mach-tegra/
   1.1% arch/arm/mach-u300/
   2.5% arch/arm/plat-s3c24xx/
   3.6% arch/arm/
   4.8% arch/sh/kernel/cpu/sh2a/
   1.0% arch/sh/kernel/cpu/sh3/
  11.1% arch/sh/kernel/cpu/sh4a/
   0.3% arch/
   4.1% drivers/clk/tegra/
   0.7% drivers/clocksource/
   1.2% drivers/dma/
   1.0% drivers/irqchip/
  26.3% drivers/pinctrl/sh-pfc/
   0.7% drivers/sh/pfc/
   0.6% drivers/
   0.5% include/linux/

Aaro Koskinen (1):
      ARM: OMAP1: nokia770: enable CBUS/Retu

Abhilash Kesavan (1):
      ARM: SAMSUNG: Gracefully exit on suspend failure

Alexander Shiyan (1):
      ARM: S3C24XX: Fix compile breakage for SMDK2410

Alexey Galakhov (1):
      ARM: S5PV210: Fix early uart output in fifo mode

Andrea Adami (1):
      ARM: pxa: pxa27x.c: add dummy SA1100 rtc clock

Andrew Lunn (2):
      ARM: Kirkwood: Cleanup unneeded include files
      cpuidle: kirkwood: Move out of mach directory

André Hentschel (1):
      ARM: OMAP2+: Include soc.h to drm.c to fix compiling

AnilKumar Ch (1):
      ARM: OMAP2+: AM33XX: omap2plus_defconfig: Add support for few drivers

Arnd Bergmann (31):
      mfd/vexpress: vexpress_sysreg_setup must not be __init
      ARM: msm: proc_comm_boot_wait should not be __init
      ARM: prima2: fix __init section for cpu hotplug
      ARM: kirkwood: add missing include for nsa310
      ARM: disable virt_to_bus/virt_to_bus almost everywhere
      ARM: samsung: fix assembly syntax for new gas
      ARM: w90x900: fix legacy assembly syntax
      ARM: shmobile: fix defconfig warning on CONFIG_USB
      ARM: sa1100: don't warn about mach/ide.h
      ARM: integrator/versatile: fix NOMMU warnings
      ARM: integrator: fix build with INTEGRATOR_AP off
      ARM: pick Versatile by default for !MMU
      ARM: mvebu: allow selecting mvebu without Armada XP
      ARM: s3c: i2c: add platform_device forward declaration
      scripts/sortextable: silence script output
      Merge branch 'warning-fixes' into next/fixes-non-critical
      [media] davinci: do not include mach/hardware.h
      remoteproc: omap: depend on OMAP_MBOX_FWK
      net: cwdavinci_cpdma: export symbols for cpsw
      Merge branch 'omap/multiplatform-fixes', tag 'v3.8-rc5' into next/multiplatform
      ARM: arch_timer: include linux/errno.h
      ARM: imx: MACH_MX31ADS_WM1133_EV1 needs REGULATOR_WM8350
      Merge tag 'renesas-pinmux2-for-v3.9' of git://git.kernel.org/.../horms/renesas into next/sh-pinmux
      Merge tag 'renesas-soc5-for-v3.9' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'cleanup_for_v3.9_round3' of git://git.infradead.org/users/jcooper/linux into next/cleanup
      Merge tag 'omap-for-v3.9/usb-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/soc
      Revert "sunxi: a13-olinuxino: Add user LED to the device tree"
      Revert "sunxi: a10-cubieboard: Add user LEDs to the device tree"
      Merge tag 'tegra-for-3.9-soc-ccf-fixes' of git://git.kernel.org/.../swarren/linux-tegra into next/dt
      Merge tag 'arm-imx-clk-fixes' of git://git.pengutronix.de/git/imx/linux-2.6 into next/fixes-non-critical
      ARM: prima2: remove duplicate v7_invalidate_l1

Barry Song (10):
      ARM: PRIMA2: add CSR SiRFmarco device tree .dts
      ARM: PRIMA2: enable AUTO_ZRELADDR for SIRF in Kconfig
      ARM: PRIMA2: initialize l2x0 according to mach from DT
      ARM: PRIMA2: mv timer to timer-prima2 as we will add timer-marco
      ARM: PRIMA2: rstc: enable the support for Marco
      ARM: PRIMA2: rtciobg: it is also compatible with marco
      ARM: PRIMA2: irq: make prima2 irq can work even we enable GIC for Marco
      ARM: PRIMA2: add new SiRFmarco SMP SoC infrastructures
      ARM: PRIMA2: provide two DEBUG_LL ports for prima2 and marco
      ARM: MARCO: fix the build issue due to gic-vic-to-irqchip move

Bastian Hecht (4):
      ARM: shmobile: sh73a0: Add CPU sleep suspend
      ARM: shmobile: r8a7740: Add CPU sleep suspend
      ARM: SH-Mobile: sh73a0: Secondary CPUs handle own SCU flags
      ARM: SH-Mobile: sh73a0: Add CPU Hotplug

Bryan Wu (3):
      ARM: DT: tegra: Unify the description of Tegra20 boards
      ARM: DT: tegra: Add board level compatible properties
      ARM: DT: tegra: Add Tegra30 Beaver board support

Catalin Marinas (1):
      arm: Move sp810.h to include/linux/amba/

Chen Gang (3):
      ARM: SAMSUNG: using vsnprintf instead of vsprintf for the limit buffer length 256
      ARM: OMAP: Fix the use of uninitialized dma_lch_count
      ARM: OMAP2+: using strlcpy instead of strncpy

Christoffer Dall (16):
      ARM: Add page table and page defines needed by KVM
      ARM: Section based HYP idmap
      KVM: ARM: Initial skeleton to compile KVM support
      KVM: ARM: Hypervisor initialization
      KVM: ARM: Memory virtualization setup
      KVM: ARM: Inject IRQs and FIQs from userspace
      KVM: ARM: World-switch implementation
      KVM: ARM: Emulation framework and CP15 emulation
      KVM: ARM: User space API for getting/setting co-proc registers
      KVM: ARM: Demux CCSIDR in the userspace API
      KVM: ARM: Handle guest faults in KVM
      KVM: ARM: Handle I/O aborts
      KVM: ARM: Add maintainer entry for KVM/ARM
      ARM: gic: add missing distributor defintions
      KVM: ARM: Introduce KVM_ARM_SET_DEVICE_ADDR ioctl
      ARM: KVM: VGIC accept vcpu and dist base addresses from user space

Cong Ding (1):
      ARM: S3C24XX: fix uninitialized variable warning

Daniel Mack (5):
      ARM: OMAP: gpmc: don't create devices from initcall on DT
      mtd: omap-nand: pass device_node in platform data
      ARM: OMAP: gpmc-nand: drop __init annotation
      ARM: OMAP: gpmc: enable hwecc for AM33xx SoCs
      ARM: OMAP: gpmc: add DT bindings for GPMC timings and NAND

Dinh Nguyen (4):
      arm: socfpga: Add new device tree source for actual socfpga HW
      arm: socfpga: Add entries to enable make dtbs socfpga
      arm: Add v7_invalidate_l1 to cache-v7.S
      arm: socfpga: Add SMP support for actual socfpga harware

Dom Cobley (1):
      ARM: bcm2835: add a pm_power_off implementation

Douglas Gilbert (1):
      ARM: at91/at91sam9x5.dtsi: fix usart3 TXD

Emilio López (1):
      sunxi: a10-cubieboard: Add user LEDs to the device tree

Ezequiel Garcia (4):
      ARM: OMAP2+: gpmc: Remove unneeded of_node_put()
      mtd: omap-onenand: pass device_node in platform data
      ARM: OMAP2+: gpmc-onenand: drop __init annotation
      ARM: OMAP2+: gpmc: add DT bindings for OneNAND

Fabio Baltieri (2):
      clocksource: nomadik-mtu: support timer-based delay
      cpufreq: db8500: set CPUFREQ_CONST_LOOPS

Fabio Estevam (10):
      ARM: mach-imx: Kconfig: Do not select Babbage for MACH_IMX51_DT
      ARM: Let CONFIG_MACH_IMX31_DT be built by default
      ARM: clk-imx31: Add dummy clock
      ARM: mx31: Replace clk_register_clkdev with clock DT lookup
      ARM: clk-imx35: Fix build warnings with W=1
      ARM: imx: Remove mach-mx51_3ds board
      ARM: imx: Remove mx508 support
      ARM: imx_v6_v7_defconfig: Select IPUV3 driver
      ARM: mxs_defconfig: Select CONFIG_DEVTMPFS_MOUNT
      ARM: imx_v4_v5_defconfig: Add VPU support

Frank Li (1):
      ARM: dts: imx6: fix fec ptp clock slow 10 time

Gerlando Falauto (1):
      arm: plat-orion: fix printing of "MPP config unavailable on this hardware"

Giridhar Maruthy (1):
      ARM: dts: fix tick and alarm irq numbers for exynos5440

Gregory CLEMENT (2):
      arm: mvebu: i2c come back in defconfig
      rtc: Add support of rtc-mv for MVEBU SoCs

Guennadi Liakhovetski (4):
      ARM: mackerel: include the correct .dtsi file
      ARM: sh7372: add clock lookup entries for DT-based devices
      ARM: sh7372: fix cache clean / invalidate order
      ARM: shmobile: add function declarations for sh7372 DT helper functions

Gwenhael Goavec-Merou (2):
      ARM: imx27: add a clock gate to activate SPLL clock
      ARM: imx27: clk-imx27: SPI: Rename IPG clock and add PER clock

Heiko Stuebner (11):
      ARM: S3C24XX: transform irq handling into a declarative form
      ARM: S3C24XX: Move irq syscore-ops to irq-pm
      ARM: S3C24XX: Modify s3c_irq_wake to use the hwirq property
      ARM: S3C24XX: move s3c2416 irq init to common irq code
      ARM: S3C24XX: modify s3c2416 irq init to initialize all irqs
      ARM: S3C24XX: transform s3c2416 irqs into new structure
      ARM: S3C24XX: move s3c2443 irq code to irq.c
      ARM: S3C24XX: modify s3c2443 irq init to initialize all irqs
      ARM: S3C24XX: transform s3c2443 subirqs into new structure
      ARM: S3C24XX: let S3C2412_PM select S3C2412_PM_SLEEP
      ARM: S3C24XX: add missing platform_device.h include for osiris

Hideki EIRAKU (1):
      ARM: shmobile: armadillo800eva: set clock rates before timer init

Hiroshi Doyu (17):
      clocksource: tegra: cosmetic: Fix error message
      ARM: tegra: Make variables static
      ARM: tegra: Add CPU nodes to Tegra20 device tree
      ARM: tegra: Add CPU nodes to Tegra30 device tree
      ARM: tegra: Use DT /cpu node to detect number of CPU core
      ARM: Add API to detect SCU base address from CP15
      ARM: tegra: Skip scu_enable(scu_base) if not Cortex A9
      ARM: tegra: fuse: Add chip ID Tegra114 0x35
      ARM: dt: tegra114: Add new SoC base, Tegra114 SoC
      ARM: dt: tegra114: Add new board, Dalmore
      ARM: dt: tegra114: Add new board, Pluto
      ARM: tegra: Add initial support for Tegra114 SoC.
      ARM: tegra: add AHB entry to Tegra114 DT
      ARM: dt: tegra20: Rename "gart" to "iommu"
      ARM: dt: tegra30: Rename "smmu" to "iommu"
      ARM: tegra: Add SMMU entry to Tegra114 DT
      ARM: tegra: Fix build error for gic update

Igor Grinberg (2):
      ARM: PXA3xx: program the CSMSADRCFG register
      ARM: OMAP3: cm-t3517: add MMC support

Jason Cooper (4):
      ARM: kirkwood: nsa310: cleanup includes and unneeded code
      Merge tag 'tags/mvebu_fixes_for_v3.8-rc6' into mvebu/drivers
      ARM: kirkwood: nsa310: cleanup includes and unneeded code
      ARM: mvebu: correct gated clock documentation

Jason Gunthorpe (1):
      ARM: Kirkwood: Support basic hotplug for PCI-E

Javier Martinez Canillas (4):
      ARM: OMAP3: igep0020: simplify GPIO LEDs dependencies
      ARM: OMAP2+: omap2plus_defconfig: enable TFP410 chip support
      ARM: OMAP2+: omap2plus_defconfig: enable CMA allocator
      ARM: imx: configs: enable netfilter support

Jean Pihet (1):
      ARM: OMAP2+: powerdomain: fix powerdomain trace integration

Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: Animeo IP: enable watchdog support

Jean-Francois Moine (1):
      Dove: activate GPIO interrupts in DT

Joachim Eastwood (4):
      ARM: at91: fix board-rm9200-dt after sys_timer conversion
      ARM: at91: add MMC bindings to RM9200 DT
      ARM: at91: add SSC bindings to RM9200 DT
      ARM: at91: add EMAC bindings to RM9200 DT

Jon Hunter (2):
      ARM: OMAP2+: Prevent potential crash if GPMC probe fails
      ARM: OMAP2+: Fix selection of clockevent timer when using device-tree

Jonas Aaberg (1):
      cpufreq: dbx500: Minor code cleanup

Joseph Lo (14):
      ARM: tegra30: fix power up sequence for boot_secondary
      ARM: tegra: update the cache maintenance order for CPU shutdown
      ARM: tegra: moving the clock gating procedure to tegra_cpu_kill
      ARM: tegra: clean up the CPUINIT section
      ARM: tegra: make device can run on UP
      ARM: tegra30: make the wait time of CPU power up to proportional to HZ
      ARM: tegra: fix compile error when disable CPU_IDLE
      ARM: tegra: add pending SGI checking API
      ARM: tegra20: cpuidle: add powered-down state for secondary CPU
      clk: tegra20: Implementing CPU low-power function for tegra_cpu_car_ops
      ARM: tegra20: flowctrl: add support for cpu_suspend_enter/exit
      ARM: tegra20: cpuidle: apply coupled cpuidle for powered-down mode
      ARM: tegra: add Tegra114 ARM_CPUIDLE_WFI_STATE support
      clk: tegra: fix wrong clock index between se to sata_cold

Josh Cartwright (2):
      ARM: multi_v7_defconfig: remove unnecessary CONFIG_GPIOLIB
      ARM: multi_v7_defconfig: add ARCH_ZYNQ

Josh Wu (2):
      ARM: at91: at91sam9x5: add DT parameters to enable PMECC
      ARM: at91: at91sam9n12: add DT parameters to enable PMECC

Kim Milo (2):
      ARM: OMAP2+: craneboard: support NAND device
      ARM: OMAP2+: craneboard: support the TPS65910 PMU

Kukjin Kim (36):
      cpufreq: exynos: cleanup exynos-cpufreq header
      ARM: S5P64X0: remove gpiolib.c file in mach-s5p64x0
      ARM: S5P64X0: move i2c.h into local directory
      ARM: S5P64X0: move s5p64x0-clock.h into local directory
      ARM: S5PV210: move regs-sys.h into setup-usb-phy.c file
      ARM: EXYNOS: move mach/pmu.h file into common.h
      ARM: SAMSUNG: cleanup mach/regs-audss.h file
      ARM: SAMSUNG: cleanup mach/gpio-fns.h gpio-track.h and gpio-nrs.h
      ARM: S3C24XX: make anubis-cpld, anubis-irq and anubis-map local
      ARM: S3C24XX: make bast-cpld.h, bast-irq.h and bast-map.h local
      ARM: S3C24XX: make gta02.h local
      ARM: S3C24XX: make h1940.h and h1940-latch.h local
      ARM: S3C24XX: make osiris-cpld.h and osiris-map.h local
      ARM: S3C24XX: make otom-map.h local
      ARM: S3C24XX: make vr1000-cpld.h, vr1000-irq.h and vr1000-map.h local
      ARM: S3C2416: remove regs-s3c2416-mem.h and regs-s3c2416.h
      ARM: S3C2412: cleanup regs-s3c2412.h
      ARM: S3C24XX: remove idle.h
      ARM: S3C24XX: remove dsc.c and make regs-dsc.h local
      ARM: S3C64XX: make crag6410.h local
      ARM: S3C64XX: make regs-gpio-memport.h local
      ARM: S3C64XX: make regs-modem.h local
      ARM: S3C64XX: make regs-srom.h local
      ARM: S3C64XX: make regs-sys.h local
      ARM: S3C64XX: make regs-syscon-power.h local
      ARM: S3C24XX: Move mach-s3c2410/ cpufreq into mach-s3c24xx/
      ARM: S3C24XX: Move mach-s3c2410/ pll into mach-s3c24xx/
      ARM: S3C2412: Remove useless codes mach-s3c2412/gpio.c
      ARM: S3C24XX: Move mach-s3c2412/ cpufreq driver into mach-s3c24xx/
      ARM: S3C24XX: Move mach-s3c2440/ cpufreq driver into mach-s3c24xx/
      ARM: S3C24XX: Move mach-s3c2440/ pll into mach-s3c24xx/
      ARM: dts: fix compatible value for exynos pinctrl
      ARM: S3C24XX: Remove plat-s3c24xx directory in arch/arm/
      ARM: S3C24XX: header mach/regs-s3c2412-mem.h local
      ARM: S3C24XX: header mach/regs-power.h local
      ARM: S3C24XX: header mach/regs-mem.h local

Kumar, Anil (5):
      ARM: davinci: da850: add pinctrl driver DT entries
      ARM: davinci: da850: add NAND driver DT entries
      ARM: davinci: da8xx defconfig: enable pinctrl config option
      ARM: davinci: da850: add wdt DT node
      ARM: davinci: da850 DT: add support for machine reboot

Kuninori Morimoto (6):
      ARM: shmobile: fix sample amixer settings for mackerel
      ARM: shmobile: add sample amixer settings for ap4evb
      ARM: shmobile: add sample amixer settings for armadillo800eva
      ARM: shmobile: r8a7740: add TMU timer support
      ARM: shmobile: sh73a0: fixup div4_clks bitmap
      ARM: shmobile: r8a7779: scif .irqs used SCIx_IRQ_MUXED()

Kyungmin Park (1):
      ARM: OMAP2+: Remove apollon board support

Lad, Prabhakar (1):
      ARM: davinci: da850: move interrupt-parent property to soc node

Laurent Pinchart (90):
      sh: sh7264: Rename CRX0CRX1 mark to match GPIO names
      sh: sh7269: Rename CRX0CRX1(CRX2) marks to match GPIO names
      sh: sh7723: Rename GPIO_FN_SIUOSPD to GPIO_FN_SIUAOSPD
      sh: sh7757: Fix GPIO_FN_ET0_MDIO and GPIO_FN_ET1_MDIO GPIO entries
      sh: sh7786: Fix port E, G and J GPIOs
      sh: sh7786: Fix last GPIO index
      sh: shx3: Fix last GPIO index
      sh-pfc: Split platform data from the sh_pfc structure
      sh-pfc: Move private definitions and declarations to private header
      sh-pfc: Merge PFC core and pinctrl
      sh-pfc: Merge PFC core and gpio
      sh-pfc: Move platform device and driver to the core
      sh-pfc: Use devm_kzalloc()
      sh-pfc: Use devm_ioremap_nocache()
      sh-pfc: Let the compiler decide whether to inline functions
      sh-pfc: Remove check for impossible error condition
      sh-pfc: Sort headers alphabetically
      sh-pfc: Use sh_pfc_ namespace prefix through the whole driver
      sh-pfc: Split platform device and platform driver registration
      sh-pfc: Support passing resources through platform device
      ARM: shmobile: Select PINCTRL
      ARM: shmobile: r8a7740: Register PFC platform device
      ARM: shmobile: r8a7779: Register PFC platform device
      ARM: shmobile: sh7372: Register PFC platform device
      ARM: shmobile: sh73a0: Register PFC platform device
      ARM: shmobile: r8a7740: Add pin control resources
      ARM: shmobile: sh7372: Add pin control resources
      ARM: shmobile: sh73a0: Add pin control resources
      sh: Add PFC platform device registration helper function
      sh: sh7203: Register PFC platform device
      sh: sh7264: Register PFC platform device
      sh: sh7269: Register PFC platform device
      sh: sh7720: Register PFC platform device
      sh: sh7722: Register PFC platform device
      sh: sh7723: Register PFC platform device
      sh: sh7724: Register PFC platform device
      sh: sh7734: Register PFC platform device
      sh: sh7757: Register PFC platform device
      sh: sh7785: Register PFC platform device
      sh: sh7786: Register PFC platform device
      sh: shx3: Register PFC platform device
      sh-pfc: Remove platform device registration
      sh-pfc: Remove unused resource and num_resources platform data fields
      sh-pfc: Move driver from drivers/sh/ to drivers/pinctrl/
      sh-pfc: Support pinmux info in driver data instead of platform data
      sh-pfc: Add r8a7740 pinmux support
      sh-pfc: Add r8a7779 pinmux support
      sh-pfc: Add sh7372 pinmux support
      sh-pfc: Add sh73a0 pinmux support
      sh-pfc: Add sh7203 pinmux support
      sh-pfc: Add sh7264 pinmux support
      sh-pfc: Add sh7269 pinmux support
      sh-pfc: Add sh7720 pinmux support
      sh-pfc: Add sh7722 pinmux support
      sh-pfc: Add sh7723 pinmux support
      sh-pfc: Add sh7724 pinmux support
      sh-pfc: Add sh7734 pinmux support
      sh-pfc: Add sh7757 pinmux support
      sh-pfc: Add sh7785 pinmux support
      sh-pfc: Add sh7786 pinmux support
      sh-pfc: Add shx3 pinmux support
      ARM: shmobile: r8a7740: Use driver-provided pinmux info
      ARM: shmobile: r8a7779: Use driver-provided pinmux info
      ARM: shmobile: sh7372: Use driver-provided pinmux info
      ARM: shmobile: sh73a0: Use driver-provided pinmux info
      sh: sh7203: pinmux: Use driver-provided pinmux info
      sh: sh7264: pinmux: Use driver-provided pinmux info
      sh: sh7269: pinmux: Use driver-provided pinmux info
      sh: sh7720: pinmux: Use driver-provided pinmux info
      sh: sh7722: pinmux: Use driver-provided pinmux info
      sh: sh7723: pinmux: Use driver-provided pinmux info
      sh: sh7724: pinmux: Use driver-provided pinmux info
      sh: sh7734: pinmux: Use driver-provided pinmux info
      sh: sh7757: pinmux: Use driver-provided pinmux info
      sh: sh7785: pinmux: Use driver-provided pinmux info
      sh: sh7786: pinmux: Use driver-provided pinmux info
      sh: shx3: pinmux: Use driver-provided pinmux info
      sh: Remove unused sh_pfc_register_info() function
      sh-pfc: Remove pinmux_info definition
      sh-pfc: Move sh_pfc.h from include/linux/ to driver directory
      ARM: shmobile: kzm9g: Use of_machine_is_compatible()
      ARM: shmobile: Include sh73a0 DTSI in kzm9g
      ARM: shmobile: ag5evm: Use gpio_request_one()
      ARM: shmobile: ap4evb: Use gpio_request_one()
      ARM: shmobile: armadillo800eva: Use gpio_request_one()
      ARM: shmobile: armadillo800eva: Use gpio_set_value() to set GPIO value
      ARM: shmobile: kota2: Use gpio_request_one()
      ARM: shmobile: bonito: Use gpio_request_one()
      ARM: shmobile: kzm9g: Use gpio_request_one()
      ARM: shmobile: mackerel: Use gpio_request_one()

Laxman Dewangan (12):
      ARM: tegra: defconfig updates
      ARM: tegra30: tegra30 gpio is not compatible with tegra20 gpio
      ARM: tegra: dts: add aliases and DMA requestor for serial controller
      ARM: tegra: add DT entry for KBC controller
      ARM: tegra: seaboard: enable keyboard in DT
      ARM: tegra: cardhu: register UARTC
      ARM: tegra: whistler: enable keyboard in DT
      ARM: tegra: harmony: enable keyboard in DT
      ARM: tegra114: select PINCTRL for Tegra114 SoC
      ARM: DT: tegra114: add GPIO DT entry
      ARM: DT: tegra114: add pinmux DT entry
      clk: tegra: initialise parent of uart clocks

Lee Jones (5):
      cpufreq: Give driver used for dbx500 family a more generic name
      mfd: db8500: Update cpufreq device name
      cpufreq: dbx500: Update file header
      ARM: ux500: Disable Power Supply and Battery Management by default
      ARM: ux500: Fix u9540 booting issues

Linus Walleij (24):
      dma: coh901318: create a proper platform data file
      dma: coh901318: push platform data into driver
      dma: coh901318: remove hardcoded target addresses
      dma: coh901318: skip hard-coded addresses
      dma: coh901318: push header down into the DMA subsystem
      dma: coh901318: push definitions into driver
      dma: coh901318: merge header files
      dma: coh901318: cut down on platform data abstraction
      ARM: nomadik: move last custom calls to pinctrl
      ARM: nomadik: initial devicetree support
      ARM: nomadik: move pin maps to cpu file
      ARM: nomadik: move remaining PrimeCells to device tree
      ARM: nomadik: add FSMC NAND
      ARM: nomadik: move GPIO and pinctrl to device tree
      ARM: nomadik: convert SMSC91x ethernet to device tree
      ARM: nomadik: migrate MMC/SD card support to device tree
      ARM: nomadik: add I2C devices to the device tree
      ARM: nomadik: delete old board files
      ARM: nomadik: get rid of <mach/hardware.h>
      mfd: prcmu: delete pin control helpers
      ARM: ux500: de-globalize <mach/id.h>
      ARM: nomadik: fix OF compilation regression
      drivers/db8500-cpufreq: delete dangling include
      mfd: db8500-prcmu: update resource passing

Lucas Stach (4):
      ASoC: tegra: add ac97 host controller to device tree
      ARM: tegra: move serial clock-frequency attr into the Tegra20 dtsi
      ARM: tegra: Add Colibri T20 512MB COM device tree
      ARM: tegra: Add Toradex Iris carrier board DT with T20 512MB COM

Magnus Damm (3):
      ARM: mach-shmobile: sh73a0 external IRQ wake update
      ARM: shmobile: Register ARM architected timer
      sh-pfc: sh_pfc_probe() sizeof() fix

Marc Zyngier (19):
      KVM: ARM: Power State Coordination Interface implementation
      Merge remote-tracking branch 'arm-soc/irqchip/gic-vic-move' into kvm-arm/vgic
      ARM: arch_timers: switch to physical timers if HYP mode is available
      ARM: Dummy Virtual Machine platform support
      ARM: gic: define GICH offsets for VGIC support
      ARM: gic: add __ASSEMBLY__ guard to C definitions
      ARM: KVM: Keep track of currently running vcpus
      ARM: KVM: Initial VGIC infrastructure code
      ARM: KVM: VGIC distributor handling
      ARM: KVM: VGIC virtual CPU interface management
      ARM: KVM: vgic: retire queued, disabled interrupts
      ARM: KVM: VGIC interrupt injection
      ARM: KVM: VGIC control interface world switch
      ARM: KVM: VGIC initialisation code
      ARM: KVM: Add VGIC configuration option
      Merge branch 'for-arm-soc/arch-timers' of git://git.kernel.org/.../will/linux into kvm-arm/timer
      ARM: KVM: arch_timers: Add guest timer core support
      ARM: KVM: arch_timers: Add timer world switch
      ARM: KVM: arch_timers: Wire the init code and config option

Marek Vasut (2):
      ARM: mxs: Enable touchscreen on m28evk
      ARM: mxs: Update mxs_defconfig

Mark Jackson (1):
      ARM: OMAP2+: omap2plus_defconfig: enable omap1 rtc

Mark Rutland (18):
      ARM: vexpress: Fix wdt interrupt in ca15{-tc1,_a7} dts
      arm: arch_timer: balance device_node refcounting
      arm: arch_timer: remove redundant available check
      arm: arch_timer: use u64/u32 for register data
      arm: arch_timer: standardise counter reading
      arm: arch_timer: split cntfrq accessor
      arm: arch_timer: factor out register accessors
      arm: arch_timer: add isbs to register accessors
      arm: arch_timer: divorce from local_timer api
      arm: arch_timer: add arch_counter_set_user_access
      arm: arch_timer: move core to drivers/clocksource
      arm64: arm_generic: prevent reading stale time
      arm64: move from arm_generic to arm_arch_timer
      Documentation: Add ARMv8 to arch_timer devicetree
      clockevents: Add generic timer broadcast receiver
      clockevents: Add generic timer broadcast function
      arm: Use generic timer broadcast receiver
      arm: Add generic timer broadcast support

Marko Katic (1):
      ARM: pxa: Minor naming fixes in spitz.c

Maxime Coquelin (1):
      ARM: ux500: Introduce cpu_is_u8580()

Maxime Ripard (10):
      ARM: dts: cfa10049: Add PCA9555 GPIO expander to the device tree
      ARM: sunxi: Add device tree for Miniand Hackberry
      ARM: mxs: dt: Add Crystalfontz CFA-10037 device tree support
      ARM: dts: cfa10049: Change the SPI3 bus to spi-gpio
      ARM: dts: mxs: Add muxing options for the third PWM
      ARM: dts: mxs: Add the LCD to the 10049 board
      ARM: mxs: dts: Add gpio-keys for the rotary to the CFA-10049
      ARM: mxs: dts: Add rotary encoder to the CFA-10049
      sunxi: Cleanup the reset code and add meaningful registers defines
      sunxi: a13-olinuxino: Add user LED to the device tree

Michal Simek (3):
      arm: zynq: Add missing irqchip.h to common.c
      arm: zynq: Add missing irqchip.h to common.c
      MAINTAINERS: Add ARM/Zynq architecture entry

Mike Dunn (4):
      ARM: palmtreo: add docg4 device initialization
      ARM: palmtreo: replace #if defined with IF_ENABLED
      ARM: palmtreo: fix lcd initilialization on treo680
      ARM: palmtreo: fix #ifdefs for leds-gpio device

Mrugesh Katepallewar (1):
      ARM: davinci: da850: add RTC DT entries

Nicolas Ferre (2):
      ARM: at91/DT: remove atmel,use-dma-* from 9x5 and 9n12 USART nodes
      ARM: at91: remove NEOCORE 926 board

Nobuhiro Iwamatsu (1):
      ARM: shmobile: Include DTSI of r8a7740 to armadillo800eva

Olof Johansson (104):
      Merge tag 'swarren-for-3.9-arm-timer-rework' of git://git.kernel.org/.../swarren/linux-tegra into next/cleanup
      Merge branch 'timer/cleanup' into next/cleanup
      Merge tag 'ux500-cpufreq-for-arm-soc' of git://git.kernel.org/.../linusw/linux-stericsson into next/drivers
      Merge tag 'omap-for-v3.9/multiplatform-enable-signed-v2' of git://git.kernel.org/.../tmlind/linux-omap into next/multiplatform
      Merge tag 'vt8500-multiplatform-3.9' of git://server.prisktech.co.nz/git/linuxwmt into next/multiplatform
      Merge tag 'armsoc-3.9' of git://server.prisktech.co.nz/git/linuxwmt into next/soc
      Merge branch 'timer/cleanup' into next/cleanup
      Merge branch 'clocksource/cleanup' into next/cleanup
      Merge tag 'vt8500/timer' of git://server.prisktech.co.nz/git/linuxwmt into next/cleanup
      Merge tag 'gic-vic-to-irqchip' of git://sources.calxeda.com/kernel/linux into next/cleanup
      Merge branch 'vt8500/timer' into next/cleanup
      Merge branch 'vt8500/wm8x50' into next/soc
      Merge branch 'defconfig' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'cleanup_for_v3.9' of git://git.infradead.org/users/jcooper/linux into next/cleanup
      Merge tag 'v3.8-rc5' into next/cleanup
      Merge branch 'armsoc/fix' of git://github.com/hzhuang1/linux into next/cleanup
      Merge branch 'armsoc/fix' of git://github.com/hzhuang1/linux into next/fixes-non-critical
      Merge branch 'armsoc/board' of git://github.com/hzhuang1/linux into next/boards
      Merge branch 'depends/cleanup' into next/soc
      Merge branch 'marco-timer-cleanup-rebase' of git://gitorious.org/sirfprima2-kernel/sirfprima2-kernel into next/soc
      Merge tag 'imx-soc' of git://git.pengutronix.de/git/imx/linux-2.6 into next/soc
      Merge branch 'depends/cleanup' into next/drivers
      Merge tag 'coh901318-for-arm-soc' of http://git.kernel.org/.../linusw/linux-stericsson into next/drivers
      Merge tag 'ux500-fixes-for-v3.8' of http://git.kernel.org/.../linusw/linux-stericsson into fixes
      Merge branch 'pfc' of git://git.kernel.org/.../horms/renesas into next/sh-pinmux
      Merge branch 'defconfig2' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge branch 'boards' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge branch 'soc' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'davinci-for-v3.9/soc' of git://gitorious.org/linux-davinci/linux-davinci into next/soc
      Merge tag 'davinci-for-v3.9/board' of git://gitorious.org/linux-davinci/linux-davinci into next/boards
      Merge tag 'davinci-for-v3.9/dt' of git://gitorious.org/linux-davinci/linux-davinci into next/dt
      Merge branch 'depends/cleanup' into next/dt
      Merge tag 'nmk-dt-on-cleanups' of git://git.kernel.org/.../linusw/linux-nomadik into next/dt
      Merge tag 'imx-cleanup-3.9' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/cleanup
      Merge tag 'bcm2835-for-3.9-soc' of git://git.kernel.org/.../swarren/linux-rpi into next/soc
      Merge tag 'bcm2835-for-3.9-cleanup' of git://git.kernel.org/.../swarren/linux-rpi into next/cleanup
      Merge tag 'bcm2835-for-3.9-dt' of git://git.kernel.org/.../swarren/linux-rpi into next/dt
      Merge tag 'bcm2835-for-3.9-defconfig' of git://git.kernel.org/.../swarren/linux-rpi into next/boards
      Merge branch 'v3.8-samsung-fixes-4' of git://git.kernel.org/.../kgene/linux-samsung into fixes
      Merge tag 'mvebu_fixes_for_v3.8-rc6' of git://git.infradead.org/users/jcooper/linux into fixes
      Merge tag 'cleanup_for_v3.9_round2' of git://git.infradead.org/users/jcooper/linux into next/cleanup
      Merge tag 'vexpress/fixes-for-3.9' of git://git.linaro.org/people/pawelmoll/linux into next/fixes-non-critical
      Merge tag 'ux500-no-idh' of git://git.kernel.org/.../linusw/linux-stericsson into next/cleanup
      Merge branch 'zynq/timer' of git://git.xilinx.com/linux-xlnx into next/cleanup
      Merge tag 'at91-fixes' of git://github.com/at91linux/linux-at91 into fixes
      Merge tag 'vexpress/drivers-for-3.9' of git://git.linaro.org/people/pawelmoll/linux into next/drivers
      Merge tag 'renesas-boards2-for-v3.9' of git://git.kernel.org/.../horms/renesas into next/boards
      Merge tag 'renesas-soc2-for-v3.9' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge branch 'next/cleanup-header' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge tag 'imx6q-cpudile-3.9' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/soc
      Merge tag 'cleanup_for_v3.9_round2' of git://git.infradead.org/users/jcooper/linux into next/cleanup
      Merge tag 'v3.8-rc6' into next/soc
      Merge tag 'drivers_for_v3.9' of git://git.infradead.org/users/jcooper/linux into next/soc
      Merge tag 'v3.8-rc6' into next/dt
      Merge tag 'cleanup-decompwdog-3.9' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/cleanup
      Merge tag 'highbank-fixes-for-3.8' of git://sources.calxeda.com/kernel/linux into fixes
      Merge tag 'imx-fixes-3.8-4' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes
      Merge tag 'renesas-soc3-for-v3.9' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'tegra-for-3.9-cleanup' of git://git.kernel.org/.../swarren/linux-tegra into next/cleanup
      Merge tag 'tegra-for-3.9-soc-ccf' of git://git.kernel.org/.../swarren/linux-tegra into next/soc
      Merge tag 'tegra-for-3.9-soc-usb' of git://git.kernel.org/.../swarren/linux-tegra into next/soc
      Merge tag 'tegra-for-3.9-soc-cpuidle' of git://git.kernel.org/.../swarren/linux-tegra into next/soc
      Merge tag 'tegra-for-3.9-soc-t114' of git://git.kernel.org/.../swarren/linux-tegra into next/soc
      ARM: tegra: remove empty tegra_smp_init_cpus()
      Merge branch 'next/soc' into next/dt
      Merge tag 'tegra-for-3.9-dt' of git://git.kernel.org/.../swarren/linux-tegra into next/dt
      Merge tag 'tegra-for-3.9-defconfig' of git://git.kernel.org/.../swarren/linux-tegra into next/boards
      Merge tag 'omap-for-v3.9/fixes-non-critical-signed-v2' of git://git.kernel.org/.../tmlind/linux-omap into next/fixes-non-critical
      Merge tag 'omap-for-v3.9/gpmc-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/drivers
      Merge tag 'omap-for-v3.9/pm-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/soc
      Merge tag 'omap-for-v3.9/board-signed' of git://git.kernel.org/.../tmlind/linux-omap into next/boards
      Merge tag 'imx-soc-3.9' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/soc
      Merge branch 'next/cleanup-s3c24xx' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge branch 'next/irq-s3c24xx' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge branch 'next/cleanup-s3c24xx-2' of git://git.kernel.org/.../kgene/linux-samsung into next/cleanup
      Merge tag 'v3.8-rc6' into next/cleanup
      Merge tag 'at91-cleanup' of git://github.com/at91linux/linux-at91 into next/cleanup
      Merge tag 'renesas-soc4-for-v3.9' of git://git.kernel.org/.../horms/renesas into next/soc
      Merge tag 'omap-for-v3.9/twl-signed-v2' of git://git.kernel.org/.../tmlind/linux-omap into next/boards
      Merge tag 'at91-dt' of git://github.com/at91linux/linux-at91 into next/dt
      Merge tag 'davinci-for-v3.9/dt-2' of git://gitorious.org/linux-davinci/linux-davinci into next/dt
      ARM: tegra: Fix build error w/ ARCH_TEGRA_114_SOC w/o ARCH_TEGRA_3x_SOC
      Merge branch 'tegra/t114' into next/soc
      Merge tag 'mxs-soc-3.9' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/soc
      Merge tag 'mxs-dt-3.9' of git://git.linaro.org/people/shawnguo/linux-2.6 into next/dt
      Merge branch 'for-rmk/perf' of git://git.kernel.org/.../will/linux into next/virt
      Merge branch 'for-rmk/virt/kvm/core' of git://git.kernel.org/.../will/linux into next/virt
      Merge branch 'for-rmk/broadcast' of git://git.kernel.org/.../will/linux into next/virt
      Merge branch 'for-arm-soc/arch-timers' of git://git.kernel.org/.../will/linux into next/virt
      Merge branch 'irqchip/gic-vic-move' into next/virt
      Merge branch 'depends/rmk-psci' into next/virt
      Merge branch 'depends/cleanup' into next/virt
      Merge branch 'for-arm-soc/virt/mach' of git://git.kernel.org/.../will/linux into next/virt
      arm: arch_timer: add missing inline in stub function
      Merge branch 'socfpga/hw' into next/soc
      Merge tag 'for-arm-soc-cleanup' of git://git.kernel.org/.../linusw/linux-stericsson into next/cleanup
      Merge branch 'fixes-for-3.9' into next/fixes-non-critical
      Merge tag 'at91-fixes' of git://github.com/at91linux/linux-at91 into next/fixes-non-critical
      Merge tag 'v3.8-rc7' into next/boards
      Merge tag 'arm-imx-defconfig' of git://git.pengutronix.de/git/imx/linux-2.6 into next/boards
      Merge branch 'kvm-arm/timer' of git://git.kernel.org/.../maz/arm-platforms into next/virt
      Merge branch 'next/fixes-samsung' of git://git.kernel.org/.../kgene/linux-samsung into next/fixes-non-critical
      Merge tag 'sunxi-dt-for-3.9' of https://github.com/mripard/linux into next/dt
      Merge tag 'at91-dt-late' of git://github.com/at91linux/linux-at91 into next/dt

Pali Rohár (2):
      RX-51: Add leds lp5523 names from Maemo 5 2.6.28 kernel
      RX-51: Register twl4030-madc device

Paul Walmsley (19):
      ARM: OMAP2+: omap_device: remove obsolete pm_lats and early_device code
      ARM: OMAP4: clock/hwmod data: start to remove some IP block control "clocks"
      ARM: OMAP4: clock/hwmod data: remove MODULEMODE entries in mux + gate combos
      ARM: OMAP2xxx: clock data: clean up unused null clocks
      ARM: OMAP2xxx: powerdomain: core powerdomain missing logic retention states
      ARM: OMAP3xxx: CPUIdle: simplify the PER next-state code
      ARM: OMAP2+: hwmod: add support for blocking WFI when a device is active
      ARM: OMAP2420: hwmod data/PM: use hwmod to block WFI when I2C active
      ARM: OMAP3xxx: CPUIdle: optimize __omap3_enter_idle()
      ARM: OMAP4: MPUSS PM: remove unnecessary shim functions for powerdomain control
      ARM: OMAP2+: clockdomain: add pwrdm_state_switch() call to clkdm_sleep()
      ARM: OMAP2xxx: PM: clean up some crufty powerstate programming code
      ARM: OMAP2: PM/powerdomain: drop unnecessary pwrdm_wait_transition()
      ARM: OMAP2+: PM/powerdomain: move omap_set_pwrdm_state() to powerdomain code
      ARM: OMAP2+: powerdomain/clockdomain: add a per-powerdomain spinlock
      ARM: OMAP2xxx: CM: remove autodep handling
      ARM: OMAP2+: clockdomain: work on wkdep/sleepdep functions
      ARM: OMAP2+: clockdomain: convert existing atomic usecounts into spinlock-protected shorts/ints
      ARM: OMAP2+: powerdomain: fix whitespace, improve flag comments

Peter De Schrijver (3):
      clk: tegra: Implement locking for super clock
      clk: tegra: Add missing spinlock for hclk and pclk
      clk: tegra: local arrays should be static

Peter Ujfalusi (9):
      ARM: OMAP: 3430sdp: Enable extmute functionality for audio
      ARM: OMAP: zoom: Zoom2 does not have extmute functionality
      ARM: OMAP2+: twl-common: Add default twl4030 audio configuration
      ARM: OMAP2+: twl-common: Allow boards to customize the twl4030 audio setup
      ARM: OMAP: zoom: Audio support via the common omap-twl4030 machine driver
      ARM: OMAP: sdp3430: Audio support via the common omap-twl4030 machine driver
      ARM: OMAP: board-4430sdp: Proper support for TWL6030 PWM LED/Backlight
      ARM: OMAP: omap3beagle: Use the pwm_leds driver to control the PMU_STAT led
      ARM: board-zoom: Do not request LCD panel enable GPIO from twl4030

Philip Avinash (1):
      ARM: OMAP2+: gpmc: Add device tree documentation for elm handle

Prashant Gaikwad (18):
      ARM: tegra: add function to read chipid
      ARM: tegra: move tegra_cpu_car.h to linux/clk/tegra.h
      ARM: tegra: define Tegra30 CAR binding
      clk: tegra: add Tegra specific clocks
      clk: tegra: add clock support for Tegra20
      clk: tegra: add clock support for Tegra30
      ARM: tegra: migrate to new clock code
      ARM: tegra: remove legacy clock code
      spi: tegra: do not use clock name to get clock
      ARM: tegra: add clock properties to Tegra20 DT
      ARM: tegra: add clock properties to Tegra30 DT
      ARM: tegra: paz00: add clock information to DT
      staging: nvec: remove use of clk_get_sys
      ASoC: tegra: remove auxdata
      ARM: tegra20: remove auxdata
      ARM: tegra30: remove auxdata
      clk: tegra20: remove unused TEGRA_CLK_DUPLICATE()s
      clk: tegra30: remove unused TEGRA_CLK_DUPLICATE()s

Richard Zhao (1):
      ARM: tegra: cpufreq: move clk_get/put out of function tegra_cpu_init/exit

Rob Herring (17):
      ARM: GIC: remove assembly ifdefs from gic.h
      ARM: GIC: remove direct use of gic_raise_softirq
      ARM: GIC: set handle_arch_irq in GIC initialization
      ARM: remove mach .handle_irq for GIC users
      irqchip: Move ARM GIC to drivers/irqchip
      ARM: use common irqchip_init for GIC init
      irqchip: Move ARM gic.h to include/linux/irqchip/arm-gic.h
      ARM: VIC: shrink down vic.h
      ARM: VIC: set handle_arch_irq in VIC initialization
      ARM: remove mach .handle_irq for VIC users
      ARM: remove unneeded vic.h includes
      ARM: samsung: remove unused tick.h
      irqchip: Move ARM VIC to drivers/irqchip
      ARM: spear: use common irqchip_init function
      ARM: picoxcell: use common irqchip_init function
      irqchip: Move ARM vic.h to include/linux/irqchip/arm-vic.h
      ARM: exynos: move exynos4210-combiner to drivers/irqchip

Robert Nelson (1):
      ARM: at91: at91sam9x5: fix usart3 pinctrl name

Robert Tivy (5):
      ARM: davinci: da850 board: change pr_warning() to pr_warn()
      ARM: davinci: devices-da8xx.c: change pr_warning() to pr_warn()
      ARM: davinci: psc.c: change pr_warning() to pr_warn()
      ARM: davinci: psc: introduce reset API
      ARM: davinci: da850: add dsp clock definition

Roger Quadros (2):
      ARM: OMAP: Consolidate OMAP USB-HS platform data (part 1/3)
      ARM: OMAP: Consolidate OMAP USB-HS platform data (part 3/3)

Rusty Russell (1):
      KVM: ARM: VFP userspace interface

Sachin Kamat (4):
      ARM: shmobile: Remove duplicate inclusion of dma-mapping.h in setup-r8a7740.c
      ARM: S3C24XX: Make 'clk_msysclk' static
      ARM: SAMSUNG: Silence empty switch warning in sdhci.h
      ARM: SAMSUNG: Silence empty switch warning in fimc-core.h

Santosh Shilimkar (1):
      ARM: OMAP: Make use of available scu_a9_get_base() interface

Sebastian Hesselbarth (2):
      ARM: dove: cleanup includes
      ARM: dove: cleanup includes

Sekhar Nori (2):
      ARM: davinci: defconfig: enable devtmpfs and devtmpfs automount
      ARM: davinci: defconfig: enable pm_runtime

Shawn Guo (18):
      ARM: decompress: remove unused ARCH_HAS_DECOMP_WDOG
      ARM: remove unused arch_decomp_wdog()
      ARM: samsung: remove unused arch_decomp_wdog() code
      clockevents: export clockevents_config_and_register for module use
      ARM: use clockevents_config_and_register() where possible
      clocksource: use clockevents_config_and_register() where possible
      ARM: remove redundant 'select GENERIC_GPIO'
      ARM: imx: remove unused imx6q_clock_map_io()
      ARM: imx: use debug_ll_io_init() for imx6q
      Merge tag 'imx-cleanup-3.9' into imx6q-cpuidle
      ARM: imx: return zero in case next event gets a large increment
      ARM: imx: mask gpc interrupts initially
      ARM: imx: move imx6q_cpuidle_driver into a separate file
      ARM: imx6q: support WAIT mode using cpuidle
      Merge tag 'imx-cleanup-3.9' into imx/soc
      ARM: imx: use separated debug uart symbol for imx31 and imx35
      ARM: imx: support DEBUG_LL uart port selection for all i.MX SoCs
      ARM: imx_v6_v7_defconfig: enable anatop regulator and snvs rtc

Shirish S (1):
      ARM: dts: Correct pin configuration of SD 4 for exynos4x12-pinctrl

Simon Horman (15):
      ARM: mach-shmobile: mackerel: update defconfig
      ARM: mach-shmobile: fix memory size for kota2_defconfig
      ARM: mach-shmobile: kzm9g: defconfig update
      ARM: mach-shmobile: armadillo: update defconfig
      ARM: mach-shmobile: kzm9d: update defconfig
      ARM: mach-shmobile: armadillo: defconfig: Enable CEU
      ARM: mach-shmobile: mackerel:  enable VFP in defconfig
      Merge remote-tracking branches 'arm-soc/irqchip/gic-vic-move' and 'arm-soc/timer/cleanup' into soc
      ARM: mach-shmobile: sh73a0: Allow initialisation of GIC by DT
      ARM: mach-shmobile: sh73a0: Minimal setup using DT
      ARM: mach-shmobile: sh73a0: Initialise MMCIF using DT
      ARM: mach-shmobile: sh73a0:  Add reg and device_type properties to cpus
      ARM: mach-shmobile: emev2:  Add reg and device_type properties to cpus
      ARM: shmobile: r8a7779: Correct TMU clock support
      ARM: shmobile: r8a7779: Correct TMU clock support again

Soren Brinkmann (7):
      arm: zynq: timer: Replace PSS through PS
      arm: zynq: timer: Remove unnecessary register write
      arm: zynq: timer: Remove unused #defines
      arm: zynq: timer: Align columns
      arm: zynq: timer: Remove redundant #includes
      arm: zynq: timer: Fix comment style
      arm: zynq: timer: Set clock_event cpumask

Srinidhi Kasagar (1):
      ARM: mach-ux500: use SGI0 to wake up the other core

Steffen Trumtrar (1):
      ARM: i.MX25: clk: parent per5_clk to AHB clock

Stephen Warren (41):
      cris: move usec/nsec conversion to do_slow_gettimeoffset
      time: convert arch_gettimeoffset to a pointer
      m68k: set arch_gettimeoffset directly
      ARM: set arch_gettimeoffset directly
      ARM: at91: convert timer suspend/resume to clock_event_device
      ARM: pxa: convert timer suspend/resume to clock_event_device
      ARM: sa1100: convert timer suspend/resume to clock_event_device
      ARM: ux500: convert timer suspend/resume to clock_event_device
      ARM: samsung: register syscore_ops for timer resume directly
      ARM: remove struct sys_timer suspend and resume fields
      ARM: delete struct sys_timer
      clocksource: add common of_clksrc_init() function
      ARM: sunxi: fix struct sys_timer removal
      Merge remote-tracking branch 'korg_arm-soc/timer/cleanup' into cleanup
      ARM: bcm2835: make use of CLKSRC_OF
      clk: bcm2835: probe for fixed-clock in device tree
      ARM: bcm2835 rpi: remove hard-coded memreserve from DT
      ARM: bcm2835: add SDHCI node to DT
      ARM: bcm2835: add I2C controllers to DT
      ARM: bcm2835: fix clock node aliasing in device tree
      ARM: bcm2835: defconfig updates
      Merge remote-tracking branch 'korg_arm-soc/timer/cleanup' into for-3.9/cleanup
      ARM: tegra: move timer.c to drivers/clocksource/
      ARM: tegra: fix Kconfig warnings when !SMP
      Merge remote-tracking branch 'korg_arm-soc/depends/rmk-perf' into for-3.9/scu-base-rework
      ARM: tegra: define Tegra20 CAR binding
      ARM: tegra: add clocks properties to USB PHY nodes
      usb: host: tegra: don't touch EMC clock
      Merge branch 'for-3.9/scu-base-rework' into for-3.9/soc-t114
      ARM: tegra: trimslice: add gpio-poweroff node to DT
      ARM: tegra: seaboard: enable HDMI port
      ARM: tegra: ventana: enable HDMI port
      ARM: tegra: paz00: enable HDMI port
      ARM: tegra: swap cache-/interrupt-ctrlr nodes in DT
      ARM: tegra: move serial clock-frequency attr into the Tegra30 dtsi
      ARM: imx: fix imx31-dt.c time-related warning
      clocksource: always define CLOCKSOURCE_OF_DECLARE
      ARM: tegra: enable ARCH_REQUIRE_GPIOLIB for Tegra114
      ARM: tegra: sort Kconfig selects for Tegra114
      clk: tegra: fix driver to match DT binding
      ARM: tegra: remove clock-frequency properties from serial nodes

Steve Zhan (1):
      ARM: ux500: add spin_unlock(&master_lock).

Thomas Abraham (2):
      ARM: dts: Fix compatible value of pinctrl module on EXYNOS5440
      ARM: EXYNOS: Fix crash on soft reset on EXYNOS5440

Thomas Gleixner (1):
      ARM: OMAP: make wakeupgen_lock raw

Thomas Petazzoni (4):
      arm: kirkwood: dockstar: remove useless include of SDIO header
      irqchip: add to the directories part of the IRQ subsystem in MAINTAINERS
      irqchip: add basic infrastructure
      arm: add set_handle_irq() to register the parent IRQ controller handler function

Tomasz Figa (1):
      ARM: S3C64XX: Fix missing header error with CONFIG_CPU_IDLE enabled

Tony Lindgren (16):
      ARM: OMAP2+: Limit omap initcalls to omap only on multiplatform kernels
      ARM: OMAP2+: Use omap initcalls
      ARM: OMAP: Fix i2c cmdline initcall for multiplatform
      ARM: OMAP: Fix dmaengine init for multiplatform
      ARM: OMAP2+: Add multiplatform debug_ll support
      ARM: OMAP2+: Disable code that currently does not work with multiplaform
      ARM: OMAP2+: Enable ARCH_MULTIPLATFORM support
      ARM: OMAP2+: Add minimal support for booting vexpress
      ARM: OMAP2+: Remove now obsolete uncompress.h and debug-macro.S
      Merge branch 'peter/for-tony' of git://gitorious.org/omap-audio/linux-audio into omap-for-v3.9/twl
      Merge tag 'omap-cleanup-a-for-3.9' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.9/pm
      Merge tag 'omap-cleanup-b-for-3.9' of git://git.kernel.org/.../pjw/omap-pending into omap-for-v3.9/pm
      ARM: OMAP2+: Fix twl section warnings related to omap_twl4030_audio_init
      ARM: OMAP2+: Fix warning for hwspinlock omap_postcore_initcall
      ARM: OMAP2+: Make sure files with omap initcalls include soc.h
      Merge branch 'usbhost17-for-arm-soc' of git://github.com/rogerq/linux into omap-for-v3.9/usb

Tony Prisk (8):
      arm: vt8500: Remove single platform Kconfig options
      arm: vt8500: Convert debug-macro.S to be multiplatform friendly
      arm: vt8500: Remove remaining mach includes
      arm: vt8500: Add support for Wondermedia WM8750/WM8850
      timer: vt8500: Move timer code to drivers/clocksource
      timer: vt8500: Convert vt8500 to use CLKSRC_OF
      dts: vt8500: Add initial dts support for WM8850
      arm: vt8500: Update MAINTAINERS entry for arch-vt8500

Torben Hohn (2):
      ARM: mxs: use apbx bus clock to drive the timers on timrotv2
      ARM: mxs: decrease mxs_clockevent_device.min_delta_ns to 2 clock cycles

Ulf Hansson (1):
      cpufreq: dbx500: Move clk_get to probe

Ulrich Hecht (2):
      ARM: mach-shmobile: add shmobile_cpu_disable_any()
      ARM: mach-shmobile: sh73a0: allow unplugging of CPU0

Venu Byravarasu (11):
      ARM: tegra: remove USB address related macros from iomap.h
      usb: phy: use kzalloc to allocate struct tegra_usb_phy
      ARM: tegra: Add new DT property to USB node.
      usb: host: tegra: Resetting PORT0 based on information received via DT.
      usb: phy: remove unused APIs from Tegra PHY.
      ARM: tegra: add DT nodes for Tegra USB PHY
      USB: PHY: tegra: get rid of instance number to differentiate legacy controller
      USB: PHY: tegra: Get rid of instance number to differentiate PHY type
      usb: add APIs to access host registers from Tegra PHY
      ARM: tegra: Add reset GPIO information to PHY DT node
      usb: host: tegra: make use of PHY pointer of HCD

Viresh Kumar (1):
      ARM: SPEAr13xx: Enable CONFIG_ARCH_HAS_CPUFREQ

Vishwanathrao Badarkhe, Manish (1):
      ARM: davinci: da850: add DT node for I2C0

Vivien Didelot (1):
      ARM: davinci: da8xx_register_spi() should not register SPI board info

Will Deacon (10):
      Merge branch 'for-rmk/perf' into for-rmk/virt/kvm/core
      Merge branch 'for-will/kvm/core' of git://github.com/virtualopensystems/linux-kvm-arm into for-rmk/virt/kvm/core
      Merge branch 'timers/for-arm' of git://git.kernel.org/.../tip/tip into for-rmk/broadcast
      Merge branch 'clocks/broadcast-arm' of git://linux-arm.org/linux-mr into for-rmk/broadcast
      Merge branch 'for-will/arch-timer-unification' of git://linux-arm.org/linux-mr into for-arm-soc/arch-timers
      Merge branch 'for-rmk/virt/psci' into for-arm-soc/virt/mach
      Merge branch 'irqchip/gic-vic-move' of git://git.kernel.org/.../arm/arm-soc into for-arm-soc/virt/mach
      ARM: mach-virt: add SMP support using PSCI
      ARM: integrator: ensure ap_syscon_base is initialised when !CONFIG_MMU
      ARM: mach-virt: fixup machine descriptor after removal of sys_timer

