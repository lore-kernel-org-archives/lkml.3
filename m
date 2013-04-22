Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab3DVKtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:49:25 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57333 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307Ab3DVKtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:49:23 -0400
Date: Mon, 22 Apr 2013 11:48:58 +0100
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Rob Herring <robherring2@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        "arm@kernel.org" <arm@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/4] ARM: sched_clock: Add support for >32 bit sched_clock
Message-ID: <20130422104858.GB2572@mudshark.cambridge.arm.com>
References: <1366417746-24990-1-git-send-email-sboyd@codeaurora.org>
 <1366417746-24990-4-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366417746-24990-4-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Sat, Apr 20, 2013 at 01:29:05AM +0100, Stephen Boyd wrote:
> The arm architected system counter has at least 56 bits of
> useable bits. Add support to ARM's sched_clock implementation for
> counters with more than 32 bits so we can avoid the complexity of
> dealing with wraparound on these devices while benefiting from
> the irqtime accounting and suspend/resume handling that the ARM
> sched_clock code already has.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
> 
> Maybe we need a union for the epoch_ns usage?
> 
>  arch/arm/include/asm/sched_clock.h |   2 +
>  arch/arm/kernel/sched_clock.c      | 101 +++++++++++++++++++++++++++----------
>  2 files changed, 77 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/arm/include/asm/sched_clock.h b/arch/arm/include/asm/sched_clock.h
> index 3d520dd..7fcd2ee 100644
> --- a/arch/arm/include/asm/sched_clock.h
> +++ b/arch/arm/include/asm/sched_clock.h
> @@ -13,4 +13,6 @@ extern void setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate);
>  
>  extern unsigned long long (*sched_clock_func)(void);
>  
> +extern void setup_sched_clock_64(u64 (*read)(void), int bits,
> +				 unsigned long rate);

Curious, but why do we need two setup_sched_clock functions, where the bits
are passed as a parameter? Can't we just do the right thing if the clock
claims to be more than 32 bits wide (and get rid of the BUG_ONs at the same
time)?

Will
