Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554Ab3GRX7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 19:59:53 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:58594 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759528Ab3GRX7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 19:59:49 -0400
Message-ID: <51E88170.3080505@linaro.org>
Date: Thu, 18 Jul 2013 16:59:44 -0700
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
        Tomasz Figa <t.figa@samsung.com>
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

I've not been able to take a deep review yet, but this looks pretty much 
like what we discussed last week, so I'm happy with it so far. Has this 
gotten much testing (on both 32 and 64bit systems?)

One detail: Most of this is likely to go in via tip/timers/core, but the 
5/17 "arch_timer: Move to generic sched_clock" will need some 
synchronization with Catalin to make sure its ok to go in via tip. Not 
sure what other arm64 changes are pending that would depend or collide 
with that change.

thanks
-john

