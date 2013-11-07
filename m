Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab3KGLD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 06:03:56 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:49160 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab3KGLDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 06:03:54 -0500
Message-ID: <527B7397.9020208@linaro.org>
Date: Thu, 07 Nov 2013 12:03:51 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        sboyd@codeaurora.org, kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH v2 0/5] Allwinner SoCs High Speed Timer support
References: <1382706463-3892-1-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1382706463-3892-1-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2013 03:07 PM, Maxime Ripard wrote:
> Hi everyone,
>
> Here is a few patches adding support for the High Speed Timers running on the
> Allwinner SoCs.
>
> These timers are 64 bits timers running at a much higher speed than the timers
> used for now on these SoCs, since they are no longer wired to the 24MHz
> oscillator, but to the AHB clock.
>
> This HS timers are actually found in all the supported SoCs but the A10.
> However, the A20 and A31 come with 4 of these high speed timers, while the A10s
> and A13 only have two, hence why we introduce two different compatibles.
>
> The A31 is not using these for now, as its timers are asserted in reset by a
> reset controller that first need to gain some support in the kernel first, but
> that's for another patchset.

Hi Maxime,

the patchset is applied in my tree for 3.14.

Fixed a trivial conflict in the arch/arm/mach-sunxi/Kconfig

Thanks !
   -- Daniel

> Changes from v1:
>    - Reported correctly the minimum ticks we can set
>    - No longer use the HS timers as the default timers in the system
>    - Removed the IRQF_DISABLED interrupt flag
>    - Filled the irq clock_event_device field
>    - Changed the cpumask to cpu_possible_mask
>
> Maxime Ripard (5):
>    clocksource: sun4i: Increase a bit the clock event and sources rating
>    clocksource: Add Allwinner SoCs HS timers driver
>    ARM: sun5i: a10s: Add support for the High Speed Timers
>    ARM: sun5i: a13: Add support for the High Speed Timers
>    ARM: sun7i: a20: Add support for the High Speed Timers
>
>   .../bindings/timer/allwinner,sun5i-a13-hstimer.txt |  22 +++
>   arch/arm/boot/dts/sun5i-a10s.dtsi                  |   7 +
>   arch/arm/boot/dts/sun5i-a13.dtsi                   |   7 +
>   arch/arm/boot/dts/sun7i-a20.dtsi                   |  10 ++
>   arch/arm/mach-sunxi/Kconfig                        |   1 +
>   drivers/clocksource/Kconfig                        |   4 +
>   drivers/clocksource/Makefile                       |   1 +
>   drivers/clocksource/sun4i_timer.c                  |   4 +-
>   drivers/clocksource/timer-sun5i.c                  | 192 +++++++++++++++++++++
>   9 files changed, 246 insertions(+), 2 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/timer/allwinner,sun5i-a13-hstimer.txt
>   create mode 100644 drivers/clocksource/timer-sun5i.c
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

