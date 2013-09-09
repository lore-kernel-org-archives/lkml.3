Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002Ab3IIV5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 17:57:16 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:56107 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603Ab3IIV5O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 17:57:14 -0400
MIME-Version: 1.0
In-Reply-To: <20130909215406.11074.28281@quantum>
References: <20130909215406.11074.28281@quantum>
From: Mike Turquette <mturquette@linaro.org>
Date: Mon, 9 Sep 2013 14:56:53 -0700
Message-ID: <CAPtuhTjQvdnOvJ5Bb0ZXwFhpmSYhE1TR=YTrJmtLDVKMDfGUcQ@mail.gmail.com>
Subject: Re: [GIT PULL] clk: changes for 3.12
To: torvalds@linux-foundation.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 9, 2013 at 2:54 PM, Mike Turquette <mturquette@linaro.org> wrote:
> The following changes since commit 3b2f64d00c46e1e4e9bd0bb9bb12619adac27a4b:
>
>   Linux 3.11-rc2 (2013-07-21 12:05:29 -0700)
>
> are available in the git repository at:
>
>   git://git.linaro.org/people/mturquette/linux.git tags/clk-for-linus-3.12
>
> for you to fetch changes up to 12d298865ec5d0f14dd570c3506c270880769ed7:
>
>   clk: only call get_parent if there is one (2013-09-09 14:10:10 -0700)

I forgot to add that there was only one interesting merge conflict
found in linux-next. If you care to see how Stephen resolved it the
thread is here:
http://www.spinics.net/lists/linux-next/msg26584.html

Regards,
Mike

>
> ----------------------------------------------------------------
> The common clk framework changes for 3.12 are dominated by clock driver
> patches, both new drivers and fixes to existing. A high percentage of
> these are for Samsung platforms like Exynos. Core framework fixes and
> some new features like automagical clock re-parenting round out the
> patches.
>
> ----------------------------------------------------------------
> Alex Elder (2):
>       clk: get matching entry under lock in of_clk_init()
>       clk: only call get_parent if there is one
>
> Axel Lin (1):
>       clk: sunxi: Fix checking return value of clk_register_[composite|factors]
>
> Emilio López (2):
>       clk: sunxi: fix initialization of basic clocks
>       clk: sunxi: fix initialization of basic clocks
>
> Fabio Estevam (2):
>       clk: mxs: clk-imx23: Include <linux/clk/mxs.h>
>       clk: clk-divider: Export clk_register_divider()
>
> Gerhard Sittig (1):
>       clk: wrap I/O access for improved portability
>
> James Hogan (6):
>       clk: abstract parent cache
>       clk: move some parent related functions upwards
>       clk: add support for clock reparent on set_rate
>       clk: add CLK_SET_RATE_NO_REPARENT flag
>       clk: clk-mux: implement remuxing on set_rate
>       clk: fix new_parent dereference before null check
>
> Jisheng Zhang (1):
>       clk: mvebu: add missing iounmap
>
> Mark Brown (2):
>       clk: wm831x: Provide is_prepared() rather than is_enabled()
>       clk: wm831x: Initialise wm831x pointer on init
>
> Maxime Ripard (5):
>       clk: sunxi: Add A10s gates
>       clk: sunxi: Rename the structure to prepare the addition of sun6i
>       clk: sunxi: Allow to specify the divider width from the dividers data
>       clk: sunxi: Add A31 clocks support
>       clk: sunxi: Add Allwinner A20 gates
>
> Mike Turquette (6):
>       Merge branch 'clk-next-s3c64xx' into clk-next
>       clk: export fixed-factor, gate & mux registration
>       Merge tag 'zynq-clk-for-3.12' of git://git.xilinx.com/linux-xlnx into clk-next
>       clk: handle NULL struct clk gracefully
>       Merge branch 'clk-next-s3c64xx-delta' into clk-next
>       Merge tag 'sunxi-clk-for-3.12' of https://github.com/mripard/linux into clk-next-sunxi
>
> Peter Meerwald (1):
>       clk: fix typos
>
> Rahul Sharma (8):
>       clk/exynos5250: add mout_hdmi mux clock for hdmi
>       clk/exynos5250: add sclk_hdmiphy in the list of special clocks
>       clk/exynos5250: change parent to aclk200_disp1 for hdmi subsystem
>       clk/exynos5420: add sclk_hdmiphy to the list of special clocks
>       clk/exynos5420: add gate clock for mixer sysmmu
>       clk/exynos5420: fix the order of parents of hdmi mux
>       clk/exynos5420: add hdmi mux to change parents in hdmi driver
>       clk/exynos5420: assign dout_pixel id to pixel clock divider
>
> Sachin Kamat (31):
>       of/documentation: Fix a typo in exynos5250-clock.txt
>       clk: exynos4: Staticize local symbols
>       clk: exynos4: Remove unused function
>       clk: exynos5250: Staticize local symbols
>       clk: exynos5420: Staticize local symbols
>       clk: exynos5440: Staticize local symbols
>       clk: exynos-audss: Staticize exynos_audss_clk_init
>       clk: exynos5250: Add G2D gate clock
>       clk: exynos4: Add clock entries for TMU
>       of/documentation: Update G2D documentation
>       Documentation: clk: Fix a trivial typo in audss
>       clk: exynos4: Make exynos4_plls static
>       clk: exynos5250: Make exynos5250_plls static
>       clk: exynos5420: Make exynos5420_plls static
>       clk: exynos4: Fix incorrect placement of __initdata
>       clk: exynos5250: Fix incorrect placement of __initdata
>       clk: exynos5420: Fix incorrect placement of __initdata
>       clk: exynos5440: Fix incorrect placement of __initdata
>       clk: tegra114: Fix incorrect placement of __initdata
>       clk: tegra20: Fix incorrect placement of __initdata
>       clk: tegra30: Fix incorrect placement of __initdata
>       clk: prima2: Fix incorrect placement of __initdata
>       clk: bcm2835: Fix incorrect placement of __initconst
>       clk: nomadik: Fix incorrect placement of __initconst
>       clk: u300: Fix incorrect placement of __initconst
>       clk: armada-370: Fix incorrect placement of __initconst
>       clk: armada-xp: Fix incorrect placement of __initconst
>       clk: dove: Fix incorrect placement of __initconst
>       clk: kirkwood: Fix incorrect placement of __initconst
>       clk: sunxi: Fix incorrect placement of __initconst
>       clk: s3c64xx: Fix incorrect placement of __initdata
>
> Soren Brinkmann (2):
>       clk/zynq/pll: Fix documentation for PLL register function
>       clk/zynq/pll: Use #defines for fbdiv min/max values
>
> Stephen Boyd (1):
>       clk: fixed-rate: Export clk_fixed_rate_register()
>
> Thierry Reding (1):
>       clk: Move symbol export to proper location
>
> Tomasz Figa (20):
>       clk: mux: Add support for read-only muxes.
>       clk: samsung: pll: Add support for PLL6552 and PLL6553
>       clk: samsung: Add clock driver for S3C64xx SoCs
>       clk: samsung: pll: Use new registration method for PLL6552 and PLL6553
>       pwm: samsung: Update DT bindings documentation to cover clocks
>       ARM: dts: exynos4: Specify PWM clocks in PWM node
>       clocksource: samsung_pwm_timer: Get clock from device tree
>       clk: samsung: exynos4: Use separate aliases for cpufreq related clocks
>       clk: samsung: Modify _get_rate() helper to use __clk_lookup()
>       clk: samsung: exynos4: Remove unused static clkdev aliases
>       clk: samsung: exynos4: Remove checks for DT node
>       clk: samsung: exynos4: Rename exynos4_plls to exynos4x12_plls
>       clk: samsung: pll: Use new registration method for PLL45xx
>       clk: samsung: pll: Add support for rate configuration of PLL45xx
>       clk: samsung: pll: Use new registration method for PLL46xx
>       clk: samsung: pll: Add support for rate configuration of PLL46xx
>       clk: samsung: exynos4: Reorder registration of mout_vpllsrc
>       clk: samsung: exynos4: Register PLL rate tables for Exynos4210
>       clk: samsung: exynos4: Register PLL rate tables for Exynos4x12
>       clk: samsung: exynos5250: Simplify registration of PLL rate tables
>
> Tuomas Tynkkynen (1):
>       clk: tegra30: Don't wait for PLL_U lock bit
>
> Tushar Behera (1):
>       Documentation: exynos5250-clock: Add div_i2s1 and div_i2s2
>
> Vikas Sajjan (3):
>       clk: samsung: Add set_rate() clk_ops for PLL36xx
>       clk: samsung: Reorder MUX registration for mout_vpllsrc
>       clk: samsung: Add EPLL and VPLL freq table for exynos5250 SoC
>
> Yadwinder Singh Brar (9):
>       clk: samsung: Introduce a common samsung_clk_pll struct
>       clk: samsung: Define a common samsung_clk_register_pll()
>       clk: samsung: Migrate exynos5250 to use common samsung_clk_register_pll()
>       clk: samsung: Migrate exynos4 to use common samsung_clk_register_pll()
>       clk: samsung: Migrate exynos5420 to use common samsung_clk_register_pll()
>       clk: samsung: Remove unused pll registeration code for pll35xx and pll36xx
>       clk: samsung: Add support to register rate_table for samsung plls
>       clk: samsung: Add set_rate() clk_ops for PLL35xx
>       clk: s2mps11: Add support for s2mps11
>
>  Documentation/clk.txt                              |  46 +-
>  .../devicetree/bindings/clock/clk-exynos-audss.txt |   2 +-
>  .../devicetree/bindings/clock/exynos4-clock.txt    |   1 +
>  .../devicetree/bindings/clock/exynos5250-clock.txt |  14 +-
>  .../devicetree/bindings/clock/exynos5420-clock.txt |  12 +
>  .../bindings/clock/samsung,s3c64xx-clock.txt       |  77 +++
>  Documentation/devicetree/bindings/clock/sunxi.txt  |  12 +
>  .../bindings/clock/sunxi/sun5i-a10s-gates.txt      |  75 +++
>  .../bindings/clock/sunxi/sun6i-a31-gates.txt       |  83 +++
>  .../bindings/clock/sunxi/sun7i-a20-gates.txt       |  98 +++
>  .../devicetree/bindings/gpu/samsung-g2d.txt        |   7 +-
>  .../devicetree/bindings/pwm/pwm-samsung.txt        |  12 +
>  arch/arm/boot/dts/exynos4.dtsi                     |   2 +
>  arch/arm/mach-imx/clk.h                            |   5 +-
>  drivers/clk/Kconfig                                |   8 +-
>  drivers/clk/Makefile                               |   1 +
>  drivers/clk/clk-bcm2835.c                          |   2 +-
>  drivers/clk/clk-divider.c                          |   8 +-
>  drivers/clk/clk-fixed-factor.c                     |   2 +
>  drivers/clk/clk-fixed-rate.c                       |   1 +
>  drivers/clk/clk-gate.c                             |   7 +-
>  drivers/clk/clk-mux.c                              |  19 +-
>  drivers/clk/clk-nomadik.c                          |   4 +-
>  drivers/clk/clk-prima2.c                           |   2 +-
>  drivers/clk/clk-s2mps11.c                          | 273 ++++++++
>  drivers/clk/clk-u300.c                             |   4 +-
>  drivers/clk/clk-wm831x.c                           |  16 +-
>  drivers/clk/clk.c                                  | 450 ++++++++-----
>  drivers/clk/mmp/clk-mmp2.c                         |  39 +-
>  drivers/clk/mmp/clk-pxa168.c                       |  40 +-
>  drivers/clk/mmp/clk-pxa910.c                       |  31 +-
>  drivers/clk/mvebu/armada-370.c                     |  14 +-
>  drivers/clk/mvebu/armada-xp.c                      |  12 +-
>  drivers/clk/mvebu/clk-cpu.c                        |   4 +-
>  drivers/clk/mvebu/common.c                         |  18 +-
>  drivers/clk/mvebu/dove.c                           |  12 +-
>  drivers/clk/mvebu/kirkwood.c                       |  14 +-
>  drivers/clk/mxs/clk-imx23.c                        |   1 +
>  drivers/clk/mxs/clk.h                              |   4 +-
>  drivers/clk/samsung/Makefile                       |   3 +
>  drivers/clk/samsung/clk-exynos-audss.c             |   8 +-
>  drivers/clk/samsung/clk-exynos4.c                  | 605 ++++++++++--------
>  drivers/clk/samsung/clk-exynos5250.c               | 129 +++-
>  drivers/clk/samsung/clk-exynos5420.c               | 123 ++--
>  drivers/clk/samsung/clk-exynos5440.c               |  18 +-
>  drivers/clk/samsung/clk-pll.c                      | 701 ++++++++++++++++-----
>  drivers/clk/samsung/clk-pll.h                      |  85 ++-
>  drivers/clk/samsung/clk-s3c64xx.c                  | 473 ++++++++++++++
>  drivers/clk/samsung/clk.c                          |  10 +-
>  drivers/clk/samsung/clk.h                          |  55 +-
>  drivers/clk/spear/spear1310_clock.c                | 179 +++---
>  drivers/clk/spear/spear1340_clock.c                |  97 +--
>  drivers/clk/spear/spear3xx_clock.c                 |  57 +-
>  drivers/clk/spear/spear6xx_clock.c                 |  35 +-
>  drivers/clk/sunxi/clk-sunxi.c                      | 270 ++++++--
>  drivers/clk/tegra/clk-tegra114.c                   |  38 +-
>  drivers/clk/tegra/clk-tegra20.c                    |   8 +-
>  drivers/clk/tegra/clk-tegra30.c                    |  37 +-
>  drivers/clk/versatile/clk-vexpress.c               |   4 +-
>  drivers/clk/zynq/clkc.c                            |  86 +--
>  drivers/clk/zynq/pll.c                             |  19 +-
>  drivers/clocksource/samsung_pwm_timer.c            |  12 +-
>  include/dt-bindings/clock/samsung,s3c64xx-clock.h  | 178 ++++++
>  include/linux/clk-private.h                        |   3 +
>  include/linux/clk-provider.h                       |  31 +
>  65 files changed, 3595 insertions(+), 1101 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/clock/samsung,s3c64xx-clock.txt
>  create mode 100644 Documentation/devicetree/bindings/clock/sunxi/sun5i-a10s-gates.txt
>  create mode 100644 Documentation/devicetree/bindings/clock/sunxi/sun6i-a31-gates.txt
>  create mode 100644 Documentation/devicetree/bindings/clock/sunxi/sun7i-a20-gates.txt
>  create mode 100644 drivers/clk/clk-s2mps11.c
>  create mode 100644 drivers/clk/samsung/clk-s3c64xx.c
>  create mode 100644 include/dt-bindings/clock/samsung,s3c64xx-clock.h
