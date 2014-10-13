Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbaJMJlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 05:41:53 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:35983 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbaJMJls convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 05:41:48 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org
User-Agent: alot/0.3.5
To: torvalds@linux-foundation.org
Message-ID: <20141013094139.938.40926@quantum>
Subject: [GIT PULL] clk: changes for 3.18
Date: Mon, 13 Oct 2014 02:41:39 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9e82bf014195d6f0054982c463575cdce24292be:

  Linux 3.17-rc5 (2014-09-14 17:50:12 -0700)

are available in the git repository at:

  https://git.linaro.org/people/mike.turquette/linux.git tags/clk-for-linus-3.18

for you to fetch changes up to 98d147f50eb0ce4328e013f5f2c076896003c761:

  clk: pxa clocks build system fix (2014-10-05 13:41:53 -0700)

----------------------------------------------------------------
The clk tree changes for 3.18 are dominated by clock drivers. Mostly
fixes and enhancements to existing drivers as well as new drivers. This
tag contains a bit more arch code than I usually take due to some OMAP2+
changes. Additionally it contains the restart notifier handlers which
are merged as a dependency into several trees.

The PXA changes are the only messy part. Due to having a stable tree I
had to revert one patch and follow up with one more fix near the tip of
this tag. Some dead code is introduced but it will soon become live code
after 3.18-rc1 is released as the rest of the PXA family is converted
over to the common clock framework.

Another trend in this tag is that multiple vendors have started to push
the complexity of changing their CPU frequency into the clock driver,
whereas this used to be done in CPUfreq drivers.

Changes to the clk core include a generic gpio-clock type and a
clk_set_phase() function added to the top-level clk.h api. Due to some
confusion on the fbdev mailing list the kernel boot parameters
documentation was updated to further explain the clk_ignore_unused
parameter, which is often required by users of the simplefb driver.
Finally some fixes to the locking around the clock debugfs stuff was
done to prevent deadlocks when interacting with other subsystems.

----------------------------------------------------------------
Andy Gross (1):
      clk: qcom: Add IPQ8064 PLL required for USB

Behan Webster (1):
      clk: ti: LLVMLinux: Move __init outside of type definition

Boris BREZILLON (6):
      clk: at91: fix num_parents test in at91sam9260 slow clk implementation
      clk: at91: fix PLL_MAX_COUNT macro definition
      clk: at91: rework PLL rate calculation
      clk: at91: fix recalc_rate implementation of PLL driver
      clk: at91: rework rm9200 USB clock to propagate set_rate to the parent clk
      clk: at91: fix div by zero in USB clock driver

Chander Kashyap (1):
      clk: samsung: exynos5260: fix typo in clock name

Chen-Yu Tsai (2):
      clk: sunxi: add correct divider table for sun4i-apb0 clock
      clk: sunxi: Add sun8i MBUS clock support

Doug Anderson (2):
      clk: rockchip: Fix the clocks for i2c1 and i2c2
      clk: rockchip: change pll rate without a clk-notifier

Gregory CLEMENT (3):
      clk: mvebu: Fix clk frequency value if SSCG is enabled
      clk: mvebu: armada-370: Fix timer drift caused by the SSCG deviation
      clk: mvebu: armada-375: Fix the description of the SAR in the comment

Guenter Roeck (8):
      kernel: add support for kernel restart handler call chain
      power/restart: call machine_restart instead of arm_pm_restart
      arm64: support restart through restart handler call chain
      arm: support restart through restart handler call chain
      watchdog: moxart: register restart handler with kernel restart handler
      watchdog: alim7101: register restart handler with kernel restart handler
      watchdog: sunxi: register restart handler with kernel restart handler
      arm/arm64: unexport restart handlers

Guoxiong Yan (1):
      clk: hix5hd2: add watchdog0 clocks

Heiko Stuebner (8):
      clk: rockchip: add binding id for ARMCLK
      Merge branch 'v3.18-next/armclkid' into v3.18-next/cpuclk
      clk: rockchip: fix rk3066 pll status register location
      clk: rockchip: reparent aclk_cpu_pre to the gpll
      clk: rockchip: make tightly bound armclk child-clocks read-only
      clk: rockchip: add new clock-type for the cpuclk
      clk: rockchip: switch to using the new cpuclk type for armclk
      Merge tag 'tags/restart-handler-for-v3.18' into v3.18-next/cpuclk

Heiko Stübner (8):
      clk: rockchip: implement the fraction divider branch type
      clk: rockchip: make rockchip_clk_register_branch static
      clk: rockchip: protect critical clocks from getting disabled
      clk: fractional-divider: cast parent_rate to u64 before multiplying
      clk: rockchip: also protect hclk_peri as critical
      clk: rockchip: add missing rk3288 npll rate table
      clk: rockchip: add restart handler
      clk: samsung: register restart handlers for s3c2412 and s3c2443

Javier Martinez Canillas (6):
      clk: max77686: Add DT include for MAX77686 PMIC clock
      clk: Add generic driver for Maxim PMIC clocks
      clk: max77686: Convert to the generic max clock driver
      clk: max77686: Improve Maxim 77686 PMIC clocks binding
      clk: Add driver for Maxim 77802 PMIC clocks
      clk: max77802: Add DT binding documentation

Jiancheng Xue (1):
      clk: hix5hd2: add sd clk

Jianqun (2):
      clk: rockchip: fix rk3288 pll status register location
      clk: rockchip: rk3288: i2s_frac adds flag to set parent's rate

Jyri Sarha (1):
      clk: add gpio gated clock

Kever Yang (3):
      clk: rockchip: add some needed clock binding id for rk3288
      clk: rockchip: use the clock id for nodes init
      clk: rockchip: add clock node in PD_VIDEO

Kiran Padwal (1):
      clk: Remove .owner field for driver

Krzysztof Kozlowski (3):
      clk: samsung: exynos3250: Register DMC clk provider
      ARM: dts: exynos3250: Add CMU node for DMC domain clocks
      dt-bindings: clk: samsung: Document the DMC domain of Exynos3250 CMU

Kuninori Morimoto (1):
      clk: shmobile: add missing 0x0100 for SDCKCR

Marek Szyprowski (3):
      clk: samsung: exynos4: add missing smmu_g2d clock and update comments
      clk: samsung: exynos4: add support for MOUT_HDMI and MOUT_MIXER clocks
      clk: samsung: exynos4: fix g3d clocks

Mark Brown (1):
      clk: gpio-gate: Ensure gpiod_ APIs are prototyped

Mark yao (2):
      clk: rockchip: rk3288: add reset indices for SOFTRST9-11
      clk: rockchip: rk3288: fix softreset register count

Maxime Ripard (8):
      clk: Include of.h in clock-provider.h
      clk: Add a function to retrieve phase
      clk: sunxi: factors: Invert the probing logic
      clk: sunxi: Introduce mbus compatible
      ARM: sunxi: dt: Switch to the new mbus compatible
      clk: sunxi: Move mod0 clock to a file of its own
      clk: sunxi: Move mbus to mod0 file
      clk: sunxi: mod0: Introduce MMC proper phase handling

Mike Turquette (22):
      clk: mvebu: share locks between gate clocks
      clk: mvebu: powersave clock is a multiplexer
      cpufreq: kirkwood: use the powersave multiplexer
      Merge branch 'for-v3.17-rc/ti-clk-driver' of github.com:t-kristo/linux-pm into clk-fixes
      Merge branch 'clk-next-debugfs-lock' into clk-next
      Merge branch 'clk-fixes' into clk-next
      Merge branch 'clk-next-rockchip' into clk-next
      asm-generic: COMMON_CLK defines __clk_{get,put}
      Merge tag 'tegra-clk-3.18' of git://nv-tegra.nvidia.com/user/pdeschrijver/linux into clk-next
      Merge tag 'qcom-clocks-for-3.18' of git://git.kernel.org/.../galak/linux-qcom into clk-next
      Merge tag 'clk-mvebu-3.18' of git://git.infradead.org/linux-mvebu into clk-next
      clk: introduce clk_set_phase function & callback
      Merge tag 'v3.18-rockchip-cpuclk' of git://git.kernel.org/.../mmind/linux-rockchip into clk-next
      Merge tag 'sunxi-clocks-for-3.18' of git://git.kernel.org/.../mripard/linux into clk-next
      Merge tag 'hix5hd2-clock-for-3.18-v2' of git://github.com/hisilicon/linux-hisi into clk-next
      Merge branch 'for-v3.18/ti-clk-driver' of github.com:t-kristo/linux-pm into clk-next
      Merge tag 'for_3.18/samsung-clk' of git://git.kernel.org/.../tfiga/samsung-clk into clk-next
      Merge branch 'clk-pxa27x' into clk-next
      doc/kernel-parameters.txt: clarify clk_ignore_unused
      Merge tag 'v3.18-rockchip-clk2' of git://git.kernel.org/.../mmind/linux-rockchip into clk-next
      Revert "arm: pxa: Transition pxa27x to clk framework"
      Merge tag 'clk-mvebu-3.18-2' of git://git.infradead.org/linux-mvebu into clk-next

Mikko Perttunen (2):
      ARM: tegra: Add PLL_M_UD and PLL_C_UD to tegra124-car binding header
      clk: tegra124: Add PLL_M_UD and PLL_C_UD clocks

Nishanth Menon (2):
      clk: ti: divider: Provide error check for incoming parameters in set_rate
      clk: ti: dra7-atl: Provide error check for incoming parameters in set_rate

Pankaj Dubey (3):
      clk: samsung: exynos3250: fix mout_cam_blk parent list
      clk: samsung: exynos3250: fix width and shift of div_spi0_isp clock
      clk: samsung: exynos3250: fix width field of mout_mmc0/1

Peter Ujfalusi (1):
      clk: ti: dra7-atl-clock: Mark the device as pm_runtime_irq_safe

Robert Jarzmik (7):
      clk: add pxa clocks infrastructure
      clk: dts: document pxa clock binding
      arm: pxa: add clock pll selection bits
      clk: add pxa27x clock drivers
      dts: add devicetree bindings for pxa27x clocks
      arm: pxa: Transition pxa27x to clk framework
      clk: pxa clocks build system fix

Sebastian Andrzej Siewior (1):
      clk: ti: consider the fact that of_clk_get() might return an error

Soren Brinkmann (3):
      clk: zynq: Remove unnecessary OOM message
      clk: zynq: Remove pointless return at end of void function
      clk: zynq: Move const initdata into correct code section

Stephen Boyd (5):
      clk: qcom: Fix sdc 144kHz frequency entry
      clk: Don't hold prepare_lock across debugfs creation
      clk: qcom: Consolidate frequency finding logic
      clk: qcom: Add support for setting rates on PLLs
      clk: qcom: Add support for banked MD RCGs

Tero Kristo (3):
      clk: prevent erronous parsing of children during rate change
      clk: ti: change clock init to use generic of_clk_init
      clk: ti: dra7-atl-clock: fix a memory leak

Thomas Abraham (1):
      clk: samsung: exynos4: remove duplicate div_core2 divider clock instantiation

Thomas Petazzoni (1):
      clk: mvebu: fix sscg node lookup

Tomeu Vizoso (1):
      clk: tegra: Make clock initialization more robust

Ulrich Hecht (2):
      ARM: shmobile: r8a7794: document MSTP clock support
      ARM: shmobile: r8a7794: document CPG clock support

Uwe Kleine-König (1):
      clk/efm32gg: fix dt init prototype

Wei Yan (1):
      clk: hix5hd2: add I2C clocks

Xiubo Li (1):
      clk: use uninitialized_var instead setting 'flags' to 0 directly.

Zhangfei Gao (1):
      clk: hix5hd2: add complex clk

 .../devicetree/bindings/clock/exynos3250-clock.txt |  10 +-
 .../devicetree/bindings/clock/gpio-gate-clock.txt  |  21 ++
 .../devicetree/bindings/clock/maxim,max77686.txt   |  16 +-
 .../devicetree/bindings/clock/maxim,max77802.txt   |  44 +++
 .../devicetree/bindings/clock/pxa-clock.txt        |  16 +
 .../bindings/clock/renesas,cpg-mstp-clocks.txt     |   1 +
 .../clock/renesas,rcar-gen2-cpg-clocks.txt         |   1 +
 Documentation/devicetree/bindings/clock/sunxi.txt  |   4 +
 Documentation/kernel-parameters.txt                |  14 +-
 arch/arm/boot/dts/exynos3250.dtsi                  |   6 +
 arch/arm/boot/dts/pxa27x.dtsi                      |  20 +-
 arch/arm/boot/dts/sun5i-a10s.dtsi                  |   2 +-
 arch/arm/boot/dts/sun5i-a13.dtsi                   |   2 +-
 arch/arm/boot/dts/sun7i-a20.dtsi                   |   2 +-
 arch/arm/kernel/process.c                          |  12 +-
 arch/arm/mach-omap2/io.c                           |  12 +-
 arch/arm/mach-omap2/prm_common.c                   |   2 -
 arch/arm/mach-pxa/include/mach/pxa2xx-regs.h       |  10 +
 arch/arm64/kernel/process.c                        |   3 +-
 drivers/clk/Kconfig                                |  16 +
 drivers/clk/Makefile                               |   4 +
 drivers/clk/at91/clk-pll.c                         | 160 ++++-----
 drivers/clk/at91/clk-slow.c                        |   2 +-
 drivers/clk/at91/clk-usb.c                         |  20 +-
 drivers/clk/clk-axi-clkgen.c                       |   1 -
 drivers/clk/clk-efm32gg.c                          |   6 +-
 drivers/clk/clk-fractional-divider.c               |   2 +-
 drivers/clk/clk-gate.c                             |   2 +-
 drivers/clk/clk-gpio-gate.c                        | 205 ++++++++++++
 drivers/clk/clk-max-gen.c                          | 192 +++++++++++
 drivers/clk/clk-max-gen.h                          |  32 ++
 drivers/clk/clk-max77686.c                         | 184 +---------
 drivers/clk/clk-max77802.c                         |  97 ++++++
 drivers/clk/clk-palmas.c                           |   1 -
 drivers/clk/clk-twl6040.c                          |   1 -
 drivers/clk/clk-wm831x.c                           |   1 -
 drivers/clk/clk.c                                  | 175 +++++++---
 drivers/clk/hisilicon/clk-hix5hd2.c                | 232 ++++++++++++-
 drivers/clk/mvebu/armada-370.c                     |   8 +
 drivers/clk/mvebu/armada-375.c                     |   4 +-
 drivers/clk/mvebu/common.c                         |  91 ++++-
 drivers/clk/mvebu/common.h                         |   9 +
 drivers/clk/mvebu/kirkwood.c                       | 102 +++++-
 drivers/clk/pxa/Makefile                           |   2 +
 drivers/clk/pxa/clk-pxa.c                          |  97 ++++++
 drivers/clk/pxa/clk-pxa.h                          | 107 ++++++
 drivers/clk/pxa/clk-pxa27x.c                       | 370 +++++++++++++++++++++
 drivers/clk/qcom/clk-pll.c                         |  68 +++-
 drivers/clk/qcom/clk-pll.h                         |  20 ++
 drivers/clk/qcom/clk-rcg.c                         | 115 +++----
 drivers/clk/qcom/clk-rcg.h                         |   6 +-
 drivers/clk/qcom/clk-rcg2.c                        |  19 +-
 drivers/clk/qcom/common.c                          |  16 +
 drivers/clk/qcom/common.h                          |   4 +
 drivers/clk/qcom/gcc-ipq806x.c                     |  33 +-
 drivers/clk/qcom/mmcc-apq8084.c                    |   1 -
 drivers/clk/qcom/mmcc-msm8960.c                    |  29 +-
 drivers/clk/qcom/mmcc-msm8974.c                    |   1 -
 drivers/clk/rockchip/Makefile                      |   1 +
 drivers/clk/rockchip/clk-cpu.c                     | 329 ++++++++++++++++++
 drivers/clk/rockchip/clk-pll.c                     |  63 +---
 drivers/clk/rockchip/clk-rk3188.c                  | 171 +++++++++-
 drivers/clk/rockchip/clk-rk3288.c                  | 207 +++++++++---
 drivers/clk/rockchip/clk.c                         | 119 ++++++-
 drivers/clk/rockchip/clk.h                         |  39 +++
 drivers/clk/samsung/clk-exynos3250.c               | 202 ++++++++++-
 drivers/clk/samsung/clk-exynos4.c                  |  18 +-
 drivers/clk/samsung/clk-exynos5260.c               |   2 +-
 drivers/clk/samsung/clk-s3c2410-dclk.c             |   1 -
 drivers/clk/samsung/clk-s3c2412.c                  |  29 ++
 drivers/clk/samsung/clk-s3c2443.c                  |  19 ++
 drivers/clk/shmobile/clk-rcar-gen2.c               |   1 +
 drivers/clk/sunxi/Makefile                         |   2 +
 drivers/clk/sunxi/clk-factors.c                    | 101 +++++-
 drivers/clk/sunxi/clk-factors.h                    |  16 +-
 drivers/clk/sunxi/clk-mod0.c                       | 283 ++++++++++++++++
 drivers/clk/sunxi/clk-sun6i-apb0-gates.c           |   1 -
 drivers/clk/sunxi/clk-sun6i-apb0.c                 |   1 -
 drivers/clk/sunxi/clk-sun6i-ar100.c                |   1 -
 drivers/clk/sunxi/clk-sun8i-apb0.c                 |   1 -
 drivers/clk/sunxi/clk-sun8i-mbus.c                 |  78 +++++
 drivers/clk/sunxi/clk-sunxi.c                      | 161 +--------
 drivers/clk/tegra/clk-tegra124.c                   |   8 +
 drivers/clk/tegra/clk.c                            |   9 +-
 drivers/clk/ti/clk-dra7-atl.c                      |   9 +-
 drivers/clk/ti/clk.c                               |  68 ++--
 drivers/clk/ti/clockdomain.c                       |   5 +
 drivers/clk/ti/divider.c                           |  11 +-
 drivers/clk/zynq/clkc.c                            |  30 +-
 drivers/clk/zynq/pll.c                             |   4 +-
 drivers/cpufreq/kirkwood-cpufreq.c                 |  14 +-
 drivers/power/reset/restart-poweroff.c             |   3 +-
 drivers/watchdog/alim7101_wdt.c                    |  42 ++-
 drivers/watchdog/moxart_wdt.c                      |  32 +-
 drivers/watchdog/sunxi_wdt.c                       |  31 +-
 include/asm-generic/clkdev.h                       |   2 +
 include/dt-bindings/clock/exynos3250.h             |  27 ++
 include/dt-bindings/clock/exynos4.h                |  12 +-
 include/dt-bindings/clock/hix5hd2-clock.h          |  27 ++
 include/dt-bindings/clock/maxim,max77686.h         |  23 ++
 include/dt-bindings/clock/maxim,max77802.h         |  22 ++
 include/dt-bindings/clock/pxa-clock.h              |  77 +++++
 include/dt-bindings/clock/rk3188-cru-common.h      |   1 +
 include/dt-bindings/clock/rk3288-cru.h             |  82 ++++-
 include/dt-bindings/clock/tegra124-car.h           |   6 +-
 include/linux/clk-private.h                        |   2 +
 include/linux/clk-provider.h                       |  33 ++
 include/linux/clk.h                                |  29 ++
 include/linux/clk/ti.h                             |   1 +
 include/linux/reboot.h                             |   3 +
 kernel/reboot.c                                    |  81 +++++
 111 files changed, 4323 insertions(+), 850 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/gpio-gate-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/maxim,max77802.txt
 create mode 100644 Documentation/devicetree/bindings/clock/pxa-clock.txt
 create mode 100644 drivers/clk/clk-gpio-gate.c
 create mode 100644 drivers/clk/clk-max-gen.c
 create mode 100644 drivers/clk/clk-max-gen.h
 create mode 100644 drivers/clk/clk-max77802.c
 create mode 100644 drivers/clk/pxa/Makefile
 create mode 100644 drivers/clk/pxa/clk-pxa.c
 create mode 100644 drivers/clk/pxa/clk-pxa.h
 create mode 100644 drivers/clk/pxa/clk-pxa27x.c
 create mode 100644 drivers/clk/rockchip/clk-cpu.c
 create mode 100644 drivers/clk/sunxi/clk-mod0.c
 create mode 100644 drivers/clk/sunxi/clk-sun8i-mbus.c
 create mode 100644 include/dt-bindings/clock/maxim,max77686.h
 create mode 100644 include/dt-bindings/clock/maxim,max77802.h
 create mode 100644 include/dt-bindings/clock/pxa-clock.h
