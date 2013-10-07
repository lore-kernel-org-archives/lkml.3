Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab3JGOZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 10:25:14 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:59547 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab3JGOZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 10:25:09 -0400
Message-ID: <5252C443.9070501@linaro.org>
Date: Mon, 07 Oct 2013 16:25:07 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
CC: Boris BREZILLON <b.brezillon@overkiz.com>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [GIT PULL] clocksource: event stream on architected timers and tcb_clksrc
 misc changes
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Thomas, Ingo,

- Will Deacon and Sudeep KarkadaNagesha implemented the event stream for 
architected timer. The event streams can be used to impose a timeout on 
a wfe, to safeguard against any programming error in case an expected 
event is not generated or even to implement wfe-based timeouts for 
userspace locking implementations. Some files fall under the arm 
maintainers' umbrella but those changes have been reviewed and acked by 
the relevant people (Catalin Marinas and Olof Johansson).

- Boris Brezillon improved the tcb_clksrc driver by removing a 
deprecated flag, checking return code values and using functions from 
the common clock framework.

Thanks !

    -- Daniel

The following changes since commit 68e90740284c69292881cd38c7ece6f09a18a58f:

   Merge branch 'clockevents/3.13' of 
git://git.linaro.org/people/dlezcano/linux into timers/core (2013-10-03 
07:57:02 +0200)

are available in the git repository at:

   git://git.linaro.org/people/dlezcano/linux.git clockevents/3.13

for you to fetch changes up to f51380a75652a4600b34ce384c4ff89ce0a15132:

   clocksource: tcb_clksrc: Remove IRQF_DISABLED (2013-10-03 16:28:40 +0200)

----------------------------------------------------------------
Boris BREZILLON (3):
       clocksource: tcb_clksrc: Replace clk_enable/disable with 
clk_prepare_enable/disable_unprepare
       clocksource: tcb_clksrc: Improve driver robustness
       clocksource: tcb_clksrc: Remove IRQF_DISABLED

Daniel Lezcano (1):
       Merge branch 'timer_evtstrm' of git://linux-arm.org/linux-skn 
into clockevents/3.13

Sudeep KarkadaNagesha (4):
       ARM/ARM64: arch_timer: add macros for bits in control register
       ARM: arch_timer: add support to configure and enable event stream
       ARM64: arch_timer: add support to configure and enable event stream
       drivers: clocksource: add CPU PM notifier for ARM architected timer

Will Deacon (1):
       drivers: clocksource: add support for ARM architected timer event 
stream

  arch/arm/include/asm/arch_timer.h    |   36 +++++++++++++++++---
  arch/arm/include/uapi/asm/hwcap.h    |    1 +
  arch/arm/kernel/setup.c              |    1 +
  arch/arm64/include/asm/arch_timer.h  |   42 +++++++++++++++++++----
  arch/arm64/include/asm/hwcap.h       |   11 +++---
  arch/arm64/include/uapi/asm/hwcap.h  |    1 +
  arch/arm64/kernel/setup.c            |   11 ++++++
  drivers/clocksource/Kconfig          |   15 +++++++++
  drivers/clocksource/arm_arch_timer.c |   49 +++++++++++++++++++++++++++
  drivers/clocksource/tcb_clksrc.c     |   61 
++++++++++++++++++++++++++++------
  include/clocksource/arm_arch_timer.h |   10 ++++++
  11 files changed, 211 insertions(+), 27 deletions(-)

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

