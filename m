Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbaI2ASh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 20:18:37 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:51723 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbaI2ASg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 20:18:36 -0400
Message-ID: <5428A559.5050908@linaro.org>
Date: Mon, 29 Sep 2014 02:18:33 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "horms+renesas@verge.net.au" <horms+renesas@verge.net.au>,
        Carlo Caione <carlo@caione.org>,
        =?UTF-8?B?R2HDq2wgUE9SVEFZ?= <gael.portay@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Nathan Lynch <Nathan_Lynch@mentor.com>, Stefan Agner <stefan@agner.ch>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        "Hao.Liu@csr.com >> Hao Liu" <Hao.Liu@csr.com>
Subject: [GIT PULL] : clockevents/clocksource for 3.18
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Thomas, Ingo,

sorry for sending my PR so late but I have been very busy.

This PR contains the following changes:

  * Simon Horman provided the DT soc bindings for the sh_cmt, sh_mtu2 
and sh_tmu

  * Carlo Caione implemented the driver for the Meson6 with its 
documentation

  * Gael Portay fixed to unprepare the clock when the irq request fails 
and he took the opportunity to replace 'setup_irq' by 'request_irq' for 
the 'tcb_clrsrc' driver

  * Hao Liu disabled the timer before setting it again for the 'sirf' driver

  * Michal Simek changed the 'cadence_ttc' timer to make configurable 
the counter width (16 and 32), defaulting to 16 which is the current setting

  * Nathan Lynch provided a set of cleanup for the architected arm timer 
in preparation of the vdso support

  * Stefan Agner disabled the 'vf_pit_timer' when the system is entering 
in suspend in order to prevent the system to be woken up by the timer

  * Sudeep Holla added a check to make sure the mem and the cp15 timers 
are available if they are defined in the DT

Thanks !

   -- Daniel

The following changes since commit 88299c9bdb109e0d95abdca648065631ff91b2cb:

   timerfd: Remove an always true check (2014-08-27 11:17:48 +0200)

are available in the git repository at:

   http://git.linaro.org/people/daniel.lezcano/linux.git clockevents/3.18

for you to fetch changes up to 867f667fb9c6734e06cc24e96fc7f06a7e772084:

   Merge tag 'renesas-clocksource-for-v3.18' of 
git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas into 
clockevents/3.18 (2014-09-29 01:59:51 +0200)

----------------------------------------------------------------

Carlo Caione (2):
       ARM: meson: documentation: Add timer documentation
       ARM: meson6: clocksource: Add Meson6 timer support

Daniel Lezcano (1):
       Merge tag 'renesas-clocksource-for-v3.18' of 
git://git.kernel.org/.../horms/renesas into clockevents/3.18

Gael Portay (1):
       clocksource: tcb_clksrc: Sanitize IRQ request

Hao Liu (1):
       clocksource: sirf: Disable counter before re-setting it

Michal Simek (1):
       clocksource: cadence_ttc: Add support for 32bit mode

Nathan Lynch (3):
       clocksource: arm_arch_timer: Change clocksource name if CP15 
unavailable
       clocksource: arm_arch_timer: Enable counter access for 32-bit ARM
       clocksource: arm_arch_timer: Consolidate arch_timer_evtstrm_enable

Simon Horman (3):
       clocksource: sh_cmt: Document SoC specific bindings
       clocksource: sh_mtu2: Document r7s72100 binding
       clocksource: sh_tmu: Document r8a7779 binding

Stefan Agner (1):
       clocksource: vf_pit_timer: Support shutdown mode

Sudeep Holla (1):
       clocksource: arm_arch_timer: Discard unavailable timers correctly

  .../bindings/timer/amlogic,meson6-timer.txt        |  15 ++
  .../devicetree/bindings/timer/renesas,cmt.txt      |  44 +++++-
  .../devicetree/bindings/timer/renesas,mtu2.txt     |   7 +-
  .../devicetree/bindings/timer/renesas,tmu.txt      |   7 +-
  arch/arm/include/asm/arch_timer.h                  |  25 ---
  arch/arm64/include/asm/arch_timer.h                |  31 ----
  drivers/clocksource/Kconfig                        |   3 +
  drivers/clocksource/Makefile                       |   1 +
  drivers/clocksource/arm_arch_timer.c               |  64 +++++++-
  drivers/clocksource/cadence_ttc_timer.c            |  15 +-
  drivers/clocksource/meson6_timer.c                 | 167 
+++++++++++++++++++++
  drivers/clocksource/tcb_clksrc.c                   |  13 +-
  drivers/clocksource/timer-marco.c                  |   5 +-
  drivers/clocksource/vf_pit_timer.c                 |   4 +
  14 files changed, 314 insertions(+), 87 deletions(-)
  create mode 100644 
Documentation/devicetree/bindings/timer/amlogic,meson6-timer.txt
  create mode 100644 drivers/clocksource/meson6_timer.c


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

