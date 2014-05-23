Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbaEWKVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:21:54 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:36980 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaEWKVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:21:52 -0400
Message-ID: <537F214C.8000700@linaro.org>
Date: Fri, 23 May 2014 12:22:04 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
CC: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Matthew Leach <matthew.leach@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Xiubo Li <Li.Xiubo@freescale.com>, "Yang,Wei" <Wei.Yang@windriver.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>
Subject: [GIT PULL] clockevents: new material for 3.16
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Thomas, Ingo,

this time we have a big number of changes in the clockevents.

There is a branch shared between Simon and I with two merges. The first 
merge was to pull the cmt,mtu changes from Laurent into the 
clockevents/cmt-mtu2-tmu-cleanups branch. Then this one has been merged 
in the clockevents/3.16. A bit later, a new fix on top of these changes 
has been provided and applied to clockevents/cmt-mtu2-tmu-cleanups with 
a second merge to clockevents/3.16.

clockevents/cmt-mtu2-tmu-cleanups will stay there until the 3.16 is 
released.

This pull request contains the following changes:

  * Laurent Pinchart did a lot of modifications to prepare the DT 
support. These modifications include a lot of cleanup (structure 
renaming, preparation to support multiple channel, kzalloc usage, ...) 
and then finishes to drop the old code to the new one.

  * Jingoo Han removed the dev_err when an allocation fails because this 
error is already given by the mm subsystems.
	* http://patchwork.ozlabs.org/patch/324158/
         * [conflict resolved] kmalloc => kzalloc changes with cmt,tmu, 
mtu cleanups from Laurent Pinchard

  * Matthew Leach added the ARM global timer with vexpress, enabled the 
ARM global timer with the A5 and added the definition in the DT. He also 
fixed a invalid check when looking for an usable ARM global timer for A9

  * Maxime Ripard added the support for AllWinner A31 for sun4i and made 
the timer reset optional through the DT

  * Stephen Boyd used the msm timer for the udelay

  * Uwe Kleine-König fixed the non-standard 'compatible' binding for efm32

  * Xiubo Li clarified the types for the clocksource_mmio_read* and 
added a new Flextimer Module (FTM) with its bindings

  * Yang Wei added the 'notrace' attribute to 'read_sched_clock' for the 
dw_apb_timer

The following changes since commit 2779ac167b1a1bf8153dca9f3a141c6148c6b89f:

   timer_stats/doc: Fix /proc/timer_stats documentation (2014-05-04 
20:46:32 +0200)

are available in the git repository at:

   git://git.linaro.org/people/daniel.lezcano/linux.git clockevents/3.16

for you to fetch changes up to 2529c3a330797000d699d70c9a65b8525c6652de:

   clocksource: Add Freescale FlexTimer Module (FTM) timer support 
(2014-05-23 10:12:04 +0200)

----------------------------------------------------------------
Daniel Lezcano (3):
       Merge branch 'clockevents/cmt-mtu2-tmu-cleanups' into 
clockevents/3.16
       Merge remote-tracking branch 'tip/timers/core/timers/core' into 
clockevents/3.16
       Merge branch 'clockevents/cmt-mtu2-tmu-cleanups' into 
clockevents/3.16

Jingoo Han (4):
       clocksource: em_sti: Remove unnecessary OOM messages
       clocksource: sh_cmt: Remove unnecessary OOM messages
       clocksource: sh_mtu2: Remove unnecessary OOM messages
       clocksource: sh_tmu: Remove unnecessary OOM messages

Laurent Pinchart (53):
       clocksource: sh_cmt: Use request_irq() instead of setup_irq()
       clocksource: sh_cmt: Split channel fields from sh_cmt_priv
       clocksource: sh_cmt: Rename struct sh_cmt_priv to sh_cmt_device
       clocksource: sh_cmt: Split channel setup to separate function
       clocksource: sh_cmt: Constify name argument to sh_cmt_register()
       clocksource: sh_cmt: Rename mapbase/mapbase_str to mapbase_ch/mapbase
       clocksource: sh_cmt: Add memory base to sh_cmt_channel structure
       clocksource: sh_cmt: Add index to struct sh_cmt_channel
       clocksource: sh_cmt: Replace kmalloc + memset with kzalloc
       clocksource: sh_cmt: Allocate channels dynamically
       clocksource: sh_cmt: Split static information from sh_cmt_device
       clocksource: sh_cmt: Replace hardcoded register values with macros
       clocksource: sh_cmt: Set cpumask to cpu_possible_mask
       clocksource: sh_cmt: Hardcode CMT clock event rating to 125
       clocksource: sh_cmt: Hardcode CMT clock source rating to 125
       clocksource: sh_cmt: Add support for multiple channels per device
       clocksource: sh_cmt: Rename clock to "fck" in the non-legacy case
       clocksource: sh_cmt: Remove FSF mail address from GPL notice
       clocksource: sh_cmt: Sort headers alphabetically
       clocksource: sh_cmt: Request IRQ for clock event device only
       clocksource: sh_tmu: Use request_irq() instead of setup_irq()
       clocksource: sh_tmu: Split channel fields from sh_tmu_priv
       clocksource: sh_tmu: Rename struct sh_tmu_priv to sh_tmu_device
       clocksource: sh_tmu: Split channel setup to separate function
       clocksource: sh_tmu: Constify name argument to sh_tmu_register()
       clocksource: sh_tmu: Add memory base to sh_tmu_channel structure
       clocksource: sh_tmu: Add index to struct sh_tmu_channel
       clocksource: sh_tmu: Replace kmalloc + memset with kzalloc
       clocksource: sh_tmu: Allocate channels dynamically
       clocksource: sh_tmu: Replace hardcoded register values with macros
       clocksource: sh_tmu: Hardcode TMU clock event and source ratings 
to 200
       clocksource: sh_tmu: Add support for multiple channels per device
       clocksource: sh_tmu: Rename clock to "fck" in the non-legacy case
       clocksource: sh_tmu: Remove FSF mail address from GPL notice
       clocksource: sh_tmu: Sort headers alphabetically
       clocksource: sh_mtu2: Use request_irq() instead of setup_irq()
       clocksource: sh_mtu2: Turn sh_mtu2_priv fields into local variables
       clocksource: sh_mtu2: Split channel fields from sh_mtu2_priv
       clocksource: sh_mtu2: Rename struct sh_mtu2_priv to sh_mtu2_device
       clocksource: sh_mtu2: Split channel setup to separate function
       clocksource: sh_mtu2: Constify name argument to sh_mtu2_register()
       clocksource: sh_mtu2: Add memory base to sh_mtu2_channel structure
       clocksource: sh_mtu2: Add index to struct sh_mtu2_channel
       clocksource: sh_mtu2: Replace kmalloc + memset with kzalloc
       clocksource: sh_mtu2: Allocate channels dynamically
       clocksource: sh_mtu2: Replace hardcoded register values with macros
       clocksource: sh_mtu2: Set cpumask to cpu_possible_mask
       clocksource: sh_mtu2: Hardcode MTU2 clock event rating to 200
       clocksource: sh_mtu2: Add support for multiple channels per device
       clocksource: sh_mtu2: Rename clock to "fck" in the non-legacy case
       clocksource: sh_mtu2: Remove FSF mail address from GPL notice
       clocksource: sh_mtu2: Sort headers alphabetically
       clocksource: sh_tmu: Fix channel IRQ retrieval in legacy case

Matthew Leach (4):
       clocksource: arm_global_timer: Only check for unusable timer on A9
       documentaion: DT: allow a A5 compatible string in global timer
       dts: ca5: add the global timer for the A5
       KConfig: Vexpress: build the ARM_GLOBAL_TIMER with vexpress platform

Maxime Ripard (2):
       clocksource: sun5i: Add support for reset controller
       ARM: sun6i: a31: Add support for the High Speed Timers

Stephen Boyd (1):
       clocksource: qcom: Implement read_current_timer for udelay

Uwe Kleine-König (1):
       clocksource: efm32: use $vendor,$device scheme for compatible string

Xiubo Li (5):
       clocksource: Fix type confusion for clocksource_mmio_readX_Y
       clocksource: Fix clocksource_mmio_readX_down
       clocksource: ftm: Add FlexTimer Module (FTM) Timer devicetree 
Documentation
       ARM: dts: vf610: Add Freescale FlexTimer Module timer node.
       clocksource: Add Freescale FlexTimer Module (FTM) timer support

Yang Wei (1):
       clocksource: dw_apb_timer_of: Do not trace read_sched_clock

  .../devicetree/bindings/arm/global_timer.txt       |    7 +-
  .../bindings/timer/allwinner,sun5i-a13-hstimer.txt |    4 +
  ...efm32,timer.txt => energymicro,efm32-timer.txt} |    4 +-
  .../devicetree/bindings/timer/fsl,ftm-timer.txt    |   31 +
  arch/arm/boot/dts/sun6i-a31.dtsi                   |   11 +
  arch/arm/boot/dts/vexpress-v2p-ca5s.dts            |   10 +-
  arch/arm/boot/dts/vf610.dtsi                       |   13 +
  arch/arm/mach-vexpress/Kconfig                     |    1 +
  drivers/clocksource/Kconfig                        |    5 +
  drivers/clocksource/Makefile                       |    1 +
  drivers/clocksource/arm_global_timer.c             |    5 +-
  drivers/clocksource/dw_apb_timer_of.c              |    2 +-
  drivers/clocksource/em_sti.c                       |    4 +-
  drivers/clocksource/fsl_ftm_timer.c                |  367 ++++++++
  drivers/clocksource/mmio.c                         |    8 +-
  drivers/clocksource/qcom-timer.c                   |   13 +
  drivers/clocksource/sh_cmt.c                       |  958 
+++++++++++++-------
  drivers/clocksource/sh_mtu2.c                      |  490 +++++++---
  drivers/clocksource/sh_tmu.c                       |  543 ++++++-----
  drivers/clocksource/time-efm32.c                   |    3 +-
  drivers/clocksource/timer-sun5i.c                  |    6 +
  include/linux/sh_timer.h                           |    1 +
  22 files changed, 1785 insertions(+), 702 deletions(-)
  rename Documentation/devicetree/bindings/timer/{efm32,timer.txt => 
energymicro,efm32-timer.txt} (87%)
  create mode 100644 
Documentation/devicetree/bindings/timer/fsl,ftm-timer.txt
  create mode 100644 drivers/clocksource/fsl_ftm_timer.c


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

