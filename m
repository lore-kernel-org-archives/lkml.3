Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753Ab3GVRHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 13:07:18 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:59472 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab3GVRHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 13:07:14 -0400
Message-ID: <51ED66BE.8040006@linaro.org>
Date: Mon, 22 Jul 2013 10:07:10 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        Barry Song <Baohua.Song@csr.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jingchang Lu <b35083@freescale.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v4 00/17] 64-bit friendly generic sched_clock()
References: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 04:21 PM, Stephen Boyd wrote:
> This patchset adds support for 64 bit counters in the generic
> sched_clock code and converts drivers over to use it. Based
> on v3.11-rc1.
>
> Changes since v3:
>   * Move to use seqcount to fix issues with 64-bit cyc counters
>   * Move to hrtimer to fix underflow/overflow errors in wraparound
>     calculation
>   * Use of 1 hour in clocks_calc_mult_shift
>   * Converted over drivers in drivers/clocksource
>
> Stephen Boyd (17):
>    clocksource: Extract max nsec calculation into separate function
>    sched_clock: Use seqcount instead of rolling our own
>    sched_clock: Use an hrtimer instead of timer
>    sched_clock: Add support for >32 bit sched_clock
>    arch_timer: Move to generic sched_clock framework
>    sched_clock: Remove sched_clock_func() hook
>    clocksource: bcm2835: Switch to sched_clock_register()
>    ocksource: dbx500-prcmu: Switch to sched_clock_register()
>    clocksource: dw_apb_timer_of: Switch to sched_clock_register()
>    clocksource: mxs_timer: Switch to sched_clock_register()
>    clocksource: nomadik: Switch to sched_clock_register()
>    clocksource: samsung_pwm_timer: Switch to sched_clock_register()
>    clocksource: tegra: Switch to sched_clock_register()
>    clocksource: time-armada-370-xp: Switch to sched_clock_register()
>    clocksource: sirf: Switch to sched_clock_register() and use 64 bits
>    clocksource: vf_pit_timer: Switch to sched_clock_register()
>    sched_clock: Deprecate setup_sched_clock()

Ok, so if there's no major objections with this set, here's my plan:

1) I'm going to queue 1-4 in a fortglx/3.12/sched-clock64 branch, I'll 
send git pull requests to both Thomas and Olof, so they can both merge 
the common base for the conversion code in both drivers/clocksource and 
arch/arm.

2) If I can get Catalin's ack on 5/17, I'll queue it and 6/17 for 
tip/timers/core.

3) I'll also queue the rest and send to Thomas or Daniel for 
tip/timers/core.

That sound ok to everyone?

thanks
-john


