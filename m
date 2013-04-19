Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967587Ab3DSAA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 20:00:26 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20548 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967325Ab3DSAAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 20:00:25 -0400
X-IronPort-AV: E=Sophos;i="4.87,504,1363158000"; 
   d="scan'208";a="39750057"
Message-ID: <51708918.1070501@codeaurora.org>
Date: Thu, 18 Apr 2013 17:00:24 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] clocksource: arm_arch_timer: unify sched_clock init
References: <1366313410-16692-1-git-send-email-robherring2@gmail.com>
In-Reply-To: <1366313410-16692-1-git-send-email-robherring2@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/13 12:30, Rob Herring wrote:
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index 122ff05..17ed8e4 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -266,6 +266,15 @@ static struct notifier_block arch_timer_cpu_nb __cpuinitdata = {
>  	.notifier_call = arch_timer_cpu_notify,
>  };
>  
> +static u64 sched_clock_mult __read_mostly;
> +
> +unsigned long long notrace arch_timer_sched_clock(void)
> +{
> +	return arch_timer_read_counter() * sched_clock_mult;
> +}
> +unsigned long long sched_clock(void) \
> +	__attribute__((weak, alias("arch_timer_sched_clock")));

I'm still lost, how does this prevent the timer in ARM's 32 bit
sched_clock code from getting setup in sched_clock_postinit()? That
print is still there right? Who owns sched_clock() in multi-target builds?

Why can't we play along with the sched_clock code that lives in arm?
Maybe we should resurrect those clocksource sched_clock patches again.
Or maybe we should add support for setup_sched_clock_64() in arm's sched
clock code.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

