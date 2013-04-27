Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab3D0ASp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 20:18:45 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:48897 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888Ab3D0ASn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 20:18:43 -0400
Date: Fri, 26 Apr 2013 17:18:38 -0700
From: Olof Johansson <olof@lixom.net>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH/RESEND] ARM: arch_timer: Silence debug preempt warnings
Message-ID: <20130427001838.GA2134@quad.lixom.net>
References: <1366241178-16626-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366241178-16626-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 04:26:18PM -0700, Stephen Boyd wrote:
> Hot-plugging with CONFIG_DEBUG_PREEMPT=y on a device with arm
> architected timers causes a slew of "using smp_processor_id() in
> preemptible" warnings:
> 
>   BUG: using smp_processor_id() in preemptible [00000000] code: sh/111
>   caller is arch_timer_cpu_notify+0x14/0xc8
> 
> This happens because sometimes the cpu notifier,
> arch_timer_cpu_notify(), is called in preemptible context and
> other times in non-preemptible context but we use this_cpu_ptr()
> to retrieve the clockevent in all cases. We're only going to
> actually use the pointer in non-preemptible context though, so
> push the this_cpu_ptr() access down into the cases to force the
> checks to occur only in non-preemptible contexts.
> 
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Acked-by: Marc Zyngier <Marc.Zyngier@arm.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
> 
> Resending to arm-soc maintainers instead of timekeeping maintainers. Who
> maintains this driver?

Subsystem is maintained by John and Thomas, but given the recent moves of ARM
drivers there (which mostly has been acked by them), we'll take the patch at
this time.

Applied on top of late/clksrc in arm-soc. Thanks.


-Olof
