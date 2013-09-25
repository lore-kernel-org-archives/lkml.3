Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab3IYWl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 18:41:27 -0400
Received: from zetta.elopez.com.ar ([199.30.59.35]:53991 "EHLO
	zetta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab3IYWl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 18:41:26 -0400
Message-ID: <52436682.3060106@elopez.com.ar>
Date: Wed, 25 Sep 2013 19:41:06 -0300
From: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC: linux-arm-kernel@lists.infradead.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Allwinner SoCs High Speed Timer support
References: <1380117790-19390-1-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1380117790-19390-1-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

El 25/09/13 11:03, Maxime Ripard escribió:
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
>
> Thanks,
> Maxime
>
> Maxime Ripard (5):
>    clocksource: sun4i: Select CLKSRC_MMIO
>    clocksource: Add Allwinner SoCs HS timers driver
>    ARM: sun5i: a10s: Add support for the High Speed Timers
>    ARM: sun5i: a13: Add support for the High Speed Timers
>    ARM: sun7i: a20: Add support for the High Speed Timers

I tested these 5 patches on my Cubieboard2 (A20) and it boots and seems 
to work fine, so

Tested-by: Emilio López <emilio@elopez.com.ar>

# uptime && cat /proc/interrupts
  01:45:01 up  1:45,  load average: 0.01, 0.03, 0.04
            CPU0
  33:      56223       GIC  33  serial
  54:          0       GIC  54  sun4i_timer0
  87:        522       GIC  87  eth0
113:      66980       GIC 113  sun5i_timer0
IPI0:          0  CPU wakeup interrupts
IPI1:          0  Timer broadcast interrupts
IPI2:          0  Rescheduling interrupts
IPI3:          0  Function call interrupts
IPI4:          0  Single function call interrupts
IPI5:          0  CPU stop interrupts
Err:          0

Cheers,

Emilio
