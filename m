Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbaCKWfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 18:35:31 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:51602 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547AbaCKWf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 18:35:26 -0400
Message-ID: <531F8FAC.2040902@linaro.org>
Date: Tue, 11 Mar 2014 23:35:24 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [GIT PR] clockevents : new material for 3.15
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Thomas, Ingo,

here it the pull request for 3.15:

	* Ezequiel Garcia used the atomic access for shared register for orion 
and armada-370-xp. It allows to use the watchdog which shares the register

	* Ivan Khoronzhuk added the keystone driver

	* Linus Walleij moved the u300 driver into the clocksource directory

	* Magnus Damm re-ordered the Kconfig options for CMT, TMU and STI in 
order to move them in the clocksource drivers' Kconfig file

	* Matthias Brugger removes an useless variable for keystone

	* Maxime Ripard added some new compatibles in the DT

	* Soren Brinkmann added the cpufreq support for zynq. The patchset has 
been floating around since a while now. I reviewed the patchset, it 
seems ok for me but may be more experimented eyes should have a look at 
the "Overhaul clocksource frequency adjustment" patch

	* Stephen Boyd added the dynamic irq affinity for the arch timer

The following changes since commit 
f9a8a0abc3138a623895dcb6c2575ca31ca3da34: 
 
                           [14/1841]

   Merge branch 'fortglx/3.15/time' of 
git://git.linaro.org/people/john.stultz/linux into timers/core 
(2014-03-10 19:53:09 +0100)

are available in the git repository at:


   git://git.linaro.org/people/daniel.lezcano/linux.git clockevents/next

for you to fetch changes up to 09e15176ded1faa7bd685b3b5b1213cf0240566e:

   clocksource: exynos_mct: silence a static checker warning (2014-03-11 
23:13:23 +0100)

----------------------------------------------------------------
Dan Carpenter (1):
       clocksource: exynos_mct: silence a static checker warning

Ezequiel Garcia (2):
       clocksource: orion: Use atomic access for shared registers
       clocksource: armada-370-xp: Use atomic access for shared registers

Ivan Khoronzhuk (2):
       clocksource: keystone: add bindings for keystone timer
       clocksource: timer-keystone: introduce clocksource driver for 
Keystone

Linus Walleij (1):
       ARM: u300: move timer driver to clocksource

Magnus Damm (3):
       ARM: shmobile: Remove CMT, TMU and STI Kconfig entries
       sh: Remove Kconfig entries for TMU, CMT and MTU2
       clocksource: Add Kconfig entries for CMT, MTU2, TMU and STI

Matthias Brugger (1):
       clocksource: timer-keystone: Delete unnecessary variable

Maxime Ripard (2):
       clocksource: sunxi: Add new compatibles
       ARM: sunxi: dt: Convert to the new clocksource compatible

Soren Brinkmann (4):
       clocksource/cadence_ttc: Call clockevents_update_freq() with IRQs 
enabled
       clocksource/cadence_ttc: Overhaul clocksource frequency adjustment
       arm: zynq: Don't use arm_global_timer with cpufreq
       arm: zynq: Add support for cpufreq

Stephen Boyd (1):
       clocksource: arch_timer: Set dynamic irq affinity on mmio clockevent

  .../bindings/timer/allwinner,sun4i-timer.txt       |    4 +-
  .../bindings/timer/ti,keystone-timer.txt           |   29 +++
  MAINTAINERS                                        |    1 +
  arch/arm/boot/dts/sun4i-a10.dtsi                   |    2 +-
  arch/arm/boot/dts/sun5i-a10s.dtsi                  |    2 +-
  arch/arm/boot/dts/sun5i-a13.dtsi                   |    2 +-
  arch/arm/boot/dts/sun6i-a31.dtsi                   |    2 +-
  arch/arm/boot/dts/sun7i-a20.dtsi                   |    2 +-
  arch/arm/boot/dts/zynq-7000.dtsi                   |    6 +
  arch/arm/mach-shmobile/Kconfig                     |   36 +--
  arch/arm/mach-u300/Makefile                        |    2 +-
  arch/arm/mach-zynq/Kconfig                         |    4 +-
  arch/arm/mach-zynq/common.c                        |    3 +
  arch/sh/Kconfig                                    |   76 ++----
  drivers/clocksource/Kconfig                        |   44 ++++
  drivers/clocksource/Makefile                       |    2 +
  drivers/clocksource/arm_arch_timer.c               |    1 +
  drivers/clocksource/cadence_ttc_timer.c            |  121 +++++++---
  drivers/clocksource/exynos_mct.c                   |    2 +-
  drivers/clocksource/sun4i_timer.c                  |    2 +-
  drivers/clocksource/time-armada-370-xp.c           |   12 +-
  drivers/clocksource/time-orion.c                   |   28 +--
  drivers/clocksource/timer-keystone.c               |  241 
++++++++++++++++++++
  .../timer.c => drivers/clocksource/timer-u300.c    |    4 -
  24 files changed, 481 insertions(+), 147 deletions(-)
  create mode 100644 
Documentation/devicetree/bindings/timer/ti,keystone-timer.txt
  create mode 100644 drivers/clocksource/timer-keystone.c
  rename arch/arm/mach-u300/timer.c => drivers/clocksource/timer-u300.c 
(99%)



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

