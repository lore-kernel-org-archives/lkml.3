Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab3G3KFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 06:05:08 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:40607 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758626Ab3G3KE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 06:04:59 -0400
Message-ID: <51F78FCB.2020004@linaro.org>
Date: Tue, 30 Jul 2013 12:04:59 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH v4 07/17] clocksource: bcm2835: Switch to sched_clock_register()
References: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org> <1374189690-10810-8-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1374189690-10810-8-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 01:21 AM, Stephen Boyd wrote:
> The 32 bit sched_clock interface now supports 64 bits. Upgrade to
> the 64 bit function to allow us to remove the 32 bit registration
> interface.
> 
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---

Hi Stephen,

you sent a series with tick and clocksource changes.

John is recipient of part of them. I replaced him to maintain the
clocksource drivers.

Is the series you sent for clocksource drivers supposed to be taken by
me or by Russell ?

In the future if there are no dependencies, it would be preferable to
group the clocksource drivers changes into a series and send them to me.

Thanks
  -- Daniel

>  drivers/clocksource/bcm2835_timer.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/clocksource/bcm2835_timer.c b/drivers/clocksource/bcm2835_timer.c
> index 07ea7ce..26ed331 100644
> --- a/drivers/clocksource/bcm2835_timer.c
> +++ b/drivers/clocksource/bcm2835_timer.c
> @@ -49,7 +49,7 @@ struct bcm2835_timer {
>  
>  static void __iomem *system_clock __read_mostly;
>  
> -static u32 notrace bcm2835_sched_read(void)
> +static u64 notrace bcm2835_sched_read(void)
>  {
>  	return readl_relaxed(system_clock);
>  }
> @@ -110,7 +110,7 @@ static void __init bcm2835_timer_init(struct device_node *node)
>  		panic("Can't read clock-frequency");
>  
>  	system_clock = base + REG_COUNTER_LO;
> -	setup_sched_clock(bcm2835_sched_read, 32, freq);
> +	sched_clock_register(bcm2835_sched_read, 32, freq);
>  
>  	clocksource_mmio_init(base + REG_COUNTER_LO, node->name,
>  		freq, 300, 32, clocksource_mmio_readl_up);
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

